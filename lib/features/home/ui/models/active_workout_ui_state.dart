import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/async_value.dart';

import '../../data/models/active_workout.dart';
import '../../data/models/finished_workout.dart';
import '../../data/models/plan_exercise.dart';

class ActiveWorkoutUiState extends Equatable {
  const ActiveWorkoutUiState({
    required this.workout,
    this.isFinishing = false,
    this.isGivingUp = false,
    this.finished,
    this.coolDownNext = false,
    this.errorMessage,
  });

  final AsyncValue<ActiveWorkout> workout;
  final bool isFinishing;
  final bool isGivingUp;

  final FinishedWorkout? finished;
  final bool coolDownNext;

  final String? errorMessage;

  factory ActiveWorkoutUiState.initial() =>
      ActiveWorkoutUiState(workout: AsyncValue.loading());

  ActiveWorkout? get active => workout.data;

  bool get isBusy => isFinishing || isGivingUp;

  List<PlanExercise> get exercises => active?.exercises ?? const [];

  int get index {
    final workout = active;
    if (workout == null || exercises.isEmpty) return 0;
    return workout.currentIndex.clamp(0, exercises.length - 1);
  }

  PlanExercise? get current => exercises.isEmpty ? null : exercises[index];

  int get setsDone {
    final workout = active;
    if (workout == null || index >= workout.setsDone.length) return 0;
    return workout.setsDone[index];
  }

  bool get isCurrentDone => current != null && setsDone >= current!.sets;

  bool get isLast => index >= exercises.length - 1;

  @override
  List<Object?> get props => [
    workout,
    isFinishing,
    isGivingUp,
    finished,
    coolDownNext,
    errorMessage,
  ];

  ActiveWorkoutUiState copyWith({
    AsyncValue<ActiveWorkout>? workout,
    bool? isFinishing,
    bool? isGivingUp,
    FinishedWorkout? finished,
    bool? coolDownNext,
    String? Function()? errorMessage,
  }) {
    return ActiveWorkoutUiState(
      workout: workout ?? this.workout,
      isFinishing: isFinishing ?? this.isFinishing,
      isGivingUp: isGivingUp ?? this.isGivingUp,
      finished: finished ?? this.finished,
      coolDownNext: coolDownNext ?? this.coolDownNext,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
