import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

/// Use case for updating an existing post
class UpdatePost implements UseCase<PostEntity, UpdatePostParams> {
  final PostsRepository repository;

  UpdatePost(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(UpdatePostParams params) async {
    return repository.updatePost(params.post);
  }
}

/// Parameters for UpdatePost use case
class UpdatePostParams extends Equatable {
  final PostEntity post;

  const UpdatePostParams({required this.post});

  @override
  List<Object?> get props => [post];
}
