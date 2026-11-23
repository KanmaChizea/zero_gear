import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/feedback/error_view.dart';

import '../../../data/models/plan_enums.dart';
import '../../../data/services/plan_service.dart';
import '../../../data/services/workout_service.dart';
import '../../models/stretch_offer_ui_state.dart';
import '../../widgets/workout/stretch_tile.dart';
import '../../widgets/workout/workout_header.dart';
import 'stretch_offer_view_model.dart';

class StretchOfferView extends StatelessWidget {
  const StretchOfferView({super.key, required this.phase, required this.day});

  final DayPhase phase;
  final int day;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StretchOfferViewModel(
        planService: context.read<PlanService>(),
        workoutService: context.read<WorkoutService>(),
        phase: phase,
        day: day,
      ),
      child: const _StretchOfferBody(),
    );
  }
}

class _StretchOfferBody extends StatelessWidget {
  const _StretchOfferBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<StretchOfferViewModel>();
    final isWarmUp = viewModel.isWarmUp;
    final noun = isWarmUp ? 'warm-up' : 'cool-down';

    return BlocConsumer<StretchOfferViewModel, StretchOfferUiState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage == null) return;
        viewModel.clearError();
        AppToast.error(context, title: state.errorMessage!);
      },
      builder: (context, state) {
        final stretches = state.stretches.data;
        return AppScreen(
          header: WorkoutHeader(
            tag: 'OPTIONAL',
            title: isWarmUp ? 'Warm up first?' : 'Cool down?',
            text: stretches == null
                ? ''
                : '${stretches.length} gentle stretches · '
                      'about ${state.minutes} min · '
                      '${isWarmUp ? 'You can skip this' : 'Your workout is already saved'}',
          ),
          footer: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              spacing: 12.h,
              children: [
                Button(
                  label: 'Start $noun',
                  enabled: stretches != null && !state.isSkipping,
                  onPressed: () => context.pushReplacementNamed(
                    AppRoute.activeStretch.name,
                    pathParameters: {
                      'phase': viewModel.phase.name,
                      'day': '${viewModel.day}',
                    },
                  ),
                ),
                Button(
                  label: 'Skip $noun',
                  variant: ButtonVariant.outlined,
                  isLoading: state.isSkipping,
                  enabled: stretches != null,
                  onPressed: () async {
                    final proceed = await viewModel.skip();
                    if (!proceed || !context.mounted) return;
                    if (isWarmUp) {
                      context.pushReplacementNamed(
                        AppRoute.activeWorkout.name,
                      );
                    } else {
                      context.goNamed(AppRoute.home.name);
                    }
                  },
                ),
              ],
            ),
          ),
          children: [
            state.stretches.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (data) => Column(
                spacing: 8.h,
                children: [for (final item in data) StretchTile(item: item)],
              ),
              error: (error) => ErrorView(
                title: 'Could not load the $noun',
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
