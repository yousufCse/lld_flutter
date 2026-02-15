import '../../constants/app_errors.dart';
import 'app_exceptions.dart';

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
