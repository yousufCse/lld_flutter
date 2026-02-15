class OtpVerifyEntity {
  bool success;
  OtpVerifyData data;
  String message;

  OtpVerifyEntity({
    required this.success,
    required this.data,
    required this.message,
  });
}

class OtpVerifyData {
  bool verified;
  String phone;
  String purpose;
  String verifiedAt;
  String verificationToken;

  OtpVerifyData({
    required this.verified,
    required this.phone,
    required this.purpose,
    required this.verifiedAt,
    required this.verificationToken,
  });
}
