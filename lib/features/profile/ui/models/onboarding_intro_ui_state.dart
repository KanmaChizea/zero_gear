import 'package:equatable/equatable.dart';

class OnboardingIntroUiState extends Equatable {
  const OnboardingIntroUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  OnboardingIntroUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return OnboardingIntroUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
