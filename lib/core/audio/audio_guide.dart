import 'package:flutter_tts/flutter_tts.dart';

class AudioGuide {
  final FlutterTts _tts = FlutterTts();
  Future<void>? _ready;

  /// Who is currently speaking. A screen being replaced closes after the
  /// next one has started, so it must not cut off the next one's audio.
  Object? _owner;

  Future<void> _configure() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1);
    await _tts.setPitch(1);
  }

  Future<void> speak(String text, {required Object owner}) async {
    if (text.trim().isEmpty) return;
    _owner = owner;
    try {
      await (_ready ??= _configure());
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // Audio is a bonus; the workout carries on without it.
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
