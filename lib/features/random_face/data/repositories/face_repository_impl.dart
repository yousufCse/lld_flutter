import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/face.dart';
import '../../domain/repositories/face_repository.dart';
import '../datasources/face_remote_data_source.dart';

@LazySingleton(as: FaceRepository)
class FaceRepositoryImpl implements FaceRepository {
  final FaceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FaceRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, Face>> getRandomFace() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFace = await remoteDataSource.getRandomFace();
        return Right(remoteFace);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    }
  }
}
