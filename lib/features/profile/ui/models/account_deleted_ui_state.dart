import 'package:equatable/equatable.dart';

class AccountDeletedUiState extends Equatable {
  const AccountDeletedUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  AccountDeletedUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return AccountDeletedUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
