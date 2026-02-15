import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/domain/usecase.dart';
import '../../../../core/errors/failures/failures.dart';
import '../entities/auth_status_result.dart';
import '../repositories/auth_repository.dart';

@injectable
class CheckAuthStatusUsecase implements Usecase<AuthStatusResult, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUsecase(this.repository);

  @override
  Future<Either<Failure, AuthStatusResult>> call(NoParams params) async {
    // Simplified logic: just check if first time launch and token validity
    final isFirstTimeResult = await repository.isFirstTimeLaunch();

    return isFirstTimeResult.fold((failure) => Left(failure), (
      isFirstTime,
    ) async {
      if (isFirstTime) {
        return const Right(
          AuthStatusResult(isAuthenticated: false, isFirstTime: true),
        );
      }

      return Right(
        AuthStatusResult(isAuthenticated: false, isFirstTime: false),
      );

      // final isTokenValidResult = await repository.isTokenValid();

      // return isTokenValidResult.fold((failure) => Left(failure), (
      //   isTokenValid,
      // ) {
      //   return Right(
      //     AuthStatusResult(isAuthenticated: isTokenValid, isFirstTime: false),
      //   );
      // });
    });
  }
}
