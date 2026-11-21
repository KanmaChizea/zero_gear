import 'package:equatable/equatable.dart';

class ProfileInfoUiState extends Equatable {
  const ProfileInfoUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, errorMessage];

  ProfileInfoUiState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return ProfileInfoUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
