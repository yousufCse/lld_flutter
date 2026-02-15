import '../constants/app_errors.dart';

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
  }) : super(message: message, code: code ?? AppErrorCodes.networkError);

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
  }) : super(message: message, code: code ?? AppErrorCodes.serverError);

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
  }) : super(message: message, code: code ?? AppErrorCodes.authError);

  factory AuthException.unauthorized() => const AuthException(
    AppErrors.unauthorized,
    code: AppErrorCodes.unauthorized,
  );

  factory AuthException.sessionExpired() => const AuthException(
    AppErrors.sessionExpired,
    code: AppErrorCodes.sessionExpired,
  );

  factory AuthException.invalidCredentials() => const AuthException(
    AppErrors.invalidCredentials,
    code: AppErrorCodes.invalidCredentials,
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
  }) : super(message: message, code: code ?? AppErrorCodes.parsingError);

  factory ParsingException.fromData(dynamic data) =>
      ParsingException(AppErrors.parsingError, data: data);

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
  }) : super(message: message, code: code ?? AppErrorCodes.cacheError);

  factory CacheException.readFailed() => const CacheException(
    AppErrors.cacheError,
    code: AppErrorCodes.cacheReadError,
  );

  factory CacheException.writeFailed() => const CacheException(
    AppErrors.cacheWriteError,
    code: AppErrorCodes.cacheWriteError,
  );

  factory CacheException.notFound() => const CacheException(
    AppErrors.cacheDataNotFound,
    code: AppErrorCodes.cacheNotFound,
  );

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
  }) : super(code: code ?? AppErrorCodes.apiError);

  factory ApiException.badRequest(String message) => ApiException(
    message: message,
    statusCode: 400,
    code: AppErrorCodes.badRequest,
  );

  factory ApiException.notFound(String message) => ApiException(
    message: message,
    statusCode: 404,
    code: AppErrorCodes.notFound,
  );

  factory ApiException.validationFailed(
    String message, {
    Map<String, dynamic>? data,
  }) => ApiException(
    message: message,
    statusCode: 422,
    code: AppErrorCodes.validationError,
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
  }) : super(message: message, code: code ?? AppErrorCodes.unknownError);

  @override
  String toString() => 'CustomException: $message';
}
