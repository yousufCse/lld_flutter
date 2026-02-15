import 'package:equatable/equatable.dart';

/// Base failure class with equality comparison
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({required this.message, this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

// Network Related Failures
final class NetworkFailure extends Failure {
  const NetworkFailure({String? message, String? code, super.details})
    : super(
        message: message ?? 'Network connection failed',
        code: code ?? 'NETWORK_ERROR',
      );
}

// Server Related Failures
final class ServerFailure extends Failure {
  const ServerFailure({String? message, String? code, super.details})
    : super(
        message: message ?? 'Server error occurred',
        code: code ?? 'SERVER_ERROR',
      );
}

// Authentication Failures
final class AuthFailure extends Failure {
  const AuthFailure({required super.message, String? code})
    : super(code: code ?? 'AUTH_ERROR');

  factory AuthFailure.unauthorized() =>
      const AuthFailure(message: 'Unauthorized access', code: 'UNAUTHORIZED');

  factory AuthFailure.sessionExpired() => const AuthFailure(
    message: 'Session expired. Please login again',
    code: 'SESSION_EXPIRED',
  );

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    message: 'Invalid email or password',
    code: 'INVALID_CREDENTIALS',
  );
}

// Cache Related Failures
final class CacheFailure extends Failure {
  const CacheFailure({String? message})
    : super(message: message ?? 'Cache operation failed', code: 'CACHE_ERROR');
}

// Parsing Failures
final class ParsingFailure extends Failure {
  const ParsingFailure({String? message, super.details})
    : super(message: message ?? 'Failed to parse data', code: 'PARSING_ERROR');
}

// API Failures
final class ApiFailure extends Failure {
  final int statusCode;

  const ApiFailure({
    required this.statusCode,
    String? message,
    String? code,
    super.details,
  }) : super(
         message: message ?? 'API request failed',
         code: code ?? 'API_ERROR_$statusCode',
       );

  @override
  List<Object?> get props => [...super.props, statusCode];
}

// Custom Failures
final class CustomFailure extends Failure {
  const CustomFailure({required super.message, String? code, super.details})
    : super(code: code ?? 'CUSTOM_ERROR');
}
