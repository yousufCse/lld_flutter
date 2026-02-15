import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import 'package:niramoy_health_app/core/types/type_defs.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/register_entity.dart';

import '../repositories/register_repository.dart';

@injectable
class RegisterInitiateUsecase extends Usecase<RegisterEntity, RegisterParams> {
  RegisterInitiateUsecase({required this.repository});

  final RegisterRepository repository;

  @override
  Result<RegisterEntity> call(RegisterParams params) =>
      repository.registerInitiate(params);
}

class RegisterParams extends Params {
  final String firstName;
  final String lastName;
  final String phone;
  final String? dateOfBirth; // This could be in 'YYYY-MM-DD' format
  final String gender;
  final bool termsAccepted;

  RegisterParams({
    required this.phone,
    required this.gender,
    required this.termsAccepted,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
  });
}
