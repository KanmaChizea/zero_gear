import 'dart:js_interop';
import 'dart:js_interop_unsafe';

abstract final class AppUpdate {
  static const _build = String.fromEnvironment('APP_BUILD');

  static bool get isEnabled => _build.isNotEmpty;

  static Future<bool> hasNewerBuild() async {
    if (!isEnabled) return false;
    try {
      final url = 'version.json?t=${DateTime.now().millisecondsSinceEpoch}';
      final options = JSObject()..['cache'] = 'no-store'.toJS;
      final response = await globalContext
          .callMethod<JSPromise<JSObject>>('fetch'.toJS, url.toJS, options)
          .toDart;
      if (!response.getProperty<JSBoolean>('ok'.toJS).toDart) return false;
      final body = await response
          .callMethod<JSPromise<JSObject>>('json'.toJS)
          .toDart;
      final latest = body['build_number'];
      return latest.isA<JSString>() && (latest as JSString).toDart != _build;
    } catch (_) {
      return false;
    }
  }

  static void reload() {
    final location = globalContext['location'] as JSObject;
    location.callMethod<JSAny?>('reload'.toJS);
  }
}
