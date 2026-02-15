import 'package:flutter_exercise/core/di/injectable_container.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'app_logger.dart';

@dev
@LazySingleton(as: AppLogger)
class DevAppLogger implements AppLogger {
  DevAppLogger({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  void d(String message) {
    _logger.d(message);
  }

  @override
  void i(String message) {
    _logger.i(message);
  }

  @override
  void w(String message) {
    _logger.w(message);
  }

  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    if (error != null) {
      _logger.e('Error: $error');
    }
    if (stackTrace != null) {
      _logger.e('StackTrace: $stackTrace');
    }
  }
}

final logger = getIt<AppLogger>();
