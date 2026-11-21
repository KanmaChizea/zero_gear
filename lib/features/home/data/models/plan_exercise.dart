import 'exercise.dart';
import 'package:equatable/equatable.dart';
import 'plan_enums.dart';

class PlanExercise extends Equatable {
  const PlanExercise({
    required this.phase,
    required this.position,
    required this.sets,
    required this.reps,
    required this.exercise,
  });

  factory PlanExercise.fromJson(Map<String, Object?> json) => PlanExercise(
    phase: DayPhase.values.byName(json['phase']! as String),
    position: (json['position']! as num).toInt(),
    sets: (json['sets']! as num).toInt(),
    reps: json['reps']! as String,
    exercise: Exercise.fromJson(json),
  );

  final DayPhase phase;

  final int position;
  final int sets;

  final String reps;
  final Exercise exercise;

  Map<String, Object?> toJson() => {
    ...exercise.toJson(),
    'phase': phase.name,
    'position': position,
    'sets': sets,
    'reps': reps,
  };

  @override
  List<Object?> get props => [phase, position, sets, reps, exercise];
}
