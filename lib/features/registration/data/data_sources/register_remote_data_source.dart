import 'package:niramoy_health_app/features/registration/data/models/register_request/register_request_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/register_response/register_response_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/otp_verify_request/otp_verify_request_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/account_verification_response/account_verification_response_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/otp_resend_request/otp_resend_request_model.dart';
import 'package:niramoy_health_app/features/registration/data/models/otp_resend_response/otp_resend_response_model.dart';

import '../models/completion_request/account_completion_request_model.dart';
import '../models/completion_response/account_completion_response_model.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterResponseModel> registerInitiate(RegisterRequestModel request);
  Future<AccountVerificationResponseModel> verifyOtp(
    OtpVerifyRequestModel request,
  );
  Future<OtpResendResponseModel> resendOtp(OtpResendRequestModel request);
  Future<AccountCompletionResponseModel> completeRegistration(
    AccountCompletionRequestModel request,
  );
}
