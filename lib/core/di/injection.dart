import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/posts/data/datasources/posts_local_datasource.dart';
import '../../features/posts/data/datasources/posts_remote_datasource.dart';
import '../../features/posts/data/repositories/posts_repository_impl.dart';
import '../../features/posts/domain/repositories/posts_repository.dart';
import '../../features/posts/domain/usecases/get_post_by_id.dart';
import '../../features/posts/domain/usecases/get_posts.dart';
import '../../features/posts/presentation/bloc/posts_bloc.dart';
import '../network/api_client.dart';
import '../services/network_service.dart';
import '../services/storage_service.dart';

/// Global GetIt instance
final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ==================== External ====================

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // ==================== Core ====================

  // API Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Storage Service
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(getIt<SharedPreferences>()),
  );

  // Network Service
  getIt.registerLazySingleton<NetworkService>(() => NetworkService());

  // ==================== Features ====================

  // Posts Feature
  _initPostsFeature();
}

/// Initialize Posts feature dependencies
void _initPostsFeature() {
  // Data Sources
  getIt.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<PostsLocalDataSource>(
    () => PostsLocalDataSourceImpl(storageService: getIt<StorageService>()),
  );

  // Repository
  getIt.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDataSource: getIt<PostsRemoteDataSource>(),
      localDataSource: getIt<PostsLocalDataSource>(),
      networkService: getIt<NetworkService>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetPosts>(
    () => GetPosts(getIt<PostsRepository>()),
  );

  getIt.registerLazySingleton<GetPostById>(
    () => GetPostById(getIt<PostsRepository>()),
  );

  // BLoC
  getIt.registerFactory<PostsBloc>(
    () => PostsBloc(
      getPosts: getIt<GetPosts>(),
      getPostById: getIt<GetPostById>(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
