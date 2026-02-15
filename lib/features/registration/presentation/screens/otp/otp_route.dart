import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:niramoy_health_app/core/app/navigation/route_names.dart';
import 'package:niramoy_health_app/core/di/injectable_container.dart';

import '../../cubit/account_completion/account_completion_cubit.dart';
import '../../cubit/otp_form/otp_form_cubit.dart';
import 'otp_screen.dart';

class OtpRoute extends GoRoute {
  OtpRoute()
    : super(
        path: RouteNames.otpVerification,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<OtpFormCubit>()),
              BlocProvider(
                create: (context) => getIt<AccountCompletionCubit>(),
              ),
            ],
            child: OtpScreen(registrationId: state.extra as String),
          );
        },
      );
}
