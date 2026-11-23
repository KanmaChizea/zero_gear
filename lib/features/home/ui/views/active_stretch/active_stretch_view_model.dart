import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../../data/models/plan_enums.dart';
import '../../../data/services/plan_service.dart';
import '../../../data/services/workout_service.dart';
import '../../models/active_stretch_ui_state.dart';

class ActiveStretchViewModel extends Cubit<ActiveStretchUiState> {
  ActiveStretchViewModel({
    required this._planService,
    required this._workoutService,
    required this.phase,
    required this.day,
  }) : assert(phase != DayPhase.main),
       super(ActiveStretchUiState.initial()) {
    initialize();
  }

  final PlanService _planService;
  final WorkoutService _workoutService;
  final DayPhase phase;
  final int day;

  bool get isWarmUp => phase == DayPhase.warmup;

  Future<void> initialize() async {
    emit(ActiveStretchUiState.initial());
    final result = await _planService.planDay(day);
    emit(
      ActiveStretchUiState(
        stretches: switch (result) {
          Ok(:final value) => AsyncValue.data(
            isWarmUp ? value.warmUp : value.coolDown,
          ),
          Error(:final error) => AsyncValue.error(error.message),
        },
      ),
    );
  }

  void onPageChanged(int index) {
    if (index == state.index || state.isFinishing) return;
    emit(state.copyWith(index: index));
  }

  /// Ends the warm-up or cool-down, after the last stretch or when skipped.
  /// Returns true when the view should move on.
  /// - Cool-down: the workout is already saved, so there is nothing to do.
  /// - Warm-up: the workout has not started yet (it begins with the first
  ///   exercise), so create it unless it is already running.
  Future<bool> finish() async {
    if (state.isFinishing) return false;
    if (!isWarmUp) return true;
    if (_workoutService.state.active?.day.overallDay == day) return true;

    emit(state.copyWith(isFinishing: true));
    final result = await _workoutService.begin(day);
    switch (result) {
      case Ok():
        emit(state.copyWith(isFinishing: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isFinishing: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
