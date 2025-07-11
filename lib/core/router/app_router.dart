import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/random_face/presentation/pages/random_face_page.dart';
import '../../features/vital_signs/presentation/pages/vital_signs_page.dart';
import 'app_routes.dart';

/// Router class responsible for generating routes based on route names
class AppRouter {
  /// Generate routes based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case AppRoutes.dashboard:
        // The token should be passed as an argument
        final token = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => DashboardPage(token: token));

      case AppRoutes.randomFace:
        return MaterialPageRoute(builder: (_) => RandomFacePage());

      case AppRoutes.vitalSigns:
        // The userId should be passed as an argument
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VitalSignsPage(userId: userId),
        );

      default:
        // If the route is not defined, show a 404 page or redirect to a default page
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
}
