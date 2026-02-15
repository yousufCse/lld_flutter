import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/data/local/token_storage.dart';
import 'package:niramoy_health_app/core/errors/errors.dart';

import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<String?> getCachedToken();
  Future<String?> getCachedRefreshToken();
  Future<void> cacheTokens(String token, String refreshToken);
  Future<void> clearCache();
  Future<bool> isFirstTimeLaunch();
  Future<void> setFirstTimeLaunchComplete();
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenStorage tokenStorage;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.tokenStorage,
    required this.secureStorage,
  });

  static const _userKey = 'cached_user';

  @override
  Future<String?> getCachedToken() async {
    try {
      return await tokenStorage.getToken();
    } catch (e) {
      throw CacheException('Failed to get cached token');
    }
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    try {
      return await tokenStorage.getRefreshToken();
    } catch (e) {
      throw CacheException('Failed to get cached refresh token');
    }
  }

  @override
  Future<void> cacheTokens(String token, String refreshToken) async {
    try {
      await tokenStorage.saveTokens(token, refreshToken);
    } catch (e) {
      throw CacheException('Failed to cache tokens');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await tokenStorage.clearTokens();
      await secureStorage.delete(key: _userKey);
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }

  @override
  Future<bool> isFirstTimeLaunch() async {
    try {
      return await tokenStorage.isFirstTimeLaunch();
    } catch (e) {
      throw CacheException('Failed to check first time launch');
    }
  }

  @override
  Future<void> setFirstTimeLaunchComplete() async {
    try {
      await tokenStorage.setFirstTimeLaunchComplete();
    } catch (e) {
      throw CacheException('Failed to set first time launch complete');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await secureStorage.read(key: _userKey);
      if (userJson != null) {
        return UserModel.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await secureStorage.write(
        key: _userKey,
        value: json.encode(user.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache user');
    }
  }
}
