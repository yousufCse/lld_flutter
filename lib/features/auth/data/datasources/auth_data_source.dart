import 'package:flutter_exercise/core/di/injection_names.dart';
import 'package:flutter_exercise/core/network/api_client.dart';
import 'package:injectable/injectable.dart';

import '../models/login_request_model.dart';
import '../models/token_model.dart';

abstract class AuthDataSource {
  Future<TokenModel> login(LoginRequestModel loginRequest);
  Future<void> logout();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({
    @Named(InjectionNames.apiClientBasic) required this.client,
  });

  final ApiClient client;

  @override
  Future<TokenModel> login(LoginRequestModel loginRequest) async {
    final tokenModel = client.get(
      endpoint: '//',
      fromJson: (json) {
        final tokenModel = TokenModel.fromJson(json);
        return tokenModel;
      },
    );
    return tokenModel;
  }

  @override
  Future<void> logout() async {
    // Just perform a logout API call if needed
    // Token clearing will be handled by the repository

    // If there's an actual logout endpoint, call it here
    // await client.post('/auth/logout');
    return;
  }
}
