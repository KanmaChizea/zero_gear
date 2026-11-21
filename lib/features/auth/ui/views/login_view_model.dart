import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../data/services/auth_service.dart';
import '../models/login_ui_state.dart';

class LoginViewModel extends Cubit<LoginUiState> {
  LoginViewModel({required this._authService}) : super(const LoginUiState());

  final AuthService _authService;

  Future<void> submit() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorMessage: () => null));
    final result = await _authService.signInWithGoogle();
    switch (result) {
      case Ok():
        emit(state.copyWith(isLoading: false));
        break;
      case Error(:final error):
        emit(
          state.copyWith(isLoading: false, errorMessage: () => error.message),
        );
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
