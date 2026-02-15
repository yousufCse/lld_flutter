import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/presentation/widgets/index.dart';
import 'package:niramoy_health_app/core/resources/index.dart';
import 'package:niramoy_health_app/features/registration/presentation/cubit/form/registration_form_cubit.dart';

class NameField extends StatelessWidget {
  const NameField({super.key, required this.cubit});

  final RegistrationFormCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
      buildWhen: (prev, curr) =>
          prev.firstNameError != curr.firstNameError ||
          prev.lastNameError != curr.lastNameError,
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField.name(
                labelText: RegistrationStrings.firstName,
                errorText: state.firstNameError,
                onChanged: cubit.onFirstNameChanged,
              ),
            ),
            const SizedBox(width: AppSizes.space16),
            Expanded(
              child: AppTextField.name(
                labelText: RegistrationStrings.lastName,
                errorText: state.lastNameError,
                onChanged: cubit.onLastNameChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}
