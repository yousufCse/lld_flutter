import 'package:niramoy_health_app/core/types/type_defs.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/register_initiate_usecase.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/otp_verify_usecase.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/otp_resend_usecase.dart';

import '../entities/account_completion_entity.dart';
import '../entities/register_entity.dart';
import '../entities/otp_resend_entity.dart';
import '../entities/account_verification_entity.dart';
import '../usecases/account_completion_usecase.dart';

abstract class RegisterRepository {
  Result<RegisterEntity> registerInitiate(RegisterParams params);
  Result<AccountVerificationEntity> verifyOtp(OtpVerifyParams params);
  Result<OtpResendEntity> resendOtp(OtpResendParams params);
  Result<AccountCompletionEntity> completeRegistration(
    CompleteRegistrationParams params,
  );
}
