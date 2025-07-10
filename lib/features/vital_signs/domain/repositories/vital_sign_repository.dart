import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/vital_sign.dart';

abstract class VitalSignRepository {
  Future<Either<Failure, VitalSign>> getLatestVitalSign(String userId);
}
