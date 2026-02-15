import 'package:dartz/dartz.dart';

import '../app/logger/app_logger.dart';
import '../constants/app_errors.dart';
import '../errors/errors.dart';
import '../network/network_info.dart';
import '../types/type_defs.dart';

/// Base repository for handling exceptions and converting them to failures
abstract class BaseRepository {
  final NetworkInfo networkInfo;
  final AppLogger? logger;

  const BaseRepository({required this.networkInfo, this.logger});

  /// Main exception handler with comprehensive error mapping
  ///
  /// Checks network connectivity first, then executes the operation
  /// and catches all exceptions, converting them to appropriate Failures
  Result<T> handleException<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    // Check network connectivity first
    if (!await networkInfo.isConnected) {
      _logError(
        'Network not connected${operationName != null ? ' - $operationName' : ''}',
      );
      return const Left(NetworkFailure(message: AppErrors.noInternet));
    }

    try {
      final result = await operation();
      _logSuccess(operationName);
      return Right(result);
    } on NetworkException catch (e, stackTrace) {
      return Left(_mapNetworkException(e, stackTrace));
    } on AuthException catch (e, stackTrace) {
      return Left(_mapAuthException(e, stackTrace));
    } on ServerException catch (e, stackTrace) {
      return Left(_mapServerException(e, stackTrace));
    } on ApiException catch (e, stackTrace) {
      return Left(_mapApiException(e, stackTrace));
    } on ParsingException catch (e, stackTrace) {
      return Left(_mapParsingException(e, stackTrace));
    } on CacheException catch (e, stackTrace) {
      return Left(_mapCacheException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(_mapCustomException(e, stackTrace));
    }
  }

  // ==================== Exception Mappers ====================

  Failure _mapNetworkException(NetworkException e, StackTrace stackTrace) {
    _logError('NetworkException: ${e.message}', e, stackTrace);
    return NetworkFailure(message: e.message, code: e.code);
  }

  Failure _mapAuthException(AuthException e, StackTrace stackTrace) {
    _logError('AuthException: ${e.message}', e, stackTrace);
    return AuthFailure(message: e.message, code: e.code);
  }

  Failure _mapServerException(ServerException e, StackTrace stackTrace) {
    _logError('ServerException: ${e.message}', e, stackTrace);
    return ServerFailure(message: e.message, code: e.code);
  }

  Failure _mapApiException(ApiException e, StackTrace stackTrace) {
    _logError(
      'ApiException: ${e.message} (Status: ${e.statusCode})',
      e,
      stackTrace,
    );
    return ApiFailure(
      statusCode: e.statusCode,
      message: e.message,
      code: e.code,
      details: e.responseData,
    );
  }

  Failure _mapParsingException(ParsingException e, StackTrace stackTrace) {
    _logError('ParsingException: ${e.message}', e, stackTrace);
    return ParsingFailure(
      message: e.message,
      details: e.data != null ? {'data': e.data} : null,
    );
  }

  Failure _mapCacheException(CacheException e, StackTrace stackTrace) {
    _logError('CacheException: ${e.message}', e, stackTrace);
    return CacheFailure(message: e.message);
  }

  Failure _mapCustomException(Object e, StackTrace stackTrace) {
    _logError('CustomException: $e', e, stackTrace);
    return CustomFailure(message: e.toString(), code: 'UNKNOWN_ERROR');
  }

  // ==================== Logging ====================

  void _logError(String message, [Object? error, StackTrace? stackTrace]) {
    logger?.e(message, error, stackTrace);
  }

  void _logSuccess(String? operationName) {
    if (operationName != null) {
      logger?.i('$operationName - Operation successful');
    } else {
      logger?.i('Operation successful');
    }
  }
}
