import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/active_workout_ui_state.dart';
import 'active_workout_view_model.dart';

class ActiveWorkoutView extends StatelessWidget {
  const ActiveWorkoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ActiveWorkoutViewModel(homeService: context.read<HomeService>()),
      child: const _ActiveWorkoutBody(),
    );
  }
}

class _ActiveWorkoutBody extends StatelessWidget {
  const _ActiveWorkoutBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Workout')),
      body: BlocBuilder<ActiveWorkoutViewModel, ActiveWorkoutUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Active Workout'));
        },
      ),
    );
  }
}
