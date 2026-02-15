import 'package:dio/dio.dart';

import '../../../core/di/injection.dart';
import '../../services/storage_service.dart';

/// Auth interceptor for adding authentication tokens to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get token from storage
    final storageService = getIt<StorageService>();
    final token = storageService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - attempt token refresh
    if (err.response?.statusCode == 401) {
      // TODO: Implement token refresh logic here
      // final newToken = await _refreshToken();
      // if (newToken != null) {
      //   final opts = err.requestOptions;
      //   opts.headers['Authorization'] = 'Bearer $newToken';
      //   final response = await getIt<Dio>().fetch(opts);
      //   return handler.resolve(response);
      // }
    }

    handler.next(err);
  }

  /// Check if endpoint is public (doesn't need auth)
  bool _isPublicEndpoint(String path) {
    const publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
    ];
    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  // Future<String?> _refreshToken() async {
  //   try {
  //     final storageService = getIt<StorageService>();
  //     final refreshToken = storageService.getRefreshToken();
  //
  //     if (refreshToken == null) return null;
  //
  //     // Make refresh token request
  //     // Save new tokens
  //     // Return new access token
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
