import 'active_workout.dart';
import 'package:equatable/equatable.dart';
import 'workout_history.dart';

class WorkoutState extends Equatable {
  const WorkoutState({this.active, this.history});

  final ActiveWorkout? active;

  final WorkoutHistory? history;

  WorkoutState copyWith({
    ActiveWorkout? Function()? active,
    WorkoutHistory? Function()? history,
  }) => WorkoutState(
    active: active != null ? active() : this.active,
    history: history != null ? history() : this.history,
  );

  @override
  List<Object?> get props => [active, history];
}
