import 'pwa_install_mode.dart';

abstract final class PwaInstall {
  static PwaInstallMode get mode => PwaInstallMode.none;

  static Future<bool> prompt() async => false;
}
