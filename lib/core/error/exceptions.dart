/// Custom exceptions for the application
/// These are thrown by data sources and caught by repositories

/// Exception thrown when a server error occurs
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exception thrown when there's no internet connection
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'No internet connection',
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when cache operations fail
class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Cache error occurred',
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when authentication fails
class AuthException implements Exception {
  final String message;

  const AuthException({
    this.message = 'Authentication failed',
  });

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when validation fails
class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  const ValidationException({
    this.message = 'Validation failed',
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when a resource is not found
class NotFoundException implements Exception {
  final String message;

  const NotFoundException({
    this.message = 'Resource not found',
  });

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown when request times out
class TimeoutException implements Exception {
  final String message;

  const TimeoutException({
    this.message = 'Request timed out',
  });

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception thrown for unexpected errors
class UnexpectedException implements Exception {
  final String message;
  final dynamic originalError;

  const UnexpectedException({
    this.message = 'An unexpected error occurred',
    this.originalError,
  });

  @override
  String toString() => 'UnexpectedException: $message';
}
