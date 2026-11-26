abstract final class AppUpdate {
  static bool get isEnabled => false;

  static Future<bool> hasNewerBuild() async => false;

  static void reload() {}
}
