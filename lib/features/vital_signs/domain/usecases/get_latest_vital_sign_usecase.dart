import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/vital_sign.dart';
import '../repositories/vital_sign_repository.dart';

class GetLatestVitalSignParams extends Params {
  final String userId;

  const GetLatestVitalSignParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

@lazySingleton
class GetLatestVitalSignUseCase
    implements UseCase<VitalSign, GetLatestVitalSignParams> {
  final VitalSignRepository repository;

  GetLatestVitalSignUseCase(this.repository);

  @override
  Future<Either<Failure, VitalSign>> call(GetLatestVitalSignParams params) {
    return repository.getLatestVitalSign(params.userId);
  }
}
