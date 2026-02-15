import '../../constants/app_errors.dart';

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
