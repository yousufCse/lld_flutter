enum AppFlavor {
  dev,
  staging,
  prod;

  String get name {
    switch (this) {
      case AppFlavor.dev:
        return 'Development';
      case AppFlavor.staging:
        return 'Staging';
      case AppFlavor.prod:
        return 'Production';
    }
  }

  String get envName {
    switch (this) {
      case AppFlavor.dev:
        return 'dev';
      case AppFlavor.staging:
        return 'staging';
      case AppFlavor.prod:
        return 'prod';
    }
  }
}

/// Current app flavor (set at app startup)
class AppConfig {
  static AppFlavor currentFlavor = AppFlavor.dev;

  static AppFlavor get flavor => currentFlavor;

  static set flavor(AppFlavor value) {
    currentFlavor = value;
  }

  static bool get isDevelopment => currentFlavor == AppFlavor.dev;
  static bool get isStaging => currentFlavor == AppFlavor.staging;
  static bool get isProduction => currentFlavor == AppFlavor.prod;
}
