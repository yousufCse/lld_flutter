part of 'otp_form_cubit.dart';

class OtpFormState extends Equatable {
  const OtpFormState({
    required this.otp,
    required this.timerDuration,
    required this.isResendVisible,
    required this.verificationState,
    required this.resendState,
  });

  final String otp;
  final Duration timerDuration;
  final bool isResendVisible;
  final OtpVerificationState verificationState;
  final OtpResendState resendState;

  const OtpFormState.initial()
    : otp = '',
      timerDuration = Duration.zero,
      isResendVisible = false,
      verificationState = const OtpVerificationInitial(),
      resendState = const OtpResendInitial();

  OtpFormState copyWith({
    String? otp,
    Duration? timerDuration,
    bool? isResendVisible,
    OtpVerificationState? verificationState,
    OtpResendState? resendState,
  }) {
    return OtpFormState(
      otp: otp ?? this.otp,
      timerDuration: timerDuration ?? this.timerDuration,
      isResendVisible: isResendVisible ?? this.isResendVisible,
      verificationState: verificationState ?? this.verificationState,
      resendState: resendState ?? this.resendState,
    );
  }

  @override
  List<Object?> get props => [
    otp,
    timerDuration,
    isResendVisible,
    verificationState,
    resendState,
  ];
}
