import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/error_view.dart';
import 'package:zero_gear/features/home/ui/models/day_detail_ui_state.dart';
import 'package:zero_gear/features/home/ui/widgets/workout/exercise_tile.dart';
import 'package:zero_gear/features/home/ui/widgets/workout/workout_header.dart';

import '../../../data/services/plan_service.dart';
import '../../../data/services/workout_service.dart';
import 'day_detail_view_model.dart';

class DayDetailView extends StatelessWidget {
  const DayDetailView({super.key, required this.day});
  final int day;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DayDetailViewModel(
        planService: context.read<PlanService>(),
        workoutService: context.read<WorkoutService>(),
        day: day,
      ),
      child: const _DayDetailBody(),
    );
  }
}

class _DayDetailBody extends StatelessWidget {
  const _DayDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<DayDetailViewModel>();
    return BlocBuilder<DayDetailViewModel, DayDetailUiState>(
      builder: (context, state) {
        final plan = state.plan.data;
        return AppScreen(
          header: plan == null
              ? null
              : WorkoutHeader(
                  tag: 'Day ${viewModel.day}'.toUpperCase(),
                  title: plan.name,
                  text:
                      '${plan.main.length} exercises · '
                      'about ${plan.estimatedMinutes} min · '
                      'Targets ${plan.focusMuscles.join(', ')}',
                ),
          footer: Button(
            label: state.isResuming
                ? 'Resume'
                : 'Start Day ${formatNumber(viewModel.day)}',
            onPressed: () {},
          ),
          children: [
            state.plan.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (data) => Column(
                spacing: 8,
                children: data.exercises
                    .map((e) => ExerciseTile(item: e))
                    .toList(),
              ),
              error: (error) => ErrorView(
                title: 'Error',
                text: error,
                onRetry: viewModel.initialize,
              ),
            ),
          ],
        );
      },
    );
  }
}
