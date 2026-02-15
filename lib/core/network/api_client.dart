import 'dart:async';

import 'package:dio/dio.dart';

import '../app/logger/console_app_logger.dart';
import '../constants/app_errors.dart';
import '../errors/errors.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required Dio dio}) : _dio = dio;

  /// Generic GET request
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) => _execute(() async {
    final response = await _dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );
    return _parseResponse(response.data, fromJson);
  });

  /// Generic POST request
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) => _execute(() async {
    final response = await _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _parseResponse(response.data, fromJson);
  });

  /// Generic PUT request
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) => _execute(() async {
    final response = await _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _parseResponse(response.data, fromJson);
  });

  /// Generic PATCH request
  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic json) fromJson,
  }) => _execute(() async {
    final response = await _dio.patch(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return _parseResponse(response.data, fromJson);
  });

  /// Generic DELETE request
  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) => _execute(() async {
    final response = await _dio.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _parseResponse(response.data, fromJson);
  });

  /// For requests that don't return data (like delete operations)
  Future<void> deleteWithoutResponse({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _execute(() async {
    await _dio.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  });

  /// Upload file with multipart
  Future<T> uploadFile<T>({
    required String endpoint,
    required String filePath,
    required String fileKey,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    required T Function(dynamic json) fromJson,
  }) => _execute(() async {
    final formData = FormData.fromMap({
      fileKey: await MultipartFile.fromFile(filePath),
      ...?data,
    });

    final response = await _dio.post(
      endpoint,
      data: formData,
      onSendProgress: onSendProgress,
    );

    return _parseResponse(response.data, fromJson);
  });

  /// Upload multiple files
  Future<T> uploadMultipleFiles<T>({
    required String endpoint,
    required List<String> filePaths,
    required String fileKey,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    required T Function(dynamic json) fromJson,
  }) => _execute(() async {
    final files = await Future.wait(
      filePaths.map((path) => MultipartFile.fromFile(path)),
    );

    final formData = FormData.fromMap({fileKey: files, ...?data});

    final response = await _dio.post(
      endpoint,
      data: formData,
      onSendProgress: onSendProgress,
    );

    return _parseResponse(response.data, fromJson);
  });

  /// Download file
  Future<void> downloadFile({
    required String endpoint,
    required String savePath,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) => _execute(() async {
    await _dio.download(
      endpoint,
      savePath,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
    );
  });

  // ==================== Helper Methods ====================

  /// Centralized error handling wrapper for all API operations.
  Future<T> _execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw CustomException(
        AppErrors.unknownError,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Parse response data with error handling
  T _parseResponse<T>(dynamic data, T Function(dynamic json) fromJson) {
    try {
      return fromJson(data);
    } catch (e, stackTrace) {
      throw ParsingException(
        AppErrors.parsingError,
        data: data,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Handle Dio errors and throw appropriate exceptions
  Never _handleDioError(DioException error) {
    logger.e('DioException: ${error.message}', error, error.stackTrace);
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(
          AppErrors.timeout,
          code: AppErrorCodes.timeout,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.badResponse:
        throw _handleResponseError(error.response);

      case DioExceptionType.connectionError:
        throw NetworkException(
          AppErrors.noInternet,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.badCertificate:
        throw ServerException(
          AppErrors.serverError,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.cancel:
        throw CustomException(
          AppErrors.requestCancelled,
          code: AppErrorCodes.customError,
          originalError: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          throw NetworkException(
            AppErrors.noInternet,
            originalError: error,
            stackTrace: error.stackTrace,
          );
        }
        throw ServerException(
          AppErrors.unknownError,
          originalError: error,
          stackTrace: error.stackTrace,
        );
    }
  }

  /// Handle HTTP response errors
  AppException _handleResponseError(Response? response) {
    if (response == null) {
      return const ServerException(AppErrors.serverError);
    }

    final error = _extractField(response, 'error');
    final message = _extractField(response, 'message');

    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>?
        : null;
    logger.e(
      '_handleResponseError: ${response.statusCode} - $message',
      null,
      StackTrace.current,
    );
    switch (response.statusCode) {
      case 400:
        return ApiException.badRequest(
          message ?? AppErrors.apiRequestFailed,
          code: error,
          data: data,
        );

      case 401:
        return AuthException.unauthorized();

      case 403:
        return AuthException(message ?? AppErrors.unauthorized, code: error);

      case 404:
        return ApiException.notFound(
          message ?? AppErrors.notFound,
          code: error,
          data: data,
        );

      case 422:
        return ApiException.validationFailed(
          message ?? AppErrors.requiredField,
          data: data,
          code: error,
        );

      case 429:
        return ApiException.tooManyRequests(
          message ?? AppErrors.tryAgain,
          data: data,
          code: error,
        );

      case 500:
        return ServerException(
          message ?? AppErrors.serverError,
          statusCode: 500,
        );

      case 502:
        return ServerException(
          message ?? AppErrors.badGateway,
          statusCode: 502,
        );

      case 503:
        return ServerException(
          message ?? AppErrors.serviceUnavailable,
          statusCode: 503,
        );

      case 504:
        return ServerException(message ?? AppErrors.timeout, statusCode: 504);

      default:
        return ServerException(
          message ?? AppErrors.serverError,
          statusCode: response.statusCode,
        );
    }
  }

  /// Extract a field value from response data
  String? _extractField(Response response, String key) {
    try {
      if (response.data is Map<String, dynamic>) {
        return response.data[key] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
