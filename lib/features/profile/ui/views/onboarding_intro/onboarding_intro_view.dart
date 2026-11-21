import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/onboarding_intro_ui_state.dart';
import 'onboarding_intro_view_model.dart';

class OnboardingIntroView extends StatelessWidget {
  const OnboardingIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingIntroViewModel(
        profileService: context.read<ProfileService>(),
      ),
      child: const _OnboardingIntroBody(),
    );
  }
}

class _OnboardingIntroBody extends StatelessWidget {
  const _OnboardingIntroBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding Intro')),
      body: BlocBuilder<OnboardingIntroViewModel, OnboardingIntroUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Onboarding Intro'));
        },
      ),
    );
  }
}
