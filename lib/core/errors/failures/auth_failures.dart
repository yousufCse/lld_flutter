// Authentication Failures
import '../../constants/app_errors.dart';
import 'failures.dart';

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
