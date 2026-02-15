import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/register_entity.dart';

part 'register_response_model.g.dart';

@JsonSerializable(createToJson: false)
class RegisterResponseModel {
  String registrationId;
  String otpReference;
  String expiresAt;
  String message;

  RegisterResponseModel({
    required this.registrationId,
    required this.otpReference,
    required this.expiresAt,
    required this.message,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  RegisterEntity get toEntity => RegisterEntity(
    registrationId: registrationId,
    otpReference: otpReference,
    expiresAt: expiresAt,
    message: message,
  );
}
