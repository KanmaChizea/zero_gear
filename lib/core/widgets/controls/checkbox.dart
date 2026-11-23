import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({super.key, required this.value, this.onPress});

  final bool value;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      checked: value,
      onTap: onPress,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          width: 22.r,
          height: 22.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value ? colors.accentPrimary : Colors.transparent,
            border: Border.all(
              color: value ? colors.accentPrimary : colors.borderStrong,
              width: 2,
            ),
          ),
          child: value
              ? SvgIcon(AppSvgs.check, size: 18, color: colors.accentOn)
              : null,
        ),
      ),
    );
  }
}
