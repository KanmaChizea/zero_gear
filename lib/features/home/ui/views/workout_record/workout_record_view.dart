import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/workout_record_ui_state.dart';
import 'workout_record_view_model.dart';

class WorkoutRecordView extends StatelessWidget {
  const WorkoutRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WorkoutRecordViewModel(homeService: context.read<HomeService>()),
      child: const _WorkoutRecordBody(),
    );
  }
}

class _WorkoutRecordBody extends StatelessWidget {
  const _WorkoutRecordBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Record')),
      body: BlocBuilder<WorkoutRecordViewModel, WorkoutRecordUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Workout Record'));
        },
      ),
    );
  }
}
