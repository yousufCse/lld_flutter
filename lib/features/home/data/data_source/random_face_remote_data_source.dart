import 'package:flutter_exercise/core/di/injection_names.dart';
import 'package:flutter_exercise/core/network/api_client.dart';
import 'package:flutter_exercise/features/home/data/model/random_face_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class RandomFaceRemoteDataSource {
  Future<RandomFaceResponseModel> fetchRandomFace();
}

@Injectable(as: RandomFaceRemoteDataSource)
class RandomFaceRemoteDataSourceImpl implements RandomFaceRemoteDataSource {
  RandomFaceRemoteDataSourceImpl(
    @Named(InjectionNames.apiClientBasic) this.apiClient,
  );

  final ApiClient apiClient;

  @override
  Future<RandomFaceResponseModel> fetchRandomFace() async {
    return apiClient.get<RandomFaceResponseModel>(
      endpoint: '',
      fromJson: (json) => RandomFaceResponseModel.fromJson(json),
    );
  }
}
