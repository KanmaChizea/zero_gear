import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/delete_account_ui_state.dart';
import 'delete_account_view_model.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteAccountViewModel(
        profileService: context.read<ProfileService>(),
      ),
      child: const _DeleteAccountBody(),
    );
  }
}

class _DeleteAccountBody extends StatelessWidget {
  const _DeleteAccountBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: BlocBuilder<DeleteAccountViewModel, DeleteAccountUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Delete Account'));
        },
      ),
    );
  }
}
