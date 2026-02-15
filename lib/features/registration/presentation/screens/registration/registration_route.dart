import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/di/injectable_container.dart';
import 'package:niramoy_health_app/features/registration/presentation/cubit/form/registration_form_cubit.dart';

import 'registration_screen.dart';

class RegistrationRoute extends GoRoute {
  RegistrationRoute()
    : super(
        path: RouteNames.registration,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<RegistrationFormCubit>(),
            child: RegistrationScreen(),
          );
        },
      );
}
