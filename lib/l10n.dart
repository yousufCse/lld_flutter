import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'res/l10n/app_localizations.dart';

/// Main localization setup for the application
class AppLocalization {
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('bn'), // Bengali
  ];

  static final List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const Locale fallbackLocale = Locale('en');

  // Cache supported language codes for faster lookup
  static const Set<String> _supportedLanguageCodes = {'en', 'bn'};

  /// Check if the given locale is supported
  static bool isLocaleSupported(Locale locale) {
    return _supportedLanguageCodes.contains(locale.languageCode);
  }

  /// Get the appropriate locale based on system locale
  static Locale getLocale(Locale? locale) {
    if (locale == null || !isLocaleSupported(locale)) {
      return fallbackLocale;
    }
    return locale;
  }
}
