import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/feedback/error_view.dart';
import 'package:zero_gear/core/widgets/icons/app_logo.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/features/home/ui/widgets/home/progress_calendar.dart';
import 'package:zero_gear/features/home/ui/widgets/home/progress_summary.dart';
import 'package:zero_gear/features/home/ui/widgets/home/todays_card.dart';

import '../../data/services/home_service.dart';
import '../../data/services/workout_service.dart';
import '../models/home_ui_state.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeViewModel(
        homeService: context.read<HomeService>(),
        workoutService: context.read<WorkoutService>(),
      ),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    return BlocConsumer<HomeViewModel, HomeUiState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage == null) return;
        viewModel.clearError();
        AppToast.error(context, title: state.errorMessage!);
      },
      builder: (context, state) {
        return AppScreen(
          header: Row(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppLogo(size: 36, style: AppTextStyles.heading),
              GestureDetector(
                onTap: () => context.pushNamed(AppRoute.profile.name),
                child: Container(
                  height: 40.h,
                  width: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.bgTertiary,
                  ),
                  child: SvgIcon(
                    AppSvgs.avatar,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          children: [
            state.summary.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24.h,
                  children: [
                    TodaysCard(
                      data: data,
                      isStarting: state.isStarting,
                      isResuming: state.isResuming,
                      isGivingUp: state.isGivingUp,
                      onStart: () => context.pushNamed(
                        AppRoute.dayDetail.name,
                        pathParameters: {'day': '${data.nextDay.overallDay}'},
                      ),
                      onResume: () async {
                        if (!await viewModel.resume() || !context.mounted) {
                          return;
                        }
                        await context.pushNamed(
                          AppRoute.dayDetail.name,
                          pathParameters: {
                            'day':
                                '${data.activeWorkout?.day.overallDay ?? data.nextDay.overallDay}',
                          },
                        );
                      },
                      onGiveUp: viewModel.giveUp,
                    ),
                    ProgressSummary(summary: data),
                    ProgressCalendar(
                      data: data.calendar,
                      startDate: data.profile.startedAt,
                    ),
                  ],
                );
              },
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
