import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';

/// Abstract repository interface for posts
/// This defines the contract that the data layer must implement
abstract class PostsRepository {
  /// Get all posts
  /// Returns [List<PostEntity>] on success or [Failure] on error
  Future<Either<Failure, List<PostEntity>>> getPosts();

  /// Get a single post by ID
  /// Returns [PostEntity] on success or [Failure] on error
  Future<Either<Failure, PostEntity>> getPostById(int id);

  /// Create a new post
  /// Returns the created [PostEntity] on success or [Failure] on error
  Future<Either<Failure, PostEntity>> createPost(PostEntity post);

  /// Update an existing post
  /// Returns the updated [PostEntity] on success or [Failure] on error
  Future<Either<Failure, PostEntity>> updatePost(PostEntity post);

  /// Delete a post
  /// Returns void on success or [Failure] on error
  Future<Either<Failure, void>> deletePost(int id);

  /// Get posts by user ID
  /// Returns [List<PostEntity>] on success or [Failure] on error
  Future<Either<Failure, List<PostEntity>>> getPostsByUserId(int userId);

  /// Get cached posts (offline support)
  /// Returns [List<PostEntity>] on success or [Failure] on error
  Future<Either<Failure, List<PostEntity>>> getCachedPosts();
}
