import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/token_model.dart';
import '../../../dashboard/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<TokenModel> login(LoginRequestModel loginRequest);
  Future<UserModel> getCurrentUser();
  Future<void> logout();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthDataSourceImpl(this.apiClient, this.sharedPreferences);

  @override
  Future<TokenModel> login(LoginRequestModel loginRequest) async {
    final response = await apiClient.post(
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
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get('/User/GetCurrentUser');
    return UserModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove('access_token');
    await sharedPreferences.remove('refresh_token');
  }
}
