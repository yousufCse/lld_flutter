/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

// ==================== Network Related Exceptions ====================

/// Exception thrown when there's a network connectivity issue
class NetworkException extends AppException {
  const NetworkException(
    String message, {
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(message: message, code: code ?? 'NETWORK_ERROR');

  @override
  String toString() => 'NetworkException: $message';
}

// ==================== Server Related Exceptions ====================

/// Exception thrown when server returns an error
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(
    String message, {
    this.statusCode,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(message: message, code: code ?? 'SERVER_ERROR');

  @override
  String toString() =>
      'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

// ==================== Authentication Exceptions ====================

/// Exception thrown for authentication/authorization issues
class AuthException extends AppException {
  const AuthException(
    String message, {
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(message: message, code: code ?? 'AUTH_ERROR');

  factory AuthException.unauthorized() => const AuthException(
    'Unauthorized access. Please login again.',
    code: 'UNAUTHORIZED',
  );

  factory AuthException.sessionExpired() => const AuthException(
    'Your session has expired. Please login again.',
    code: 'SESSION_EXPIRED',
  );

  factory AuthException.invalidCredentials() => const AuthException(
    'Invalid credentials provided.',
    code: 'INVALID_CREDENTIALS',
  );

  @override
  String toString() => 'AuthException: $message';
}

// ==================== Data Related Exceptions ====================

/// Exception thrown when parsing/serialization fails
class ParsingException extends AppException {
  final dynamic data;

  const ParsingException(
    String message, {
    this.data,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(message: message, code: code ?? 'PARSING_ERROR');

  factory ParsingException.fromData(dynamic data) =>
      ParsingException('Failed to parse data', data: data);

  @override
  String toString() => 'ParsingException: $message';
}

/// Exception thrown for cache operations
class CacheException extends AppException {
  const CacheException(
    String message, {
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(message: message, code: code ?? 'CACHE_ERROR');

  factory CacheException.readFailed() => const CacheException(
    'Failed to read from cache',
    code: 'CACHE_READ_ERROR',
  );

  factory CacheException.writeFailed() => const CacheException(
    'Failed to write to cache',
    code: 'CACHE_WRITE_ERROR',
  );

  factory CacheException.notFound() =>
      const CacheException('Data not found in cache', code: 'CACHE_NOT_FOUND');

  @override
  String toString() => 'CacheException: $message';
}

// ==================== API Exceptions ====================

/// Exception thrown for API-specific errors with status codes
class ApiException extends AppException {
  final int statusCode;
  final Map<String, dynamic>? responseData;

  const ApiException({
    required super.message,
    required this.statusCode,
    this.responseData,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'API_ERROR');

  factory ApiException.badRequest(String message) =>
      ApiException(message: message, statusCode: 400, code: 'BAD_REQUEST');

  factory ApiException.notFound(String message) =>
      ApiException(message: message, statusCode: 404, code: 'NOT_FOUND');

  factory ApiException.validationFailed(
    String message, {
    Map<String, dynamic>? data,
  }) => ApiException(
    message: message,
    statusCode: 422,
    code: 'VALIDATION_ERROR',
    responseData: data,
  );

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

// ==================== Unknown/Custom Exceptions ====================

/// Generic exception for unexpected errors
class CustomException extends AppException {
  const CustomException(
    String message, {
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(message: message, code: code ?? 'UNKNOWN_ERROR');

  @override
  String toString() => 'CustomException: $message';
}
