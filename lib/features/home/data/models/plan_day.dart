import 'package:equatable/equatable.dart';
import 'plan_enums.dart';
import 'plan_exercise.dart';

class PlanDay extends Equatable {
  const PlanDay({
    required this.overallDay,
    required this.track,
    required this.stage,
    required this.dayNumber,
    required this.level,
    required this.name,
    required this.focusMuscles,
    required this.exercises,
  });

  factory PlanDay.fromJson(Map<String, Object?> json) => PlanDay(
    overallDay: (json['overall_day']! as num).toInt(),
    track: PlanTrack.values.byName(json['track']! as String),
    stage: PlanStage.fromJson(json['stage']! as String),
    dayNumber: (json['day_number']! as num).toInt(),
    level: (json['level']! as num).toInt(),
    name: json['name']! as String,
    focusMuscles: [
      for (final muscle in json['focus_muscles']! as List<Object?>)
        muscle! as String,
    ],
    exercises: [
      for (final line in json['exercises']! as List<Object?>)
        PlanExercise.fromJson(line! as Map<String, Object?>),
    ],
  );

  final int overallDay;
  final PlanTrack track;

  final PlanStage stage;
  final int dayNumber;

  final int level;
  final String name;
  final List<String> focusMuscles;
  final List<PlanExercise> exercises;

  static const _minutesPerSet = 1.7;

  int get estimatedMinutes {
    final sets = main.fold<int>(0, (sum, line) => sum + line.sets);
    return (sets * _minutesPerSet / 5).round() * 5;
  }

  static const _secondsPerStretch = 45;

  /// About how long a warm-up or cool-down takes, in whole minutes.
  static int stretchMinutes(List<PlanExercise> stretches) =>
      (stretches.length * _secondsPerStretch / 60).ceil();

  List<PlanExercise> get warmUp => _phase(DayPhase.warmup);

  List<PlanExercise> get main => _phase(DayPhase.main);

  List<PlanExercise> get coolDown => _phase(DayPhase.cooldown);

  List<PlanExercise> _phase(DayPhase phase) =>
      exercises.where((line) => line.phase == phase).toList()
        ..sort((a, b) => a.position.compareTo(b.position));

  Map<String, Object?> toJson() => {
    'overall_day': overallDay,
    'track': track.name,
    'stage': stage.value,
    'day_number': dayNumber,
    'level': level,
    'name': name,
    'focus_muscles': focusMuscles,
    'exercises': [for (final line in exercises) line.toJson()],
  };

  @override
  List<Object?> get props => [
    overallDay,
    track,
    stage,
    dayNumber,
    level,
    name,
    focusMuscles,
    exercises,
  ];
}
