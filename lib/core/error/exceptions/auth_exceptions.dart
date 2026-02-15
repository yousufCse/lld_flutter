import '../../constants/app_errors.dart';
import 'app_exceptions.dart';

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
