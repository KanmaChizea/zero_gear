import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.title,
    required this.text,
    required this.onRetry,
    this.retryLabel = 'Try again',
  });

  final String title;
  final String text;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: AppSpacing.symmetricPadding(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SvgIcon(AppSvgs.sadBadge, size: 50, keepOriginalColors: true),
            AppSpacing.v24,
            AppText(
              title,
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),
            AppSpacing.v8,
            AppText(
              text,
              color: context.colors.textSecondary,
              textAlign: TextAlign.center,
            ),
            AppSpacing.v24,
            Button(label: retryLabel, onPressed: onRetry, fullWidth: false),
          ],
        ),
      ),
    );
  }
}
