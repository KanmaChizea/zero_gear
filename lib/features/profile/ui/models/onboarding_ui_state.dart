import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/shared_features/session/data/models/gender.dart';

enum OnboardingStep {
  gender,
  height,
  weight;

  bool get isLastStep => index == OnboardingStep.values.length - 1;

  bool get isFirstStep => index == 0;
}

class OnboardingUiState extends Equatable {
  const OnboardingUiState({
    this.isLoading = false,
    this.errorMessage,
    this.currentStep = OnboardingStep.gender,
    this.gender = Gender.female,
    this.height = 170,
    this.weight = 68,
  });

  final bool isLoading;
  final String? errorMessage;
  final OnboardingStep currentStep;
  final Gender gender;
  final double height;
  final double weight;

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    currentStep,
    gender,
    height,
    weight,
  ];

  OnboardingUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
    OnboardingStep? currentStep,
    Gender? gender,
    double? height,
    double? weight,
  }) {
    return OnboardingUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      currentStep: currentStep ?? this.currentStep,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
