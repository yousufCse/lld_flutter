import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/features/auth/presentation/cubits/auth/auth_cubit.dart';

import 'splash_screen.dart';

class SplashRoute extends GoRoute {
  SplashRoute()
    : super(
        path: RouteNames.splash,
        builder: (context, state) {
          return SplashScreen(authCubit: context.read<AuthCubit>());
        },
      );
}
