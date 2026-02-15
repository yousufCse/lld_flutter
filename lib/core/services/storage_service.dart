import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

/// Service for handling local storage operations using SharedPreferences
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // ==================== Token Management ====================

  /// Save access token
  Future<bool> setAccessToken(String token) async {
    return _prefs.setString(StorageKeys.accessToken, token);
  }

  /// Get access token
  String? getAccessToken() {
    return _prefs.getString(StorageKeys.accessToken);
  }

  /// Save refresh token
  Future<bool> setRefreshToken(String token) async {
    return _prefs.setString(StorageKeys.refreshToken, token);
  }

  /// Get refresh token
  String? getRefreshToken() {
    return _prefs.getString(StorageKeys.refreshToken);
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await _prefs.remove(StorageKeys.accessToken);
    await _prefs.remove(StorageKeys.refreshToken);
  }

  /// Check if user is logged in
  bool get isLoggedIn => getAccessToken() != null;

  // ==================== User Data ====================

  /// Save user data as JSON
  Future<bool> setUser(Map<String, dynamic> user) async {
    return _prefs.setString(StorageKeys.user, jsonEncode(user));
  }

  /// Get user data
  Map<String, dynamic>? getUser() {
    final userString = _prefs.getString(StorageKeys.user);
    if (userString == null) return null;
    return jsonDecode(userString) as Map<String, dynamic>;
  }

  /// Clear user data
  Future<bool> clearUser() async {
    return _prefs.remove(StorageKeys.user);
  }

  // ==================== Theme ====================

  /// Save theme preference
  Future<bool> setThemeMode(String theme) async {
    return _prefs.setString(StorageKeys.theme, theme);
  }

  /// Get theme preference
  String getThemeMode() {
    return _prefs.getString(StorageKeys.theme) ?? 'system';
  }

  // ==================== Locale ====================

  /// Save locale preference
  Future<bool> setLocale(String locale) async {
    return _prefs.setString(StorageKeys.locale, locale);
  }

  /// Get locale preference
  String? getLocale() {
    return _prefs.getString(StorageKeys.locale);
  }

  // ==================== Onboarding ====================

  /// Set onboarding completed
  Future<bool> setOnboardingCompleted(bool completed) async {
    return _prefs.setBool(StorageKeys.onboardingCompleted, completed);
  }

  /// Check if onboarding is completed
  bool get isOnboardingCompleted {
    return _prefs.getBool(StorageKeys.onboardingCompleted) ?? false;
  }

  // ==================== Generic Methods ====================

  /// Save string value
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save int value
  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  /// Get int value
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Save bool value
  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  /// Get bool value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Save double value
  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  /// Get double value
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Save string list
  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  /// Get string list
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  /// Clear all data
  Future<bool> clear() async {
    return _prefs.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
