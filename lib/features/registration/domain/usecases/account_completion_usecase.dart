import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/account_completion_entity.dart';

import '../repositories/register_repository.dart';

@injectable
class AccountCompletionUsecase
    extends Usecase<AccountCompletionEntity, CompleteRegistrationParams> {
  AccountCompletionUsecase(this.repository);

  final RegisterRepository repository;

  @override
  Result<AccountCompletionEntity> call(CompleteRegistrationParams params) {
    return repository.completeRegistration(params);
  }
}

class CompleteRegistrationParams extends Params {
  CompleteRegistrationParams({
    required this.registrationId,
    this.createNewAccount = true,
  });

  final String registrationId;
  final bool createNewAccount;
}
