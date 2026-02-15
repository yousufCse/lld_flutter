import 'package:flutter_exercise/core/domain/usecase.dart';
import 'package:flutter_exercise/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@lazySingleton
class LogoutUseCase implements Usecase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Result<void> call(NoParams params) {
    return repository.logout();
  }
}
