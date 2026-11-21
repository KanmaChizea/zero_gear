import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/profile_info_ui_state.dart';
import 'profile_info_view_model.dart';

class ProfileInfoView extends StatelessWidget {
  const ProfileInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileInfoViewModel(profileService: context.read<ProfileService>()),
      child: const _ProfileInfoBody(),
    );
  }
}

class _ProfileInfoBody extends StatelessWidget {
  const _ProfileInfoBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Info')),
      body: BlocBuilder<ProfileInfoViewModel, ProfileInfoUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Profile Info'));
        },
      ),
    );
  }
}
