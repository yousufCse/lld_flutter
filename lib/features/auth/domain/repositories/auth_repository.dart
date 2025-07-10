import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/token_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, TokenModel>> login(LoginRequestModel loginRequest);
  Future<Either<Failure, void>> logout();
}
