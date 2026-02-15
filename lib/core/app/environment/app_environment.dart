/// Application environment configuration
/// Manages app flavors and environment-specific settings
class AppEnvironment {
  static const String _environment = String.fromEnvironment(
    'FLUTTER_APP_FLAVOR',
    defaultValue: 'dev',
  );

  static bool get isDebug => _environment == 'dev';
  static bool get isStaging => _environment == 'staging';
  static bool get isProduction => _environment == 'prod';

  static String get environmentName => _environment;

  /// Base URLs for different environments
  static String get apiBaseUrl {
    switch (_environment) {
      case 'prod':
        return 'https://api.niramoy.health';
      case 'staging':
        return 'https://staging-api.niramoy.health';
      case 'dev':
      default:
        return 'https://dev-api.niramoy.health';
    }
  }

  /// App titles for different environments
  static String get appTitle {
    switch (_environment) {
      case 'prod':
        return 'Niramoy Health';
      case 'staging':
        return 'Niramoy Health (Staging)';
      case 'dev':
      default:
        return 'Niramoy Health (Dev)';
    }
  }

  /// API timeout durations
  static Duration get apiTimeout => const Duration(seconds: 30);

  /// Enable/disable logging based on environment
  static bool get enableLogging => isDebug || isStaging;

  /// Enable/disable crash reporting
  static bool get enableCrashReporting => isProduction;
}
