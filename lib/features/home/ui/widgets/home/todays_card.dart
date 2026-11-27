import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/home_summary.dart';

class TodaysCard extends StatelessWidget {
  const TodaysCard({
    super.key,
    required this.data,
    required this.onStart,
    required this.onPreview,
    required this.onResume,
    required this.onGiveUp,
    this.isStarting = false,
    this.isResuming = false,
    this.isGivingUp = false,
  });

  final HomeSummary data;
  final VoidCallback onStart;
  final VoidCallback onPreview;
  final VoidCallback onResume;
  final VoidCallback onGiveUp;
  final bool isStarting;
  final bool isResuming;
  final bool isGivingUp;
  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.r);
    return Material(
      color: context.colors.bgInverse,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: data.startsTomorrow ? onPreview : null,
        child: Container(
          padding: AppSpacing.symmetricPadding(vertical: 24, horizontal: 24),
          width: double.infinity,
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
                    if (data.activeWorkout != null || data.unfinishedToday != null)
                      Button(
                        label: 'Resume',
                        onPressed: onResume,
                        isLoading: isResuming,
                        enabled: !isGivingUp,
                        fullWidth: false,
                        backgroundColor: context.colors.bgPrimary,
                        foregroundColor: context.colors.textPrimary,
                      ),
                    // An unfinished workout is already saved as incomplete, so
                    // there is nothing left to give up.
                    if (data.activeWorkout != null)
                      Button(
                        label: 'Give up',
                        onPressed: onGiveUp,
                        isLoading: isGivingUp,
                        fullWidth: false,
                        variant: ButtonVariant.text,
                        foregroundColor: context.colors.textInverse,
                      ),
                    if (data.activeWorkout == null && data.unfinishedToday == null)
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
        ),
      ),
    );
  }
}

extension _XHomeSummary on HomeSummary {
  String get line1 => activeWorkout != null
      ? 'IN PROGRESS \u2022 DAY ${activeWorkout!.day.dayNumber}'
      : unfinishedToday != null
      ? 'UNFINISHED \u2022 DAY ${formatNumber(nextDay.overallDay)}'
      : 'UP NEXT \u2022 DAY ${formatNumber(nextDay.overallDay)}';

  String get line2 => activeWorkout?.day.name ?? nextDay.name;

  String get line3 {
    final active = activeWorkout;
    if (active != null) {
      return 'Exercise ${active.currentIndex + 1} of ${active.exercises.length}'
          ' \u00b7 Your ticked sets are saved';
    }
    final unfinished = unfinishedToday;
    if (unfinished != null) {
      return 'Stopped at ${formatTime(unfinished.endedAt)}'
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
