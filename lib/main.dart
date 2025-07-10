import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lld_flutter/features/dashboard/presentation/cubit/dashboard_cubit.dart';

import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Flutter error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };

  WidgetsFlutterBinding.ensureInitialized();
  try {
    await di.configureDependencies();
    print('Dependencies configured successfully');
  } catch (e) {
    print('Error configuring dependencies: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()),
        BlocProvider<DashboardCubit>(create: (_) => di.sl<DashboardCubit>()),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeMap(
            initial: (_) {
              // Handle logout if needed (initial state is used after logout)
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return MaterialApp(
            title: 'Dhanvantari Auth App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: LoginPage(),
          );
        },
      ),
    );
  }
}
