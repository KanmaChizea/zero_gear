import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/features/home/data/models/plan_day.dart';
import 'package:zero_gear/features/home/ui/widgets/workout/workout_header.dart';

import '../../../data/services/plan_service.dart';
import 'day_detail_view_model.dart';

class DayDetailView extends StatelessWidget {
  const DayDetailView({super.key, required this.day});
  final int day;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DayDetailViewModel(planService: context.read<PlanService>(), day: day),
      child: const _DayDetailBody(),
    );
  }
}

class _DayDetailBody extends StatelessWidget {
  const _DayDetailBody();

  @override
  Widget build(BuildContext context) {
    final day = context.read<DayDetailViewModel>().day;
    return BlocBuilder<DayDetailViewModel, AsyncValue<PlanDay>>(
      builder: (context, state) {
        final plan = state.data;
        return AppScreen(
          header: plan == null
              ? null
              : WorkoutHeader(
                  tag: 'Day $day'.toUpperCase(),
                  title: plan.name,
                  text:
                      '${plan.main.length} exercises · '
                      'about ${plan.estimatedMinutes} min · '
                      'Targets ${plan.focusMuscles.join(', ')}',
                ),
          children: [],
        );
      },
    );
  }
}
