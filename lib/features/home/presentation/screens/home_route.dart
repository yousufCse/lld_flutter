import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exercise/core/di/injectable_container.dart';
import 'package:flutter_exercise/core/router/route_names.dart';
import 'package:flutter_exercise/core/services/storage_service.dart';
import 'package:go_router/go_router.dart';

import '../cubit/cubit/random_face_cubit.dart';
import 'home_screen.dart';

class HomeRoute extends GoRoute {
  HomeRoute()
    : super(
        path: RouteNames.home,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<RandomFaceCubit>(),
            child: HomeScreen(
              storageService: getIt<StorageService>(),
              appLogger: getIt(),
            ),
          );
        },
      );
}
