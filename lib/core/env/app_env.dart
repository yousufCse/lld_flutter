class AppEnv {
  static const prod = 'prod';
  static const dev = 'dev';

  static String get currentEnv {
    final currentEnvironment = const String.fromEnvironment(
      'env',
      defaultValue: 'nnn',
    );
    return currentEnvironment;
  }

  static bool get isProd => currentEnv == prod;
  static bool get isDev => currentEnv == dev;
}
