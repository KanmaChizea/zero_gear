import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/update_height_weight_ui_state.dart';
import 'update_height_weight_view_model.dart';

class UpdateHeightWeightView extends StatelessWidget {
  const UpdateHeightWeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateHeightWeightViewModel(
        profileService: context.read<ProfileService>(),
      ),
      child: const _UpdateHeightWeightBody(),
    );
  }
}

class _UpdateHeightWeightBody extends StatelessWidget {
  const _UpdateHeightWeightBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Height Weight')),
      body: BlocBuilder<UpdateHeightWeightViewModel, UpdateHeightWeightUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Update Height Weight'));
        },
      ),
    );
  }
}
