/// This class contains all error message strings used in the application
class ErrorStrings {
  // Network error messages
  static const String connectionTimeout = 'Connection timeout';
  static const String noInternetConnection = 'No internet connection';
  static const String unknownError = 'Unknown error occurred';
  static const String failedToFetchData = 'Failed to fetch data';
  static const String authTokenNotFound = 'Authorization token not found';

  // HTTP error messages
  static const String badRequest = 'Bad request';
  static const String unauthorized = 'Unauthorized';
  static const String forbidden = 'Forbidden';
  static const String notFound = 'Not found';
  static const String internalServerError = 'Internal server error';
  static const String statusCodeError = 'Error occurred with status code';

  // Auth error messages
  static const String failedToLogin = 'Failed to login';
  static const String failedToLogout = 'Failed to logout';
  static const String invalidCredentials = 'Invalid email or password';
  static const String invalidTokenResponse = 'Invalid token response';
  static const String noRefreshToken = 'No refresh token available';

  // Data error messages
  static const String failedToParseData = 'Failed to parse data';
  static const String noDataFound = 'No data found';
  static const String failedToFetchUser = 'Failed to fetch user data';
  static const String failedToFetchVitalSign =
      'Failed to fetch vital sign data';
  static const String failedToFetchFace = 'Failed to parse face data';
}
