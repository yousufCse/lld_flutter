import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

/// Use case for getting all posts
class GetPosts implements UseCase<List<PostEntity>, NoParams> {
  final PostsRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(NoParams params) async {
    return repository.getPosts();
  }
}
