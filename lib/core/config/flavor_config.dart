const _dev = 'dev';
const _prod = 'prod';
const _envFileDev = '.env.dev';
const _envFileProd = '.env.prod';

enum Flavor {
  dev,
  prod;

  bool get isDev => this == Flavor.dev;
  bool get isProd => this == Flavor.prod;

  String get name => switch (this) {
    Flavor.dev => _dev,
    Flavor.prod => _prod,
  };

  String get envFile => switch (this) {
    Flavor.dev => _envFileDev,
    Flavor.prod => _envFileProd,
  };
}
