import 'package:flutter/material.dart';
import 'package:flutter_exercise/core/config/env_config.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';

class AppConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final ThemeData theme;

  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.theme,
  });

  static AppConfig? _instance;
  static AppConfig get instance => _instance!;

  static Future<void> initialize(Flavor flavor) async {
    await EnvConfig.initialize(flavor);

    _instance = AppConfig._(
      flavor: flavor,
      appName: EnvConfig.appName,
      apiBaseUrl: EnvConfig.apiBaseUrl,
      theme: _getThemeForFlavor,
    );
  }

  static ThemeData get _getThemeForFlavor {
    switch (EnvConfig.flavor) {
      case Flavor.dev:
        return ThemeData(primarySwatch: Colors.blue);
      case Flavor.prod:
        return ThemeData(primarySwatch: Colors.green);
    }
  }
}
