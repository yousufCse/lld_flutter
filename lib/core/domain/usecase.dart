import 'package:equatable/equatable.dart';
import 'package:flutter_exercise/core/utils/type_defs.dart';

abstract class Usecase<T, P extends Params> {
  Result<T> call(final P params);
}

class Params extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoParams extends Params {
  @override
  List<Object?> get props => [];
}
