import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/config/flavor_config.dart';

import 'injectable_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies(Flavor flavor) async {
  getIt.init(environment: flavor.name.toLowerCase());
}
