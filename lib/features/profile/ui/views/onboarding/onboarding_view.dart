import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/app_back_button.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/containers/stepper.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/features/profile/ui/widgets/onboarding/gender_form.dart';
import 'package:zero_gear/features/profile/ui/widgets/onboarding/height_form.dart';
import 'package:zero_gear/features/profile/ui/widgets/onboarding/weight_form.dart';

import '../../../data/services/profile_service.dart';
import '../../models/onboarding_ui_state.dart';
import 'onboarding_view_model.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OnboardingViewModel(profileService: context.read<ProfileService>()),
      child: const _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends StatefulWidget {
  const _OnboardingBody();

  @override
  State<_OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<_OnboardingBody> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<OnboardingViewModel>();
    return BlocConsumer<OnboardingViewModel, OnboardingUiState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.currentStep != current.currentStep,
      listener: (context, state) {
        if (state.errorMessage != null) {
          viewmodel.clearError();
          AppToast.error(context, title: state.errorMessage!);
          return;
        }
        controller.animateToPage(
          state.currentStep.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
        );
      },
      builder: (context, state) {
        return PopScope(
          canPop: state.currentStep.isFirstStep,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) viewmodel.goBack();
          },
          child: AppScreen(
            scrollable: false,
            header: Row(
              spacing: 18.w,
              children: [
                AppBackButton(
                  onPress: state.currentStep.isFirstStep
                      ? null
                      : viewmodel.goBack,
                ),
                Expanded(
                  child: AppStepper(
                    currentIndex: state.currentStep.index,
                    length: OnboardingStep.values.length,
                  ),
                ),
              ],
            ),

            footer: Button(
              label: state.currentStep.isLastStep
                  ? 'Create my plan'
                  : 'Continue',
              isLoading: state.isLoading,
              onPressed: () async {
                final isComplete = await viewmodel.submit();
                if (isComplete && context.mounted) {
                  await context.pushNamed(AppRoute.onboardingComplete.name);
                }
              },
            ),
            children: [
              Expanded(
                child: PageView(
                  controller: controller,
                  children: [
                    GenderForm(
                      selected: state.gender,
                      onSelect: viewmodel.setGender,
                    ),
                    HeightForm(
                      selected: state.height,
                      onSelect: viewmodel.setHeight,
                    ),
                    WeightForm(
                      selected: state.weight,
                      onSelect: viewmodel.setWeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
