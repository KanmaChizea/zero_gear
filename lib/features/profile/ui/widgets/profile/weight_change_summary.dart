import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/profile/data/models/weight_summary.dart';

class WeightChangeSummary extends StatelessWidget {
  const WeightChangeSummary({super.key, required this.data});
  final WeightSummary data;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12.w,
        children:
            [
                  (label: 'kg now', value: (data.currentKg ?? 0).toString()),
                  (
                    label: 'kg since start',
                    value: ((data.startKg ?? 0) - (data.currentKg ?? 0))
                        .toInt()
                        .toString(),
                  ),
                  (label: 'updates', value: formatNumber(data.updateCount)),
                ]
                .map(
                  (e) => Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(e.value, style: AppTextStyles.display),
                          AppText(
                            e.label,
                            style: AppTextStyles.caption,
                            color: context.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
