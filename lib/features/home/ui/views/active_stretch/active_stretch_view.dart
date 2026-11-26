import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/audio/audio_guide.dart';
import 'package:zero_gear/core/constants/app_layout.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/feedback/error_view.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

import '../../../data/models/plan_enums.dart';
import '../../../data/models/plan_exercise.dart';
import '../../../data/services/plan_service.dart';
import '../../../data/services/workout_service.dart';
import '../../models/active_stretch_ui_state.dart';
import '../../widgets/exercise/exercise_gif.dart';
import '../../../data/models/finished_workout.dart';
import '../../widgets/workout/active_workout_header.dart';
import '../../widgets/workout/hold_timer.dart';
import '../../widgets/workout/wide_workout_layout.dart';
import 'active_stretch_view_model.dart';

class ActiveStretchView extends StatelessWidget {
  const ActiveStretchView({
    super.key,
    required this.phase,
    required this.day,
    this.finished,
  });

  final DayPhase phase;
  final int day;

  /// The workout just finished; see [StretchOfferView.finished].
  final FinishedWorkout? finished;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActiveStretchViewModel(
        planService: context.read<PlanService>(),
        workoutService: context.read<WorkoutService>(),
        session: context.read<SessionCubit>(),
        audio: context.read<AudioGuide>(),
        phase: phase,
        day: day,
      ),
      child: _ActiveStretchBody(finished: finished),
    );
  }
}

class _ActiveStretchBody extends StatefulWidget {
  const _ActiveStretchBody({required this.finished});

  final FinishedWorkout? finished;

  @override
  State<_ActiveStretchBody> createState() => _ActiveStretchBodyState();
}

class _ActiveStretchBodyState extends State<_ActiveStretchBody> {
  final _pages = PageController();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _previous() => _pages.previousPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
  );

  void _next() => _pages.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ActiveStretchViewModel>();
    final isWarmUp = viewModel.isWarmUp;
    final noun = isWarmUp ? 'warm-up' : 'cool-down';

    Future<void> finish() async {
      final proceed = await viewModel.finish();
      if (!proceed || !context.mounted) return;
      if (isWarmUp) {
        context.pushReplacementNamed(AppRoute.activeWorkout.name);
      } else if (widget.finished != null) {
        context.pushReplacementNamed(
          AppRoute.workoutComplete.name,
          extra: widget.finished,
        );
      } else {
        context.goNamed(AppRoute.home.name);
      }
    }

    return BlocConsumer<ActiveStretchViewModel, ActiveStretchUiState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage == null) return;
        viewModel.clearError();
        AppToast.error(context, title: state.errorMessage!);
      },
      builder: (context, state) {
        final stretch = state.current;
        final wide = AppLayout.isWide(context);
        final footer = stretch == null
            ? null
            : Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Column(
                  spacing: 8.h,
                  children: [
                    Button(
                      label: !state.isLast
                          ? 'Next stretch'
                          : isWarmUp
                          ? 'Start workout'
                          : 'Done',
                      isLoading: state.isLast && state.isFinishing,
                      onPressed: state.isLast ? finish : _next,
                    ),
                    if (!state.isLast)
                      Button(
                        label: 'Skip $noun',
                        variant: ButtonVariant.text,
                        isLoading: state.isFinishing,
                        onPressed: finish,
                      ),
                  ],
                ),
              );
        return PopScope(
          canPop: state.index == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _previous();
          },
          child: AppScreen(
            header: ActiveWorkoutHeader(
              onBack: state.index > 0 ? _previous : () => context.pop(),
              label: isWarmUp ? 'Warm-up' : 'Cool-down',
              title: stretch == null
                  ? null
                  : 'Stretch ${state.index + 1} of ${state.items.length}',
              currentIndex: state.index,
              length: state.items.length,
            ),
            footer: wide ? null : footer,
            scrollable: false,
            children: [
              Expanded(
                child: state.stretches.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  data: (stretches) => PageView.builder(
                    controller: _pages,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: viewModel.onPageChanged,
                    itemCount: stretches.length,
                    itemBuilder: (context, index) {
                      final item = stretches[index];
                      final body = _StretchBody(
                        stretch: item,
                        isWarmUp: isWarmUp,
                        showImage: !wide,
                      );
                      return wide
                          ? WidePage(
                              image: Align(
                                alignment: Alignment.topCenter,
                                child: ExerciseGif(url: item.exercise.gifUrl),
                              ),
                              details: body,
                            )
                          : SingleChildScrollView(child: body);
                    },
                  ),
                  error: (error) => ErrorView(
                    title: 'Could not load the $noun',
                    text: error,
                    onRetry: viewModel.initialize,
                  ),
                ),
              ),
              if (wide && footer != null) WideFooter(child: footer),
            ],
          ),
        );
      },
    );
  }
}

class _StretchBody extends StatelessWidget {
  const _StretchBody({
    required this.stretch,
    required this.isWarmUp,
    required this.showImage,
  });

  final PlanExercise stretch;
  final bool isWarmUp;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final exercise = stretch.exercise;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24.h,
      children: [
        if (showImage) ExerciseGif(url: exercise.gifUrl),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: [
            AppText(exercise.name, style: AppTextStyles.display),
            AppText(
              '${isWarmUp ? 'Repeat for' : 'Hold for'} ${stretch.reps}',
              color: colors.textSecondary,
            ),
          ],
        ),
        if (stretch.holdSeconds case final seconds?)
          HoldTimer(seconds: seconds),
        if (exercise.howTo.isNotEmpty)
          AppCard(
            padding: AppSpacing.symmetricPadding(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                AppText(
                  'HOW TO',
                  style: AppTextStyles.label,
                  color: colors.textSecondary,
                ),
                AppText(exercise.howTo.join(' ')),
              ],
            ),
          ),
      ],
    );
  }
}
