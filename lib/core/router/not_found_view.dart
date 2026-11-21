import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

import 'app_route.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppScreen(
      children: [
        const Spacer(),
        const SvgIcon(AppSvgs.sadBadge, size: 96, keepOriginalColors: true),
        AppSpacing.v24,
        AppText(
          'Page not found',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
        AppSpacing.v8,
        AppText(
          'The page you are looking for does not exist.',
          color: colors.textSecondary,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        Button(
          label: 'Go home',
          onPressed: () => context.goNamed(AppRoute.home.name),
        ),
        AppSpacing.v16,
      ],
    );
  }
}
