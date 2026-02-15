import 'package:dartz/dartz.dart';
import 'package:flutter_exercise/core/domain/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/login_request_model.dart';
import '../entities/token_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase implements Usecase<TokenEntity, LoginRequestModel> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, TokenEntity>> call(LoginRequestModel params) {
    return repository.login(params);
  }
}
