import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';

import '../repositories/auth_repository.dart';

@injectable
class LogoutUsecase implements Usecase<bool, NoParams> {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  @override
  Result<bool> call(NoParams params) async {
    return await repository.logout();
  }
}
