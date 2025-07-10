import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';
import '../repositories/dashboard_repository.dart';

@lazySingleton
class GetCurrentUserUseCase {
  final DashboardRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserModel>> call() async {
    return await repository.getCurrentUser();
  }
}
