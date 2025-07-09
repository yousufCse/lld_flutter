import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/face.dart';
import '../repositories/face_repository.dart';

@lazySingleton
class GetRandomFace implements UseCase<Face, NoParams> {
  final FaceRepository repository;

  GetRandomFace(this.repository);

  @override
  Future<Either<Failure, Face>> call(NoParams params) {
    return repository.getRandomFace();
  }
}
