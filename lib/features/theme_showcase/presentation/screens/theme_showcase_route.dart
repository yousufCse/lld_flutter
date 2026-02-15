import 'package:flutter_exercise/core/router/route_names.dart';
import 'package:flutter_exercise/features/theme_showcase/presentation/screens/theme_showcase_screen.dart';
import 'package:go_router/go_router.dart';

class ThemeShowcaseRoute extends GoRoute {
  ThemeShowcaseRoute()
    : super(
        path: RouteNames.themeShowcase,
        builder: (context, state) {
          return const ThemeShowcaseScreen();
        },
      );
}
