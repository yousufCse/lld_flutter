import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants.dart';
import '../models/post_model.dart';

/// Abstract interface for local data source (caching)
abstract class PostsLocalDataSource {
  /// Get cached posts
  Future<List<PostModel>> getCachedPosts();

  /// Cache posts
  Future<void> cachePosts(List<PostModel> posts);

  /// Get a cached post by ID
  Future<PostModel?> getCachedPostById(int id);

  /// Clear cached posts
  Future<void> clearCache();

  /// Check if cache is valid
  Future<bool> isCacheValid();
}

/// Implementation of local data source using SharedPreferences
class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  final StorageService storageService;

  static const String _cacheTimestampKey =
      '${StorageKeys.cachedPosts}_timestamp';

  PostsLocalDataSourceImpl({required this.storageService});

  @override
  Future<List<PostModel>> getCachedPosts() async {
    try {
      final jsonString = storageService.getString(StorageKeys.cachedPosts);

      if (jsonString == null || jsonString.isEmpty) {
        throw const CacheException(message: 'No cached posts found');
      }

      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    try {
      final jsonList = posts.map((post) => post.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      await storageService.setString(StorageKeys.cachedPosts, jsonString);
      await storageService.setString(
        _cacheTimestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<PostModel?> getCachedPostById(int id) async {
    try {
      final posts = await getCachedPosts();
      return posts.firstWhere(
        (post) => post.id == id,
        orElse: () =>
            throw const CacheException(message: 'Post not found in cache'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await storageService.remove(StorageKeys.cachedPosts);
    await storageService.remove(_cacheTimestampKey);
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestampString = storageService.getString(_cacheTimestampKey);
      if (timestampString == null) return false;

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      return difference < AppConstants.cacheMaxAge;
    } catch (e) {
      return false;
    }
  }
}
