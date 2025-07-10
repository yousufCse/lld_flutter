import 'package:equatable/equatable.dart';

class User extends Equatable {
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
  final String? umrId;

  const User({
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

  String get fullName => '$firstName ${lastName ?? ""}';

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    mobile,
    email,
    dateOfBirth,
    gender,
    profession,
    relationship,
    bloodGroup,
    umrId,
  ];
}
