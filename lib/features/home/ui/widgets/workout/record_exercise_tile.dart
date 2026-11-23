import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/workout_record.dart';

class RecordExerciseTile extends StatelessWidget {
  const RecordExerciseTile({super.key, required this.exercise, this.onTap});

  final RecordExercise exercise;
  final VoidCallback? onTap;

  String get _subtitle {
    if (exercise.setsDone == 0) return 'Not done';
    if (exercise.isDone) return 'All ${exercise.setsPlanned} sets done';
    return '${exercise.setsDone} of ${exercise.setsPlanned} sets done';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final started = exercise.setsDone > 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Opacity(
        opacity: started ? 1 : 0.5,
        child: AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(exercise.name, style: AppTextStyles.bodyMedium),
                    AppText(
                      _subtitle,
                      style: AppTextStyles.caption,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              ),
              SvgIcon(AppSvgs.chevronRight, color: colors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
