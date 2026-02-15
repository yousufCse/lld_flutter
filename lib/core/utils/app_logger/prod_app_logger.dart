import 'package:injectable/injectable.dart';

import 'app_logger.dart';

@prod
@LazySingleton(as: AppLogger)
class ProdAppLogger implements AppLogger {
  ProdAppLogger();

  @override
  void d(String message) {}

  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void i(String message) {}

  @override
  void w(String message) {}
}
