import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/extensions/context_extensions.dart';
import 'package:niramoy_health_app/core/presentation/widgets/widgets.dart';
import 'package:niramoy_health_app/features/registration/domain/usecases/otp_resend_usecase.dart';

import '../../../domain/entities/account_completion_entity.dart';
import '../../../domain/entities/account_verification_entity.dart';
import '../../cubit/otp_form/otp_form_cubit.dart';
import '../../cubit/otp_form/otp_verification_state.dart';
import '../../widgets/otp/otp_content.dart';
import '../account_list/account_list_route.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.registrationId});

  final String registrationId;

  void onVerify(BuildContext context) {
    context.dismissKeyboard();
    context.read<OtpFormCubit>().onVerify(registrationId);
  }

  // TODO: Pass real otpReference and phone from route extras.
  void onResend(BuildContext context) {
    context.read<OtpFormCubit>().onResend(
      OtpResendParams(otpReference: '', phone: '', purpose: 'REGISTRATION'),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.i('OTP Screen build: with registrationId: $registrationId');
    return Scaffold(
      appBar: AppBar(leading: LeadingBack()),
      body: BlocListener<OtpFormCubit, OtpFormState>(
        listenWhen: (previous, current) =>
            previous.verificationState != current.verificationState,
        listener: _handleVerificationListener,
        child: OtpContent(
          onVerify: () => onVerify(context),
          onResend: () => onResend(context),
        ),
      ),
    );
  }

  void _handleVerificationListener(BuildContext context, OtpFormState state) {
    if (state.verificationState is OtpVerificationSuccess) {
      final entity = (state.verificationState as OtpVerificationSuccess)
          .verificationEntity;
      _handleVerificationSuccess(context, entity);
    } else if (state.verificationState is OtpVerificationFailure) {
      final failure = (state.verificationState as OtpVerificationFailure);
      _handleVerificationFailure(context, failure.code ?? '', failure.message);
    }
  }

  void _handleVerificationSuccess(
    BuildContext context,
    AccountVerificationEntity entity,
  ) {
    switch (entity.action) {
      case VerificationAction.choose:
        _navigateToAccountList(context, entity.existingAccounts);
        break;
      case VerificationAction.completed:
        _navigateToRegistrationSuccess(context, entity.completion!);
        break;
    }
  }

  void _navigateToAccountList(
    BuildContext context,
    List<ExistingAccount> accounts,
  ) {
    context.go(
      RouteNames.accountList,
      extra: AccountListExtras(
        existingAccounts: accounts,
        registrationId: registrationId,
      ),
    );
  }

  void _navigateToRegistrationSuccess(
    BuildContext context,
    AccountCompletionEntity completion,
  ) {
    context.go(RouteNames.registrationSuccess, extra: completion);
  }

  void _handleVerificationFailure(
    BuildContext context,
    String code,
    String message,
  ) {
    AppDialog.alert(
      context,
      title: code,
      message: message,
      variant: DialogVariant.error,
    );
  }
}
