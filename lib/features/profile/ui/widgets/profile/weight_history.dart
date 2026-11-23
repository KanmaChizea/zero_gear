import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/profile/data/models/weight_entry.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/profile_section.dart';

class WeightHistory extends StatelessWidget {
  const WeightHistory({super.key, required this.data});
  final List<WeightEntry> data;
  @override
  Widget build(BuildContext context) {
    return ProfileSection(
      title: 'HISTORY',
      items: [
        ...data.map(
          (e) => ProfileItem(
            label: formatShortDate(e.recordedAt),
            trailing: AppText(
              '${e.weightKg.toInt()} kg',
              color: context.colors.textSecondary,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
