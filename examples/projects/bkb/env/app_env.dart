import 'env_type.dart';

class AppEnv {
  static EnvType currentEnv = EnvType.dev;

  static bool get isDev => currentEnv == EnvType.dev;
  static bool get isProd => currentEnv == EnvType.prod;

  static void setEnv(EnvType env) {
    currentEnv = env;
  }
}
