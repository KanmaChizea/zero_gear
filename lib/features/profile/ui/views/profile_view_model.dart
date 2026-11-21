import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/result.dart';

import 'package:zero_gear/features/profile/data/services/profile_service.dart';
import '../models/profile_ui_state.dart';

class ProfileViewModel extends Cubit<ProfileUiState> {
  ProfileViewModel({required this._profileService})
    : super(const ProfileUiState());

  final ProfileService _profileService;

  Future<bool> setPreWorkOutStretch(bool value) async {
    if (state.isLoading) return false;
    emit(state.copyWith(isLoading: true));
    final result = await _profileService.updateFeatures(
      preWorkoutStretch: value,
    );
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

  Future<bool> setPostWorkOutStretch(bool value) async {
    if (state.isLoading) return false;
    emit(state.copyWith(isLoading: true));
    final result = await _profileService.updateFeatures(
      postWorkoutStretch: value,
    );
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

  Future<bool> setAudioInstructions(bool value) async {
    if (state.isLoading) return false;
    emit(state.copyWith(isLoading: true));
    final result = await _profileService.updateFeatures(
      audioInstructions: value,
    );
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

  void clearError() {
    emit(state.copyWith(errorMessage: () => null));
  }
}
