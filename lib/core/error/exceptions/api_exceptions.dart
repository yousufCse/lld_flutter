import '../../constants/app_errors.dart';
import 'app_exceptions.dart';

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

  factory ApiException.badRequest(
    String message, {
    Map<String, dynamic>? data,
    String? code,
  }) => ApiException(
    message: message,
    statusCode: 400,
    code: AppErrorCodes.badRequest,
    responseData: data,
  );

  factory ApiException.notFound(
    String message, {
    String? code,
    Map<String, dynamic>? data,
  }) => ApiException(
    message: message,
    statusCode: 404,
    code: code ?? AppErrorCodes.notFound,
    responseData: data,
  );

  factory ApiException.conflict(
    String message, {
    String? code,
    Map<String, dynamic>? data,
  }) => ApiException(
    message: message,
    statusCode: 409,
    code: code ?? AppErrorCodes.conflict,
    responseData: data,
  );
  factory ApiException.accountLocked(
    String message, {
    String? code,
    Map<String, dynamic>? data,
  }) => ApiException(
    message: message,
    statusCode: 409,
    code: code ?? AppErrorCodes.accountLocked,
    responseData: data,
  );

  factory ApiException.tooManyRequests(
    String message, {
    String? code,
    Map<String, dynamic>? data,
  }) => ApiException(
    message: message,
    statusCode: 429,
    code: code ?? AppErrorCodes.rateLimitExeeded,
    responseData: data,
  );

  factory ApiException.validationFailed(
    String message, {
    String? code,
    Map<String, dynamic>? data,
  }) => ApiException(
    message: message,
    statusCode: 422,
    code: code ?? AppErrorCodes.validationError,
    responseData: data,
  );

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
