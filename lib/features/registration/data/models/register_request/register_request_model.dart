import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel {
  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.termsAccepted,
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String? dateOfBirth;
  final String gender;
  final bool termsAccepted;

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
