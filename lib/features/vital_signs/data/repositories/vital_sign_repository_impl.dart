import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:lld_flutter/core/repositories/base_repository.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/vital_sign.dart';
import '../../domain/repositories/vital_sign_repository.dart';
import '../datasources/vital_sign_remote_data_source.dart';

@LazySingleton(as: VitalSignRepository)
class VitalSignRepositoryImpl extends BaseRepository
    implements VitalSignRepository {
  final VitalSignRemoteDataSource remoteDataSource;

  VitalSignRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, VitalSign>> getLatestVitalSign(String userId) async {
    return await safeApiCall(() async {
      final result = await remoteDataSource.getLatestVitalSign(userId);
      return result;
    });
  }
}
