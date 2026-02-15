import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/posts_repository.dart';

/// Use case for deleting a post
class DeletePost implements UseCase<void, DeletePostParams> {
  final PostsRepository repository;

  DeletePost(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletePostParams params) async {
    return repository.deletePost(params.id);
  }
}

/// Parameters for DeletePost use case
class DeletePostParams extends Equatable {
  final int id;

  const DeletePostParams({required this.id});

  @override
  List<Object?> get props => [id];
}
