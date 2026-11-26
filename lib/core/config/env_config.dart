import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App configuration, loaded from `.env`.
class EnvConfig {
  static const _baseUrlKey = 'BASE_URL';
  static const _publishableKey = 'PUBLISHABLE_KEY';

  static const _redirectUrlKey = 'REDIRECT_URL';
  static const _googleWebClientIdKey = 'GOOGLE_WEB_CLIENT_ID';
  static const _googleIosClientIdKey = 'GOOGLE_IOS_CLIENT_ID';
  static const _googleAndroidClientIdKey = 'GOOGLE_ANDROID_CLIENT_ID';

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
    for (final key in [
      _baseUrlKey,
      _publishableKey,
      _redirectUrlKey,
      _googleWebClientIdKey,
      _googleIosClientIdKey,
      _googleAndroidClientIdKey,
    ]) {
      if (dotenv.maybeGet(key)?.isNotEmpty != true) {
        throw StateError('$key is missing from .env');
      }
    }
  }

  static String get baseUrl => dotenv.get(_baseUrlKey);
  static String get publishableKey => dotenv.get(_publishableKey);
  static String get redirectUrl => dotenv.get(_redirectUrlKey);
  static String get googleWebClientId => dotenv.get(_googleWebClientIdKey);
  static String get googleIosClientId => dotenv.get(_googleIosClientIdKey);
  static String get googleAndroidClientId =>
      dotenv.get(_googleAndroidClientIdKey);
}
