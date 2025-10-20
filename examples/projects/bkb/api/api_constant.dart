import '../env/app_env.dart';
import '../env/env_type.dart';
import 'dev_app_url.dart';
import 'prod_app_url.dart';

abstract class AppUrl {
  String get baseUrl;
  String get authUrl;
  String get verificationUrl;
}

class ApiFactory {
  static AppUrl appUrl = _getAppUrl(AppEnv.currentEnv);

  static AppUrl _getAppUrl(EnvType env) {
    switch (env) {
      case EnvType.dev:
        return DevAppUrl();
      case EnvType.prod:
        return ProdAppUrl();
    }
  }
}
