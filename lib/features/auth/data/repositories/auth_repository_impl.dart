import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:lld_flutter/core/repositories/base_repository.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../models/login_request_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({
    required this.authDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, Token>> login(LoginRequestModel loginRequest) async {
    return await runWithFailureCapture(() async {
      final result = await authDataSource.login(loginRequest);
      // TokenModel already extends Token, so it can be returned directly
      return result;
    });
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
