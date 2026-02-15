import 'account_completion_entity.dart';

enum VerificationAction { choose, completed }

class AccountVerificationEntity {
  final VerificationAction action;
  final List<ExistingAccount> existingAccounts;
  final AccountCompletionEntity? completion;

  AccountVerificationEntity({
    required this.action,
    required this.existingAccounts,
    this.completion,
  });

  bool get hasExistingAccounts =>
      action == VerificationAction.choose && existingAccounts.isNotEmpty;

  bool get isFirstTimeUser =>
      action == VerificationAction.completed && completion != null;
}

class ExistingAccount {
  final String patientId;
  final String userName;
  final String fullName;
  final int age;
  final String gender;

  ExistingAccount({
    required this.patientId,
    required this.userName,
    required this.fullName,
    required this.age,
    required this.gender,
  });
}
