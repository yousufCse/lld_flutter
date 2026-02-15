import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/features/registration/domain/entities/account_verification_entity.dart';

import 'account_list_screen.dart';

class AccountListExtras {
  final List<ExistingAccount> existingAccounts;
  final String registrationId;

  AccountListExtras({
    required this.existingAccounts,
    required this.registrationId,
  });
}

class AccountListRoute extends GoRoute {
  AccountListRoute()
    : super(
        path: RouteNames.accountList,
        builder: (context, state) {
          final extras = state.extra as AccountListExtras;
          return AccountListScreen(extras: extras);
        },
      );
}
