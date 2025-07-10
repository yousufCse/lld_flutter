import '../models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';

abstract class DashboardRemoteDataSource {
  Future<UserModel> getCurrentUser();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient client;

  DashboardRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      // Get token from shared preferences
      final token = client.sharedPreferences.getString('access_token');

      if (token == null || token.isEmpty) {
        throw ServerException(message: 'Authorization token not found');
      }

      // Set options with authorization header explicitly
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      // Call the endpoint with explicit authorization
      final response = await client.dio.get(
        '/user/GetCurrentUser',
        options: options,
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Error occurred with status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(message: 'No internet connection');
      } else {
        throw ServerException(message: e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch user data: ${e.toString()}',
      );
    }
  }
}
