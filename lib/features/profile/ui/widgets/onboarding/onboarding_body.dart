import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({
    super.key,
    required this.title,
    required this.text,
    required this.child,
    required this.info,
  });
  final String title;
  final String text;
  final Widget child;
  final String info;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, style: AppTextStyles.display),
          AppSpacing.v8,
          AppText(text, color: context.colors.textSecondary),
          AppSpacing.v24,
          child,
          AppSpacing.v24,
          AppCard(
            child: Column(
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'WHY WE ASK',
                  style: AppTextStyles.label,
                  color: context.colors.textSecondary,
                ),
                AppText(info, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
