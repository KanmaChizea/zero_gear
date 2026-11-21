import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/appearance_ui_state.dart';
import 'appearance_view_model.dart';

class AppearanceView extends StatelessWidget {
  const AppearanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppearanceViewModel(profileService: context.read<ProfileService>()),
      child: const _AppearanceBody(),
    );
  }
}

class _AppearanceBody extends StatelessWidget {
  const _AppearanceBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: BlocBuilder<AppearanceViewModel, AppearanceUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Appearance'));
        },
      ),
    );
  }
}
