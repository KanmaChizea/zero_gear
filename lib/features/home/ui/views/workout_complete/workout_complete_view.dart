import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/workout_complete_ui_state.dart';
import 'workout_complete_view_model.dart';

class WorkoutCompleteView extends StatelessWidget {
  const WorkoutCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WorkoutCompleteViewModel(homeService: context.read<HomeService>()),
      child: const _WorkoutCompleteBody(),
    );
  }
}

class _WorkoutCompleteBody extends StatelessWidget {
  const _WorkoutCompleteBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Complete')),
      body: BlocBuilder<WorkoutCompleteViewModel, WorkoutCompleteUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Workout Complete'));
        },
      ),
    );
  }
}
