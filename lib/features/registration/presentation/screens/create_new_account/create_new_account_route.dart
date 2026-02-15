import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/di/injectable_container.dart';
import 'package:niramoy_health_app/features/registration/presentation/screens/create_new_account/create_new_account_screen.dart';

import '../../cubit/account_completion/account_completion_cubit.dart';

class CreateNewAccountRoute extends GoRoute {
  CreateNewAccountRoute()
    : super(
        path: RouteNames.createNewAccount,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<AccountCompletionCubit>(),
            child: CreateNewAccountScreen(
              registrationId: state.extra as String,
            ),
          );
        },
      );
}
