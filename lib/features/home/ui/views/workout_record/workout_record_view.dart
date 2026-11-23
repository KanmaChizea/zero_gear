import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/feedback/error_view.dart';

import '../../../data/models/workout_record.dart';
import '../../../data/models/workout_status.dart';
import '../../../data/services/workout_service.dart';
import '../../models/workout_record_ui_state.dart';
import '../../widgets/workout/record_exercise_tile.dart';
import '../../widgets/workout/record_stats.dart';
import '../../widgets/workout/workout_header.dart';
import '../../widgets/workout/workout_status_badge.dart';
import 'workout_record_view_model.dart';

class WorkoutRecordView extends StatelessWidget {
  const WorkoutRecordView({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutRecordViewModel(
        workoutService: context.read<WorkoutService>(),
        date: date,
      ),
      child: const _WorkoutRecordBody(),
    );
  }
}

class _WorkoutRecordBody extends StatelessWidget {
  const _WorkoutRecordBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<WorkoutRecordViewModel>();
    return BlocConsumer<WorkoutRecordViewModel, WorkoutRecordUiState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage == null) return;
        viewModel.clearError();
        AppToast.error(context, title: state.errorMessage!);
      },
      builder: (context, state) {
        final tag = formatWeekdayDayMonth(viewModel.date).toUpperCase();

        if (state.record.hasError) {
          return AppScreen(
            scrollable: false,
            header: WorkoutHeader(
              tag: tag,
              title: 'Workout',
              text: 'We could not load this day.',
            ),
            children: [
              Expanded(
                child: ErrorView(
                  title: 'Could not load this workout',
                  text: state.record.error!,
                  onRetry: viewModel.initialize,
                ),
              ),
            ],
          );
        }

        if (state.record.isLoading) {
          return AppScreen(
            scrollable: false,
            header: WorkoutHeader(
              tag: tag,
              title: 'Workout',
              text: 'Loading this day…',
            ),
            children: const [
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }

        final record = state.record.data;
        if (record == null) {
          return AppScreen(
            header: WorkoutHeader(
              tag: tag,
              title: 'No workout',
              text: 'Nothing was recorded on this day.',
            ),
            children: const [],
          );
        }

        return AppScreen(
          header: WorkoutHeader(
            prefix: WorkoutStatusBadge(status: record.summary.status),
            tag: tag,
            title: 'Day ${record.overallDay} · ${record.dayName}',
            text: _timesText(record),
          ),
          footer: state.canResume
              ? Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Button(
                    label: 'Complete workout',
                    isLoading: state.isResuming,
                    onPressed: () async {
                      if (!await viewModel.resume() || !context.mounted) {
                        return;
                      }
                      context.pushReplacementNamed(AppRoute.activeWorkout.name);
                    },
                  ),
                )
              : null,
          children: [
            RecordStats(record: record),
            SizedBox(height: 24.h),
            for (final exercise in record.exercises) ...[
              RecordExerciseTile(exercise: exercise),
              SizedBox(height: 12.h),
            ],
            SizedBox(height: 12.h),
          ],
        );
      },
    );
  }
}

String _timesText(WorkoutRecord record) {
  final summary = record.summary;
  final end = summary.status == WorkoutStatus.completed
      ? 'Finished'
      : 'Stopped';
  return 'Started ${formatTime(summary.startedAt)} · '
      '$end ${formatTime(summary.endedAt)}';
}
