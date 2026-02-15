import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/account_verification_entity.dart';

import '../repositories/register_repository.dart';

@injectable
class OtpVerifyUsecase
    extends Usecase<AccountVerificationEntity, OtpVerifyParams> {
  OtpVerifyUsecase({required this.repository});

  final RegisterRepository repository;

  @override
  Result<AccountVerificationEntity> call(OtpVerifyParams params) =>
      repository.verifyOtp(params);
}

class OtpVerifyParams extends Params {
  final String registrationId;
  final String otp;

  OtpVerifyParams({required this.registrationId, required this.otp});
}
