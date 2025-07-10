import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel {
  final String loginId;
  final String pin;
  final String? latitude;
  final String? longitude;
  final String? deviceId;
  final String? deviceName;
  final String? osversion;
  final String? osplatform;

  LoginRequestModel({
    required this.loginId,
    required this.pin,
    this.latitude,
    this.longitude,
    this.deviceId,
    this.deviceName,
    this.osversion,
    this.osplatform,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  // Custom toJson to convert null values to empty strings
  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'pin': pin,
      'latitude': latitude ?? '',
      'longitude': longitude ?? '',
      'deviceId': deviceId ?? '',
      'deviceName': deviceName ?? '',
      'osversion': osversion ?? '',
      'osplatform': osplatform ?? '',
    };
  }
}
