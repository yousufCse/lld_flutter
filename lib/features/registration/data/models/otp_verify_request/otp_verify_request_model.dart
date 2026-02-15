import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_verify_request_model.g.dart';

@JsonSerializable()
class OtpVerifyRequestModel {
  OtpVerifyRequestModel({required this.registrationId, required this.otp});

  final String registrationId;
  final String otp;

  factory OtpVerifyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyRequestModelToJson(this);
}
