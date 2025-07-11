import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../res/visual_strings/app_strings.dart';
import '../error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'token_refresh_interceptor.dart';

@lazySingleton
class ApiClient {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  static const String baseUrl = 'https://umrtest.com/DhanvantariAuthApi/api/v1';

  ApiClient(this.dio, this.sharedPreferences) {
    // Set the base URL for the API
    dio.options.baseUrl = baseUrl;

    // Add interceptor for authentication
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sharedPreferences.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // Add token refresh interceptor
    dio.interceptors.add(
      TokenRefreshInterceptor(
        dio: dio,
        sharedPreferences: sharedPreferences,
        baseUrl: baseUrl,
      ),
    );
  }

  Future<dynamic> get(String url) async {
    try {
      final response = await dio.get(url);
      return _processResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(url, data: data);
      return _processResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> put(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.put(url, data: data);
      return _processResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        throw ServerException(message: ErrorStrings.badRequest);
      case 401:
        throw ServerException(message: ErrorStrings.unauthorized);
      case 403:
        throw ServerException(message: ErrorStrings.forbidden);
      case 404:
        throw ServerException(message: ErrorStrings.notFound);
      case 500:
        throw ServerException(message: ErrorStrings.internalServerError);
      default:
        throw ServerException(
          message: '${ErrorStrings.statusCodeError}: ${response.statusCode}',
        );
    }
  }

  void _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      throw NetworkException(message: ErrorStrings.connectionTimeout);
    } else if (error.type == DioExceptionType.connectionError) {
      throw NetworkException(message: ErrorStrings.noInternetConnection);
    } else {
      throw ServerException(
        message: error.message ?? ErrorStrings.unknownError,
      );
    }
  }
}
