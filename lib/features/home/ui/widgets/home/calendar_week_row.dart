import 'package:flutter/material.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class CalendarWeekRow extends StatelessWidget {
  const CalendarWeekRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final child in children)
          SizedBox(
            width: 40.w,
            child: Center(child: child),
          ),
      ],
    );
  }
}
