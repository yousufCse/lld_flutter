import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../res/visual_strings/app_strings.dart';
import '../constants/api_endpoints.dart';
import '../error/exceptions.dart';

/// Interceptor to handle token refresh when a 401 Unauthorized response is received
class TokenRefreshInterceptor extends Interceptor {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final String baseUrl;

  // Flag to prevent multiple simultaneous refresh attempts
  bool _isRefreshing = false;

  // Queue of requests that failed due to 401 and are waiting for token refresh
  final List<_RequestQueueItem> _pendingRequests = [];

  TokenRefreshInterceptor({
    required this.dio,
    required this.sharedPreferences,
    required this.baseUrl,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the error is due to an unauthorized request (401)
    if (err.response?.statusCode == 401) {
      // Get the failed request options
      final options = err.requestOptions;

      // Don't retry the refresh token endpoint itself to avoid infinite loops
      if (options.path.contains(ApiEndpoints.refreshToken)) {
        return handler.next(err);
      }

      // Add to queue and attempt refresh if not already doing so
      final requestQueueItem = _RequestQueueItem(options, handler);
      _pendingRequests.add(requestQueueItem);

      // Only proceed with refresh if not already in progress
      if (!_isRefreshing) {
        _isRefreshing = true;

        try {
          await _refreshToken();
          // Process any pending requests with new token
          await _processPendingRequests();
        } catch (e) {
          // Clear token and reject all pending requests if refresh fails
          await _handleRefreshFailure();
        } finally {
          _isRefreshing = false;
        }
      }

      // Don't call handler.next() - we'll handle the response in _processPendingRequests
      return;
    }

    // For non-401 errors, continue with the error handling flow
    handler.next(err);
  }

  /// Attempts to refresh the access token using the refresh token
  Future<void> _refreshToken() async {
    final refreshToken = sharedPreferences.getString('refresh_token');
    if (refreshToken == null || refreshToken.isEmpty) {
      throw ServerException(message: ErrorStrings.noRefreshToken);
    }

    // Create a new Dio instance to avoid interceptors loop
    final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));

    try {
      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Check for error in response
        if (data['error'] != null) {
          throw ServerException(message: data['error']);
        }

        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null) {
          // Save the new access token
          await sharedPreferences.setString('access_token', newAccessToken);

          // Save the new refresh token if provided
          if (newRefreshToken != null) {
            await sharedPreferences.setString('refresh_token', newRefreshToken);
          }
        } else {
          throw ServerException(message: ErrorStrings.invalidTokenResponse);
        }
      } else {
        throw ServerException(message: 'Failed to refresh token');
      }
    } catch (e) {
      throw ServerException(
        message: e is ServerException ? e.message : 'Token refresh failed',
      );
    }
  }

  /// Process all pending requests with the new token
  Future<void> _processPendingRequests() async {
    final requests = List<_RequestQueueItem>.from(_pendingRequests);
    _pendingRequests.clear();

    for (var request in requests) {
      try {
        // Get the new token
        final accessToken = sharedPreferences.getString('access_token');
        if (accessToken == null) {
          request.handler.reject(
            DioException(
              requestOptions: request.options,
              error: 'Access token not available',
            ),
          );
          continue;
        }

        // Update the authorization header
        request.options.headers['Authorization'] = 'Bearer $accessToken';

        // Retry the original request
        final response = await dio.fetch(request.options);
        request.handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          request.handler.reject(e);
        } else {
          request.handler.reject(
            DioException(requestOptions: request.options, error: e.toString()),
          );
        }
      }
    }
  }

  /// Handle refresh token failure - clear tokens and reject pending requests
  Future<void> _handleRefreshFailure() async {
    // Clear tokens from storage
    await sharedPreferences.remove('access_token');
    await sharedPreferences.remove('refresh_token');

    // Reject all pending requests
    final requests = List<_RequestQueueItem>.from(_pendingRequests);
    _pendingRequests.clear();

    for (var request in requests) {
      request.handler.reject(
        DioException(
          requestOptions: request.options,
          error: 'Token refresh failed, please login again',
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 401,
            requestOptions: request.options,
            data: {'error': 'Token refresh failed, please login again'},
          ),
        ),
      );
    }
  }
}

/// Helper class to store requests that are waiting for token refresh
class _RequestQueueItem {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RequestQueueItem(this.options, this.handler);
}
