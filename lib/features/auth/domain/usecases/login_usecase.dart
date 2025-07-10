import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/token_model.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, TokenModel>> call(
    LoginRequestModel loginRequest,
  ) async {
    return await repository.login(loginRequest);
  }
}
