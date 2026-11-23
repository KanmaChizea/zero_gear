import 'active_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/shared_features/session/data/models/profile.dart';
import 'plan_day.dart';
import 'plan_day_summary.dart';
import 'progress_rating.dart';
import 'workout_status.dart';
import 'workout_summary.dart';

class HomeStats extends Equatable {
  const HomeStats({
    required this.completedThisWeek,
    required this.totalCompleted,
    required this.daysSinceStart,
  });

  final int completedThisWeek;
  final int totalCompleted;

  final int daysSinceStart;

  @override
  List<Object?> get props => [
    completedThisWeek,
    totalCompleted,
    daysSinceStart,
  ];
}

class HomeSummary extends Equatable {
  const HomeSummary({
    required this.profile,
    required this.nextDay,
    required this.nextPlan,
    required this.todayWorkout,
    required this.activeWorkout,
    required this.stats,
    required this.weekRating,
    required this.allTimeRating,
    required this.calendar,
  });

  final Profile profile;

  final PlanDaySummary nextDay;
  final PlanDay nextPlan;

  final WorkoutSummary? todayWorkout;

  final ActiveWorkout? activeWorkout;
  final HomeStats stats;
  final ProgressRating weekRating;
  final ProgressRating allTimeRating;

  final Map<DateTime, WorkoutStatus> calendar;

  WorkoutSummary? get unfinishedToday =>
      activeWorkout == null && todayWorkout?.status == WorkoutStatus.incomplete
      ? todayWorkout
      : null;

  bool get startsTomorrow => todayWorkout?.status == WorkoutStatus.completed;

  @override
  List<Object?> get props => [
    profile,
    nextDay,
    nextPlan,
    todayWorkout,
    activeWorkout,
    stats,
    weekRating,
    allTimeRating,
    calendar,
  ];
}

class PlanListing extends Equatable {
  const PlanListing({
    required this.days,
    required this.statusByDay,
    required this.nextDay,
  });

  final List<PlanDaySummary> days;

  final Map<int, WorkoutStatus> statusByDay;
  final int nextDay;

  @override
  List<Object?> get props => [days, statusByDay, nextDay];
}

// enum ProgressRating {
//   none('NOT RATED YET'),
//   good('GOOD'),
//   great('GREAT'),
//   needsWork('NEEDS WORK');

//   final String label;

//   const ProgressRating(this.label);
// }
