import 'package:equatable/equatable.dart';

class WeightChartUiState extends Equatable {
  const WeightChartUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  WeightChartUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return WeightChartUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
