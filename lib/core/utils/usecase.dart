import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

// Parameters passed to usecases
abstract class Params extends Equatable {
  const Params();
}

// This will be used when a usecase doesn't need any parameters
class NoParams extends Params {
  @override
  List<Object?> get props => [];
}

// Generic usecase class
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
