import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/plan_exercise.dart';

class StretchTile extends StatelessWidget {
  const StretchTile({super.key, required this.item});

  final PlanExercise item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.symmetricPadding(vertical: 24, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(item.exercise.name, style: AppTextStyles.bodyMedium),
                AppText(
                  item.reps,
                  style: AppTextStyles.caption,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
