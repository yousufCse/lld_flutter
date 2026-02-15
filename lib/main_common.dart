import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';
import 'package:flutter_exercise/core/theme/app_theme.dart';

import 'core/config/app_config.dart';
import 'core/di/injectable_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/cubit/theme_cubit.dart';

Future<void> mainCommon(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies(flavor);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<ThemeCubit>())],
      child: const RootMaterialApp(),
    );
  }
}

class RootMaterialApp extends StatelessWidget {
  const RootMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    return AnimatedTheme(
      data: themeCubit.isDarkMode
          ? AppTheme.darkTheme()
          : AppTheme.lightTheme(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConfig.instance.appName,
        routerConfig: AppRouter().router,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: themeCubit.state.mode,
      ),
    );
  }
}
