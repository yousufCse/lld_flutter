import 'package:flutter_exercise/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

import 'vital_sign_screen.dart';

class VitalSignRoute extends GoRoute {
  VitalSignRoute()
      : super(
          path: RouteNames.vitalSign,
          builder: (context, state) {
            return const VitalSignScreen();
          },
        );
}
