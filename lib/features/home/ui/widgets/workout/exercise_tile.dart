import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/extensions/string_extensions.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/plan_exercise.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({super.key, required this.item});
  final PlanExercise item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed(
        AppRoute.exerciseDetail.name,
        extra: item.exercise,
        pathParameters: {
          'repCount': '${'set'.plural(item.sets)}  x ${item.reps} reps',
        },
      ),
      child: AppCard(
        padding: AppSpacing.symmetricPadding(vertical: 24, horizontal: 12),
        child: Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: Column(
                spacing: 4.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(item.exercise.name, style: AppTextStyles.bodyMedium),
                  AppText(
                    '${'set'.plural(item.sets)}  x ${item.reps} reps',
                    style: AppTextStyles.caption,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
            SvgIcon(AppSvgs.chevronRight, color: context.colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
