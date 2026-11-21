import 'package:flutter/material.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/icons/check_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class OnboardingCompleteView extends StatelessWidget {
  const OnboardingCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CheckIcon(iconSize: 44, size: 96),
                      AppSpacing.v24,
                      AppText(
                        'Your plan is ready',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.display,
                      ),
                      AppSpacing.v8,
                      AppText(
                        'We built it from your answers. Do the days in any order, on any date you like.',
                        color: context.colors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Button(
                label: 'Go home',
                onPressed: () => context.goNamed(AppRoute.home.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
