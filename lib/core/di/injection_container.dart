// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lld_flutter/core/router/navigation/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../router/navigation/navigation_service_factory.dart';
import 'injection_container.config.dart';

final sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependencies({String? environment}) async {
  await init(sl, environment: environment);
}

@module
abstract class RegisterModule {
  // External dependencies
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();

  @lazySingleton
  NavigationService get navigationService => NavigationServiceFactory.create();
}
