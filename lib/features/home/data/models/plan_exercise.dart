import 'exercise.dart';
import 'package:equatable/equatable.dart';
import 'plan_enums.dart';

class PlanExercise extends Equatable {
  const PlanExercise({
    required this.phase,
    required this.position,
    required this.sets,
    required this.reps,
    required this.holdSeconds,
    required this.exercise,
  });

  factory PlanExercise.fromJson(Map<String, Object?> json) => PlanExercise(
    phase: DayPhase.values.byName(json['phase']! as String),
    position: (json['position']! as num).toInt(),
    sets: (json['sets']! as num).toInt(),
    reps: json['reps']! as String,
    holdSeconds: (json['hold_seconds'] as num?)?.toInt(),
    exercise: Exercise.fromJson(json),
  );

  final DayPhase phase;

  final int position;
  final int sets;

  final String reps;

  final int? holdSeconds;

  final Exercise exercise;

  String get repsText => int.tryParse(reps) != null ? '$reps reps' : reps;

  Map<String, Object?> toJson() => {
    ...exercise.toJson(),
    'phase': phase.name,
    'position': position,
    'sets': sets,
    'reps': reps,
    'hold_seconds': holdSeconds,
  };

  @override
  List<Object?> get props => [
    phase,
    position,
    sets,
    reps,
    holdSeconds,
    exercise,
  ];
}
