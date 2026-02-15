import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/presentation/widgets/app_text_field.dart';
import 'package:niramoy_health_app/core/resources/resources.dart';
import 'package:niramoy_health_app/features/registration/presentation/cubit/form/registration_form_cubit.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({super.key, required this.cubit});

  final RegistrationFormCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
      buildWhen: (prev, curr) => prev.mobileError != curr.mobileError,
      builder: (context, state) {
        return AppTextField.phone(
          labelText: RegistrationStrings.mobile,
          hintText: RegistrationStrings.mobileHint,
          maxLength: 14,
          errorText: state.mobileError,
          onChanged: cubit.onMobileChanged,
        );
      },
    );
  }
}
