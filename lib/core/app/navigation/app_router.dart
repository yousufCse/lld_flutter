import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/navigation_redirection_service.dart';
import 'package:niramoy_health_app/core/app/navigation/route_redirection_trigger.dart';
import 'package:niramoy_health_app/core/di/injectable_container.dart';
import 'package:niramoy_health_app/features/splash/presentation/route/splash_route.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class AppRouter {
  final GoRouter _routerConfig;
  GoRouter get config => _routerConfig;

  AppRouter._init(this._routerConfig);

  factory AppRouter() {
    return _appRouter;
  }

  static final AppRouter _appRouter = AppRouter._init(
    GoRouter(
      observers: [routeObserver],
      redirect: getIt<NavigationRedirectionService>().redirectTo,
      refreshListenable: getIt<RouteRedirectionTrigger>(),
      routes: [SplashRoute()],
    ),
  );
}
