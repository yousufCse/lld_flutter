import 'package:injectable/injectable.dart';
import 'package:lld_flutter/core/constants/api_endpoints.dart';

import '../../../../core/data/base_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/token_model.dart';

abstract class AuthDataSource {
  Future<TokenModel> login(LoginRequestModel loginRequest);
  Future<void> logout();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl extends BaseRemoteDataSource
    implements AuthDataSource {
  AuthDataSourceImpl(super.apiClient);

  @override
  Future<TokenModel> login(LoginRequestModel loginRequest) async {
    return safeApiCall(() async {
      final response = await client.post(
        ApiEndpoints.login,
        data: loginRequest.toJson(),
      );

      final tokenModel = TokenModel.fromJson(response);
      return tokenModel;
    });
  }

  @override
  Future<void> logout() async {
    // Just perform a logout API call if needed
    // Token clearing will be handled by the repository
    return safeApiCall(() async {
      // If there's an actual logout endpoint, call it here
      // await client.post('/auth/logout');
      return;
    });
  }
}
