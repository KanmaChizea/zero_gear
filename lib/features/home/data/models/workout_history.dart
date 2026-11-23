import 'workout_status.dart';
import 'workout_summary.dart';

class WorkoutHistory {
  WorkoutHistory._(this.workouts, this._dayByDate, this.completedCount);

  factory WorkoutHistory.fromWorkouts(List<WorkoutSummary> workouts) {
    final sorted = [...workouts]
      ..sort((a, b) => a.localDate.compareTo(b.localDate));
    final dayByDate = <DateTime, int>{};
    var completed = 0;
    for (final workout in sorted) {
      dayByDate[workout.localDate] = completed + 1;
      if (workout.status == WorkoutStatus.completed) completed++;
    }
    return WorkoutHistory._(List.unmodifiable(sorted), dayByDate, completed);
  }

  final List<WorkoutSummary> workouts;
  final int completedCount;
  final Map<DateTime, int> _dayByDate;

  int get nextDay => completedCount + 1;

  WorkoutSummary? on(DateTime date) {
    for (final workout in workouts) {
      if (workout.localDate == date) return workout;
    }
    return null;
  }

  int dayOf(WorkoutSummary workout) => _dayByDate[workout.localDate] ?? nextDay;

  Map<DateTime, WorkoutStatus> get statusByDate => {
    for (final workout in workouts) workout.localDate: workout.status,
  };

  Map<int, WorkoutStatus> get statusByDay {
    final result = <int, WorkoutStatus>{};
    for (final workout in workouts) {
      final day = dayOf(workout);
      if (result[day] != WorkoutStatus.completed) result[day] = workout.status;
    }
    return result;
  }

  int completedBetween(DateTime from, DateTime to) => workouts
      .where(
        (workout) =>
            workout.status == WorkoutStatus.completed &&
            !workout.localDate.isBefore(from) &&
            !workout.localDate.isAfter(to),
      )
      .length;
}
