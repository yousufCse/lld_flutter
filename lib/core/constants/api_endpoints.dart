/// This class contains API endpoint strings used in the application
class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String refreshToken = '/Auth/RefreshToken';

  // User endpoints
  static const String getCurrentUser = '/user/GetCurrentUser';

  // Vital sign endpoints
  static const String getLatestVitalSign = '/VitalSign/GetLatestVitalSign';

  // External APIs
  static const String randomUserApi = 'https://randomuser.me/api/';
}
