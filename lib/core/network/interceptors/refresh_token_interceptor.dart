import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/data/local/token_storage.dart';
import 'package:niramoy_health_app/core/di/injection_names.dart';
import 'package:niramoy_health_app/core/network/base_config.dart';

import '../../errors/errors.dart';
import '../api_endpoints.dart';

/// Interceptor to handle token refresh when a 401 Unauthorized response is received
@lazySingleton
class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage tokenStorage;

  // Flag to prevent multiple simultaneous refresh attempts
  bool _isRefreshing = false;

  // Queue of requests that failed due to 401 and are waiting for token refresh
  final List<_RequestQueueItem> _pendingRequests = [];

  RefreshTokenInterceptor({
    @Named(InjectionNames.dioSingleton) required this.dio,
    required this.tokenStorage,
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
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw ServerException('No refresh token available');
    }

    // Create a new Dio instance to avoid interceptors loop
    final refreshDio = Dio(BaseConfig());

    try {
      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Check for error in response
        if (data['error'] != null) {
          throw ServerException(data['error']);
        }

        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null) {
          await tokenStorage.saveToken(newAccessToken);
          await tokenStorage.saveRefreshToken(newRefreshToken ?? refreshToken);
        } else {
          throw ServerException('Invalid token refresh response');
        }
      } else {
        throw ServerException('Failed to refresh token');
      }
    } catch (e) {
      throw ServerException(
        e is ServerException ? e.message : 'Token refresh failed',
      );
    }
  }

  /// Process all pending requests with the new token
  Future<void> _processPendingRequests() async {
    final requests = List<_RequestQueueItem>.from(_pendingRequests);
    _pendingRequests.clear();

    for (var request in requests) {
      try {
        // Get the new token from TokenStorage
        final accessToken = await tokenStorage.getToken();

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
    // Clear tokens using TokenStorage
    await tokenStorage.clearTokens();

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
