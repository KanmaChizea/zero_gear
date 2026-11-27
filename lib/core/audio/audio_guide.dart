import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class AudioGuide {
  final FlutterTts _tts = FlutterTts();
  Future<void>? _ready;

  final AudioPlayer _beeper = AudioPlayer();
  Future<void>? _beeperReady;

  /// Who is currently speaking. A screen being replaced closes after the
  /// next one has started, so it must not cut off the next one's audio.
  Object? _owner;

  bool _speaking = false;
  Completer<void>? _started;
  double? _rate;

  static const _rateNormal = 0.45;
  static const _rateBrisk = 0.55;
  static const _startTimeout = Duration(seconds: 1);
  static final _beepSound = AssetSource('sounds/beep.wav');

  Future<void> _configure() async {
    _tts.setStartHandler(() {
      _speaking = true;
      final started = _started;
      if (started != null && !started.isCompleted) started.complete();
    });
    _tts.setCompletionHandler(() => _speaking = false);
    _tts.setCancelHandler(() => _speaking = false);
    _tts.setErrorHandler((_) => _speaking = false);
    await _tts.setLanguage('en-US');
    await _tts.setVolume(1);
    await _tts.setPitch(1);
  }

  Future<void> _configureBeeper() async {
    if (!kIsWeb) {
      await AudioPlayer.global.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      await _beeper.setPlayerMode(PlayerMode.lowLatency);
    }
    await _beeper.setReleaseMode(ReleaseMode.stop);
    await _beeper.setSource(_beepSound);
  }

  Future<void> warmUp() async {
    try {
      await (_ready ??= _configure());
    } catch (_) {}
    try {
      await (_beeperReady ??= _configureBeeper());
    } catch (_) {}
  }

  Future<void> beep() async {
    try {
      await (_beeperReady ??= _configureBeeper());
      await _beeper.stop();
      await _beeper.resume();
    } catch (_) {}
  }

  Future<bool> speak(
    String text, {
    required Object owner,
    bool brisk = false,
  }) async {
    if (text.trim().isEmpty) return false;
    _owner = owner;
    final started = _started = Completer<void>();
    try {
      await (_ready ??= _configure());
      if (_speaking) await _tts.stop();
      final rate = brisk ? _rateBrisk : _rateNormal;
      if (rate != _rate) {
        await _tts.setSpeechRate(rate);
        _rate = rate;
      }
      await _tts.speak(text);
      await started.future.timeout(_startTimeout);
      return true;
    } catch (_) {
      // Audio is a bonus; the workout carries on without it.
      return false;
    }
  }

  /// Stops the audio, unless someone else has started speaking since.
  Future<void> stop({required Object owner}) async {
    if (_owner != owner) return;
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
