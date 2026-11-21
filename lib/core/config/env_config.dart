import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavor.dart';

/// Per-flavor configuration, loaded from `env/.env.<flavor>`.
class EnvConfig {
  static const _baseUrlKey = 'BASE_URL';
  static const _publishableKey = 'PUBLISHABLE_KEY';

  static Future<void> init(Flavor flavor) async {
    await dotenv.load(fileName: '.env');
    for (final key in [_baseUrlKey, _publishableKey]) {
      if (dotenv.maybeGet(key)?.isNotEmpty != true) {
        throw StateError('$key is missing from .env');
      }
    }
  }

  static String get baseUrl => dotenv.get(_baseUrlKey);
}
