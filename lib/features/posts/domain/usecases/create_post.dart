import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

/// Use case for creating a new post
class CreatePost implements UseCase<PostEntity, CreatePostParams> {
  final PostsRepository repository;

  CreatePost(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(CreatePostParams params) async {
    return repository.createPost(params.post);
  }
}

/// Parameters for CreatePost use case
class CreatePostParams extends Equatable {
  final PostEntity post;

  const CreatePostParams({required this.post});

  @override
  List<Object?> get props => [post];
}
