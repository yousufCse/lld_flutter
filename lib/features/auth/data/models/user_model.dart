import 'package:json_annotation/json_annotation.dart';
import 'package:niramoy_health_app/features/auth/domain/entities/user_entity.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'umrid')
  final String? umrIdJson;
  final String id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? profession;
  final String? relationship;
  final String? bloodGroup;

  const UserModel({
    required this.umrIdJson,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.profession,
    required this.relationship,
    required this.bloodGroup,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
      email: email,
      dateOfBirth: dateOfBirth,
      bloodGroup: bloodGroup,
      gender: gender,
      profession: profession,
      relationship: relationship,
      umrId: umrIdJson,
    );
  }

  UserModel.empty()
    : umrIdJson = null,
      id = '',
      firstName = '',
      lastName = '',
      mobile = '',
      email = null,
      dateOfBirth = null,
      gender = null,
      profession = null,
      relationship = null,
      bloodGroup = null;
}
