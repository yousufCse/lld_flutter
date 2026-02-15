import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/presentation/widgets/widgets.dart';
import 'package:niramoy_health_app/features/registration/presentation/cubit/account_completion/account_completion_cubit.dart';
import 'package:niramoy_health_app/features/registration/presentation/widgets/create_new/create_new_account_content.dart';

class CreateNewAccountScreen extends StatelessWidget {
  const CreateNewAccountScreen({super.key, required this.registrationId});

  final String registrationId;

  void onComfirmed(BuildContext context) {
    // call API to create new account with registrationId
    // on success, navigate to OTP screen or home screen
    // For now, just pop back to account list
    context.read<AccountCompletionCubit>().completeAccount(registrationId);
  }

  void onCancelled(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    logger.i(
      'Building CreateNewAccountScreen with registrationId: $registrationId',
    );
    return BlocListener<AccountCompletionCubit, AccountCompletionState>(
      listener: (BuildContext context, AccountCompletionState state) {
        state.whenOrNull(
          success: (entity) {
            logger.i('Account completion successful, navigating to OTP screen');
            context.push(RouteNames.registrationSuccess, extra: entity);
          },
          error: (code, message) => context.showErrorSnackbar(message),
        );
      },
      child: Scaffold(
        appBar: AppBar(leading: LeadingBack()),
        body: CreateNewAccountContent(
          onConfirmed: () => onComfirmed(context),
          onCancelled: () => onCancelled(context),
        ),
      ),
    );
  }
}
