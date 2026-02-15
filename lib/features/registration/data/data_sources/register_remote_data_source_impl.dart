import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/di/injection_names.dart';
import 'package:niramoy_health_app/core/network/api_client.dart';
import 'package:niramoy_health_app/core/network/api_endpoints.dart';
import 'package:niramoy_health_app/features/registration/data/models/register_request/register_request_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/register_response/register_response_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/otp_verify_request/otp_verify_request_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/account_verification_response/account_verification_response_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/otp_resend_request/otp_resend_request_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/otp_resend_response/otp_resend_response_model.dart';

import '../models/completion_request/account_completion_request_model.dart';
import '../models/completion_response/account_completion_response_model.dart';
import 'register_remote_data_source.dart';

@Injectable(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  RegisterRemoteDataSourceImpl({
    @Named(InjectionNames.apiClientBasic) required this.basicApiClient,
  });

  final ApiClient basicApiClient;

  @override
  Future<RegisterResponseModel> registerInitiate(
    RegisterRequestModel request,
  ) async {
    return await basicApiClient.post(
      endpoint: ApiEndpoints.registerInitiate,
      data: request.toJson(),
      fromJson: (json) => RegisterResponseModel.fromJson(json),
    );
  }

  @override
  Future<AccountVerificationResponseModel> verifyOtp(
    OtpVerifyRequestModel request,
  ) async {
    return await basicApiClient.post(
      endpoint: ApiEndpoints.checkAccounts,
      data: request.toJson(),
      fromJson: (json) => AccountVerificationResponseModel.fromJson(json),
    );
  }

  @override
  Future<OtpResendResponseModel> resendOtp(
    OtpResendRequestModel request,
  ) async {
    return await basicApiClient.post(
      endpoint: ApiEndpoints.otpResend,
      data: request.toJson(),
      fromJson: (json) => OtpResendResponseModel.fromJson(json),
    );
  }

  @override
  Future<AccountCompletionResponseModel> completeRegistration(
    AccountCompletionRequestModel request,
  ) async {
    return await basicApiClient.post(
      endpoint: ApiEndpoints.registerComplete,
      data: request.toJson(),
      fromJson: (json) => AccountCompletionResponseModel.fromJson(json),
    );
  }
}
