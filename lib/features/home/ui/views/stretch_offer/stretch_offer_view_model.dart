import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../../data/models/plan_enums.dart';
import '../../../data/services/plan_service.dart';
import '../../../data/services/workout_service.dart';
import '../../models/stretch_offer_ui_state.dart';

class StretchOfferViewModel extends Cubit<StretchOfferUiState> {
  StretchOfferViewModel({
    required this._planService,
    required this._workoutService,
    required this.phase,
    required this.day,
  }) : assert(phase != DayPhase.main),
       super(StretchOfferUiState.initial()) {
    initialize();
  }

  final PlanService _planService;
  final WorkoutService _workoutService;
  final DayPhase phase;
  final int day;

  bool get isWarmUp => phase == DayPhase.warmup;

  Future<void> initialize() async {
    emit(StretchOfferUiState.initial());
    final result = await _planService.planDay(day);
    emit(
      StretchOfferUiState(
        stretches: switch (result) {
          Ok(:final value) => AsyncValue.data(
            isWarmUp ? value.warmUp : value.coolDown,
          ),
          Error(:final error) => AsyncValue.error(error.message),
        },
      ),
    );
  }

  /// Returns true when the view should move on.
  /// - Cool-down: the workout is already saved, so there is nothing to do.
  /// - Warm-up: the workout has not started yet (it begins with the first
  ///   exercise), so create it unless it is already running.
  Future<bool> skip() async {
    if (state.isSkipping) return false;
    if (!isWarmUp) return true;
    if (_workoutService.state.active?.day.overallDay == day) return true;

    emit(state.copyWith(isSkipping: true));
    final result = await _workoutService.begin(day);
    switch (result) {
      case Ok():
        emit(state.copyWith(isSkipping: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isSkipping: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
