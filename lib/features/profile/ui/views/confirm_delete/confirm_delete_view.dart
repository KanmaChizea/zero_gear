import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/confirm_delete_ui_state.dart';
import 'confirm_delete_view_model.dart';

class ConfirmDeleteView extends StatelessWidget {
  const ConfirmDeleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmDeleteViewModel(
        profileService: context.read<ProfileService>(),
      ),
      child: const _ConfirmDeleteBody(),
    );
  }
}

class _ConfirmDeleteBody extends StatelessWidget {
  const _ConfirmDeleteBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Delete')),
      body: BlocBuilder<ConfirmDeleteViewModel, ConfirmDeleteUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Confirm Delete'));
        },
      ),
    );
  }
}
