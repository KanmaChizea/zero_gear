import 'package:flutter/material.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class ConfirmationModal extends StatelessWidget {
  const ConfirmationModal({
    super.key,
    required this.title,
    required this.text,
    required this.yesLabel,
    required this.yesOnPress,
    required this.noLabel,
    this.noOnPress,
  });
  final String title;
  final String text;
  final String yesLabel;
  final Function() yesOnPress;
  final String noLabel;
  final Function()? noOnPress;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, style: AppTextStyles.heading),
        AppSpacing.v12,
        AppText(text, color: context.colors.textSecondary),
        AppSpacing.v28,
        Button(
          label: yesLabel,
          onPressed: () {
            context.pop();
            yesOnPress();
          },
        ),
        AppSpacing.v12,
        Button(
          label: noLabel,
          variant: ButtonVariant.outlined,
          onPressed: () {
            context.pop();
            noOnPress?.call();
          },
        ),
      ],
    );
  }
}
