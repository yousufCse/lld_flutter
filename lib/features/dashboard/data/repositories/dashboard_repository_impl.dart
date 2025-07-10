import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:lld_flutter/core/repositories/base_repository.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl extends BaseRepository
    implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return await safeApiCall(() async {
      final result = await remoteDataSource.getCurrentUser();
      return result;
    });
  }
}
