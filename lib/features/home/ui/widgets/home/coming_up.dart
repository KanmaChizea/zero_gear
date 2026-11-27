import 'package:flutter/material.dart';
import 'package:zero_gear/core/extensions/string_extensions.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/plan_day.dart';

class ComingUp extends StatelessWidget {
  const ComingUp({super.key, required this.days, required this.onOpen});

  final List<PlanDay> days;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        AppText(
          'COMING UP',
          style: AppTextStyles.label,
          color: context.colors.textSecondary,
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8.w,
            children: [
              for (final day in days)
                Expanded(
                  child: _DayTile(
                    day: day,
                    onTap: () => onOpen(day.overallDay),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.day, required this.onTap});

  final PlanDay day;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AppCard(
        padding: AppSpacing.padding12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: [
            AppText(
              'Day ${formatNumber(day.overallDay)}',
              style: AppTextStyles.caption,
              color: colors.textSecondary,
            ),
            Expanded(
              child: AppText(
                day.name,
                style: AppTextStyles.bodyMedium,
                maxLines: 2,
              ),
            ),
            AppText(
              'exercise'.plural(day.main.length),
              style: AppTextStyles.caption,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
