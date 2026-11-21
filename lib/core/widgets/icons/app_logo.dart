import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

import 'svg_icon.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 64, this.fullLogo = true, this.style});

  final double size;
  final TextStyle? style;
  final bool fullLogo;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        SvgIcon(
          Theme.of(context).brightness == Brightness.light
              ? AppSvgs.logoMark
              : AppSvgs.logoMarkDark,
          keepOriginalColors: true,
          size: size,
        ),
        if (fullLogo) AppText('Zero Gear', style: style ?? AppTextStyles.title),
      ],
    );
  }
}
