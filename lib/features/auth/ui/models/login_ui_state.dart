import 'package:equatable/equatable.dart';

/// Everything the login screen needs to render.
class LoginUiState extends Equatable {
  const LoginUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  LoginUiState copyWith({bool? isLoading, String? Function()? errorMessage}) {
    return LoginUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
