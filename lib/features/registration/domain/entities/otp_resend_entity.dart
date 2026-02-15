class OtpResendEntity {
  bool success;
  OtpResendData data;
  String message;

  OtpResendEntity({
    required this.success,
    required this.data,
    required this.message,
  });
}

class OtpResendData {
  String otpReference;
  String phone;
  String otpExpiresAt;
  int resendCount;
  int maxResends;
  String nextResendAvailableAt;

  OtpResendData({
    required this.otpReference,
    required this.phone,
    required this.otpExpiresAt,
    required this.resendCount,
    required this.maxResends,
    required this.nextResendAvailableAt,
  });
}
