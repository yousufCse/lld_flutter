import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: 'umrid')
  final String? umrIdJson;

  const UserModel({
    required super.id,
    super.firstName,
    super.lastName,
    super.mobile,
    super.email,
    super.dateOfBirth,
    super.gender,
    super.profession,
    super.relationship,
    super.bloodGroup,
    this.umrIdJson,
  }) : super(umrId: umrIdJson);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
