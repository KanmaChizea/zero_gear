import 'package:flutter/widgets.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPress});
  final Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress ?? context.pop,
      child: Container(
        height: 40.h,
        width: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1.5, color: context.colors.borderDefault),
        ),
        child: const SvgIcon(AppSvgs.chevronLeft, size: 20),
      ),
    );
  }
}
