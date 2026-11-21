import 'package:equatable/equatable.dart';

class DayDetailUiState extends Equatable {
  const DayDetailUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  DayDetailUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return DayDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
