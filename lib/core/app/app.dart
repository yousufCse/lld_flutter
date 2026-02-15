import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niramoy_health_app/core/config/app_config.dart';
import 'package:niramoy_health_app/core/di/injectable_container.dart';
import 'package:niramoy_health_app/core/responsive/responsive_data.dart';

import '../../../l10n.dart';
import '../app/navigation/app_router_2.dart';
import 'global_app_providers.dart';

/// Main application widget that configures the app with all necessary providers
/// and localization support
class NiramoyApp extends StatefulWidget {
  const NiramoyApp({super.key});

  @override
  State<NiramoyApp> createState() => _NiramoyAppState();
}

class _NiramoyAppState extends State<NiramoyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp.router(
        title: AppConfig.instance.appName,
        debugShowCheckedModeBanner: AppConfig.instance.flavor.isDev,
        routerConfig: getIt<AppRouter>().router,
        theme: AppConfig.instance.theme,
        localizationsDelegates: AppLocalization.localizationsDelegates,
        supportedLocales: AppLocalization.supportedLocales,
        locale: Locale(
          WidgetsBinding.instance.platformDispatcher.locale.languageCode,
        ),
        builder: (context, child) {
          return ResponsiveData.fromMediaQuery(
            mediaQuery: MediaQuery.of(context),
            child: child!,
          );
        },
      ),
    );
  }
}
