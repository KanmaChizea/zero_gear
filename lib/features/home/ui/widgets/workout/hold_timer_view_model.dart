import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/audio/audio_guide.dart';

import '../../models/hold_timer_ui_state.dart';

class HoldTimerViewModel extends Cubit<HoldTimerUiState> {
  HoldTimerViewModel({required this._audio, required this.seconds})
    : super(const HoldTimerUiState()) {
    unawaited(_audio.warmUp());
  }

  final AudioGuide _audio;
  final int seconds;

  static const _readyFor = Duration(seconds: 3);
  static const _setFor = Duration(seconds: 2);
  static const _showDoneFor = Duration(seconds: 2);
  static const _maxVoiceLag = Duration(milliseconds: 800);
  static const _spokenFrom = 5;

  Timer? _ticker;

  int _run = 0;

  @override
  Future<void> close() {
    _cancel();
    unawaited(_audio.stop(owner: this));
    return super.close();
  }

  Future<void> start() async {
    if (state.isRunning) return;
    final run = ++_run;

    emit(const HoldTimerUiState(stage: HoldTimerStage.ready));
    unawaited(_audio.speak('Ready', owner: this, brisk: true));
    await Future<void>.delayed(_readyFor);
    if (run != _run) return;

    emit(const HoldTimerUiState(stage: HoldTimerStage.set));
    unawaited(_audio.speak('Set', owner: this, brisk: true));
    await Future<void>.delayed(_setFor);
    if (run != _run) return;

    final asked = Stopwatch()..start();
    final spoke = await _audio.speak('Go', owner: this, brisk: true);
    if (run != _run) return;
    final lag = !spoke
        ? Duration.zero
        : asked.elapsed > _maxVoiceLag
        ? _maxVoiceLag
        : asked.elapsed;
    _count(lag);
  }

  void stop() {
    _cancel();
    unawaited(_audio.stop(owner: this));
    emit(const HoldTimerUiState());
  }

  void _cancel() {
    _run++;
    _ticker?.cancel();
    _ticker = null;
  }

  void _count(Duration voiceLag) {
    final clock = Stopwatch()..start();
    final total = Duration(seconds: seconds);
    var said = seconds;
    var beeped = seconds;
    emit(HoldTimerUiState(stage: HoldTimerStage.hold, secondsLeft: seconds));
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (ticker) {
      final elapsed = clock.elapsed;
      final left = seconds - elapsed.inSeconds;

      if (left < beeped && left > _spokenFrom) {
        beeped = left;
        unawaited(_audio.beep());
      }

      final due = seconds - (elapsed + voiceLag).inSeconds;
      if (due < said && said > 0) {
        said = due < 0 ? 0 : due;
        if (said <= _spokenFrom) {
          unawaited(
            _audio.speak(said > 0 ? '$said' : 'Done', owner: this, brisk: true),
          );
        }
      }

      if (left > 0) {
        emit(HoldTimerUiState(stage: HoldTimerStage.hold, secondsLeft: left));
      } else if (elapsed < total + _showDoneFor) {
        emit(const HoldTimerUiState(stage: HoldTimerStage.done));
      } else {
        ticker.cancel();
        emit(const HoldTimerUiState());
      }
    });
  }
}
