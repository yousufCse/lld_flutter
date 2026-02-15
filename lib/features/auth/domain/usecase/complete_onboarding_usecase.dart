import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';

import '../repositories/auth_repository.dart';

@injectable
class CompleteOnboardingUsecase implements Usecase<void, NoParams> {
  final AuthRepository repository;

  CompleteOnboardingUsecase(this.repository);

  @override
  Result<void> call(NoParams params) async {
    return await repository.completeOnboarding();
  }
}
