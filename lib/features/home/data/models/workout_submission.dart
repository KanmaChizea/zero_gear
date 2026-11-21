import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/extensions/date_extensions.dart';
import 'plan_enums.dart';
import 'workout_status.dart';
import 'workout_summary.dart';

class SubmittedExercise extends Equatable {
  const SubmittedExercise({
    required this.position,
    required this.slug,
    required this.name,
    required this.gifUrl,
    required this.setsPlanned,
    required this.setsDone,
  });

  factory SubmittedExercise.fromJson(Map<String, Object?> json) =>
      SubmittedExercise(
        position: (json['position']! as num).toInt(),
        slug: json['slug']! as String,
        name: json['name']! as String,
        gifUrl: json['gif_url'] as String?,
        setsPlanned: (json['sets_planned']! as num).toInt(),
        setsDone: (json['sets_done']! as num).toInt(),
      );

  final int position;
  final String slug;
  final String name;
  final String? gifUrl;
  final int setsPlanned;
  final int setsDone;

  Map<String, Object?> toJson() => {
    'position': position,
    'slug': slug,
    'name': name,
    'gif_url': gifUrl,
    'sets_planned': setsPlanned,
    'sets_done': setsDone,
  };

  @override
  List<Object?> get props => [
    position,
    slug,
    name,
    gifUrl,
    setsPlanned,
    setsDone,
  ];
}

class WorkoutSubmission extends Equatable {
  const WorkoutSubmission({
    required this.userId,
    required this.track,
    required this.stage,
    required this.dayNumber,
    required this.localDate,
    required this.status,
    required this.startedAt,
    required this.endedAt,
    required this.exercises,
  });

  factory WorkoutSubmission.fromJson(Map<String, Object?> json) =>
      WorkoutSubmission(
        userId: json['user_id']! as String,
        track: PlanTrack.values.byName(json['track']! as String),
        stage: PlanStage.fromJson(json['stage']! as String),
        dayNumber: (json['day_number']! as num).toInt(),
        localDate: DateTime.parse(json['local_date']! as String),
        status: WorkoutStatus.values.byName(json['status']! as String),
        startedAt: DateTime.parse(json['started_at']! as String).toLocal(),
        endedAt: DateTime.parse(json['ended_at']! as String).toLocal(),
        exercises: [
          for (final line in json['exercises']! as List<Object?>)
            SubmittedExercise.fromJson(line! as Map<String, Object?>),
        ],
      );

  final String userId;
  final PlanTrack track;
  final PlanStage stage;
  final int dayNumber;
  final DateTime localDate;
  final WorkoutStatus status;
  final DateTime startedAt;
  final DateTime endedAt;
  final List<SubmittedExercise> exercises;

  WorkoutSummary toSummary() => WorkoutSummary(
    id: '',
    localDate: localDate,
    status: status,
    startedAt: startedAt,
    endedAt: endedAt,
  );

  Map<String, Object?> toJson() => {
    'user_id': userId,
    'track': track.name,
    'stage': stage.value,
    'day_number': dayNumber,
    'local_date': localDate.isoDate,
    'status': status.name,
    'started_at': startedAt.toUtc().toIso8601String(),
    'ended_at': endedAt.toUtc().toIso8601String(),
    'exercises': [for (final line in exercises) line.toJson()],
  };

  @override
  List<Object?> get props => [
    userId,
    track,
    stage,
    dayNumber,
    localDate,
    status,
    startedAt,
    endedAt,
    exercises,
  ];
}
