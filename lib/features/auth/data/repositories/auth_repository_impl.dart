import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:lld_flutter/core/repositories/base_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../models/login_request_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthDataSource authDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.authDataSource,
    required this.tokenStorage,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, Token>> login(LoginRequestModel loginRequest) async {
    return await runWithFailureCapture(() async {
      final tokenModel = await authDataSource.login(loginRequest);

      // Save the token in storage
      await tokenStorage.saveToken(tokenModel);

      // TokenModel already extends Token, so it can be returned directly
      return tokenModel;
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Call API logout if needed
      await authDataSource.logout();

      // Clear tokens from storage
      await tokenStorage.clearToken();

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to logout'));
    }
  }
}
