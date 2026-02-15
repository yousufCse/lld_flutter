import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Failures are returned from repositories to the domain layer
/// They represent expected error states that the UI can handle
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure caused by server errors (5xx)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred. Please try again later.',
    super.statusCode,
  });
}

/// Failure caused by network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
  });
}

/// Failure caused by cache operations
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load cached data.',
    super.statusCode,
  });
}

/// Failure caused by authentication issues (401)
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please login again.',
    super.statusCode = 401,
  });
}

/// Failure caused by authorization issues (403)
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'You do not have permission to access this resource.',
    super.statusCode = 403,
  });
}

/// Failure caused by resource not found (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
  });
}

/// Failure caused by validation errors (422)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    super.message = 'Validation failed. Please check your input.',
    super.statusCode = 422,
    this.errors,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

/// Failure caused by timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
  });
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.statusCode,
  });
}

/// Failure caused by bad request (400)
class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = 'Invalid request. Please check your input.',
    super.statusCode = 400,
  });
}

/// Failure caused by conflict (409)
class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'A conflict occurred. The resource may already exist.',
    super.statusCode = 409,
  });
}
