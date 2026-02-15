import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/di/injection_names.dart';
import 'package:niramoy_health_app/core/error/app_exceptions.dart';
import 'package:niramoy_health_app/core/network/api_client.dart';
import 'package:niramoy_health_app/core/network/api_endpoints.dart';
import 'package:niramoy_health_app/features/auth/data/models/login_request_model.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequestModel request);
  Future<UserModel> getCurrentUser();
  Future<bool> validateToken();
  Future<String> refreshToken(String refreshToken);
  Future<bool> logout();
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient basicClient;
  final ApiClient authClient;

  AuthRemoteDataSourceImpl({
    @Named(InjectionNames.apiClientBasic) required this.basicClient,
    @Named(InjectionNames.apiClientAuth) required this.authClient,
  });

  @override
  Future<LoginResponse> login(LoginRequestModel request) async {
    final loginResponse = await basicClient.post(
      endpoint: ApiEndpoints.login,
      data: json.encode(request.toJson()),
      fromJson: (json) {
        logger.i('LoginResponse fromJson called with: $json');
        return LoginResponse.fromJson(json);
      },
    );
    if (loginResponse.token.isEmpty) {
      throw AuthException('Login failed: Empty token received');
    }
    logger.w('LoginResponse received: ${loginResponse.toString()}');

    return loginResponse;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await authClient.get(
      endpoint: ApiEndpoints.getCurrentUser,
      fromJson: (json) => UserModel.fromJson(json),
    );

    return response;
  }

  @override
  Future<bool> validateToken() async {
    final response = await authClient.get(
      endpoint: '/auth/validate',
      fromJson: (json) => json,
    );
    return response.statusCode == 200;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await authClient.post(
        endpoint: '/auth/refresh',
        data: json.encode({'refresh_token': refreshToken}),
        fromJson: (json) => json,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'];
      } else {
        throw AuthException('Failed to refresh token');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw NetworkException('Network error occurred');
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final response = await authClient.post(
        endpoint: ApiEndpoints.logout,
        data: json.encode({'token': ''}),
        fromJson: (json) => json,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw NetworkException('Network error occurred');
    }
  }
}
