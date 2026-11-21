import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, this.onPress});

  final bool value;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      toggled: value,
      onTap: onPress,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 44.w,
          height: 26.h,
          padding: EdgeInsets.all(3.r),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: value ? colors.accentPrimary : colors.textSecondary,
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Container(
            width: 20.r,
            height: 20.r,
            decoration: BoxDecoration(
              color: colors.bgPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
