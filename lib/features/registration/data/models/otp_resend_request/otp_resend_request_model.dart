import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_resend_request_model.g.dart';

@JsonSerializable()
class OtpResendRequestModel {
  OtpResendRequestModel({
    required this.otpReference,
    required this.phone,
    required this.purpose,
  });

  final String otpReference;
  final String phone;
  final String purpose;

  factory OtpResendRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResendRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpResendRequestModelToJson(this);
}
