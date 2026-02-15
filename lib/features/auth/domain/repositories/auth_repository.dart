import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/login_request_model.dart';
import '../entities/token_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, TokenEntity>> login(LoginRequestModel loginRequest);

  Future<Either<Failure, void>> logout();
}
