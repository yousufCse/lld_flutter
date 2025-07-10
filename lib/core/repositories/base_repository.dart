import 'package:dartz/dartz.dart';
import 'package:lld_flutter/core/error/exceptions.dart';
import 'package:lld_flutter/core/error/failures.dart';
import 'package:lld_flutter/core/network/network_info.dart';

abstract class BaseRepository {
  final NetworkInfo networkInfo;

  BaseRepository({required this.networkInfo});

  Future<Either<Failure, T>> safeRepositoryCall<T>(
    Future<T> Function() apiCall,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await apiCall();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
