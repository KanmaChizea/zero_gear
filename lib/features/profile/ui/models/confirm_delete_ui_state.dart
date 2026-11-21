import 'package:equatable/equatable.dart';

class ConfirmDeleteUiState extends Equatable {
  const ConfirmDeleteUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  ConfirmDeleteUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return ConfirmDeleteUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
