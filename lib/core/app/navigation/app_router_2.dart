import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/app/logger/console_app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:niramoy_health_app/features/auth/presentation/screens/login/login_route.dart';
import 'package:niramoy_health_app/features/auth/presentation/screens/onboarding/onboarding_route.dart';
import 'package:niramoy_health_app/features/auth/presentation/screens/splash/splash_route.dart';
import 'package:niramoy_health_app/features/home/presentation/screens/home_route.dart';
import 'package:niramoy_health_app/features/registration/presentation/screens/registration/registration_shell_route.dart';

import 'go_router_refresh_stream.dart';

@lazySingleton
class AppRouter {
  final AuthCubit authCubit;
  AuthStatus? _previousStatus;

  AppRouter({required this.authCubit});

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: _routes,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;

      logger.i(
        '[AppRouter2] First ->  Location = ${state.matchedLocation} | AuthState = ${authState.status} | Previous Status = $_previousStatus',
      );
      if (authState.status == _previousStatus) return null;
      _previousStatus = authState.status;

      logger.i(
        '[AppRouter2] After ->  Location = ${state.matchedLocation} | Previous Status = $_previousStatus',
      );

      if (authState.status == AuthStatus.firstTime &&
          state.matchedLocation != RouteNames.onboarding) {
        return RouteNames.onboarding;
      }
      if (authState.status == AuthStatus.authenticated &&
          state.matchedLocation != RouteNames.home &&
          authState.loginEntity != null) {
        return RouteNames.home;
      }
      if (authState.status == AuthStatus.unauthenticated &&
          state.matchedLocation != RouteNames.login) {
        return RouteNames.login;
      }

      return null; // No redirection
    },
  );
}

final _routes = <RouteBase>[
  SplashRoute(),
  OnboardingRoute(),
  LoginRoute(),
  RegistrationShellRoute(),
  HomeRoute(),
];
