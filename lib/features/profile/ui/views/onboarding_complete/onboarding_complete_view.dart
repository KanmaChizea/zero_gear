import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/onboarding_complete_ui_state.dart';
import 'onboarding_complete_view_model.dart';

class OnboardingCompleteView extends StatelessWidget {
  const OnboardingCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCompleteViewModel(
        profileService: context.read<ProfileService>(),
      ),
      child: const _OnboardingCompleteBody(),
    );
  }
}

class _OnboardingCompleteBody extends StatelessWidget {
  const _OnboardingCompleteBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding Complete')),
      body: BlocBuilder<OnboardingCompleteViewModel, OnboardingCompleteUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Onboarding Complete'));
        },
      ),
    );
  }
}
