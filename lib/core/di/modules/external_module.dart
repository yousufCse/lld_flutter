import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:niramoy_health_app/core/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ExternalModule {
  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker.createInstance();

  @lazySingleton
  SharedPreferencesAsync get sharedPreferencesAsync => SharedPreferencesAsync();

  @lazySingleton
  Logger get logger => Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 0, // no stack trace
      errorMethodCount: 0,
      colors: false,
      printEmojis: false,
    ),
    level: AppConfig.instance.isLoggingEnabled ? Level.all : Level.off,
  );

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
