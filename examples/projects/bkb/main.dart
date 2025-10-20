// ignore_for_file: avoid_print

import 'api/api_constant.dart';
import 'env/app_env.dart';
import 'env/env_type.dart';

void main(List<String> args) {
  print('----- BKB Project -----');

  AppEnv.setEnv(EnvType.dev);

  print('Current Environment: ${AppEnv.currentEnv.value}');
  print('Base URL: ${ApiFactory.appUrl.baseUrl}');
}
