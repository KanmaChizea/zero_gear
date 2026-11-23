import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../../data/services/home_service.dart';
import '../../data/services/workout_service.dart';
import '../models/home_ui_state.dart';

class HomeViewModel extends Cubit<HomeUiState> {
  HomeViewModel({required this._homeService, required this._workoutService})
    : super(HomeUiState(summary: AsyncValue.loading())) {
    initialize();
    _workoutChanges = _workoutService.stream
        .distinct(
          (a, b) =>
              (a.active == null) == (b.active == null) &&
              identical(a.history, b.history),
        )
        .listen((_) => initialize(showLoading: false));
  }

  StreamSubscription<Object?>? _workoutChanges;

  @override
  Future<void> close() {
    _workoutChanges?.cancel();
    return super.close();
  }

  final HomeService _homeService;
  final WorkoutService _workoutService;

  int _loadId = 0;

  Future<void> initialize({bool showLoading = true}) async {
    final loadId = ++_loadId;
    if (showLoading) emit(state.copyWith(summary: AsyncValue.loading()));
    final result = await _homeService.load();
    if (loadId != _loadId || isClosed) return;
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

  Future<bool> resume() async {
    final summary = state.summary.data;
    if (summary == null || state.isBusy) return false;
    if (summary.activeWorkout != null) return true;

    emit(state.copyWith(isResuming: true));
    final result = await _workoutService.resumeIncomplete();
    switch (result) {
      case Ok():
        emit(state.copyWith(isResuming: false));
        return true;
      case Error(:final error):
        emit(
          state.copyWith(isResuming: false, errorMessage: () => error.message),
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
