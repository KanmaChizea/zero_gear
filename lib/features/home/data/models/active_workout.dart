import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/extensions/date_extensions.dart';
import 'plan_day.dart';
import 'plan_exercise.dart';
import 'workout_status.dart';
import 'workout_submission.dart';

class ActiveWorkout extends Equatable {
  const ActiveWorkout({
    required this.userId,
    required this.day,
    required this.localDate,
    required this.startedAt,
    required this.setsDone,
    this.currentIndex = 0,
    this.lastTickAt,
  });

  factory ActiveWorkout.begin({
    required String userId,
    required PlanDay day,
    required DateTime now,
  }) => ActiveWorkout(
    userId: userId,
    day: day,
    localDate: now.dateOnly,
    startedAt: now,
    setsDone: List.filled(day.main.length, 0),
  );

  factory ActiveWorkout.fromJson(Map<String, Object?> json) => ActiveWorkout(
    userId: json['user_id']! as String,
    day: PlanDay.fromJson(json['day']! as Map<String, Object?>),
    localDate: DateTime.parse(json['local_date']! as String),
    startedAt: DateTime.parse(json['started_at']! as String).toLocal(),
    setsDone: [
      for (final sets in json['sets_done']! as List<Object?>)
        (sets! as num).toInt(),
    ],
    currentIndex: (json['current_index']! as num).toInt(),
    lastTickAt: json['last_tick_at'] == null
        ? null
        : DateTime.parse(json['last_tick_at']! as String).toLocal(),
  );

  static const resumeWindow = Duration(hours: 2);

  final String userId;
  final PlanDay day;
  final DateTime localDate;

  final DateTime startedAt;

  final List<int> setsDone;

  final int currentIndex;
  final DateTime? lastTickAt;

  List<PlanExercise> get exercises => day.main;

  int get finishedExercises {
    var count = 0;
    for (var i = 0; i < exercises.length && i < setsDone.length; i++) {
      if (setsDone[i] >= exercises[i].sets) count++;
    }
    return count;
  }

  bool get hasProgress => setsDone.any((sets) => sets > 0);

  DateTime? get deadline => lastTickAt?.add(resumeWindow);

  ActiveWorkout copyWith({
    List<int>? setsDone,
    int? currentIndex,
    DateTime? lastTickAt,
  }) => ActiveWorkout(
    userId: userId,
    day: day,
    localDate: localDate,
    startedAt: startedAt,
    setsDone: setsDone ?? this.setsDone,
    currentIndex: currentIndex ?? this.currentIndex,
    lastTickAt: lastTickAt ?? this.lastTickAt,
  );

  WorkoutSubmission toSubmission(WorkoutStatus status, DateTime endedAt) =>
      WorkoutSubmission(
        userId: userId,
        track: day.track,
        stage: day.stage,
        dayNumber: day.dayNumber,
        localDate: localDate,
        status: status,
        startedAt: startedAt,
        endedAt: endedAt,
        exercises: [
          for (var i = 0; i < exercises.length; i++)
            SubmittedExercise(
              position: exercises[i].position,
              slug: exercises[i].exercise.slug,
              name: exercises[i].exercise.name,
              gifUrl: exercises[i].exercise.gifUrl,
              setsPlanned: exercises[i].sets,
              setsDone: i < setsDone.length ? setsDone[i] : 0,
            ),
        ],
      );

  Map<String, Object?> toJson() => {
    'user_id': userId,
    'day': day.toJson(),
    'local_date': localDate.isoDate,
    'started_at': startedAt.toUtc().toIso8601String(),
    'sets_done': setsDone,
    'current_index': currentIndex,
    'last_tick_at': lastTickAt?.toUtc().toIso8601String(),
  };

  @override
  List<Object?> get props => [
    userId,
    day,
    localDate,
    startedAt,
    setsDone,
    currentIndex,
    lastTickAt,
  ];
}
