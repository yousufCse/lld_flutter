import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';

import 'login_screen.dart';

class LoginRoute extends GoRoute {
  LoginRoute()
    : super(
        path: RouteNames.login,
        builder: (context, state) {
          return const LoginScreen();
        },
      );
}
