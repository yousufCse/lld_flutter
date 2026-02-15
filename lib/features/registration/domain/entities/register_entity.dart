class RegisterEntity {
  String registrationId;
  String otpReference;
  String expiresAt;
  String message;

  RegisterEntity({
    required this.registrationId,
    required this.otpReference,
    required this.expiresAt,
    required this.message,
  });

  @override
  String toString() {
    return 'RegisterEntity{registrationId: $registrationId, otpReference: $otpReference, expiresAt: $expiresAt, message: $message}';
  }
}
