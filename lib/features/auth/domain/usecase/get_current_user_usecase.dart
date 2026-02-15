import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';
import 'package:niramoy_health_app/features/auth/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';

@injectable
class GetCurrentUserUsecase extends Usecase<UserEntity, NoParams> {
  GetCurrentUserUsecase({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;

  @override
  Result<UserEntity> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
