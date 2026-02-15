import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Type definition for API responses that can fail
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Type definition for void API responses that can fail
typedef ResultVoid = Future<Either<Failure, void>>;

/// Type definition for data map (JSON)
typedef DataMap = Map<String, dynamic>;
