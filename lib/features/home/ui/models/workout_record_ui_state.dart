import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/async_value.dart';

import '../../data/models/workout_record.dart';

class WorkoutRecordUiState extends Equatable {
  const WorkoutRecordUiState({required this.record});

  /// Null data when nothing was recorded on the selected date.
  final AsyncValue<WorkoutRecord?> record;

  factory WorkoutRecordUiState.initial() =>
      WorkoutRecordUiState(record: AsyncValue.loading());

  @override
  List<Object?> get props => [record];
}
