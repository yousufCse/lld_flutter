import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/otp_verify_entity.dart';

part 'otp_verify_response_model.g.dart';

@JsonSerializable(createToJson: false)
class OtpVerifyResponseModel {
  @JsonKey(name: "success")
  bool success;
  @JsonKey(name: "data")
  OtpVerifyDataModel data;
  @JsonKey(name: "message")
  String message;

  OtpVerifyResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory OtpVerifyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyResponseModelFromJson(json);

  OtpVerifyEntity get toEntity => OtpVerifyEntity(
    success: success,
    data: data.toOtpVerifyDataEntity,
    message: message,
  );
}

@JsonSerializable(createToJson: false)
class OtpVerifyDataModel {
  @JsonKey(name: "verified")
  bool verified;
  @JsonKey(name: "phone")
  String phone;
  @JsonKey(name: "purpose")
  String purpose;
  @JsonKey(name: "verified_at")
  String verifiedAt;
  @JsonKey(name: "verification_token")
  String verificationToken;

  OtpVerifyDataModel({
    required this.verified,
    required this.phone,
    required this.purpose,
    required this.verifiedAt,
    required this.verificationToken,
  });

  factory OtpVerifyDataModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyDataModelFromJson(json);

  OtpVerifyData get toOtpVerifyDataEntity => OtpVerifyData(
    verified: verified,
    phone: phone,
    purpose: purpose,
    verifiedAt: verifiedAt,
    verificationToken: verificationToken,
  );
}
