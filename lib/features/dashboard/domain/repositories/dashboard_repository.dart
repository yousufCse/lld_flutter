import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, UserModel>> getCurrentUser();
}
