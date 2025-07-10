import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/login_request_model.dart';
import '../entities/token.dart';

abstract class AuthRepository {
  /// Authenticates a user and returns a token
  Future<Either<Failure, Token>> login(LoginRequestModel loginRequest);

  /// Logs out the user by clearing stored tokens
  Future<Either<Failure, void>> logout();
}
