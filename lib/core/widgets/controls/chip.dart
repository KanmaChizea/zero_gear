import 'package:flutter/material.dart';
import 'package:zero_gear/core/extensions/string_extensions.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class AppChip extends StatelessWidget {
  const AppChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetricPadding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(width: 1.5, color: context.colors.borderDefault),
      ),
      child: AppText(label.toSentenceCase, style: AppTextStyles.caption),
    );
  }
}
