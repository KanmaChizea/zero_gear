import 'package:flutter/widgets.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppSpacing.padding16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: context.colors.bgSecondary,
      ),
      child: child,
    );
  }
}
