import 'package:equatable/equatable.dart';
import 'workout_summary.dart';

class RecordExercise extends Equatable {
  const RecordExercise({
    required this.position,
    required this.slug,
    required this.name,
    required this.gifUrl,
    required this.setsPlanned,
    required this.setsDone,
  });

  factory RecordExercise.fromJson(Map<String, Object?> json) {
    final exercise = json['exercises']! as Map<String, Object?>;
    return RecordExercise(
      position: (json['position']! as num).toInt(),
      slug: exercise['slug']! as String,
      name: exercise['name']! as String,
      gifUrl: exercise['gif_url'] as String?,
      setsPlanned: (json['sets_planned']! as num).toInt(),
      setsDone: (json['sets_done']! as num).toInt(),
    );
  }

  final int position;
  final String slug;
  final String name;
  final String? gifUrl;
  final int setsPlanned;
  final int setsDone;

  bool get isDone => setsDone >= setsPlanned;

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

class WorkoutDetail extends Equatable {
  const WorkoutDetail({required this.summary, required this.exercises});

  factory WorkoutDetail.fromJson(Map<String, Object?> json) => WorkoutDetail(
    summary: WorkoutSummary.fromJson(json),
    exercises: [
      for (final line in json['workout_exercises']! as List<Object?>)
        RecordExercise.fromJson(line! as Map<String, Object?>),
    ],
  );

  final WorkoutSummary summary;
  final List<RecordExercise> exercises;

  @override
  List<Object?> get props => [summary, exercises];
}

class WorkoutRecord extends Equatable {
  const WorkoutRecord({
    required this.summary,
    required this.overallDay,
    required this.dayName,
    required this.exercises,
  });

  final WorkoutSummary summary;
  final int overallDay;
  final String dayName;
  final List<RecordExercise> exercises;

  int get minutes => summary.duration.inMinutes;

  int get exercisesDone => exercises.where((line) => line.isDone).length;

  int get setsDone => exercises.fold(0, (sum, line) => sum + line.setsDone);

  @override
  List<Object?> get props => [summary, overallDay, dayName, exercises];
}
