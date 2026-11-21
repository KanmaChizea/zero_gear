import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/active_stretch_ui_state.dart';
import 'active_stretch_view_model.dart';

class ActiveStretchView extends StatelessWidget {
  const ActiveStretchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ActiveStretchViewModel(homeService: context.read<HomeService>()),
      child: const _ActiveStretchBody(),
    );
  }
}

class _ActiveStretchBody extends StatelessWidget {
  const _ActiveStretchBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Stretch')),
      body: BlocBuilder<ActiveStretchViewModel, ActiveStretchUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Active Stretch'));
        },
      ),
    );
  }
}
