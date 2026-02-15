import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/otp_resend_entity.dart';

part 'otp_resend_response_model.g.dart';

@JsonSerializable(createToJson: false)
class OtpResendResponseModel {
  @JsonKey(name: "success")
  bool success;
  @JsonKey(name: "data")
  OtpResendDataModel data;
  @JsonKey(name: "message")
  String message;

  OtpResendResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory OtpResendResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResendResponseModelFromJson(json);

  OtpResendEntity get toEntity => OtpResendEntity(
    success: success,
    data: data.toOtpResendDataEntity,
    message: message,
  );
}

@JsonSerializable(createToJson: false)
class OtpResendDataModel {
  @JsonKey(name: "otp_reference")
  String otpReference;
  @JsonKey(name: "phone")
  String phone;
  @JsonKey(name: "otp_expires_at")
  String otpExpiresAt;
  @JsonKey(name: "resend_count")
  int resendCount;
  @JsonKey(name: "max_resends")
  int maxResends;
  @JsonKey(name: "next_resend_available_at")
  String nextResendAvailableAt;

  OtpResendDataModel({
    required this.otpReference,
    required this.phone,
    required this.otpExpiresAt,
    required this.resendCount,
    required this.maxResends,
    required this.nextResendAvailableAt,
  });

  factory OtpResendDataModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResendDataModelFromJson(json);

  OtpResendData get toOtpResendDataEntity => OtpResendData(
    otpReference: otpReference,
    phone: phone,
    otpExpiresAt: otpExpiresAt,
    resendCount: resendCount,
    maxResends: maxResends,
    nextResendAvailableAt: nextResendAvailableAt,
  );
}
