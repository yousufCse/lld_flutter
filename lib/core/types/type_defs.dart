import 'package:dartz/dartz.dart';
import '../error/failures/failures.dart';

typedef Result<T> = Future<Either<Failure, T>>;
typedef ResultVoid = Result<void>;
typedef ResultString = Result<String>;

typedef StringCallback = void Function(String);
typedef BooleanCallback = void Function(bool);
