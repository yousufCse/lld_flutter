import 'package:equatable/equatable.dart';

import '../constants/app_errors.dart';

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
        message: message ?? AppErrors.networkConnectionFailed,
        code: code ?? AppErrorCodes.networkError,
      );
}

// Server Related Failures
final class ServerFailure extends Failure {
  const ServerFailure({String? message, String? code, super.details})
    : super(
        message: message ?? AppErrors.serverError,
        code: code ?? AppErrorCodes.serverError,
      );
}

// Authentication Failures
final class AuthFailure extends Failure {
  const AuthFailure({required super.message, String? code})
    : super(code: code ?? AppErrorCodes.authError);

  factory AuthFailure.unauthorized() => const AuthFailure(
    message: AppErrors.unauthorized,
    code: AppErrorCodes.unauthorized,
  );

  factory AuthFailure.sessionExpired() => const AuthFailure(
    message: AppErrors.sessionExpired,
    code: AppErrorCodes.sessionExpired,
  );

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    message: AppErrors.invalidCredentials,
    code: AppErrorCodes.invalidCredentials,
  );
}

// Cache Related Failures
final class CacheFailure extends Failure {
  const CacheFailure({String? message})
    : super(
        message: message ?? AppErrors.cacheOperationFailed,
        code: AppErrorCodes.cacheError,
      );
}

// Parsing Failures
final class ParsingFailure extends Failure {
  const ParsingFailure({String? message, super.details})
    : super(
        message: message ?? AppErrors.parsingError,
        code: AppErrorCodes.parsingError,
      );
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
         message: message ?? AppErrors.apiRequestFailed,
         code: code ?? '${AppErrorCodes.apiError}_$statusCode',
       );

  @override
  List<Object?> get props => [...super.props, statusCode];
}

// Custom Failures
final class CustomFailure extends Failure {
  const CustomFailure({required super.message, String? code, super.details})
    : super(code: code ?? AppErrorCodes.customError);
}
