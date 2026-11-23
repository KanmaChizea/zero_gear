import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/workout_status.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    required this.day,
    required this.status,
    required this.isToday,
    required this.onTap,
  });

  final int day;
  final WorkoutStatus? status;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final completed = status == WorkoutStatus.completed;
    final incomplete = status == WorkoutStatus.incomplete;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 40.r,
        height: 40.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: completed ? colors.accentPrimary : null,
          border: incomplete
              ? Border.all(color: colors.accentPrimary, width: 2)
              : isToday && !completed
              ? Border.all(color: colors.borderStrong, width: 1.5)
              : null,
        ),
        child: AppText(
          '$day',
          style: AppTextStyles.bodyMedium,
          color: completed ? colors.accentOn : colors.textPrimary,
        ),
      ),
    );
  }
}
