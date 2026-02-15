import 'package:equatable/equatable.dart';

import '../../../domain/entities/account_verification_entity.dart';

abstract class OtpVerificationState extends Equatable {
  const OtpVerificationState();
}

class OtpVerificationInitial extends OtpVerificationState {
  const OtpVerificationInitial();

  @override
  List<Object?> get props => [];
}

class OtpVerificationLoading extends OtpVerificationState {
  const OtpVerificationLoading();

  @override
  List<Object?> get props => [];
}

class OtpVerificationSuccess extends OtpVerificationState {
  final AccountVerificationEntity verificationEntity;

  const OtpVerificationSuccess(this.verificationEntity);

  @override
  List<Object?> get props => [verificationEntity];
}

class OtpVerificationFailure extends OtpVerificationState {
  final String message;
  final String? code;

  const OtpVerificationFailure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}
