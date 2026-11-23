import 'package:flutter/material.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/icons/check_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

import '../../../data/models/finished_workout.dart';
import '../../../data/models/workout_status.dart';
import '../../widgets/home/calendar_day_cell.dart';

class WorkoutCompleteView extends StatelessWidget {
  const WorkoutCompleteView({super.key, required this.finished});

  final FinishedWorkout finished;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final minutes = (finished.duration.inSeconds / 60).round().clamp(
      1,
      1 << 30,
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPaddingOf(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 56.h),
                        const Center(child: CheckIcon(iconSize: 32, size: 72)),
                        SizedBox(height: 24.h),
                        AppText(
                          'Workout complete',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title,
                        ),
                        SizedBox(height: 8.h),
                        AppText(
                          'Day ${finished.overallDay} · ${finished.dayName} '
                          'is done. Nice work.',
                          color: colors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        AppText(
                          '$minutes min',
                          style: AppTextStyles.display,
                          textAlign: TextAlign.center,
                        ),
                        AppText(
                          'Workout time',
                          color: colors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        AppText(
                          'Started ${formatTime(finished.startedAt)} · '
                          'Finished ${formatTime(finished.endedAt)}',
                          style: AppTextStyles.caption,
                          color: colors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        _CalendarNote(finished: finished),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Button(
                    label: 'Back to home',
                    onPressed: () => context.goNamed(AppRoute.home.name),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarNote extends StatelessWidget {
  const _CalendarNote({required this.finished});

  final FinishedWorkout finished;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(17.5.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.borderDefault, width: 1.5),
      ),
      child: Row(
        spacing: 16.w,
        children: [
          CalendarDayCell(
            day: finished.localDate.day,
            status: WorkoutStatus.completed,
            isToday: false,
            onTap: null,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Marked on your calendar',
                  style: AppTextStyles.bodyMedium,
                ),
                AppText(
                  formatWeekdayDayMonth(finished.localDate),
                  style: AppTextStyles.caption,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
