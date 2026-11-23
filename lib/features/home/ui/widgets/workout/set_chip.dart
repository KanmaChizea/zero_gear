import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class SetChip extends StatelessWidget {
  const SetChip({
    super.key,
    required this.number,
    required this.isDone,
    required this.onTap,
  });

  final int number;
  final bool isDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.square(
        dimension: 48.r,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: isDone
              ? Container(
                  key: const ValueKey('done'),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.accentPrimary,
                  ),
                  child: SvgIcon(
                    AppSvgs.check,
                    size: 22,
                    color: colors.accentOn,
                  ),
                )
              : Container(
                  key: const ValueKey('todo'),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.bgPrimary,
                    border: Border.all(width: 1.5, color: colors.borderStrong),
                  ),
                  child: AppText('$number', style: AppTextStyles.bodyMedium),
                ),
        ),
      ),
    );
  }
}
