import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/app_back_button.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class WorkoutHeader extends StatelessWidget {
  const WorkoutHeader({
    super.key,
    required this.title,
    required this.text,
    required this.tag,
    this.prefix,
  });
  final String title;
  final String text;
  final String tag;
  final Widget? prefix;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24.h,
      children: [
        const AppBackButton(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: [
            ?prefix,
            AppText(
              tag,
              color: context.colors.textSecondary,
              style: AppTextStyles.label,
            ),
            AppText(title, style: AppTextStyles.display),
            AppText(
              text,
              color: context.colors.textSecondary,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ],
    );
  }
}
