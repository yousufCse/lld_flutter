import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/base_repository.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';
import 'package:niramoy_health_app/features/registration/data/data_sources/register_remote_data_source.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/register_entity.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/account_verification_entity.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/otp_resend_entity.dart';
import 'package:niramoy_health_app/features/registration/domain/repositories/register_repository.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/account_completion_usecase.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/register_initiate_usecase.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/otp_verify_usecase.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/otp_resend_usecase.dart';

import '../../domain/entities/account_completion_entity.dart';
import '../models/completion_request/account_completion_request_model.dart';
import '../models/register_request/register_request_model.dart';
import '../models/otp_verify_request/otp_verify_request_model.dart';
import '../models/otp_resend_request/otp_resend_request_model.dart';

@Injectable(as: RegisterRepository)
class RegisterRepositoryImpl extends BaseRepository
    implements RegisterRepository {
  RegisterRepositoryImpl({required this.remote, required super.networkInfo});

  final RegisterRemoteDataSource remote;

  @override
  Result<RegisterEntity> registerInitiate(RegisterParams params) async {
    return handleException(() async {
      final result = await remote.registerInitiate(
        RegisterRequestModel(
          firstName: params.firstName,
          lastName: params.lastName,
          phone: params.phone,
          gender: params.gender.toUpperCase(),
          dateOfBirth: params.dateOfBirth,
          termsAccepted: params.termsAccepted,
        ),
      );
      return result.toEntity;
    });
  }

  @override
  Result<AccountVerificationEntity> verifyOtp(OtpVerifyParams params) async {
    return handleException(() async {
      final result = await remote.verifyOtp(
        OtpVerifyRequestModel(
          registrationId: params.registrationId,
          otp: params.otp,
        ),
      );
      return result.toEntity;
    });
  }

  @override
  Result<OtpResendEntity> resendOtp(OtpResendParams params) async {
    return handleException(() async {
      final result = await remote.resendOtp(
        OtpResendRequestModel(
          otpReference: params.otpReference,
          phone: params.phone,
          purpose: params.purpose,
        ),
      );
      return result.toEntity;
    });
  }

  @override
  Result<AccountCompletionEntity> completeRegistration(
    CompleteRegistrationParams params,
  ) {
    return handleException(() async {
      final result = await remote.completeRegistration(
        AccountCompletionRequestModel(
          registrationId: params.registrationId,
          createNewAccount: params.createNewAccount,
        ),
      );
      return result.toEntity;
    });
  }
}
