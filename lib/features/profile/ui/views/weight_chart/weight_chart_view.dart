import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/weight_chart_ui_state.dart';
import 'weight_chart_view_model.dart';

class WeightChartView extends StatelessWidget {
  const WeightChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeightChartViewModel(profileService: context.read<ProfileService>()),
      child: const _WeightChartBody(),
    );
  }
}

class _WeightChartBody extends StatelessWidget {
  const _WeightChartBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weight Chart')),
      body: BlocBuilder<WeightChartViewModel, WeightChartUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Weight Chart'));
        },
      ),
    );
  }
}
