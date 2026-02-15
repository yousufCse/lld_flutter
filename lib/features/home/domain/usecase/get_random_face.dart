import 'package:flutter_exercise/core/utils/type_defs.dart';
import 'package:flutter_exercise/core/domain/usecase.dart';
import 'package:flutter_exercise/features/home/domain/entity/random_face_entity.dart';
import 'package:flutter_exercise/features/home/domain/repository/random_face_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRandomFace extends Usecase<RandomFaceEntity, NoParams> {
  final RandomFaceRepository repository;

  GetRandomFace({required this.repository});

  @override
  Result<RandomFaceEntity> call(NoParams params) {
    return repository.fetchRandomFace();
  }
}
