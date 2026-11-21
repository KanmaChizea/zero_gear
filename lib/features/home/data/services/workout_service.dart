import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/extensions/date_extensions.dart';
import 'package:zero_gear/core/network/network_exception.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/utils/app_exception.dart';
import 'package:zero_gear/core/utils/app_logger.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/active_workout.dart';
import '../models/finished_workout.dart';
import '../models/workout_history.dart';
import '../models/workout_record.dart';
import '../models/workout_state.dart';
import '../models/workout_status.dart';
import '../models/workout_submission.dart';
import '../models/workout_summary.dart';
import '../repositories/workout_local_repository.dart';
import '../repositories/workout_repository.dart';
import 'plan_service.dart';

class WorkoutService extends Cubit<WorkoutState> {
  WorkoutService(this._repository, this._local, this._plan, this._session)
    : super(const WorkoutState());

  final WorkoutRepository _repository;
  final WorkoutLocalRepository _local;
  final PlanService _plan;
  final SessionCubit _session;

  bool _restored = false;
  bool _syncing = false;

  bool _historyStale = false;

  Future<ActiveWorkout?> restoreActiveWorkout() async {
    if (_restored) return state.active;

    final userId = _session.user?.id;
    if (userId == null) return null;
    _restored = true;

    final stored = _local.readActive();
    if (stored == null) return null;

    final deadline = stored.deadline;
    if (stored.userId != userId || deadline == null) {
      await _local.clearActive();
      return null;
    }
    if (DateTime.now().isAfter(deadline)) {
      await _submit(stored, WorkoutStatus.incomplete, stored.lastTickAt!);
      await _local.clearActive();
      return null;
    }
    emit(state.copyWith(active: () => stored));
    return stored;
  }

  Future<Result<ActiveWorkout>> begin(int overallDay) async {
    final userId = _session.user?.id;
    if (userId == null) {
      return const Result.error(AppException('Please sign in first.'));
    }
    final today = DateTime.now().dateOnly;
    if (state.history?.on(today)?.status == WorkoutStatus.completed) {
      return const Result.error(
        AppException("You already finished today's workout."),
      );
    }

    final day = await _plan.planDay(overallDay);
    return day.andThen<ActiveWorkout>((day) async {
      final workout = ActiveWorkout.begin(
        userId: userId,
        day: day,
        now: DateTime.now(),
      );
      await _save(workout);
      return Result.ok(workout);
    });
  }

  Future<Result<ActiveWorkout>> resumeIncomplete() async {
    final userId = _session.user?.id;
    if (userId == null) {
      return const Result.error(AppException('Please sign in first.'));
    }
    final today = DateTime.now().dateOnly;
    final loaded = await history();
    return loaded.andThen<ActiveWorkout>((history) async {
      final summary = history.on(today);
      if (summary == null || summary.status != WorkoutStatus.incomplete) {
        return const Result.error(
          AppException('There is no unfinished workout today.'),
        );
      }
      final setsByPosition = await _setsByPosition(summary);
      return setsByPosition.andThen<ActiveWorkout>((sets) async {
        final plan = await _plan.planDay(history.dayOf(summary));
        return plan.andThen<ActiveWorkout>((day) async {
          final done = [
            for (final line in day.main)
              math.min(sets[line.position] ?? 0, line.sets),
          ];
          final next = [
            for (var i = 0; i < done.length; i++)
              if (done[i] < day.main[i].sets) i,
          ].firstOrNull;
          final workout = ActiveWorkout(
            userId: userId,
            day: day,
            localDate: summary.localDate,
            startedAt: summary.startedAt,
            setsDone: done,
            currentIndex: next ?? 0,
            lastTickAt: DateTime.now(),
          );
          await _save(workout);
          return Result.ok(workout);
        });
      });
    });
  }

  Future<ActiveWorkout?> setSetsDone(int exerciseIndex, int sets) async {
    final workout = state.active;
    if (workout == null ||
        exerciseIndex < 0 ||
        exerciseIndex >= workout.exercises.length) {
      return workout;
    }
    final planned = workout.exercises[exerciseIndex].sets;
    final done = [...workout.setsDone];
    done[exerciseIndex] = math.max(0, math.min(sets, planned));
    final next = workout.copyWith(
      setsDone: done,
      currentIndex: exerciseIndex,
      lastTickAt: DateTime.now(),
    );
    await _save(next);
    return next;
  }

  Future<ActiveWorkout?> goToExercise(int exerciseIndex) async {
    final workout = state.active;
    if (workout == null ||
        exerciseIndex < 0 ||
        exerciseIndex >= workout.exercises.length) {
      return workout;
    }
    final next = workout.copyWith(currentIndex: exerciseIndex);
    await _save(next);
    return next;
  }

  Future<Result<FinishedWorkout>> finish() => _end(WorkoutStatus.completed);

  Future<Result<FinishedWorkout>> giveUp() => _end(WorkoutStatus.incomplete);

  Future<Result<WorkoutHistory>> history({bool refresh = false}) async {
    final cached = state.history;
    if (!refresh && !_historyStale && cached != null) return Result.ok(cached);

    await syncPending();
    final fetched = await _repository.fetchWorkouts();
    switch (fetched) {
      case Ok(:final value):
        final history = WorkoutHistory.fromWorkouts(_withPending(value));
        _historyStale = false;
        emit(state.copyWith(history: () => history));
        return Result.ok(history);
      case Error(:final error):
        return cached != null ? Result.ok(cached) : Result.error(error);
    }
  }

  Future<Result<WorkoutRecord?>> recordOn(DateTime date) async {
    final loaded = await history();
    return loaded.andThen<WorkoutRecord?>((history) async {
      final summary = history.on(date.dateOnly);
      if (summary == null) return const Result.ok(null);

      final exercises = await _exercisesOf(summary);
      return exercises.andThen<WorkoutRecord?>((exercises) async {
        final overallDay = history.dayOf(summary);
        final day = await _plan.summaryFor(overallDay);
        final dayName = switch (day) {
          Ok(:final value) => value.name,
          Error() => 'Day $overallDay',
        };
        return Result.ok(
          WorkoutRecord(
            summary: summary,
            overallDay: overallDay,
            dayName: dayName,
            exercises: exercises,
          ),
        );
      });
    });
  }

  Future<void> syncPending() async {
    if (_syncing) return;
    final pending = _local.readPending();
    if (pending.isEmpty) return;

    _syncing = true;
    try {
      final remaining = <WorkoutSubmission>[];
      for (var i = 0; i < pending.length; i++) {
        final result = await _repository.saveWorkout(pending[i]);
        if (result case Error(:final error)) {
          if (error is NetworkException) {
            remaining.addAll(pending.skip(i));
            break;
          }
          if (_isRetryable(error)) {
            remaining.add(pending[i]);
          } else {
            AppLogger.log('Dropped workout that cannot be saved: $error');
          }
        }
      }
      if (remaining.length != pending.length) {
        await _local.savePending(remaining);
        _historyStale = true;
      }
    } finally {
      _syncing = false;
    }
  }

  Future<void> clear() async {
    _restored = false;
    _historyStale = false;
    emit(const WorkoutState());
    await _local.clear();
  }

  Future<Result<FinishedWorkout>> _end(WorkoutStatus status) async {
    final workout = state.active;
    if (workout == null) {
      return const Result.error(AppException('No workout is in progress.'));
    }
    final endedAt = DateTime.now();
    final submitted = await _submit(workout, status, endedAt);
    switch (submitted) {
      case Error(:final error):
        return Result.error(error);
      case Ok(:final value):
        await _local.clearActive();
        emit(state.copyWith(active: () => null));
        return Result.ok(
          FinishedWorkout(
            overallDay: workout.day.overallDay,
            dayName: workout.day.name,
            localDate: workout.localDate,
            status: status,
            startedAt: workout.startedAt,
            endedAt: endedAt,
            synced: value,
          ),
        );
    }
  }

  Future<Result<bool>> _submit(
    ActiveWorkout workout,
    WorkoutStatus status,
    DateTime endedAt,
  ) async {
    final submission = workout.toSubmission(status, endedAt);
    final result = await _repository.saveWorkout(submission);
    switch (result) {
      case Ok():
        _historyStale = true;
        return const Result.ok(true);
      case Error(:final error):
        if (!_isRetryable(error)) return Result.error(error);
        final queued = _local
            .readPending()
            .where((item) => item.localDate != submission.localDate)
            .toList();
        await _local.savePending([...queued, submission]);
        _historyStale = true;
        return const Result.ok(false);
    }
  }

  Future<void> _save(ActiveWorkout workout) async {
    _restored = true;
    emit(state.copyWith(active: () => workout));
    await _local.saveActive(workout);
  }

  List<WorkoutSummary> _withPending(List<WorkoutSummary> saved) {
    final pending = _local.readPending();
    if (pending.isEmpty) return saved;
    final byDate = {for (final workout in saved) workout.localDate: workout};
    for (final submission in pending) {
      byDate[submission.localDate] = submission.toSummary();
    }
    return byDate.values.toList();
  }

  WorkoutSubmission? _pendingOn(DateTime date) {
    for (final submission in _local.readPending()) {
      if (submission.localDate == date) return submission;
    }
    return null;
  }

  Future<Result<List<RecordExercise>>> _exercisesOf(
    WorkoutSummary summary,
  ) async {
    if (!summary.isSynced) {
      final pending = _pendingOn(summary.localDate);
      return Result.ok([
        for (final line in pending?.exercises ?? const <SubmittedExercise>[])
          RecordExercise(
            position: line.position,
            slug: line.slug,
            name: line.name,
            gifUrl: line.gifUrl,
            setsPlanned: line.setsPlanned,
            setsDone: line.setsDone,
          ),
      ]);
    }
    final detail = await _repository.fetchWorkoutDetail(summary.localDate);
    return detail.map((detail) => detail?.exercises ?? const []);
  }

  Future<Result<Map<int, int>>> _setsByPosition(WorkoutSummary summary) async {
    final exercises = await _exercisesOf(summary);
    return exercises.map(
      (lines) => {for (final line in lines) line.position: line.setsDone},
    );
  }

  bool _isRetryable(AppException error) {
    final status = error.statusCode;
    return error is NetworkException ||
        error is UnauthorizedException ||
        status == null ||
        status >= 500 ||
        status == 408 ||
        status == 429;
  }
}
