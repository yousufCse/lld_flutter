import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/logger/app_logger.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/di/injectable_container.dart';
import 'package:niramoy_health_app/features/auth/presentation/cubits/auth/auth_cubit.dart';

import 'home_screen.dart';

class HomeRoute extends GoRoute {
  HomeRoute()
    : super(
        path: RouteNames.home,
        builder: (context, state) {
          return HomeScreen(
            logger: getIt<AppLogger>(),
            authState: context.read<AuthCubit>().state,
          );
        },
      );
}
