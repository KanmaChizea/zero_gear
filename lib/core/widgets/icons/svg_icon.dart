import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zero_gear/core/theme/app_colors.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.asset, {
    super.key,
    this.size,
    this.color,
    this.keepOriginalColors = false,
    this.currentColor,
  });

  final String asset;
  final double? size;
  final Color? color;
  final bool keepOriginalColors;

  /// Colors the parts of the SVG that use `currentColor`; with
  /// [keepOriginalColors], everything else keeps its own color.
  final Color? currentColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      theme: SvgTheme(currentColor: currentColor ?? const Color(0xFF000000)),
      width: size?.r,
      height: size?.r,
      colorFilter: keepOriginalColors
          ? null
          : ColorFilter.mode(
              color ?? context.colors.textPrimary,
              BlendMode.srcIn,
            ),
    );
  }
}
