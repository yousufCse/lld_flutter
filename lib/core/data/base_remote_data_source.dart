import 'package:dio/dio.dart';
import '../../res/visual_strings/app_strings.dart';
import '../error/exceptions.dart';
import '../network/api_client.dart';

/// Base class for remote data sources to eliminate code duplication
abstract class BaseRemoteDataSource {
  final ApiClient client;

  BaseRemoteDataSource(this.client);

  /// Helper method to safely execute API calls with standardized error handling
  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(message: ErrorStrings.connectionTimeout);
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(message: ErrorStrings.noInternetConnection);
      } else {
        throw ServerException(message: e.message ?? ErrorStrings.unknownError);
      }
    } catch (e) {
      throw ServerException(
        message: '${ErrorStrings.failedToFetchData}: ${e.toString()}',
      );
    }
  }

  /// Helper method for GET requests with JSON parsing
  Future<T> getRequest<T>(
    String endpoint,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final response = await client.dio.get(endpoint);

    if (response.statusCode == 200 && response.data != null) {
      return fromJson(response.data);
    } else {
      throw ServerException(
        message: '${ErrorStrings.statusCodeError}: ${response.statusCode}',
      );
    }
  }

  /// Helper method for POST requests with JSON parsing
  Future<T> postRequest<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final response = await client.dio.post(endpoint, data: data);

    if (response.statusCode == 200 && response.data != null) {
      return fromJson(response.data);
    } else {
      throw ServerException(
        message: '${ErrorStrings.statusCodeError}: ${response.statusCode}',
      );
    }
  }

  /// Helper method for PUT requests with JSON parsing
  Future<T> putRequest<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final response = await client.dio.put(endpoint, data: data);

    if (response.statusCode == 200 && response.data != null) {
      return fromJson(response.data);
    } else {
      throw ServerException(
        message: '${ErrorStrings.statusCodeError}: ${response.statusCode}',
      );
    }
  }

  /// Helper method for DELETE requests with JSON parsing
  Future<T> deleteRequest<T>(
    String endpoint,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final response = await client.dio.delete(endpoint);

    if (response.statusCode == 200 && response.data != null) {
      return fromJson(response.data);
    } else {
      throw ServerException(
        message: '${ErrorStrings.statusCodeError}: ${response.statusCode}',
      );
    }
  }
}
