// lib/config/env.dart
class Env {
  // App basics
  static String get appName =>
      const String.fromEnvironment('appName', defaultValue: 'My App');

  // API settings
  static String get baseUrl => const String.fromEnvironment(
    'baseUrl',
    defaultValue: 'https://default-api.example.com',
  );
  static String get themeColor =>
      const String.fromEnvironment('themeColor', defaultValue: '#4CAF50');

  static String get apiKey =>
      const String.fromEnvironment('apiKey', defaultValue: '');

  // Feature flags
  static bool get isDebugMode =>
      const bool.fromEnvironment('isDebugMode', defaultValue: false);

  // Current environment
  static String get env =>
      const String.fromEnvironment('env', defaultValue: 'dev');

  // Helper methods
  static bool get isDev => env == 'dev';
  static bool get isStaging => env == 'staging';
  static bool get isProd => env == 'prod';
}
