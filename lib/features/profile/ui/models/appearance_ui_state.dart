import 'package:equatable/equatable.dart';

class AppearanceUiState extends Equatable {
  const AppearanceUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  AppearanceUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return AppearanceUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
