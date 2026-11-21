import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/shared_features/session/data/models/gender.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../../data/services/profile_service.dart';
import '../../models/onboarding_ui_state.dart';

class OnboardingViewModel extends Cubit<OnboardingUiState> {
  OnboardingViewModel({required this._profileService})
    : super(const OnboardingUiState());

  final ProfileService _profileService;

  void goToNextStep() {
    if (state.currentStep.isLastStep) return;
    emit(
      state.copyWith(
        currentStep: OnboardingStep.values[state.currentStep.index + 1],
      ),
    );
  }

  void goBack() {
    if (state.currentStep.isFirstStep) return;
    emit(
      state.copyWith(
        currentStep: OnboardingStep.values[state.currentStep.index - 1],
      ),
    );
  }

  void setGender(Gender gender) => emit(state.copyWith(gender: gender));
  void setHeight(double value) => emit(state.copyWith(height: value));
  void setWeight(double value) => emit(state.copyWith(weight: value));

  Future<bool> submit() async {
    if (!state.currentStep.isLastStep) {
      goToNextStep();
      return false;
    }
    if (state.isLoading) return false;
    emit(state.copyWith(isLoading: true));
    final result = await _profileService.completeOnboarding(
      gender: state.gender,
      heightCm: state.height,
      weightKg: state.weight,
    );
    switch (result) {
      case Ok():
        emit(state.copyWith(isLoading: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isLoading: false, errorMessage: () => error.message),
        );
    }
    return false;
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
