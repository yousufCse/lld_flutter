class AccountCompletionEntity {
  final String patientId;
  final String userName;
  final CredentialsEntity credentials;

  AccountCompletionEntity({
    required this.patientId,
    required this.userName,
    required this.credentials,
  });
}

class CredentialsEntity {
  final String temporaryPassword;
  final bool mustChangePassword;

  CredentialsEntity({
    required this.temporaryPassword,
    required this.mustChangePassword,
  });
}
