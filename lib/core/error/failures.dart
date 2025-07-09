import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String message;

  const ServerFailure({this.message = 'Server Failure'});

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure({this.message = 'Cache Failure'});

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure({this.message = 'Network Failure'});

  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  final String message;

  const UnknownFailure({this.message = 'Unknown Error Occurred'});

  @override
  List<Object?> get props => [message];
}
