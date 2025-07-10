import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user.dart';
import '../repositories/dashboard_repository.dart';

@lazySingleton
class GetCurrentUserUseCase implements UseCase<User, NoParams> {
  final DashboardRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
