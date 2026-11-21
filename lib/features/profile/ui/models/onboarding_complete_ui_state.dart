import 'package:equatable/equatable.dart';

class OnboardingCompleteUiState extends Equatable {
  const OnboardingCompleteUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  OnboardingCompleteUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return OnboardingCompleteUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
