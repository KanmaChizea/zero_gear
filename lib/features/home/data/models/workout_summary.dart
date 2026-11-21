import 'package:equatable/equatable.dart';
import 'workout_status.dart';

class WorkoutSummary extends Equatable {
  const WorkoutSummary({
    required this.id,
    required this.localDate,
    required this.status,
    required this.startedAt,
    required this.endedAt,
  });

  factory WorkoutSummary.fromJson(Map<String, Object?> json) => WorkoutSummary(
    id: json['id']! as String,
    localDate: DateTime.parse(json['local_date']! as String),
    status: WorkoutStatus.values.byName(json['status']! as String),
    startedAt: DateTime.parse(json['started_at']! as String).toLocal(),
    endedAt: DateTime.parse(json['ended_at']! as String).toLocal(),
  );

  final String id;

  final DateTime localDate;
  final WorkoutStatus status;
  final DateTime startedAt;
  final DateTime endedAt;

  bool get isSynced => id.isNotEmpty;

  Duration get duration => endedAt.difference(startedAt);

  @override
  List<Object?> get props => [id, localDate, status, startedAt, endedAt];
}
