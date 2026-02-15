import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/utils/helpers.dart';

/// BLoC observer for debugging
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logger.d('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.d('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e('onError -- ${bloc.runtimeType}',
        error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    logger.d('onClose -- ${bloc.runtimeType}');
  }
}

Future<void> main() async {
  // Catch all errors in the Flutter framework
  await runZonedGuarded<Future<void>>(
    () async {
      // Ensure Flutter is initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      // Initialize dependencies
      await initializeDependencies();

      // Set up BLoC observer for debugging
      if (kDebugMode) {
        Bloc.observer = AppBlocObserver();
      }

      // Handle Flutter errors
      FlutterError.onError = (FlutterErrorDetails details) {
        logger.e(
          'Flutter Error',
          error: details.exception,
          stackTrace: details.stack,
        );
        // In production, you might want to send this to a crash reporting service
      };

      // Run the app
      runApp(const App());
    },
    (error, stackTrace) {
      // Handle errors that occur outside Flutter's error handling
      logger.e('Unhandled error', error: error, stackTrace: stackTrace);
      // In production, you might want to send this to a crash reporting service
    },
  );
}
