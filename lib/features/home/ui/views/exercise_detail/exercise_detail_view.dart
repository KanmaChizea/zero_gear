import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/exercise_detail_ui_state.dart';
import 'exercise_detail_view_model.dart';

class ExerciseDetailView extends StatelessWidget {
  const ExerciseDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExerciseDetailViewModel(homeService: context.read<HomeService>()),
      child: const _ExerciseDetailBody(),
    );
  }
}

class _ExerciseDetailBody extends StatelessWidget {
  const _ExerciseDetailBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Detail')),
      body: BlocBuilder<ExerciseDetailViewModel, ExerciseDetailUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Exercise Detail'));
        },
      ),
    );
  }
}
