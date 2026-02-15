import 'package:flutter/material.dart';
import '../../presentation/cubits/user_client/user_client_cubit.dart';

/// Dependency injection container for the application
/// Provides centralized management of all dependencies
class Injector {
  static final Map<Type, dynamic> _instances = {};
  static UserClientCubit? _userClientCubit;

  /// Register a dependency
  static void register<T>(T instance) {
    _instances[T] = instance;
  }

  /// Get a dependency instance
  static T get<T>() {
    return _instances[T] as T;
  }

  /// Initialize UserClientCubit
  static UserClientCubit get userClientCubit {
    _userClientCubit ??= UserClientCubit();
    return _userClientCubit!;
  }

  static List<Widget> get repositories {
    return [
      // Add repository providers here
    ];
  }

  static List<Widget> get blocs {
    return [
      // Add other blocs/cubits here as needed
    ];
  }

  /// Initialize all dependencies that need async setup
  static Future<void> initialize() async {
    // Initialize services that need async setup
    // await Firebase.initializeApp();
    // await SharedPreferences.getInstance();
    // etc.
  }

  /// Dispose all resources
  static Future<void> dispose() async {
    _userClientCubit?.resetClient();
    _instances.clear();
  }
}

/// Extension on BuildContext for easy dependency access
extension BuildContextInjector on BuildContext {
  /// Get a dependency instance
  T getDependency<T>() {
    return Injector.get<T>();
  }

  /// Get a cubit instance
  T cubit<T>() {
    return Injector.get<T>();
  }

  /// Get the UserClientCubit
  UserClientCubit get userClientCubit => Injector.userClientCubit;
}
