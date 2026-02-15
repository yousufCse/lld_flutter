import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/base_repository.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';
import 'package:niramoy_health_app/features/auth/data/models/login_request/login_request_model.dart';
import 'package:niramoy_health_app/features/auth/domain/usecase/login_usecase.dart';

import '../../../../core/errors/errors.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/local/auth_local_data_source.dart';
import '../data_source/remote/auth_remote_data_source.dart';
import '../models/login_response/login_response_model.dart' as login_response;
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required super.networkInfo,
  });

  @override
  Result<bool> login(LoginParams params) {
    return handleException(() async {
      final response = await remoteDataSource.login(
        LoginRequestModel(
          patientId: params.patientId,
          password: params.password,
        ),
      );

      await localDataSource.cacheTokens(
        response.data.tokens.accessToken,
        response.data.tokens.refreshToken,
      );
      await localDataSource.cacheUser(_convertToUserModel(response.data.user));
      return response.success;
    });
  }

  @override
  Result<bool> logout() {
    return handleException(() async {
      await localDataSource.clearCache();
      final response = await remoteDataSource.logout();
      return response.success;
    });
  }

  @override
  Result<bool> isTokenValid() async {
    try {
      final token = await localDataSource.getCachedToken();
      if (token == null) {
        return const Right(false);
      }

      final isValid = await remoteDataSource.validateToken();
      return Right(isValid);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Result<bool> refreshToken() {
    return handleException(() async {
      final refreshToken = await localDataSource.getCachedRefreshToken();
      if (refreshToken == null) {
        throw AuthException('No refresh token found');
      }

      final responseModel = await remoteDataSource.refreshToken(refreshToken);
      await localDataSource.cacheTokens(
        responseModel.data.tokens.accessToken,
        responseModel.data.tokens.refreshToken,
      );
      return responseModel.success;
    });
  }

  @override
  Result<bool> isFirstTimeLaunch() {
    return handleException(() async {
      final isFirstTime = await localDataSource.isFirstTimeLaunch();
      return isFirstTime;
    });
  }

  @override
  Result<bool> completeOnboarding() {
    return handleException(() async {
      await localDataSource.setFirstTimeLaunchComplete();
      return true;
    });
  }

  @override
  Result<UserEntity> getCurrentUser() {
    return handleException(() async {
      final user = await localDataSource.getCachedUser();
      if (user == null) {
        throw AuthException('No user found in cache');
      }
      return user.toEntity();
    });
  }

  /// Converts login response UserModel to the correct UserModel for caching
  UserModel _convertToUserModel(login_response.UserModel loginUser) {
    // Split name into firstName and lastName
    final nameParts = loginUser.name.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return UserModel(
      id: loginUser.id,
      firstName: firstName,
      lastName: lastName,
      mobile: loginUser.phone,
      email: null, // Not available in login response
      dateOfBirth: null, // Not available in login response
      gender: loginUser.gender,
      profession: null, // Not available in login response
      relationship: null, // Not available in login response
      bloodGroup: null, // Not available in login response
      umrIdJson: loginUser.patientId,
    );
  }
}
