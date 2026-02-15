// API Failures
import '../../constants/app_errors.dart';
import 'failures.dart';

final class ApiFailure extends Failure {
  final int statusCode;

  const ApiFailure({
    required this.statusCode,
    String? message,
    String? code,
    super.details,
  }) : super(
         message: message ?? AppErrors.apiRequestFailed,
         code: code ?? '${AppErrorCodes.apiError}_$statusCode',
       );

  @override
  List<Object?> get props => [...super.props, statusCode];
}
