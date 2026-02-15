import 'package:dio/dio.dart';

import '../../error/exceptions.dart';
import '../../utils/helpers.dart';

/// Error interceptor for handling and transforming Dio errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    logger.e('API Error: ${err.message}', error: err);

    final exception = _handleError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  /// Handle Dio errors and convert them to custom exceptions
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException(
          message: 'Connection timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Unable to connect to server. Please check your internet.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return const UnexpectedException(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.badCertificate:
        return const ServerException(
          message: 'Invalid SSL certificate.',
        );

      case DioExceptionType.unknown:
      default:
        if (error.message?.contains('SocketException') ?? false) {
          return const NetworkException(
            message: 'No internet connection.',
          );
        }
        return UnexpectedException(
          message: error.message ?? 'An unexpected error occurred.',
          originalError: error,
        );
    }
  }

  /// Handle bad response errors based on status code
  Exception _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    String message = 'An error occurred';

    // Try to extract message from response
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ??
          data['error'] as String? ??
          data['errors']?.toString() ??
          message;
    }

    switch (statusCode) {
      case 400:
        return ServerException(
          message: message,
          statusCode: statusCode,
        );

      case 401:
        return AuthException(
          message: message.isNotEmpty ? message : 'Unauthorized access.',
        );

      case 403:
        return ServerException(
          message: message.isNotEmpty ? message : 'Access forbidden.',
          statusCode: statusCode,
        );

      case 404:
        return NotFoundException(
          message: message.isNotEmpty ? message : 'Resource not found.',
        );

      case 422:
        Map<String, List<String>>? validationErrors;
        if (data is Map<String, dynamic> && data['errors'] is Map) {
          validationErrors = (data['errors'] as Map).map(
            (key, value) => MapEntry(
              key.toString(),
              (value as List).map((e) => e.toString()).toList(),
            ),
          );
        }
        return ValidationException(
          message: message,
          errors: validationErrors,
        );

      case 429:
        return const ServerException(
          message: 'Too many requests. Please try again later.',
          statusCode: 429,
        );

      case 500:
      case 501:
      case 502:
      case 503:
        return ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
        );

      default:
        return ServerException(
          message: message,
          statusCode: statusCode,
        );
    }
  }
}
