import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env_keys.dart';
import 'flavor_config.dart';

class EnvConfig {
  static Flavor? _currentFlavor;

  static Flavor get flavor => _currentFlavor!;

  static Future<void> initialize(Flavor flavor) async {
    _currentFlavor = flavor;
    await dotenv.load(fileName: flavor.envFile);
  }

  static String get appName => dotenv.env[envKeyAppName] ?? '';
  static String get apiBaseUrl => dotenv.env[envKeyApiBaseUrl] ?? '';
  static String get apiKey => dotenv.env[envKeyApiKey] ?? '';

  static bool get enableLogging =>
      (dotenv.env[envKeyEnableLogging] ?? 'false').toLowerCase() == 'true';
}
