import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/presentation/widgets/widgets.dart';
import 'package:niramoy_health_app/core/resources/resources.dart';
import 'package:niramoy_health_app/core/responsive/responsive.dart';

import '../../cubit/form/registration_form_cubit.dart';
import 'form/form.dart';

class RegistrationContent extends StatelessWidget {
  const RegistrationContent({
    super.key,
    required this.onRegisterPressed,
    required this.formCubit,
  });

  final VoidCallback onRegisterPressed;
  final RegistrationFormCubit formCubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.space16),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.screenHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const RegistrationTitle(),
            Gap.vertical(AppSizes.space32),
            NameField(cubit: formCubit),
            Gap.vertical(AppSizes.space16),
            PhoneField(cubit: formCubit),
            Gap.vertical(AppSizes.space16),
            OthersField(cubit: formCubit),
            Gap.vertical(AppSizes.space24),
            _buildNextButton(),
            Gap.vertical(context.screenHeight * 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
      builder: (context, state) {
        return AppButton.filled(
          title: AppStrings.next,
          onPressed: state.registerState is RegisterInitiateLoading
              ? null
              : onRegisterPressed,
          isLoading: state.registerState is RegisterInitiateLoading,
        );
      },
    );
  }
}
