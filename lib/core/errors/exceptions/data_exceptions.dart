import '../../constants/app_errors.dart';
import 'app_exceptions.dart';

/// Exception thrown for cache operations
class CacheException extends AppException {
  const CacheException(
    String message, {
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(message: message, code: code ?? AppErrorCodes.cacheError);

  factory CacheException.readFailed() => const CacheException(
    AppErrors.cacheError,
    code: AppErrorCodes.cacheReadError,
  );

  factory CacheException.writeFailed() => const CacheException(
    AppErrors.cacheWriteError,
    code: AppErrorCodes.cacheWriteError,
  );

  factory CacheException.notFound() => const CacheException(
    AppErrors.cacheDataNotFound,
    code: AppErrorCodes.cacheNotFound,
  );

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when parsing/serialization fails
class ParsingException extends AppException {
  final dynamic data;

  const ParsingException(
    String message, {
    this.data,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(message: message, code: code ?? AppErrorCodes.parsingError);

  factory ParsingException.fromData(dynamic data) =>
      ParsingException(AppErrors.parsingError, data: data);

  @override
  String toString() => 'ParsingException: $message';
}
