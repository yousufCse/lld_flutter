import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_theme.dart';
import 'env_config.dart';
import 'flavor_config.dart';

class AppConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final ThemeData theme;
  final bool isLoggingEnabled;

  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.theme,
    required this.isLoggingEnabled,
  });

  static AppConfig? _instance;
  static AppConfig get instance => _instance!;

  static Future<void> initialize(Flavor flavor) async {
    await EnvConfig.initialize(flavor);

    _instance = AppConfig._(
      flavor: flavor,
      appName: EnvConfig.appName,
      apiBaseUrl: EnvConfig.apiBaseUrl,
      theme: buildAppTheme(_seedColor),
      isLoggingEnabled: EnvConfig.enableLogging,
    );
  }

  static Color get _seedColor => switch (EnvConfig.flavor) {
    Flavor.dev => AppColors.seedDev,
    Flavor.prod => AppColors.seedProd,
    Flavor.staging => AppColors.seedStaging,
  };
}
