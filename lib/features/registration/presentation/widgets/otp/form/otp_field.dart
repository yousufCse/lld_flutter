import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/presentation/widgets/index.dart';
import 'package:niramoy_health_app/core/resources/index.dart';

import '../../../cubit/otp_form/otp_form_cubit.dart';

class OtpField extends StatelessWidget {
  const OtpField({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTextField.otp(
      labelText: AppStrings.otpLabel,
      hintText: AppStrings.otpHint,
      onChanged: (value) {
        context.read<OtpFormCubit>().onOtpChanged(value);
      },
    );
  }
}
