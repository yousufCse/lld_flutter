import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/extensions/context_extensions.dart';
import 'package:niramoy_health_app/core/extensions/datetime_extensions.dart';
import 'package:niramoy_health_app/core/presentation/widgets/widgets.dart';

import '../../../domain/usecases/register_initiate_usecase.dart';
import '../../cubit/form/registration_form_cubit.dart';
import '../../widgets/registration/registration_content.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  void onRegisterPressed(BuildContext context) {
    context.dismissKeyboard();
    final cubit = context.read<RegistrationFormCubit>();
    cubit.registerInitial(_registerParams(cubit.state));
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Registration Screen build');
    return Scaffold(
      appBar: AppBar(leading: LeadingBack()),
      body: BlocListener<RegistrationFormCubit, RegistrationFormState>(
        listener: _handleListener,
        child: RegistrationContent(
          formCubit: context.read<RegistrationFormCubit>(),
          onRegisterPressed: () => onRegisterPressed(context),
        ),
      ),
    );
  }

  Future<void> _handleListener(
    BuildContext context,
    RegistrationFormState state,
  ) async {
    if (state.registerState is RegisterInitiateSuccess) {
      final registerEntity =
          (state.registerState as RegisterInitiateSuccess).registerEntity;

      context.push(
        RouteNames.otpVerification,
        extra: registerEntity.registrationId,
      );
      context.showInfoSnackbar(registerEntity.message);
    } else if (state.registerState is RegisterInitiateFailure) {
      final failure = (state.registerState as RegisterInitiateFailure);
      // Show error message to user
      AppDialog.alert(
        context,
        title: failure.code ?? '',
        message: failure.message,
        variant: DialogVariant.error,
      );
    }
  }

  RegisterParams _registerParams(RegistrationFormState state) => RegisterParams(
    firstName: state.firstName,
    lastName: state.lastName,
    phone: state.mobile,
    dateOfBirth: state.dob?.toDateString(),
    gender: state.gender,
    termsAccepted: state.termsAccepted,
  );
}
