import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/named_route.dart';
import 'package:niramoy_health_app/features/splash/presentation/ui/splash_screen.dart';

class SplashRoute extends GoRoute {
  SplashRoute()
    : super(
        path: NamedRoute.splash.routePath,
        name: NamedRoute.splash.routeName,
        builder: (context, state) => const SplashScreen(),
      );
}
