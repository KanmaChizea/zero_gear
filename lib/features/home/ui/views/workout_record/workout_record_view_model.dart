import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../../data/services/workout_service.dart';
import '../../models/workout_record_ui_state.dart';

class WorkoutRecordViewModel extends Cubit<WorkoutRecordUiState> {
  WorkoutRecordViewModel({required this._workoutService, required this.date})
    : super(WorkoutRecordUiState.initial()) {
    initialize();
  }

  final WorkoutService _workoutService;

  /// The calendar date the user tapped.
  final DateTime date;

  Future<void> initialize() async {
    emit(WorkoutRecordUiState.initial());
    final result = await _workoutService.recordOn(date);
    emit(
      WorkoutRecordUiState(
        record: switch (result) {
          Ok(:final value) => AsyncValue.data(value),
          Error(:final error) => AsyncValue.error(error.message),
        },
      ),
    );
  }

  Future<bool> resume() async {
    if (!state.canResume || state.isResuming) return false;
    if (_workoutService.state.active != null) return true;

    emit(state.copyWith(isResuming: true));
    final result = await _workoutService.resumeIncomplete();
    switch (result) {
      case Ok():
        emit(state.copyWith(isResuming: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isResuming: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
