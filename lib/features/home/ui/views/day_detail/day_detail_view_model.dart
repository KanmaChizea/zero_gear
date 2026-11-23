import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';
import 'package:zero_gear/features/home/data/services/plan_service.dart';
import 'package:zero_gear/features/home/data/services/workout_service.dart';
import 'package:zero_gear/features/home/ui/models/day_detail_ui_state.dart';

class DayDetailViewModel extends Cubit<DayDetailUiState> {
  DayDetailViewModel({
    required this._planService,
    required this._workoutService,
    required this.day,
  }) : super(DayDetailUiState.initial()) {
    initialize();
  }

  final PlanService _planService;
  final WorkoutService _workoutService;
  final int day;

  Future<void> initialize() async {
    emit(DayDetailUiState.initial());

    final active = await _workoutService.restoreActiveWorkout();
    final result = await _planService.planDay(day);
    emit(
      DayDetailUiState(
        isResuming: active?.day.overallDay == day,
        plan: switch (result) {
          Ok(:final value) => AsyncValue.data(value),
          Error(:final error) => AsyncValue.error(error.message),
        },
      ),
    );
  }
}
