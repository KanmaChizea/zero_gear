import 'package:equatable/equatable.dart';

class UpdateHeightWeightUiState extends Equatable {
  const UpdateHeightWeightUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  UpdateHeightWeightUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return UpdateHeightWeightUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
