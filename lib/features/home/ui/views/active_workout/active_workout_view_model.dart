import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../../data/services/workout_service.dart';
import '../../models/active_workout_ui_state.dart';

class ActiveWorkoutViewModel extends Cubit<ActiveWorkoutUiState> {
  ActiveWorkoutViewModel({
    required this._workoutService,
    required this._session,
  }) : super(ActiveWorkoutUiState.initial()) {
    initialize();
  }

  final WorkoutService _workoutService;
  final SessionCubit _session;

  Future<void> initialize() async {
    emit(ActiveWorkoutUiState.initial());
    final active = await _workoutService.restoreActiveWorkout();
    emit(
      ActiveWorkoutUiState(
        workout: active == null
            ? AsyncValue.error('There is no workout in progress.')
            : AsyncValue.data(active),
      ),
    );
  }

  Future<void> toggleSet(int exerciseIndex, int setIndex) async {
    final active = state.active;
    if (active == null || state.isBusy) return;
    if (exerciseIndex >= active.setsDone.length) return;
    final done = active.setsDone[exerciseIndex];
    final next = setIndex == done - 1 ? setIndex : setIndex + 1;
    final updated = await _workoutService.setSetsDone(exerciseIndex, next);
    if (updated != null) {
      emit(state.copyWith(workout: AsyncValue.data(updated)));
    }
  }

  Future<void> onPageChanged(int index) async {
    if (state.active == null || index == state.index) return;
    final updated = await _workoutService.goToExercise(index);
    if (updated != null) {
      emit(state.copyWith(workout: AsyncValue.data(updated)));
    }
  }

  /// Saves the workout as completed. Returns true when the view should move
  /// on, to [ActiveWorkoutUiState.finished] and, if
  /// [ActiveWorkoutUiState.coolDownNext], the cool-down first.
  Future<bool> finish() async {
    final active = state.active;
    if (active == null || !state.isCurrentDone || state.isBusy) return false;

    final coolDown =
        (_session.user?.profile?.postWorkoutStretch ?? false) &&
        active.day.coolDown.isNotEmpty;

    emit(state.copyWith(isFinishing: true));
    final result = await _workoutService.finish();
    switch (result) {
      case Ok(:final value):
        emit(
          state.copyWith(
            isFinishing: false,
            finished: value,
            coolDownNext: coolDown,
          ),
        );
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isFinishing: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  Future<bool> giveUp() async {
    if (state.isBusy) return false;
    emit(state.copyWith(isGivingUp: true));
    final result = await _workoutService.giveUp();
    switch (result) {
      case Ok():
        emit(state.copyWith(isGivingUp: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isGivingUp: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
