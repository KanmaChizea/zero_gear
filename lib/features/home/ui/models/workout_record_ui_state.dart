import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/extensions/date_extensions.dart';
import 'package:zero_gear/core/utils/async_value.dart';

import '../../data/models/workout_record.dart';
import '../../data/models/workout_status.dart';

class WorkoutRecordUiState extends Equatable {
  const WorkoutRecordUiState({
    required this.record,
    this.isResuming = false,
    this.errorMessage,
  });

  final AsyncValue<WorkoutRecord?> record;
  final bool isResuming;
  final String? errorMessage;

  factory WorkoutRecordUiState.initial() =>
      WorkoutRecordUiState(record: AsyncValue.loading());

  /// Only today's unfinished workout can be completed.
  bool get canResume {
    final summary = record.data?.summary;
    return summary != null &&
        summary.status == WorkoutStatus.incomplete &&
        summary.localDate == DateTime.now().dateOnly;
  }

  @override
  List<Object?> get props => [record, isResuming, errorMessage];

  WorkoutRecordUiState copyWith({
    AsyncValue<WorkoutRecord?>? record,
    bool? isResuming,
    String? Function()? errorMessage,
  }) {
    return WorkoutRecordUiState(
      record: record ?? this.record,
      isResuming: isResuming ?? this.isResuming,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
