import 'package:flutter_exercise/core/domain/base_repository.dart';
import 'package:flutter_exercise/core/utils/type_defs.dart';
import 'package:flutter_exercise/features/home/data/data_source/random_face_remote_data_source.dart';
import 'package:flutter_exercise/features/home/domain/entity/random_face_entity.dart';
import 'package:flutter_exercise/features/home/domain/repository/random_face_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RandomFaceRepository)
class RandomFaceRepositoryImpl extends BaseRepository
    implements RandomFaceRepository {
  final RandomFaceRemoteDataSource remoteDataSource;

  RandomFaceRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Result<RandomFaceEntity> fetchRandomFace() async {
    return handleException(() async {
      final responseModel = await remoteDataSource.fetchRandomFace();
      return responseModel.results.first.toEntity();
    });
  }

  // @override
  // Result<RandomFaceEntity> fetchRandomFace() {
  //   return remoteDataSource
  //       .fetchRandomFace()
  //       .then((responseModel) => responseModel.results.first.toEntity())
  //       .toResult();
  // }
}
