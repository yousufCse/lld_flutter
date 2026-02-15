import 'package:dio/dio.dart';
import 'package:niramoy_health_app/res/visible_string/visible_string.dart';

const Map<String, dynamic> headers = {
  'Content-Type': 'application/json',
  'accept': '*/*',
};

const String kBaseUrl = 'baseUrl';
const String kAuthBaseUrl = 'authBaseUrl';

class BaseConfig extends BaseOptions {
  BaseConfig() : super(headers: headers, baseUrl: baseUrl);
}

class AuthBaseConfig extends BaseOptions {
  AuthBaseConfig() : super(headers: headers, baseUrl: authBaseUrl);
}

String get baseUrl {
  const baseUrl = String.fromEnvironment(kBaseUrl);
  if (baseUrl.isEmpty) {
    // For development/day-1 allow empty or default if env not set,
    // or keep strictly throwing error.
    // adhering to pfh_app logic:
    throw vskEnvironmentSetupError;
  }
  return baseUrl;
}

String get authBaseUrl {
  const authBaseUrl = String.fromEnvironment(kAuthBaseUrl);
  if (authBaseUrl.isEmpty) {
    throw vskEnvironmentSetupError;
  }
  return authBaseUrl;
}
