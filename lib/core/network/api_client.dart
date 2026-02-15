import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_exercise/core/error/app_exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required Dio dio}) : _dio = dio;

  /// Generic GET request
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Generic POST request
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Generic PUT request
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Generic PATCH request
  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Generic DELETE request
  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// For requests that don't return data (like delete operations)
  Future<void> deleteWithoutResponse({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Upload file with multipart
  Future<T> uploadFile<T>({
    required String endpoint,
    required String filePath,
    required String fileKey,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );

      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Upload multiple files
  Future<T> uploadMultipleFiles<T>({
    required String endpoint,
    required List<String> filePaths,
    required String fileKey,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final files = await Future.wait(
        filePaths.map((path) => MultipartFile.fromFile(path)),
      );

      final formData = FormData.fromMap({fileKey: files, ...?data});

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );

      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  // Download file
  Future<void> downloadFile({
    required String endpoint,
    required String savePath,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Handle Dio errors and throw appropriate exceptions
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Connection timeout. Please try again.');

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.connectionError:
        throw const NetworkException('No internet connection');

      case DioExceptionType.badCertificate:
        throw const ServerException('Certificate verification failed');

      case DioExceptionType.unknown:
      default:
        if (error.message?.contains('SocketException') ?? false) {
          throw const NetworkException('No internet connection');
        }
        throw const ServerException('Unexpected error occurred');
    }
  }

  /// Handle HTTP response errors
  Exception _handleResponseError(Response? response) {
    if (response == null) {
      throw const ServerException('No response from server');
    }

    final errorMessage = _extractErrorMessage(response);

    switch (response.statusCode) {
      case 400:
        throw ApiException(
          message: errorMessage ?? 'Bad request',
          statusCode: 400,
        );
      case 401:
        throw AuthException(
          errorMessage ?? 'Unauthorized. Please login again.',
        );
      case 403:
        throw ApiException(
          message: errorMessage ?? 'Access forbidden',
          statusCode: 403,
        );
      case 404:
        throw ApiException(
          message: errorMessage ?? 'Resource not found',
          statusCode: 404,
        );
      case 422:
        throw ApiException(
          message: errorMessage ?? 'Validation failed',
          statusCode: 422,
        );
      case 500:
        throw ServerException(errorMessage ?? 'Internal server error');
      case 503:
        throw ServerException(errorMessage ?? 'Service unavailable');
      default:
        throw ServerException(
          errorMessage ?? 'Server error: ${response.statusCode}',
        );
    }
  }

  /// Extract error message from response
  String? _extractErrorMessage(Response response) {
    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? data['msg'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
