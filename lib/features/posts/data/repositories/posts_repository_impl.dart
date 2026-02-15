import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network_service.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_local_datasource.dart';
import '../datasources/posts_remote_datasource.dart';
import '../models/post_model.dart';

/// Implementation of PostsRepository
/// Handles data fetching from remote and local sources with proper error handling
class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  final NetworkService networkService;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    if (await networkService.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPosts();

        // Cache the posts for offline use
        await localDataSource.cachePosts(remotePosts);

        return Right(remotePosts.toEntities());
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(message: e.message));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    } else {
      // No internet connection, try to get cached data
      return getCachedPosts();
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(int id) async {
    if (await networkService.isConnected) {
      try {
        final post = await remoteDataSource.getPostById(id);
        return Right(post.toEntity());
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    } else {
      // Try to get from cache
      try {
        final cachedPost = await localDataSource.getCachedPostById(id);
        if (cachedPost != null) {
          return Right(cachedPost.toEntity());
        }
        return const Left(NetworkFailure(
          message: 'No internet connection and post not found in cache',
        ));
      } catch (e) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, PostEntity>> createPost(PostEntity post) async {
    if (!await networkService.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final postModel = PostModel.fromEntity(post);
      final createdPost = await remoteDataSource.createPost(postModel);
      return Right(createdPost.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> updatePost(PostEntity post) async {
    if (!await networkService.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final postModel = PostModel.fromEntity(post);
      final updatedPost = await remoteDataSource.updatePost(postModel);
      return Right(updatedPost.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) async {
    if (!await networkService.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.deletePost(id);
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPostsByUserId(int userId) async {
    if (!await networkService.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final posts = await remoteDataSource.getPostsByUserId(userId);
      return Right(posts.toEntities());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getCachedPosts() async {
    try {
      final cachedPosts = await localDataSource.getCachedPosts();
      return Right(cachedPosts.toEntities());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
