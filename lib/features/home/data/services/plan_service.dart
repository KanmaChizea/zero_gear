import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/app_exception.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/exercise.dart';
import '../models/plan_day.dart';
import '../models/plan_day_summary.dart';
import '../models/plan_state.dart';
import '../repositories/plan_repository.dart';

class PlanService extends Cubit<PlanState> {
  PlanService(this._repository) : super(const PlanState());

  final PlanRepository _repository;

  final _planDays = <int, PlanDay>{};
  final _exercises = <String, Exercise>{};

  static const _namedDayCount = 96;
  static const _splitLength = 6;

  Future<Result<PlanDay>> planDay(int overallDay) async {
    final cached = _planDays[overallDay];
    if (cached != null) return Result.ok(cached);
    final result = await _repository.fetchPlanDay(overallDay);
    if (result case Ok(:final value)) _planDays[overallDay] = value;
    return result;
  }

  Future<Result<PlanDaySummary>> summaryFor(int overallDay) async {
    final named = await _loadNamedDays();
    return named.map((days) => _summaryOf(days, overallDay));
  }

  Future<Result<List<PlanDaySummary>>> summaries({int? throughDay}) async {
    final named = await _loadNamedDays();
    return named.map((days) {
      final last = throughDay != null && throughDay > _namedDayCount
          ? throughDay
          : _namedDayCount;
      return [for (var day = 1; day <= last; day++) _summaryOf(days, day)];
    });
  }

  Future<Result<Exercise>> exercise(String slug) async {
    final cached = _exercises[slug];
    if (cached != null) return Result.ok(cached);
    final result = await _repository.fetchExercise(slug);
    switch (result) {
      case Error(:final error):
        return Result.error(error);
      case Ok(:final value):
        if (value == null) {
          return const Result.error(AppException('Exercise not found.'));
        }
        _exercises[slug] = value;
        return Result.ok(value);
    }
  }

  PlanDaySummary _summaryOf(Map<int, PlanDaySummary> days, int overallDay) {
    if (overallDay <= _namedDayCount) return days[overallDay]!;
    final split = days[(overallDay - 1) % _splitLength + 1]!;
    return PlanDaySummary(
      overallDay: overallDay,
      name: split.name,
      focusMuscles: split.focusMuscles,
    );
  }

  Future<Result<Map<int, PlanDaySummary>>> _loadNamedDays() async {
    if (state.namedDays.isNotEmpty) return Result.ok(state.namedDays);

    final first = await planDay(1);
    return first.andThen<Map<int, PlanDaySummary>>((first) async {
      final rows = await _repository.fetchDays(first.track);
      return rows.andThen<Map<int, PlanDaySummary>>((rows) async {
        final days = {
          for (final row in rows)
            row.overallDay: PlanDaySummary(
              overallDay: row.overallDay,
              name: row.name,
              focusMuscles: row.focusMuscles,
            ),
        };
        final complete = [
          for (var day = 1; day <= _namedDayCount; day++) days.containsKey(day),
        ].every((present) => present);
        if (!complete) {
          return const Result.error(
            AppException('The workout plan is not available right now.'),
          );
        }
        emit(PlanState(track: first.track, namedDays: days));
        return Result.ok(days);
      });
    });
  }

  void clear() {
    _planDays.clear();
    _exercises.clear();
    emit(const PlanState());
  }
}
