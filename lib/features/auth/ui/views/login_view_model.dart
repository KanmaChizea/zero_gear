import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../data/services/auth_service.dart';
import '../models/login_ui_state.dart';

class LoginViewModel extends Cubit<LoginUiState> {
  LoginViewModel({required this._authService}) : super(const LoginUiState());

  final AuthService _authService;

  AppLifecycleListener? _leavingForGoogle;

  @override
  Future<void> close() {
    _leavingForGoogle?.dispose();
    return super.close();
  }

  Future<void> submit() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorMessage: () => null));
    final result = await _authService.signInWithGoogle();
    switch (result) {
      case Ok() when kIsWeb:
        _leavingForGoogle ??= AppLifecycleListener(onResume: _cameBack);
      case Ok():
        emit(state.copyWith(isLoading: false));
      case Error(:final error):
        emit(
          state.copyWith(isLoading: false, errorMessage: () => error.message),
        );
    }
  }

  void _cameBack() {
    _leavingForGoogle?.dispose();
    _leavingForGoogle = null;
    emit(state.copyWith(isLoading: false));
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
