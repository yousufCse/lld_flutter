class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const login = '/user-management/auth/patient/login';
  static const String refreshToken = '/user-management/auth/token/refresh';
  static const String logout = '/user-management/auth/logout';

  // Patient Registration
  static const registerInitiate =
      '/api/v1/user-management/registration/patient/initiate';
  static const checkAccounts =
      '/api/v1/user-management/registration/patient/check-accounts';
  static const otpResend = '/pin-service/otp/resend';
  static const registerComplete =
      '/api/v1/user-management/registration/patient/complete';

  // User endpoints
  static const getCurrentUser = '/user/GetCurrentUser';
}
