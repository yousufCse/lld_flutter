import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class TokenStorage {
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String refreshToken);
  Future<void> saveTokens(String token, String refreshToken);
  Future<void> clearTokens();
  Future<bool> isFirstTimeLaunch();
  Future<void> setFirstTimeLaunchComplete();
  Future<void> clearAll();
}

@LazySingleton(as: TokenStorage)
class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;

  SecureTokenStorage(this._storage);

  static const _keyToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyFirstTime = 'first_time_launch';

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  @override
  Future<void> saveTokens(String token, String refreshToken) async {
    await saveToken(token);
    await saveRefreshToken(refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyRefreshToken);
  }

  @override
  Future<bool> isFirstTimeLaunch() async {
    final value = await _storage.read(key: _keyFirstTime);
    return value == null;
  }

  @override
  Future<void> setFirstTimeLaunchComplete() async {
    await _storage.write(key: _keyFirstTime, value: 'false');
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
