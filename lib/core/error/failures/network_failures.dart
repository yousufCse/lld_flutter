// Network Related Failures
import '../../constants/app_errors.dart';
import 'failures.dart';

/// Network Failure for connectivity issues
final class NetworkFailure extends Failure {
  const NetworkFailure({String? message, String? code, super.details})
    : super(
        message: message ?? AppErrors.networkConnectionFailed,
        code: code ?? AppErrorCodes.networkError,
      );
}

/// Server Failure for server-side errors
final class ServerFailure extends Failure {
  const ServerFailure({String? message, String? code, super.details})
    : super(
        message: message ?? AppErrors.serverError,
        code: code ?? AppErrorCodes.serverError,
      );
}
