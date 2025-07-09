import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/face.dart';

abstract class FaceRepository {
  /// Gets a random face from the API
  ///
  /// Returns [Face] if successful
  /// Returns [Failure] if unsuccessful
  Future<Either<Failure, Face>> getRandomFace();
}
