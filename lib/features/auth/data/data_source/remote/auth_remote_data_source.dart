import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/di/injection_names.dart';
import 'package:niramoy_health_app/core/network/api_client.dart';
import 'package:niramoy_health_app/core/network/api_endpoints.dart';
import 'package:niramoy_health_app/features/auth/data/models/login_request/login_request_model.dart';
import 'package:niramoy_health_app/features/auth/data/models/refresh_token_response/refresh_token_response_model.dart';

import '../../../../../core/error/exceptions/index.dart';
import '../../models/login_response/login_response_model.dart';
import '../../models/logout_response/logout_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<bool> validateToken();
  Future<RefreshTokenResponseModel> refreshToken(String refreshToken);
  Future<LogoutResponseModel> logout();
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
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    logger.d('Attempting login ${request.toJson()}');
    return await basicClient.post(
      endpoint: ApiEndpoints.login,
      data: request.toJson(),
      fromJson: (json) {
        logger.d('Login response JSON: $json');
        return LoginResponseModel.fromJson(json);
      },
    );
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
  Future<RefreshTokenResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await basicClient.post(
        endpoint: ApiEndpoints.refreshToken,
        data: json.encode({'refresh_token': refreshToken}),
        fromJson: (json) => RefreshTokenResponseModel.fromJson(json),
      );
      return response;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw NetworkException('Network error occurred');
    }
  }

  @override
  Future<LogoutResponseModel> logout() async {
    try {
      final response = await authClient.post(
        endpoint: ApiEndpoints.logout,
        fromJson: (json) => LogoutResponseModel.fromJson(json),
      );
      return response;
    } catch (e) {
      throw NetworkException('Network error occurred');
    }
  }
}
