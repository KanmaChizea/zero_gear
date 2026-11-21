import 'package:equatable/equatable.dart';
import 'workout_status.dart';

class FinishedWorkout extends Equatable {
  const FinishedWorkout({
    required this.overallDay,
    required this.dayName,
    required this.localDate,
    required this.status,
    required this.startedAt,
    required this.endedAt,
    required this.synced,
  });

  final int overallDay;
  final String dayName;
  final DateTime localDate;
  final WorkoutStatus status;
  final DateTime startedAt;
  final DateTime endedAt;

  final bool synced;

  Duration get duration => endedAt.difference(startedAt);

  @override
  List<Object?> get props => [
    overallDay,
    dayName,
    localDate,
    status,
    startedAt,
    endedAt,
    synced,
  ];
}
