import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';

import '../../../domain/entities/account_completion_entity.dart';
import 'success_screen.dart';

class CongratulationRoute extends GoRoute {
  CongratulationRoute()
    : super(
        path: RouteNames.registrationSuccess,
        builder: (context, state) {
          final completion = state.extra as AccountCompletionEntity;
          return CongratulationScreen(completionData: completion);
        },
      );
}
