import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavor_config.dart';

class EnvConfig {
  static Flavor? _currentFlavor;

  static Flavor get flavor => _currentFlavor!;

  static Future<void> initialize(Flavor flavor) async {
    _currentFlavor = flavor;
    await dotenv.load(fileName: flavor.envFile);
  }

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  static String get appName => dotenv.env['APP_NAME'] ?? '';
  static String get appVersion => dotenv.env['ENABLE_LOGGING'] ?? '';
}
