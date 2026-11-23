import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../../data/services/workout_service.dart';
import '../../models/workout_record_ui_state.dart';

class WorkoutRecordViewModel extends Cubit<WorkoutRecordUiState> {
  WorkoutRecordViewModel({
    required this._workoutService,
    required this.date,
  }) : super(WorkoutRecordUiState.initial()) {
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
}
