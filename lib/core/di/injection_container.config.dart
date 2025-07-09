// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/random_face/data/datasources/face_remote_data_source.dart'
    as _i1030;
import '../../features/random_face/data/repositories/face_repository_impl.dart'
    as _i38;
import '../../features/random_face/domain/repositories/face_repository.dart'
    as _i67;
import '../../features/random_face/domain/usecases/get_random_face.dart'
    as _i345;
import '../../features/random_face/presentation/bloc/face_cubit.dart' as _i1007;
import '../network/api_client.dart' as _i557;
import '../network/network_info.dart' as _i932;
import 'injection_container.dart' as _i809;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  await gh.lazySingletonAsync<_i460.SharedPreferences>(
    () => registerModule.sharedPreferences,
    preResolve: true,
  );
  gh.lazySingleton<_i973.InternetConnectionChecker>(
    () => registerModule.internetConnectionChecker,
  );
  gh.lazySingleton<_i557.ApiClient>(() => _i557.ApiClient(gh<_i361.Dio>()));
  gh.lazySingleton<_i932.NetworkInfo>(
    () => _i932.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()),
  );
  gh.lazySingleton<_i1030.FaceRemoteDataSource>(
    () => _i1030.FaceRemoteDataSourceImpl(gh<_i557.ApiClient>()),
  );
  gh.lazySingleton<_i67.FaceRepository>(
    () => _i38.FaceRepositoryImpl(
      gh<_i1030.FaceRemoteDataSource>(),
      gh<_i932.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i345.GetRandomFace>(
    () => _i345.GetRandomFace(gh<_i67.FaceRepository>()),
  );
  gh.factory<_i1007.FaceCubit>(
    () => _i1007.FaceCubit(gh<_i345.GetRandomFace>()),
  );
  return getIt;
}

class _$RegisterModule extends _i809.RegisterModule {}
