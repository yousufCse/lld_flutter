import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';

import '../repositories/auth_repository.dart';

@injectable
class LoginUsecase implements Usecase<bool, LoginParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  Result<bool> call(LoginParams params) async {
    return await repository.login(params);
  }
}

class LoginParams extends Params {
  final String patientId;
  final String password;

  LoginParams({required this.patientId, required this.password});
}
