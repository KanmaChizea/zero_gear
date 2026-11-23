import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';
import 'package:zero_gear/features/home/data/services/plan_service.dart';
import 'package:zero_gear/features/home/data/services/workout_service.dart';
import 'package:zero_gear/features/home/ui/models/day_detail_ui_state.dart';

class DayDetailViewModel extends Cubit<DayDetailUiState> {
  DayDetailViewModel({
    required this._planService,
    required this._workoutService,
    required this._session,
    required this.day,
  }) : super(DayDetailUiState.initial()) {
    initialize();
  }

  final PlanService _planService;
  final WorkoutService _workoutService;
  final SessionCubit _session;
  final int day;

  Future<void> initialize() async {
    emit(DayDetailUiState.initial());

    final active = await _workoutService.restoreActiveWorkout();
    final result = await _planService.planDay(day);
    emit(
      DayDetailUiState(
        isResuming: active?.day.overallDay == day,
        startsWithStretch:
            (_session.user?.profile?.preWorkoutStretch ?? false) &&
            result.fold((_) => false, (plan) => plan.warmUp.isNotEmpty),
        plan: switch (result) {
          Ok(:final value) => AsyncValue.data(value),
          Error(:final error) => AsyncValue.error(error.message),
        },
      ),
    );
  }

  /// Prepares the workout for the main button. Returns true when the view
  /// should navigate on:
  /// - resuming: the saved workout is already loaded, so go straight in;
  /// - starting with a warm-up: nothing is created yet (the workout begins
  ///   with the first exercise), so go to the warm-up prompt;
  /// - starting without one: create the workout, then go to exercise 1.
  Future<bool> proceed() async {
    if (state.isStarting || !state.plan.hasData) return false;
    if (state.isResuming || state.startsWithStretch) return true;

    emit(state.copyWith(isStarting: true));
    final result = await _workoutService.begin(day);
    switch (result) {
      case Ok():
        emit(state.copyWith(isStarting: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isStarting: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
