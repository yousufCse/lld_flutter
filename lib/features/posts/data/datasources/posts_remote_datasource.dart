import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/post_model.dart';

/// Abstract interface for remote data source
abstract class PostsRemoteDataSource {
  /// Get all posts from API
  Future<List<PostModel>> getPosts();

  /// Get a single post by ID
  Future<PostModel> getPostById(int id);

  /// Create a new post
  Future<PostModel> createPost(PostModel post);

  /// Update an existing post
  Future<PostModel> updatePost(PostModel post);

  /// Delete a post
  Future<void> deletePost(int id);

  /// Get posts by user ID
  Future<List<PostModel>> getPostsByUserId(int userId);
}

/// Implementation of remote data source using Dio
class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiClient apiClient;

  PostsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await apiClient.get<List<dynamic>>(ApiEndpoints.posts);

      if (response.data == null) {
        throw const ServerException(message: 'No data received from server');
      }

      return response.data!
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.post(id),
      );

      if (response.data == null) {
        throw const NotFoundException(message: 'Post not found');
      }

      return PostModel.fromJson(response.data!);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.posts,
        data: post.toJson(),
      );

      if (response.data == null) {
        throw const ServerException(message: 'Failed to create post');
      }

      return PostModel.fromJson(response.data!);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PostModel> updatePost(PostModel post) async {
    try {
      final response = await apiClient.put<Map<String, dynamic>>(
        ApiEndpoints.post(post.id),
        data: post.toJson(),
      );

      if (response.data == null) {
        throw const ServerException(message: 'Failed to update post');
      }

      return PostModel.fromJson(response.data!);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      await apiClient.delete<dynamic>(ApiEndpoints.post(id));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PostModel>> getPostsByUserId(int userId) async {
    try {
      final response = await apiClient.get<List<dynamic>>(
        ApiEndpoints.userPosts(userId),
      );

      if (response.data == null) {
        throw const ServerException(message: 'No data received from server');
      }

      return response.data!
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
