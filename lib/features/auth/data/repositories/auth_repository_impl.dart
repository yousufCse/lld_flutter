import 'package:dartz/dartz.dart';
import 'package:flutter_exercise/core/domain/base_repository.dart';
import 'package:flutter_exercise/core/storage/token/token_storage.dart';
import 'package:flutter_exercise/core/utils/type_defs.dart';
import 'package:flutter_exercise/features/auth/domain/entities/token_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
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
  Result<TokenEntity> login(LoginRequestModel loginRequest) async {
    return await handleException(() async {
      final tokenModel = await authDataSource.login(loginRequest);
      // Save the token in storage
      await tokenStorage.saveToken(tokenModel.toEntity);
      // TokenModel already extends Token, so it can be returned directly
      return tokenModel.toEntity;
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
      return const Left(ServerFailure());
    }
  }
}
