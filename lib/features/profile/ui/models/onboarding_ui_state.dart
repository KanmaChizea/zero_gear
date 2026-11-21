import 'package:equatable/equatable.dart';

class OnboardingUiState extends Equatable {
  const OnboardingUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  OnboardingUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return OnboardingUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
