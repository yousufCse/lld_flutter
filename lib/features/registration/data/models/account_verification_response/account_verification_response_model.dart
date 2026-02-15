import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/account_verification_entity.dart';

import '../completion_response/account_completion_response_model.dart';

part 'account_verification_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AccountVerificationResponseModel {
  final String action;
  final List<ExistingAccountModel> existingAccounts;
  final AccountCompletionResponseModel? completion;

  AccountVerificationResponseModel({
    required this.action,
    required this.existingAccounts,
    this.completion,
  });

  factory AccountVerificationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AccountVerificationResponseModelFromJson(json);

  AccountVerificationEntity get toEntity => AccountVerificationEntity(
    action: _mapAction(action),
    existingAccounts: existingAccounts.map((e) => e.toEntity).toList(),
    completion: completion?.toEntity,
  );

  VerificationAction _mapAction(String action) {
    switch (action.toUpperCase()) {
      case 'CHOOSE':
        return VerificationAction.choose;
      case 'COMPLETED':
        return VerificationAction.completed;
      default:
        throw Exception('Unknown verification action: $action');
    }
  }
}

@JsonSerializable(createToJson: false)
class ExistingAccountModel {
  final String patientId;
  final String userName;
  final String fullName;
  final int age;
  final String gender;

  ExistingAccountModel({
    required this.patientId,
    required this.userName,
    required this.fullName,
    required this.age,
    required this.gender,
  });

  factory ExistingAccountModel.fromJson(Map<String, dynamic> json) =>
      _$ExistingAccountModelFromJson(json);

  ExistingAccount get toEntity => ExistingAccount(
    patientId: patientId,
    userName: userName,
    fullName: fullName,
    age: age,
    gender: gender,
  );
}
