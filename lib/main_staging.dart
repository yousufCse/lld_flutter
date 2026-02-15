import 'core/config/app_config.dart';
import 'core/config/flavor_config.dart';
import 'main_common.dart';

Future<void> main() async {
  await AppConfig.initialize(Flavor.staging);
  await mainCommon(Flavor.staging);
}
