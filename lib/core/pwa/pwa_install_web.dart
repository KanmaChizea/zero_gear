import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'pwa_install_mode.dart';

abstract final class PwaInstall {
  static const _promptKey = '__pwaInstallPrompt';

  // index.html stores Chrome's install event here; iOS never fires it.
  static JSObject? get _installEvent {
    final value = globalContext[_promptKey];
    return value.isA<JSObject>() ? value as JSObject : null;
  }

  static PwaInstallMode get mode {
    if (_isInstalled) return PwaInstallMode.none;
    if (_installEvent != null) return PwaInstallMode.prompt;
    if (_isIos) return PwaInstallMode.iosManual;
    return PwaInstallMode.none;
  }

  static Future<bool> prompt() async {
    final event = _installEvent;
    if (event == null) return false;
    event.callMethod<JSAny?>('prompt'.toJS);
    final choice = await event
        .getProperty<JSPromise<JSObject>>('userChoice'.toJS)
        .toDart;
    globalContext[_promptKey] = null;
    return choice.getProperty<JSString>('outcome'.toJS).toDart == 'accepted';
  }

  static JSObject get _navigator => globalContext['navigator'] as JSObject;

  static bool get _isIos {
    final agent = _navigator.getProperty<JSString>('userAgent'.toJS).toDart;
    return RegExp('iPhone|iPad|iPod').hasMatch(agent);
  }

  static bool get _isInstalled {
    final media = globalContext.callMethod<JSObject>(
      'matchMedia'.toJS,
      '(display-mode: standalone)'.toJS,
    );
    if (media.getProperty<JSBoolean>('matches'.toJS).toDart) return true;
    final standalone = _navigator['standalone'];
    return standalone.isA<JSBoolean>() && (standalone as JSBoolean).toDart;
  }
}
