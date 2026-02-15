import 'package:flutter_exercise/core/utils/type_defs.dart';
import 'package:flutter_exercise/features/home/domain/entity/random_face_entity.dart';

abstract class RandomFaceRepository {
  Result<RandomFaceEntity> fetchRandomFace();
}
