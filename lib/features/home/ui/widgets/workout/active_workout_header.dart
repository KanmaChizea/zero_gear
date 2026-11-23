import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/app_back_button.dart';
import 'package:zero_gear/core/widgets/containers/stepper.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class ActiveWorkoutHeader extends StatelessWidget {
  const ActiveWorkoutHeader({
    super.key,
    required this.onBack,
    this.label,
    this.title,
    this.currentIndex = 0,
    this.length = 0,
  });

  final VoidCallback onBack;
  final String? label;
  final String? title;
  final int currentIndex;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      children: [
        Row(
          spacing: 16.w,
          children: [
            AppBackButton(onPress: onBack),
            if (label != null || title != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null)
                      AppText(
                        label!,
                        style: AppTextStyles.caption,
                        color: context.colors.textSecondary,
                      ),
                    if (title != null)
                      AppText(title!, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
          ],
        ),
        if (length > 0) AppStepper(currentIndex: currentIndex, length: length),
      ],
    );
  }
}
