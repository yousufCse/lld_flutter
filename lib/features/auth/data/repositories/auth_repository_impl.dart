import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../models/login_request_model.dart';
import '../models/token_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(this.authDataSource, this.networkInfo);

  @override
  Future<Either<Failure, TokenModel>> login(
    LoginRequestModel loginRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final tokenModel = await authDataSource.login(loginRequest);
        return Right(tokenModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to logout'));
    }
  }
}
