import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/vital_sign.dart';
import '../repositories/vital_sign_repository.dart';

@lazySingleton
class GetLatestVitalSignUseCase {
  final VitalSignRepository repository;

  GetLatestVitalSignUseCase(this.repository);

  Future<Either<Failure, VitalSign>> call(String userId) async {
    return await repository.getLatestVitalSign(userId);
  }
}
