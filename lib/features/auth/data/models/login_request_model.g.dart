// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestModel _$LoginRequestModelFromJson(Map<String, dynamic> json) =>
    LoginRequestModel(
      loginId: json['loginId'] as String,
      pin: json['pin'] as String,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      osversion: json['osversion'] as String?,
      osplatform: json['osplatform'] as String?,
    );
