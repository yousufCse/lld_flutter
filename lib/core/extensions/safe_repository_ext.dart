import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../error/app_exceptions.dart';
import '../error/failures.dart';
import '../utils/type_defs.dart';

extension SafeRepository<T> on Future<T> {
  Result<T> toResult() async {
    try {
      final result = await this;
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      } else if (e.response?.statusCode == 500) {
        return const Left(ServerFailure());
      }
      return const Left(CustomFailure(message: 'Unknown error'));
    } on ServerException {
      return const Left(ServerFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on CacheException {
      return const Left(CacheFailure());
    } on AuthException {
      return const Left(AuthFailure(message: ''));
    } on ParsingException {
      return const Left(ParsingFailure());
    } catch (e) {
      return const Left(CustomFailure(message: 'An unexpected error occurred'));
    }
  }
}
