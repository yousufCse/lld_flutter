import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import '../../features/auth/domain/entities/token.dart';
import '../../features/auth/data/models/token_model.dart';

/// Abstract class for token storage operations
abstract class TokenStorage {
  /// Save the token to persistent storage
  Future<void> saveToken(Token token);

  /// Retrieve the token from storage
  Future<Token?> getToken();

  /// Check if a token exists in storage
  Future<bool> hasToken();

  /// Check if the current token is expired
  /// Note: This would require token expiry information which the current Token class doesn't have
  /// This is a placeholder for future implementation
  Future<bool> isTokenExpired();

  /// Clear the stored token
  Future<void> clearToken();
}

/// Implementation of TokenStorage using SharedPreferences
@LazySingleton(as: TokenStorage)
class SharedPrefsTokenStorage implements TokenStorage {
  // Key constants for SharedPreferences
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Singleton instance of SharedPreferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<void> saveToken(Token token) async {
    final prefs = await _prefs;

    if (token.accessToken != null) {
      await prefs.setString(_accessTokenKey, token.accessToken!);
    }

    if (token.refreshToken != null) {
      await prefs.setString(_refreshTokenKey, token.refreshToken!);
    }
  }

  @override
  Future<Token?> getToken() async {
    final prefs = await _prefs;

    final accessToken = prefs.getString(_accessTokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);

    if (accessToken == null && refreshToken == null) {
      return null;
    }

    return TokenModel(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future<bool> hasToken() async {
    final prefs = await _prefs;
    return prefs.containsKey(_accessTokenKey);
  }

  @override
  Future<bool> isTokenExpired() async {
    // In a real implementation, you would need to:
    // 1. Either decode the JWT token to get its expiration
    // 2. Or store the expiration alongside the token

    // This is a placeholder implementation
    return false;
  }

  @override
  Future<void> clearToken() async {
    final prefs = await _prefs;
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
