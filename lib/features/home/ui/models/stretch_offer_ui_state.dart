import 'package:equatable/equatable.dart';

class StretchOfferUiState extends Equatable {
  const StretchOfferUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  StretchOfferUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return StretchOfferUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
