import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? profession;
  final String? relationship;
  final String? bloodGroup;

  @JsonKey(name: 'umrid')
  final String? umrId;

  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.profession,
    this.relationship,
    this.bloodGroup,
    this.umrId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get fullName => '$firstName ${lastName ?? ""}';
}
