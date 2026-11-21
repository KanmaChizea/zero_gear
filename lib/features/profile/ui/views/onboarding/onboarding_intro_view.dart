import 'package:flutter/material.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart' show Button;
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/icons/app_logo.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class OnboardingIntroView extends StatelessWidget {
  const OnboardingIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      footer: Button(
        label: 'Get started',
        onPressed: () => context.pushNamed(AppRoute.onboarding.name),
      ),
      children: [
        const AppLogo(fullLogo: false, size: 56),
        AppSpacing.v24,
        AppText('Let\'s set up your plan', style: AppTextStyles.display),
        AppSpacing.v8,
        AppText(
          'Three quick questions so we can match your workouts to you. It takes under a minute.',
          color: context.colors.textSecondary,
        ),
        AppSpacing.v24,
        const _Item(
          number: '1',
          title: 'Gender',
          text: 'Shapes which muscle groups you train most.',
        ),
        AppSpacing.v12,
        const _Item(
          number: '2',
          title: 'Height',
          text: 'Helps pick the right exercise variations.',
        ),
        AppSpacing.v12,
        const _Item(
          number: '3',
          title: 'Weight',
          text: 'Sets your starting level.',
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.number, required this.title, required this.text});
  final String number;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        spacing: 16.h,
        children: [
          Container(
            height: 32,
            width: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.bgInverse,
            ),
            child: AppText(
              number,
              style: AppTextStyles.label,
              color: context.colors.textInverse,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, style: AppTextStyles.bodyMedium),
                AppText(
                  text,
                  color: context.colors.textSecondary,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
