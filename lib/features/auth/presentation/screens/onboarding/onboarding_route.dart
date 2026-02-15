import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/logger/app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/di/injectable_container.dart';
import 'package:niramoy_health_app/features/auth/presentation/cubits/auth/auth_cubit.dart';

import 'onboarding_screen.dart';

class OnboardingRoute extends GoRoute {
  OnboardingRoute()
    : super(
        path: RouteNames.onboarding,
        builder: (context, state) {
          return OnboardingScreen(
            logger: getIt<AppLogger>(),
            authCubit: context.read<AuthCubit>(),
          );
        },
      );
}
