import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/account_deleted_ui_state.dart';
import 'account_deleted_view_model.dart';

class AccountDeletedView extends StatelessWidget {
  const AccountDeletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountDeletedViewModel(
        profileService: context.read<ProfileService>(),
      ),
      child: const _AccountDeletedBody(),
    );
  }
}

class _AccountDeletedBody extends StatelessWidget {
  const _AccountDeletedBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Deleted')),
      body: BlocBuilder<AccountDeletedViewModel, AccountDeletedUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Account Deleted'));
        },
      ),
    );
  }
}
