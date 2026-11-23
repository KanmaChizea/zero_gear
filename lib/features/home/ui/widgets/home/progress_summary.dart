import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/home_summary.dart';
import 'package:zero_gear/features/home/ui/widgets/home/rating_badge.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/profile_section.dart';

class ProgressSummary extends StatelessWidget {
  const ProgressSummary({super.key, required this.summary});
  final HomeSummary summary;

  @override
  Widget build(BuildContext context) {
    final data = summary.stats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24.h,
      children: [
        AppText('Your progress', style: AppTextStyles.heading),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12.w,
            children:
                [
                      (
                        label: 'days this week',
                        value: formatNumber(data.completedThisWeek),
                      ),
                      (
                        label: 'workouts in total',
                        value: formatNumber(data.totalCompleted),
                      ),
                      (
                        label: 'days since you started',
                        value: formatNumber(data.daysSinceStart),
                      ),
                    ]
                    .map(
                      (e) => Expanded(
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(e.value, style: AppTextStyles.display),
                              AppText(
                                e.label,
                                style: AppTextStyles.caption,
                                color: context.colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        ProfileSection(
          items: [
            ProfileItem(
              label: 'This week',
              subLabel: summary.weekRating.weekMessage,
              trailing: RatingBadge(rating: summary.weekRating),
              onPressed: () {},
            ),
            ProfileItem(
              label: 'All time',
              subLabel: summary.allTimeRating.allTimeMessage,
              trailing: RatingBadge(rating: summary.allTimeRating),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
