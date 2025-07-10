import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class DashboardRepository {
  Future<Either<Failure, User>> getCurrentUser();
}
