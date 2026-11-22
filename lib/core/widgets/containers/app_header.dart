import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/app_back_button.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.title, required this.text});
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24.h,
      children: [
        const AppBackButton(),
        AppText(title, style: AppTextStyles.display),
        AppText(text, color: context.colors.textSecondary),
      ],
    );
  }
}
