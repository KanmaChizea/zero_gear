import 'package:flutter/widgets.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class AppStepper extends StatelessWidget {
  const AppStepper({
    super.key,
    required this.currentIndex,
    required this.length,
  });
  final int currentIndex;
  final int length;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      children: [
        for (var i = 0; i < length; i++)
          Expanded(
            child: Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: i <= currentIndex
                    ? context.colors.accentPrimary
                    : context.colors.bgTertiary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
      ],
    );
  }
}
