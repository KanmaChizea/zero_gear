import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../data/services/home_service.dart';
import '../../data/services/workout_service.dart';
import '../models/home_ui_state.dart';

class HomeViewModel extends Cubit<HomeUiState> {
  HomeViewModel({
    required HomeService homeService,
    required WorkoutService workoutService,
  }) : _homeService = homeService,
       _workoutService = workoutService,
       super(HomeUiState(summary: AsyncValue.loading())) {
    initialize();
  }

  final HomeService _homeService;
  final WorkoutService _workoutService;

  Future<void> initialize({bool showLoading = true}) async {
    if (showLoading) emit(state.copyWith(summary: AsyncValue.loading()));
    final result = await _homeService.load();
    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(summary: AsyncValue.data(value)));
      case Error(:final error):
        emit(state.copyWith(summary: AsyncValue.error(error.message)));
    }
  }

  Future<bool> start() async {
    final summary = state.summary.data;
    if (summary == null || state.isBusy) return false;
    if (summary.profile.preWorkoutStretch) return true;

    emit(state.copyWith(isStarting: true));
    final result = await _workoutService.begin(summary.nextDay.overallDay);
    switch (result) {
      case Ok():
        emit(state.copyWith(isStarting: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isStarting: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  Future<bool> giveUp() async {
    if (state.isBusy) return false;
    emit(state.copyWith(isGivingUp: true));
    final result = await _workoutService.giveUp();
    switch (result) {
      case Ok():
        await initialize(showLoading: false);
        emit(state.copyWith(isGivingUp: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isGivingUp: false, errorMessage: () => error.message),
        );
        return false;
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
