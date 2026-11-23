import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/home_summary.dart';
import 'package:zero_gear/features/home/data/models/workout_status.dart';

class TodaysCard extends StatelessWidget {
  const TodaysCard({
    super.key,
    required this.data,
    required this.onStart,
    required this.onResume,
    required this.onGiveUp,
    this.isStarting = false,
    this.isGivingUp = false,
  });

  final HomeSummary data;
  final VoidCallback onStart;
  final VoidCallback onResume;
  final VoidCallback onGiveUp;
  final bool isStarting;
  final bool isGivingUp;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetricPadding(vertical: 24, horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.bgInverse,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.h,
        children: [
          AppText(
            data.line1,
            color: context.colors.textInverse,
            style: AppTextStyles.label,
          ),
          AppText(
            data.line2,
            color: context.colors.textInverse,
            style: AppTextStyles.title,
          ),
          AppText(
            data.line3,
            color: context.colors.textInverse,
            style: AppTextStyles.caption,
          ),
          if (data.line4 != null)
            AppText(
              data.line4!,
              color: context.colors.textInverse,
              style: AppTextStyles.caption,
            ),
          if (!data.startsTomorrow)
            Row(
              children: [
                if (data.activeWorkout != null)
                  Button(
                    label: 'Resume',
                    onPressed: onResume,
                    enabled: !isGivingUp,
                    fullWidth: false,
                    backgroundColor: context.colors.bgPrimary,
                    foregroundColor: context.colors.textPrimary,
                  ),
                if (data.activeWorkout != null)
                  Button(
                    label: 'Give up',
                    onPressed: onGiveUp,
                    isLoading: isGivingUp,
                    fullWidth: false,
                    variant: ButtonVariant.text,
                    foregroundColor: context.colors.textInverse,
                  ),
                if (data.activeWorkout == null)
                  Button(
                    label: 'Start workout',
                    onPressed: onStart,
                    isLoading: isStarting,
                    fullWidth: false,
                    backgroundColor: context.colors.bgPrimary,
                    foregroundColor: context.colors.textPrimary,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

extension _XHomeSummary on HomeSummary {
  String get line1 => activeWorkout != null
      ? 'IN PROGRESS \u2022 DAY ${activeWorkout!.day.dayNumber}'
      : 'UP NEXT \u2022 DAY ${formatNumber(nextDay.overallDay)}';

  String get line2 => activeWorkout?.day.name ?? nextDay.name;

  String get line3 {
    final active = activeWorkout;
    if (active != null) {
      return 'Exercise ${active.currentIndex + 1} of ${active.exercises.length}'
          ' \u00b7 Your ticked sets are saved';
    }
    return '${nextPlan.main.length} exercises'
        ' \u00b7 about ${nextPlan.estimatedMinutes} min';
  }

  String? get line4 {
    final deadline = activeWorkout?.deadline;
    if (activeWorkout != null) {
      return deadline == null
          ? null
          : 'Finish by ${formatTime(deadline)} or we will save it as incomplete.';
    }
    return startsTomorrow ? 'Starts tomorrow' : null;
  }
}
