import 'package:flutter/material.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';

class CalendarMonthButton extends StatelessWidget {
  const CalendarMonthButton({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(6.r),
        child: Opacity(
          opacity: onTap == null ? 0.3 : 1,
          child: SvgIcon(asset, size: 20),
        ),
      ),
    );
  }
}
