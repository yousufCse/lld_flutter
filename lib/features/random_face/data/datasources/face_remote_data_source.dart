import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/face_model.dart';

abstract class FaceRemoteDataSource {
  /// Calls the https://randomuser.me/api/ endpoint to get random face data
  ///
  /// Throws a [ServerException] for all error codes
  Future<FaceModel> getRandomFace();
}

@LazySingleton(as: FaceRemoteDataSource)
class FaceRemoteDataSourceImpl implements FaceRemoteDataSource {
  final ApiClient client;

  FaceRemoteDataSourceImpl(this.client);

  @override
  Future<FaceModel> getRandomFace() async {
    final response = await client.get('https://randomuser.me/api/');

    try {
      final results = response['results'] as List;
      if (results.isNotEmpty) {
        final userData = results.first;

        // Create a map that matches our FaceModel structure
        final modelData = {
          'id': userData['login']['uuid'],
          'image_url': userData['picture']['large'],
          'age': userData['dob']['age'],
          'gender': userData['gender'],
        };

        // Use the generated fromJson method
        return FaceModel.fromJson(modelData);
      } else {
        throw ServerException(message: 'No face data found');
      }
    } catch (e) {
      throw ServerException(
        message: 'Failed to parse face data: ${e.toString()}',
      );
    }
  }
}
