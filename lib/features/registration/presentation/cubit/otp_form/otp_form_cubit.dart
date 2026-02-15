import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/otp_verify_usecase.dart';
import 'package:niramoy_health_app/features/registration/presentation/cubit/otp_form/otp_resend_state.dart';

import '../../../domain/usecases/otp_resend_usecase.dart';
import 'otp_verification_state.dart';

part 'otp_form_state.dart';

const _otpTimeoutDuration = Duration(minutes: 1);
const _otpInterval = Duration(seconds: 1);

@injectable
class OtpFormCubit extends Cubit<OtpFormState> {
  OtpFormCubit(this._otpVerifyUsecase, this._otpResendUsecase)
    : super(OtpFormState.initial()) {
    _startTimer();
  }

  final OtpVerifyUsecase _otpVerifyUsecase;
  final OtpResendUsecase _otpResendUsecase;
  Timer? _timer;

  void onOtpChanged(String value) {
    emit(state.copyWith(otp: value));
  }

  Future<void> onVerify(String registrationId) async {
    emit(state.copyWith(verificationState: const OtpVerificationLoading()));

    final result = await _otpVerifyUsecase.call(
      OtpVerifyParams(registrationId: registrationId, otp: state.otp),
    );

    result.fold(
      (failure) {
        logger.e('OTP verification failed');
        emit(
          state.copyWith(
            verificationState: OtpVerificationFailure(
              failure.message,
              code: failure.code,
            ),
          ),
        );
      },
      (verificationEntity) {
        logger.i('OTP verification successful');
        emit(
          state.copyWith(
            verificationState: OtpVerificationSuccess(verificationEntity),
          ),
        );
      },
    );
  }

  // TODO: Pass real OtpResendParams from the screen (requires passing
  // otpReference and phone through the OTP route).
  Future<void> onResend(OtpResendParams params) async {
    _startTimer();

    emit(state.copyWith(resendState: const OtpResendLoading()));
    final result = await _otpResendUsecase.call(params);
    result.fold(
      (failure) {
        emit(state.copyWith(resendState: OtpResendFailure(failure.toString())));
      },
      (entity) {
        emit(state.copyWith(resendState: const OtpResendSuccess()));
      },
    );
  }

  void _startTimer() {
    emit(
      state.copyWith(
        timerDuration: _otpTimeoutDuration,
        isResendVisible: false,
      ),
    );

    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(_otpInterval, (timer) {
        final newDuration = state.timerDuration - _otpInterval;
        if (newDuration.isNegative) {
          timer.cancel();
          emit(state.copyWith(isResendVisible: true));
        } else {
          emit(state.copyWith(timerDuration: newDuration));
        }
      });
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
