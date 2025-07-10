import '../error/failures.dart';

/// A utility class for handling failures across the app
class FailureUtils {
  /// Extracts a human-readable message from a Failure object
  static String getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is UnknownFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred';
  }
}
