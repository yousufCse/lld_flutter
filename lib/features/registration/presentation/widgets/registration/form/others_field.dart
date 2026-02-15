import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/presentation/widgets/widgets.dart';
import 'package:niramoy_health_app/core/resources/resources.dart';

import '../../../cubit/form/registration_form_cubit.dart';

class OthersField extends StatelessWidget {
  const OthersField({super.key, required this.cubit});

  final RegistrationFormCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: AppDatePicker(
                labelText: RegistrationStrings.dob,
                onChanged: cubit.onDobChanged,
                lastDate: DateTime.now().subtract(Duration(days: 1)),
                firstDate: DateTime(1900),
                errorText: state.dateOfBirthError,
              ),
            ),
            Gap.horizontal(AppSizes.space16),
            Expanded(
              child: AppDropdown<String>(
                labelText: RegistrationStrings.gender,
                items: [AppStrings.male, AppStrings.female, AppStrings.other],
                onChanged: cubit.onGenderChanged,
                errorText: state.genderError,
              ),
            ),
          ],
        );
      },
    );
  }
}
