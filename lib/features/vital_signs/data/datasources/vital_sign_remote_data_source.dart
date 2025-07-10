import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/vital_sign_model.dart';

abstract class VitalSignRemoteDataSource {
  Future<VitalSignModel> getLatestVitalSign(String userId);
}

@LazySingleton(as: VitalSignRemoteDataSource)
class VitalSignRemoteDataSourceImpl implements VitalSignRemoteDataSource {
  final ApiClient client;

  VitalSignRemoteDataSourceImpl(this.client);

  @override
  Future<VitalSignModel> getLatestVitalSign(String userId) async {
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
        '/VitalSign/GetLatestVitalSign/$userId',
        options: options,
      );

      if (response.statusCode == 200 && response.data != null) {
        return VitalSignModel.fromJson(response.data);
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
        message: 'Failed to fetch vital sign data: ${e.toString()}',
      );
    }
  }
}
