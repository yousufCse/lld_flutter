/// Application-wide constants

class AppConstants {
  AppConstants._();

  // API Configuration
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache Configuration
  static const String cachePrefix = 'flutter_exercise_';
  static const Duration cacheMaxAge = Duration(days: 7);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // App Info
  static const String appName = 'Flutter Exercise';
  static const String appVersion = '1.0.0';
}

/// Storage keys for SharedPreferences
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String user = 'user';
  static const String theme = 'theme';
  static const String locale = 'locale';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String cachedPosts = 'cached_posts';
}

/// API Endpoints
class ApiEndpoints {
  ApiEndpoints._();

  // Posts
  static const String posts = '/posts';
  static String post(int id) => '/posts/$id';
  static String postComments(int postId) => '/posts/$postId/comments';

  // Users
  static const String users = '/users';
  static String user(int id) => '/users/$id';
  static String userPosts(int userId) => '/users/$userId/posts';

  // Comments
  static const String comments = '/comments';
  static String comment(int id) => '/comments/$id';

  // Albums
  static const String albums = '/albums';
  static String album(int id) => '/albums/$id';

  // Photos
  static const String photos = '/photos';
  static String photo(int id) => '/photos/$id';

  // Todos
  static const String todos = '/todos';
  static String todo(int id) => '/todos/$id';
}
