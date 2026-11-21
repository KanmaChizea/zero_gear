import 'package:equatable/equatable.dart';

class WorkoutRecordUiState extends Equatable {
  const WorkoutRecordUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  WorkoutRecordUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return WorkoutRecordUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
