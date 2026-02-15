import 'package:injectable/injectable.dart';

import '../../../../core/domain/usecase.dart';
import '../../../../core/types/type_defs.dart';
import '../repositories/auth_repository.dart';

@injectable
class RefreshTokenUsecase implements Usecase<bool, NoParams> {
  RefreshTokenUsecase(this.repository);

  final AuthRepository repository;

  @override
  Result<bool> call(NoParams params) => repository.refreshToken();
}
