import 'package:equatable/equatable.dart';

class ExerciseDetailUiState extends Equatable {
  const ExerciseDetailUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  ExerciseDetailUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return ExerciseDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
