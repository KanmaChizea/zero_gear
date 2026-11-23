import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class CalendarLegendItem extends StatelessWidget {
  const CalendarLegendItem({
    super.key,
    required this.label,
    required this.filled,
  });

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      spacing: 8.w,
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? colors.accentPrimary : null,
            border: filled
                ? null
                : Border.all(color: colors.accentPrimary, width: 2),
          ),
        ),
        AppText(
          label,
          style: AppTextStyles.caption,
          color: colors.textSecondary,
        ),
      ],
    );
  }
}
