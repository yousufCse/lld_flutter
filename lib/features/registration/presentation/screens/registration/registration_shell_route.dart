import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/features/registration/presentation/screens/account_list/account_list_route.dart';
import 'package:niramoy_health_app/features/registration/presentation/screens/create_new_account/create_new_account_route.dart';

import '../otp/otp_route.dart';
import '../success/success_route.dart';
import 'registration_route.dart';

class RegistrationShellRoute extends ShellRoute {
  RegistrationShellRoute()
    : super(
        builder: (context, state, child) {
          return child;
        },
        routes: [
          RegistrationRoute(),
          OtpRoute(),
          CongratulationRoute(),
          AccountListRoute(),
          CreateNewAccountRoute(),
        ],
      );
}
