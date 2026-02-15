import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';

import 'registration_screen.dart';

class RegistrationRoute extends GoRoute {
  RegistrationRoute()
    : super(
        path: RouteNames.registration,
        builder: (context, state) {
          return const RegistrationScreen();
        },
      );
}
