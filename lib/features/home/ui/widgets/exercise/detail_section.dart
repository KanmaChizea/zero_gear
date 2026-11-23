import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class DetailSection extends StatelessWidget {
  const DetailSection({
    super.key,
    required this.items,
    required this.title,
    required this.iconBuilder,
  });
  final List<String> items;
  final String title;
  final Widget Function(int) iconBuilder;
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.padding24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          AppText(title, style: AppTextStyles.heading),
          for (var i = 0; i < items.length; i++)
            Row(
              spacing: 12.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconBuilder(i),
                Expanded(child: AppText(items[i])),
              ],
            ),
        ],
      ),
    );
  }
}
