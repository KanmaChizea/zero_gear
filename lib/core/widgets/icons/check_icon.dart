import 'package:flutter/widgets.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/app_colors.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';

class CheckIcon extends StatelessWidget {
  const CheckIcon({super.key, required this.iconSize, required this.size});
  final double iconSize;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.h,
      width: size.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.accentPrimary,
      ),
      child: SvgIcon(
        AppSvgs.check,
        size: iconSize,
        color: context.colors.accentOn,
      ),
    );
  }
}
