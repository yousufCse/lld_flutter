import 'package:equatable/equatable.dart';

abstract class OtpResendState extends Equatable {
  const OtpResendState();
}

class OtpResendInitial extends OtpResendState {
  const OtpResendInitial();

  @override
  List<Object?> get props => [];
}

class OtpResendLoading extends OtpResendState {
  const OtpResendLoading();

  @override
  List<Object?> get props => [];
}

class OtpResendSuccess extends OtpResendState {
  const OtpResendSuccess();

  @override
  List<Object?> get props => [];
}

class OtpResendFailure extends OtpResendState {
  final String message;
  final String? code;

  const OtpResendFailure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}
