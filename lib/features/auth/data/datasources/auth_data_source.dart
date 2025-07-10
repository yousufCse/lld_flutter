import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/data/base_remote_data_source.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/token_model.dart';

abstract class AuthDataSource {
  Future<TokenModel> login(LoginRequestModel loginRequest);
  Future<void> logout();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl extends BaseRemoteDataSource
    implements AuthDataSource {
  final SharedPreferences sharedPreferences;

  AuthDataSourceImpl(ApiClient apiClient, this.sharedPreferences)
    : super(apiClient);

  @override
  Future<TokenModel> login(LoginRequestModel loginRequest) async {
    return safeApiCall(() async {
      final response = await client.post(
        '/auth/login',
        data: loginRequest.toJson(),
      );

      final tokenModel = TokenModel.fromJson(response);

      // Save token to shared preferences
      if (tokenModel.accessToken != null) {
        await sharedPreferences.setString(
          'access_token',
          tokenModel.accessToken!,
        );
      }
      if (tokenModel.refreshToken != null) {
        await sharedPreferences.setString(
          'refresh_token',
          tokenModel.refreshToken!,
        );
      }

      return tokenModel;
    });
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove('access_token');
    await sharedPreferences.remove('refresh_token');
  }
}
