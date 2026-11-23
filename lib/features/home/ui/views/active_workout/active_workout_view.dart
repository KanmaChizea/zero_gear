import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/extensions/string_extensions.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/feedback/error_view.dart';
import 'package:zero_gear/core/widgets/feedback/loader.dart';
import 'package:zero_gear/core/widgets/modals/modals.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

import '../../../data/models/plan_enums.dart';
import '../../../data/models/plan_exercise.dart';
import '../../../data/services/workout_service.dart';
import '../../models/active_workout_ui_state.dart';
import '../../widgets/exercise/exercise_gif.dart';
import '../../widgets/workout/active_workout_header.dart';
import '../../widgets/workout/set_chip.dart';
import 'active_workout_view_model.dart';

class ActiveWorkoutView extends StatelessWidget {
  const ActiveWorkoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActiveWorkoutViewModel(
        workoutService: context.read<WorkoutService>(),
        session: context.read<SessionCubit>(),
      ),
      child: const _ActiveWorkoutBody(),
    );
  }
}

class _ActiveWorkoutBody extends StatefulWidget {
  const _ActiveWorkoutBody();

  @override
  State<_ActiveWorkoutBody> createState() => _ActiveWorkoutBodyState();
}

class _ActiveWorkoutBodyState extends State<_ActiveWorkoutBody> {
  PageController? _pages;

  @override
  void dispose() {
    _pages?.dispose();
    super.dispose();
  }

  void _next() => _pages?.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ActiveWorkoutViewModel>();

    Future<void> confirmGiveUp() {
      final state = viewModel.state;
      final finished = state.active?.finishedExercises ?? 0;
      return AppModals.showConfirmationDialog(
        context,
        title: 'Give up this workout?',
        text:
            'You have finished $finished of ${state.exercises.length} '
            'exercises. We will save your progress as an incomplete workout.',
        yesLabel: 'Keep going',
        yesOnPress: () {},
        noLabel: 'Give up',
        noOnPress: () async {
          Loader.show();
          final bool left;
          try {
            left = await viewModel.giveUp();
          } finally {
            Loader.hide();
          }
          if (!left || !context.mounted) return;
          context.goNamed(AppRoute.home.name);
        },
      );
    }

    Future<void> finish() async {
      if (!await viewModel.finish() || !context.mounted) return;
      final state = viewModel.state;
      final finished = state.finished!;
      if (state.coolDownNext) {
        context.pushReplacementNamed(
          AppRoute.stretchOffer.name,
          pathParameters: {
            'phase': DayPhase.cooldown.name,
            'day': '${finished.overallDay}',
          },
          extra: finished,
        );
      } else {
        context.pushReplacementNamed(
          AppRoute.workoutComplete.name,
          extra: finished,
        );
      }
    }

    return BlocConsumer<ActiveWorkoutViewModel, ActiveWorkoutUiState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage == null) return;
        viewModel.clearError();
        AppToast.error(context, title: state.errorMessage!);
      },
      builder: (context, state) {
        final exercise = state.current;
        return PopScope(
          canPop: exercise == null,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && exercise != null) confirmGiveUp();
          },
          child: AppScreen(
            header: ActiveWorkoutHeader(
              onBack: exercise == null ? () => context.pop() : confirmGiveUp,
              label: exercise == null
                  ? null
                  : 'Day ${state.active!.day.overallDay} · '
                        '${state.active!.day.name}',
              title: exercise == null
                  ? null
                  : 'Exercise ${state.index + 1} of ${state.exercises.length}',
              currentIndex: state.index,
              length: state.exercises.length,
            ),
            footer: exercise == null
                ? null
                : Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Column(
                      spacing: 8.h,
                      children: [
                        Button(
                          label: state.isLast
                              ? 'Finish workout'
                              : 'Next exercise',
                          enabled: state.isCurrentDone,
                          isLoading: state.isFinishing,
                          onPressed: state.isLast ? finish : _next,
                        ),
                        Button(
                          label: 'See form tips',
                          variant: ButtonVariant.text,
                          onPressed: () => context.pushNamed(
                            AppRoute.exerciseDetail.name,
                            extra: exercise.exercise,
                            pathParameters: {
                              'repCount':
                                  '${'set'.plural(exercise.sets)} × '
                                  '${exercise.repsText}',
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            scrollable: false,
            children: [
              Expanded(
                child: state.workout.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  data: (workout) {
                    final pages = _pages ??= PageController(
                      initialPage: state.index,
                    );
                    return PageView.builder(
                      controller: pages,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: viewModel.onPageChanged,
                      itemCount: state.exercises.length,
                      itemBuilder: (context, index) => SingleChildScrollView(
                        child: _ExerciseBody(
                          exercise: state.exercises[index],
                          setsDone: index < workout.setsDone.length
                              ? workout.setsDone[index]
                              : 0,
                          onToggleSet: (set) => viewModel.toggleSet(index, set),
                        ),
                      ),
                    );
                  },
                  error: (error) => ErrorView(
                    title: 'Could not open your workout',
                    text: error,
                    onRetry: viewModel.initialize,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExerciseBody extends StatelessWidget {
  const _ExerciseBody({
    required this.exercise,
    required this.setsDone,
    required this.onToggleSet,
  });

  final PlanExercise exercise;
  final int setsDone;
  final ValueChanged<int> onToggleSet;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final detail = exercise.exercise;
    final rest = detail.restText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24.h,
      children: [
        ExerciseGif(url: detail.gifUrl),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: [
            AppText(detail.name, style: AppTextStyles.title),
            AppText(
              '${'set'.plural(exercise.sets)} × ${exercise.repsText}'
              '${rest != null ? ' · Rest about $rest' : ''}',
              style: AppTextStyles.caption,
              color: colors.textSecondary,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            AppText(
              'SETS',
              style: AppTextStyles.label,
              color: colors.textSecondary,
            ),
            Row(
              spacing: 16.w,
              children: [
                for (var i = 0; i < exercise.sets; i++)
                  SetChip(
                    number: i + 1,
                    isDone: i < setsDone,
                    onTap: () => onToggleSet(i),
                  ),
              ],
            ),
            AppText(
              setsDone >= exercise.sets
                  ? 'All sets done'
                  : 'Tap a set when you finish it',
              style: AppTextStyles.caption,
              color: colors.textSecondary,
            ),
          ],
        ),
        if (detail.tempoText != null)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                AppText(
                  'TEMPO',
                  style: AppTextStyles.label,
                  color: colors.textSecondary,
                ),
                AppText(detail.tempoText!, style: AppTextStyles.caption),
              ],
            ),
          ),
      ],
    );
  }
}
