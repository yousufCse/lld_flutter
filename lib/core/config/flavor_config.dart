import 'env_constants.dart';

enum Flavor {
  dev,
  prod,
  staging;

  bool get isDev => this == Flavor.dev;
  bool get isProd => this == Flavor.prod;
  bool get isStaging => this == Flavor.staging;

  String get name => switch (this) {
    Flavor.dev => EnvConstants.dev,
    Flavor.prod => EnvConstants.prod,
    Flavor.staging => EnvConstants.staging,
  };

  String get envFile => switch (this) {
    Flavor.dev => EnvConstants.devFile,
    Flavor.prod => EnvConstants.prodFile,
    Flavor.staging => EnvConstants.stagingFile,
  };
}
