import 'package:flutter/material.dart';

import 'core/app/app.dart';
import 'core/app/injector/injector.dart';
import 'core/config/flavor_config.dart';
import 'core/di/injectable_container.dart';

Future<void> mainCommon(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(flavor);
  await Injector.initialize();

  runApp(const NiramoyApp());
}
