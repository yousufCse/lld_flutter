class ErrorConverter {
  map(Object exception) {}

  // try {
  //       final result = await this;
  //       return Right(result);
  //     } on DioException catch (e) {
  //       // Handle Dio-specific errors
  //       if (e.type == DioExceptionType.connectionTimeout ||
  //           e.type == DioExceptionType.connectionError) {
  //         return Left(NetworkFailure(message: 'Connection failed'));
  //       } else if (e.response?.statusCode == 500) {
  //         return Left(ServerFailure(message: 'Server error'));
  //       }
  //       return Left(CustomFailure(e.message ?? 'Unknown error'));
  //     } on ServerException {
  //       return Left(ServerFailure());
  //     } on NetworkException {
  //       return Left(NetworkFailure());
  //     } on CacheException {
  //       return Left(CacheFailure());
  //     } on AuthException {
  //       return Left(AuthFailure());
  //     } on ParsingException {
  //       return Left(ParsingFailure());
  //     } catch (e) {
  //       return Left(CustomFailure(e.toString()));
  //     }
}
