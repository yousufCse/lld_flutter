import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/otp_resend_entity.dart';

import '../repositories/register_repository.dart';

@injectable
class OtpResendUsecase extends Usecase<OtpResendEntity, OtpResendParams> {
  OtpResendUsecase({required this.repository});

  final RegisterRepository repository;

  @override
  Result<OtpResendEntity> call(OtpResendParams params) =>
      repository.resendOtp(params);
}

class OtpResendParams extends Params {
  final String otpReference;
  final String phone;
  final String purpose;

  OtpResendParams({
    required this.otpReference,
    required this.phone,
    required this.purpose,
  });
}
