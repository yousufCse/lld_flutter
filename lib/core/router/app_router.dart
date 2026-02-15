import 'package:flutter_exercise/features/home/presentation/screens/home_route.dart';
import 'package:flutter_exercise/features/theme_showcase/presentation/screens/theme_showcase_route.dart';
import 'package:flutter_exercise/features/vital_sign/presentation/screens/vital_sign_route.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [HomeRoute(), VitalSignRoute(), ThemeShowcaseRoute()],
  );
}
