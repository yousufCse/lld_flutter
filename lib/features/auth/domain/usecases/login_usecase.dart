import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../../data/models/login_request_model.dart';
import '../entities/token.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase implements UseCase<Token, LoginRequestModel> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, Token>> call(LoginRequestModel params) {
    return repository.login(params);
  }
}
