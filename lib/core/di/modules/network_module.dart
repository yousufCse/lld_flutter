import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:niramoy_health_app/core/network/interceptors/token_interceptor.dart';

import '../../network/api_client.dart';
import '../../network/base_config.dart';
import '../injectable_container.dart';
import '../injection_names.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  @Named(InjectionNames.dioSingleton)
  Dio get dioSingleton => Dio(BaseConfig());

  @Named(InjectionNames.dioBasic)
  Dio get dioBasic => getIt<Dio>(instanceName: InjectionNames.dioSingleton);

  @Named(InjectionNames.dioAuth)
  Dio get dioAuth {
    final dio = getIt<Dio>(instanceName: InjectionNames.dioSingleton);
    dio.interceptors.addAll([
      getIt<TokenInterceptor>(),
      getIt<RefreshTokenInterceptor>(),
    ]);
    return dio;
  }

  @lazySingleton
  @Named(InjectionNames.apiClientBasic)
  ApiClient get apiClientBasic =>
      ApiClient(dio: getIt<Dio>(instanceName: InjectionNames.dioBasic));

  @lazySingleton
  @Named(InjectionNames.apiClientAuth)
  ApiClient get apiClientAuth =>
      ApiClient(dio: getIt<Dio>(instanceName: InjectionNames.dioAuth));
}
