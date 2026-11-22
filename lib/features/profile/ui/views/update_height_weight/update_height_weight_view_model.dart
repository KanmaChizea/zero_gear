import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../../data/services/profile_service.dart';
import '../../models/update_height_weight_ui_state.dart';

class UpdateHeightWeightViewModel extends Cubit<UpdateHeightWeightUiState> {
  UpdateHeightWeightViewModel({required this._profileService})
    : super(const UpdateHeightWeightUiState());

  final ProfileService _profileService;

  Future<bool> submit(String height, String weight) async {
    if (state.isLoading) return false;
    emit(state.copyWith(isLoading: true));
    final result = await _profileService.updateBodyStats(
      heightCm: double.tryParse(height) ?? 0,
      weightKg: double.tryParse(weight) ?? 0,
    );
    switch (result) {
      case Ok():
        emit(state.copyWith(isLoading: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isLoading: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
