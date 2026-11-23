import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/workout_status.dart';

class WorkoutStatusBadge extends StatelessWidget {
  const WorkoutStatusBadge({super.key, required this.status});

  final WorkoutStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (label, background, foreground) = switch (status) {
      WorkoutStatus.completed => (
        'COMPLETE',
        colors.successPrimary,
        colors.successOn,
      ),
      WorkoutStatus.incomplete => ('INCOMPLETE', null, colors.textSecondary),
    };

    return Container(
      padding: AppSpacing.symmetricPadding(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999.r),
        border: background == null
            ? Border.all(width: 1.5, color: colors.borderDefault)
            : null,
      ),
      child: AppText(label, style: AppTextStyles.label, color: foreground),
    );
  }
}
