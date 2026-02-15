import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

/// Use case for getting a single post by ID
class GetPostById implements UseCase<PostEntity, GetPostByIdParams> {
  final PostsRepository repository;

  GetPostById(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(GetPostByIdParams params) async {
    return repository.getPostById(params.id);
  }
}

/// Parameters for GetPostById use case
class GetPostByIdParams extends Equatable {
  final int id;

  const GetPostByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
