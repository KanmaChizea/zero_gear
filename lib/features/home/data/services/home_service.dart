import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/extensions/date_extensions.dart';
import 'package:zero_gear/core/shared_features/session/data/models/profile.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/utils/app_exception.dart';
import 'package:zero_gear/core/utils/result.dart';
import 'plan_service.dart';
import 'workout_service.dart';

import '../models/active_workout.dart';
import '../models/home_summary.dart';
import '../models/plan_day.dart';
import '../models/plan_day_summary.dart';
import '../models/progress_rating.dart';
import '../models/workout_history.dart';

class HomeService extends Cubit<HomeSummary?> {
  HomeService(this._session, this._plan, this._workouts) : super(null);

  final SessionCubit _session;
  final PlanService _plan;
  final WorkoutService _workouts;

  Future<Result<HomeSummary>> load({bool refresh = false}) async {
    final profile = _session.user?.profile;
    if (profile == null) {
      return const Result.error(
        AppException('Finish setting up your profile first.'),
      );
    }
    final active = await _workouts.restoreActiveWorkout();
    final history = await _workouts.history(refresh: refresh);
    return history.andThen<HomeSummary>((history) async {
      final next = await _plan.summaryFor(history.nextDay);
      final summary = await next.andThen<HomeSummary>((nextDay) async {
        final plans = await Future.wait([
          for (var i = 0; i <= PlanService.previewDays; i++)
            _plan.planDay(history.nextDay + i),
        ]);
        final upcoming = [
          for (final plan in plans.skip(1))
            if (plan case Ok(:final value)) value,
        ];
        return plans.first.map(
          (nextPlan) => _summarize(
            profile,
            history,
            nextDay,
            nextPlan,
            upcoming,
            active,
          ),
        );
      });
      if (summary case Ok(:final value)) emit(value);
      return summary;
    });
  }

  void clear() => emit(null);

  Future<Result<PlanListing>> loadPlan({int? throughDay}) async {
    final history = await _workouts.history();
    return history.andThen<PlanListing>((history) async {
      final days = await _plan.summaries(
        throughDay: throughDay ?? history.nextDay,
      );
      return days.map(
        (days) => PlanListing(
          days: days,
          statusByDay: history.statusByDay,
          nextDay: history.nextDay,
        ),
      );
    });
  }

  HomeSummary _summarize(
    Profile profile,
    WorkoutHistory history,
    PlanDaySummary nextDay,
    PlanDay nextPlan,
    List<PlanDay> upcoming,
    ActiveWorkout? active,
  ) {
    final today = DateTime.now().dateOnly;
    final completedThisWeek = history.completedBetween(
      today.startOfWeek,
      today,
    );
    final daysSinceStart = today.daysSince(profile.startedAt.dateOnly);
    final weeksSinceStart = daysSinceStart / 7;

    final weekRating = history.completedCount == 0
        ? const ProgressRating.none()
        : ProgressRating.fromWorkoutsPerWeek(completedThisWeek.toDouble());
    final allTimeRating = weeksSinceStart < 1
        ? const ProgressRating.none()
        : ProgressRating.fromWorkoutsPerWeek(
            history.completedCount / weeksSinceStart,
          );

    return HomeSummary(
      profile: profile,
      nextDay: nextDay,
      nextPlan: nextPlan,
      upcoming: upcoming,
      todayWorkout: history.on(today),
      activeWorkout: active,
      stats: HomeStats(
        completedThisWeek: completedThisWeek,
        totalCompleted: history.completedCount,
        daysSinceStart: daysSinceStart,
      ),
      weekRating: weekRating,
      allTimeRating: allTimeRating,
      calendar: history.statusByDate,
    );
  }
}
