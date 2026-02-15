import 'package:dio/dio.dart';
import 'package:flutter_exercise/core/config/app_config.dart';

Map<String, dynamic> get defaultHeaders => {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

class BaseConfig extends BaseOptions {
  BaseConfig()
    : super(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: defaultHeaders,
      );
}
