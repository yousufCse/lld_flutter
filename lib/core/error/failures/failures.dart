import 'package:equatable/equatable.dart';

import '../../constants/app_errors.dart';

/// Base failure class with equality comparison
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({required this.message, this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

/// All other custom failure
final class CustomFailure extends Failure {
  const CustomFailure({required super.message, String? code, super.details})
    : super(code: code ?? AppErrorCodes.customError);
}
