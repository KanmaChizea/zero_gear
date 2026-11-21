import 'package:equatable/equatable.dart';

class ActiveWorkoutUiState extends Equatable {
  const ActiveWorkoutUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  ActiveWorkoutUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return ActiveWorkoutUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
