import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/presentation/widgets/index.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/account_verification_entity.dart';
import 'package:niramoy_health_app/features/registration/presentation/screens/account_list/account_list_route.dart';
import 'package:niramoy_health_app/features/registration/presentation/widgets/account_list/account_list_content.dart';

class AccountListScreen extends StatelessWidget {
  const AccountListScreen({super.key, required this.extras});

  final AccountListExtras extras;

  void onAddNewAccount(BuildContext context) {
    context.push(RouteNames.createNewAccount, extra: extras.registrationId);
  }

  void onAccountSelected(BuildContext context, ExistingAccount account) async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Log In',
      message: 'Would you like to Log In?',
    );
    if (ok && context.mounted) {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i(
      'Account List Screen build: with registrationId: ${extras.registrationId} and existingAccounts: ${extras.existingAccounts.length}',
    );
    return Scaffold(
      appBar: AppBar(
        leading: LeadingBack(onPressed: () => context.go(RouteNames.login)),
      ),
      body: AccountListContent(
        accounts: extras.existingAccounts,
        onAddNewAccount: () => onAddNewAccount(context),
        onAccountSelected: (account) => onAccountSelected(context, account),
      ),
    );
  }
}
