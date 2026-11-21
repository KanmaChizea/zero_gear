import 'package:equatable/equatable.dart';

class ActiveStretchUiState extends Equatable {
  const ActiveStretchUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  ActiveStretchUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return ActiveStretchUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
