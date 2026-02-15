import 'package:dio/dio.dart';
import '../config/app_config.dart';

const _connectTimeout = Duration(seconds: 10);
const _receiveTimeout = Duration(seconds: 10);

Map<String, dynamic> get defaultHeaders => {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

class BaseConfig extends BaseOptions {
  BaseConfig()
    : super(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: defaultHeaders,
      );
}
