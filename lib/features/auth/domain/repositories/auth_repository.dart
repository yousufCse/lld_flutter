import 'package:niramoy_health_app/core/types/type_defs.dart';

import '../entities/user_entity.dart';
import '../usecase/login_usecase.dart';

abstract class AuthRepository {
  Result<bool> login(LoginParams params);
  Result<bool> logout();
  Result<UserEntity> getCurrentUser();
  Result<bool> isTokenValid();
  Result<bool> refreshToken();
  Result<bool> isFirstTimeLaunch();
  Result<bool> completeOnboarding();
}
