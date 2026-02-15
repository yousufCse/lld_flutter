import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/presentation/widgets/index.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';
import 'package:niramoy_health_app/core/resources/strings/app_strings.dart';
import 'package:niramoy_health_app/features/registration/presentation/cubit/otp_form/otp_form_cubit.dart';

import '../../cubit/otp_form/otp_verification_state.dart';
import 'form/index.dart';

class OtpContent extends StatelessWidget {
  const OtpContent({super.key, required this.onVerify, required this.onResend});

  final VoidCallback onVerify;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.contentPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OtpTitle(),
          Gap.vertical(AppSizes.space16),
          OtpInstruction(),
          Gap.vertical(AppSizes.space24),
          OtpField(),
          Gap.vertical(AppSizes.space24),
          _buildResendButton(),
          Gap.vertical(AppSizes.space24),
          _buildVerifyButton(),
          Gap.vertical(AppSizes.space16),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return BlocBuilder<OtpFormCubit, OtpFormState>(
      builder: (context, state) {
        return AppButton.filled(
          title: AppStrings.verify,
          onPressed: onVerify,
          isLoading: state.verificationState is OtpVerificationLoading,
        );
      },
    );
  }

  Widget _buildResendButton() {
    return BlocBuilder<OtpFormCubit, OtpFormState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isResendVisible,
          child: AppButton.text(title: AppStrings.resend, onPressed: onResend),
        );
      },
    );
  }
}
