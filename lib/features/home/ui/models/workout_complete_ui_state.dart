import 'package:equatable/equatable.dart';

class WorkoutCompleteUiState extends Equatable {
  const WorkoutCompleteUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  WorkoutCompleteUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return WorkoutCompleteUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
