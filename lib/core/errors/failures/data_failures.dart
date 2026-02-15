// Cache Related Failures
import '../../constants/app_errors.dart';
import 'failures.dart';

/// Cache Failure for caching issues
final class CacheFailure extends Failure {
  const CacheFailure({String? message})
    : super(
        message: message ?? AppErrors.cacheOperationFailed,
        code: AppErrorCodes.cacheError,
      );
}

/// Parsing Failure for data parsing issues
final class ParsingFailure extends Failure {
  const ParsingFailure({String? message, super.details})
    : super(
        message: message ?? AppErrors.parsingError,
        code: AppErrorCodes.parsingError,
      );
}
