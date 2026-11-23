import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/workout_record.dart';
import 'package:zero_gear/features/home/data/models/workout_status.dart';

class RecordStats extends StatelessWidget {
  const RecordStats({super.key, required this.record});

  final WorkoutRecord record;

  @override
  Widget build(BuildContext context) {
    final total = record.exercises.length;
    final done = record.exercisesDone;
    final completed = record.summary.status == WorkoutStatus.completed;

    return Row(
      spacing: 12.w,
      children: [
        _StatCard(value: '${record.minutes}', label: 'minutes'),
        _StatCard(
          value: completed ? '$total' : '$done/$total',
          label: 'exercises',
        ),
        _StatCard(value: '${record.setsDone}', label: 'sets'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: AppSpacing.symmetricPadding(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(value, style: AppTextStyles.title),
            AppText(
              label,
              style: AppTextStyles.caption,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
