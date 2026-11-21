import 'package:equatable/equatable.dart';

class DeleteAccountUiState extends Equatable {
  const DeleteAccountUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  DeleteAccountUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return DeleteAccountUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
