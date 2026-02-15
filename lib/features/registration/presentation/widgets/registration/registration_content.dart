import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/presentation/widgets/index.dart';
import 'package:niramoy_health_app/core/resources/index.dart';

import '../../cubit/form/registration_form_cubit.dart';
import 'form/index.dart';

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
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
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
            Gap.vertical(MediaQuery.of(context).size.height * 0.2),
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
