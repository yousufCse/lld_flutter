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

import '../../features/auth/data/datasources/auth_data_source.dart' as _i970;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart'
    as _i258;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/domain/usecases/get_current_user_usecase.dart'
    as _i276;
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i24;
import '../../features/random_face/data/datasources/face_remote_data_source.dart'
    as _i1030;
import '../../features/random_face/data/repositories/face_repository_impl.dart'
    as _i38;
import '../../features/random_face/domain/repositories/face_repository.dart'
    as _i67;
import '../../features/random_face/domain/usecases/get_random_face.dart'
    as _i345;
import '../../features/random_face/presentation/bloc/face_cubit.dart' as _i1007;
import '../../features/vital_signs/data/datasources/vital_sign_remote_data_source.dart'
    as _i841;
import '../../features/vital_signs/data/repositories/vital_sign_repository_impl.dart'
    as _i30;
import '../../features/vital_signs/domain/repositories/vital_sign_repository.dart'
    as _i809;
import '../../features/vital_signs/domain/usecases/get_latest_vital_sign_usecase.dart'
    as _i1038;
import '../../features/vital_signs/presentation/cubit/vital_sign_cubit.dart'
    as _i677;
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
  gh.lazySingleton<_i932.NetworkInfo>(
    () => _i932.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()),
  );
  gh.lazySingleton<_i557.ApiClient>(
    () => _i557.ApiClient(gh<_i361.Dio>(), gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i258.DashboardRemoteDataSource>(
    () => _i258.DashboardRemoteDataSourceImpl(gh<_i557.ApiClient>()),
  );
  gh.lazySingleton<_i1030.FaceRemoteDataSource>(
    () => _i1030.FaceRemoteDataSourceImpl(gh<_i557.ApiClient>()),
  );
  gh.lazySingleton<_i665.DashboardRepository>(
    () => _i509.DashboardRepositoryImpl(
      remoteDataSource: gh<_i258.DashboardRemoteDataSource>(),
      networkInfo: gh<_i932.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i841.VitalSignRemoteDataSource>(
    () => _i841.VitalSignRemoteDataSourceImpl(gh<_i557.ApiClient>()),
  );
  gh.lazySingleton<_i809.VitalSignRepository>(
    () => _i30.VitalSignRepositoryImpl(
      remoteDataSource: gh<_i841.VitalSignRemoteDataSource>(),
      networkInfo: gh<_i932.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i970.AuthDataSource>(
    () => _i970.AuthDataSourceImpl(
      gh<_i557.ApiClient>(),
      gh<_i460.SharedPreferences>(),
    ),
  );
  gh.lazySingleton<_i787.AuthRepository>(
    () => _i153.AuthRepositoryImpl(
      gh<_i970.AuthDataSource>(),
      gh<_i932.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i188.LoginUseCase>(
    () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
  );
  gh.lazySingleton<_i48.LogoutUseCase>(
    () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
  );
  gh.lazySingleton<_i67.FaceRepository>(
    () => _i38.FaceRepositoryImpl(
      gh<_i1030.FaceRemoteDataSource>(),
      gh<_i932.NetworkInfo>(),
    ),
  );
  gh.lazySingleton<_i1038.GetLatestVitalSignUseCase>(
    () => _i1038.GetLatestVitalSignUseCase(gh<_i809.VitalSignRepository>()),
  );
  gh.lazySingleton<_i345.GetRandomFace>(
    () => _i345.GetRandomFace(gh<_i67.FaceRepository>()),
  );
  gh.factory<_i117.AuthCubit>(
    () => _i117.AuthCubit(
      loginUseCase: gh<_i188.LoginUseCase>(),
      logoutUseCase: gh<_i48.LogoutUseCase>(),
    ),
  );
  gh.lazySingleton<_i276.GetCurrentUserUseCase>(
    () => _i276.GetCurrentUserUseCase(gh<_i665.DashboardRepository>()),
  );
  gh.factory<_i677.VitalSignCubit>(
    () => _i677.VitalSignCubit(
      getLatestVitalSignUseCase: gh<_i1038.GetLatestVitalSignUseCase>(),
    ),
  );
  gh.factory<_i24.DashboardCubit>(
    () => _i24.DashboardCubit(
      getCurrentUserUseCase: gh<_i276.GetCurrentUserUseCase>(),
    ),
  );
  gh.factory<_i1007.FaceCubit>(
    () => _i1007.FaceCubit(gh<_i345.GetRandomFace>()),
  );
  return getIt;
}

class _$RegisterModule extends _i809.RegisterModule {}
