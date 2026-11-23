import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/result.dart';
import 'package:zero_gear/features/auth/data/services/auth_service.dart';

import '../../models/confirm_delete_ui_state.dart';

class ConfirmDeleteViewModel extends Cubit<ConfirmDeleteUiState> {
  ConfirmDeleteViewModel({required this._authService})
    : super(const ConfirmDeleteUiState());

  final AuthService _authService;

  Future<bool> confirm() async {
    if (state.isLoading) return false;
    emit(state.copyWith(isLoading: true));
    final result = await _authService.deleteAccount();
    switch (result) {
      case Ok():
        emit(state.copyWith(isLoading: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isLoading: false, errorMessage: () => error.message),
        );
    }
    return false;
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
