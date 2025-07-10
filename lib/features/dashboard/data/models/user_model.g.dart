// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  mobile: json['mobile'] as String?,
  email: json['email'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  gender: json['gender'] as String?,
  profession: json['profession'] as String?,
  relationship: json['relationship'] as String?,
  bloodGroup: json['bloodGroup'] as String?,
  umrIdJson: json['umrid'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'mobile': instance.mobile,
  'email': instance.email,
  'dateOfBirth': instance.dateOfBirth,
  'gender': instance.gender,
  'profession': instance.profession,
  'relationship': instance.relationship,
  'bloodGroup': instance.bloodGroup,
  'umrid': instance.umrIdJson,
};
