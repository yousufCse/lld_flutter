import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/account_completion_entity.dart';

part 'account_completion_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AccountCompletionResponseModel {
  final String patientId;
  final String userName;
  final CredentialsModel credentials;

  AccountCompletionResponseModel({
    required this.patientId,
    required this.userName,
    required this.credentials,
  });

  factory AccountCompletionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AccountCompletionResponseModelFromJson(json);

  AccountCompletionEntity get toEntity => AccountCompletionEntity(
    patientId: patientId,
    userName: userName,
    credentials: credentials.toEntity,
  );
}

@JsonSerializable(createToJson: false)
class CredentialsModel {
  final String temporaryPassword;
  final bool mustChangePassword;

  CredentialsModel({
    required this.temporaryPassword,
    required this.mustChangePassword,
  });

  factory CredentialsModel.fromJson(Map<String, dynamic> json) =>
      _$CredentialsModelFromJson(json);

  CredentialsEntity get toEntity => CredentialsEntity(
    temporaryPassword: temporaryPassword,
    mustChangePassword: mustChangePassword,
  );
}
