# Flutter Project Setup — Clean Architecture

Create a Flutter project named `{PROJECT_NAME}` with the following architecture, patterns, and structure. This is a production-grade mobile app using Clean Architecture with feature-based organization.

## Tech Stack

| Category | Package | Notes |
|----------|---------|-------|
| State Management | flutter_bloc (Cubit only) | NOT Provider/Riverpod |
| DI | get_it + injectable + injectable_generator | Code-generated |
| Network | dio | With interceptors |
| Routing | go_router | |
| Error Handling | dartz (Either) | `Result<T> = Future<Either<Failure, T>>` |
| Models | json_serializable + json_annotation | NOT freezed for models |
| Equality | equatable | For entities, states, params |
| Secure Storage | flutter_secure_storage | |
| Preferences | shared_preferences | |
| Logging | logger | |
| Connectivity | connectivity_plus | |
| Build Runner | build_runner (dev) | |

Do NOT use: Provider, Riverpod, freezed (for models), or any other state management.

## Folder Structure

```
lib/
├── core/
│   ├── app/
│   │   ├── logger/
│   │   │   ├── app_logger.dart              # Abstract logger interface
│   │   │   └── console_app_logger.dart      # Implementation using logger package
│   │   ├── navigation/
│   │   │   ├── app_router.dart              # GoRouter configuration
│   │   │   └── route_names.dart             # Static route name constants
│   │   ├── theme/
│   │   │   ├── app_theme.dart               # ThemeData (Material 3)
│   │   │   └── app_colors.dart              # Color constants
│   │   └── injector/
│   │       └── app_injector.dart            # DI initialization entry point
│   ├── config/
│   │   ├── app_config.dart                  # Base config (baseUrl, etc.)
│   │   └── flavor.dart                      # Enum: dev, staging, prod
│   ├── di/
│   │   ├── injectable_container.dart        # @InjectableInit configureDependencies()
│   │   ├── injectable_container.config.dart # Generated
│   │   ├── injection_names.dart             # Static const named instances
│   │   └── modules/
│   │       ├── network_module.dart          # Dio instances, ApiClient instances
│   │       └── external_module.dart         # SharedPreferences, SecureStorage, Connectivity
│   ├── network/
│   │   ├── api_client.dart                  # Generic HTTP wrapper with _execute pattern
│   │   ├── api_endpoints.dart               # Static endpoint constants
│   │   ├── base_config.dart                 # Dio BaseOptions
│   │   ├── network_info.dart                # NetworkInfo interface + impl
│   │   └── interceptors/
│   │       ├── token_interceptor.dart       # Adds Bearer token to requests
│   │       └── refresh_token_interceptor.dart # Handles 401 + token refresh
│   ├── domain/
│   │   ├── usecase.dart                     # abstract Usecase<T, P> + Params + NoParams
│   │   └── base_repository.dart             # handleException() wrapper
│   ├── error/
│   │   ├── exceptions/
│   │   │   ├── app_exceptions.dart          # Base AppException
│   │   │   ├── network_exceptions.dart      # NetworkException
│   │   │   ├── api_exceptions.dart          # ApiException with factory methods
│   │   │   ├── auth_exceptions.dart         # AuthException
│   │   │   ├── server_exceptions.dart       # ServerException
│   │   │   ├── parsing_exceptions.dart      # ParsingException
│   │   │   ├── cache_exceptions.dart        # CacheException
│   │   │   ├── custom_exceptions.dart       # CustomException (catch-all)
│   │   │   └── index.dart                   # Barrel export
│   │   └── failures/
│   │       ├── failure.dart                 # Base Failure (Equatable)
│   │       ├── network_failure.dart
│   │       ├── api_failure.dart
│   │       ├── auth_failure.dart
│   │       ├── server_failure.dart
│   │       ├── parsing_failure.dart
│   │       ├── cache_failure.dart
│   │       ├── custom_failure.dart
│   │       └── index.dart                   # Barrel export
│   ├── types/
│   │   └── type_defs.dart                   # Result<T>, ResultVoid, callbacks
│   ├── validation/
│   │   ├── validation_rule.dart             # abstract ValidationRule
│   │   ├── field_validator.dart             # Composes rules, returns first error
│   │   ├── validation_messages.dart         # Static validation message strings
│   │   ├── app_validators.dart              # Pre-composed validators (name, email, phone, etc.)
│   │   └── rules/
│   │       ├── required_rule.dart
│   │       ├── min_length_rule.dart
│   │       ├── max_length_rule.dart
│   │       ├── pattern_rule.dart
│   │       ├── email_rule.dart
│   │       └── phone_rule.dart
│   ├── presentation/
│   │   └── widgets/
│   │       ├── app_button.dart
│   │       ├── app_text_field.dart
│   │       ├── app_scaffold.dart
│   │       └── gap.dart
│   ├── resources/
│   │   ├── app_sizes.dart                   # Spacing, radius, icon sizes
│   │   ├── app_strings.dart                 # UI strings
│   │   └── app_colors.dart                  # If separate from theme
│   ├── constants/
│   │   ├── app_errors.dart                  # Error message constants
│   │   └── app_error_codes.dart             # Error code constants
│   ├── data/
│   │   └── local/
│   │       └── token_storage.dart           # FlutterSecureStorage wrapper
│   └── extensions/
│       ├── context_extensions.dart
│       └── keyboard_dismiss.dart
│
├── features/                                # Empty — features added per project
│
├── main_dev.dart
├── main_staging.dart
└── main_prod.dart
```

## Feature Structure (for reference when adding features)

Each feature follows `data/domain/presentation`:

```
features/{feature}/
├── data/
│   ├── data_sources/
│   │   ├── {feature}_remote_data_source.dart       # Interface
│   │   └── {feature}_remote_data_source_impl.dart  # Implementation
│   ├── models/                                     # Request/Response models
│   └── repositories/{feature}_repository_impl.dart
├── domain/
│   ├── entities/
│   ├── repositories/{feature}_repository.dart      # Interface
│   └── usecases/
└── presentation/
    ├── cubit/
    ├── screens/
    └── widgets/
```

## Core Implementations

### 1. Type Definitions (`core/types/type_defs.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../error/failures/index.dart';

typedef Result<T> = Future<Either<Failure, T>>;
typedef ResultVoid = Result<void>;
typedef JsonMap = Map<String, dynamic>;
typedef FromJson<T> = T Function(Map<String, dynamic> json);
```

### 2. Base UseCase (`core/domain/usecase.dart`)

```dart
import '../types/type_defs.dart';
import 'package:equatable/equatable.dart';

abstract class Usecase<T, P> {
  Result<T> call(P params);
}

abstract class Params extends Equatable {
  const Params();
}

class NoParams extends Params {
  const NoParams();
  @override
  List<Object?> get props => [];
}
```

### 3. Base Repository (`core/domain/base_repository.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../error/exceptions/index.dart';
import '../error/failures/index.dart';
import '../network/network_info.dart';

abstract class BaseRepository {
  final NetworkInfo networkInfo;
  const BaseRepository({required this.networkInfo});

  Future<Either<Failure, T>> handleException<T>(
    Future<T> Function() action,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    try {
      final result = await action();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AppException catch (e) {
      return Left(CustomFailure(e.message));
    } catch (e) {
      return Left(CustomFailure(e.toString()));
    }
  }
}
```

### 4. ApiClient with `_execute` pattern (`core/network/api_client.dart`)

```dart
import 'package:dio/dio.dart';
import '../error/exceptions/index.dart';
import '../constants/app_errors.dart';
import '../types/type_defs.dart';

class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required FromJson<T> fromJson,
    Options? options,
  }) => _execute(() async {
    final response = await _dio.get(endpoint, queryParameters: queryParameters, options: options);
    return _parseResponse(response.data, fromJson);
  });

  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required FromJson<T> fromJson,
    Options? options,
  }) => _execute(() async {
    final response = await _dio.post(endpoint, data: data, queryParameters: queryParameters, options: options);
    return _parseResponse(response.data, fromJson);
  });

  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required FromJson<T> fromJson,
    Options? options,
  }) => _execute(() async {
    final response = await _dio.put(endpoint, data: data, queryParameters: queryParameters, options: options);
    return _parseResponse(response.data, fromJson);
  });

  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required FromJson<T> fromJson,
    Options? options,
  }) => _execute(() async {
    final response = await _dio.patch(endpoint, data: data, queryParameters: queryParameters, options: options);
    return _parseResponse(response.data, fromJson);
  });

  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required FromJson<T> fromJson,
    Options? options,
  }) => _execute(() async {
    final response = await _dio.delete(endpoint, data: data, queryParameters: queryParameters, options: options);
    return _parseResponse(response.data, fromJson);
  });

  // --- Private helpers ---

  Future<T> _execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw CustomException(AppErrors.unknownError, originalError: e, stackTrace: stackTrace);
    }
  }

  T _parseResponse<T>(dynamic data, FromJson<T> fromJson) {
    if (data is Map<String, dynamic>) {
      return fromJson(data);
    }
    throw ParsingException(AppErrors.parsingError);
  }

  Never _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw NetworkException(AppErrors.timeout);
      case DioExceptionType.connectionError:
        throw NetworkException(AppErrors.noInternet);
      case DioExceptionType.badResponse:
        throw _handleResponseError(error.response);
      case DioExceptionType.cancel:
        throw NetworkException(AppErrors.requestCancelled);
      case DioExceptionType.badCertificate:
        throw NetworkException(AppErrors.badCertificate);
      case DioExceptionType.unknown:
        throw NetworkException(AppErrors.unknownError);
    }
  }

  AppException _handleResponseError(Response? response) {
    if (response == null) return ServerException(AppErrors.unknownError);
    final statusCode = response.statusCode ?? 0;
    final message = _extractField(response, 'message')
        ?? _extractField(response, 'error')
        ?? AppErrors.unknownError;

    return switch (statusCode) {
      400 => ApiException.badRequest(message: message),
      401 => AuthException(message),
      403 => ApiException.forbidden(message: message),
      404 => ApiException.notFound(message: message),
      409 => ApiException.conflict(message: message),
      422 => ApiException.unprocessable(message: message),
      429 => ApiException.tooManyRequests(message: message),
      >= 500 => ServerException(message),
      _ => ServerException(message),
    };
  }

  String? _extractField(Response response, String key) {
    final data = response.data;
    if (data is Map<String, dynamic>) return data[key]?.toString();
    return null;
  }
}
```

### 5. Exception Hierarchy (`core/error/exceptions/`)

Base class:

```dart
// app_exceptions.dart
class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});
  @override
  String toString() => message;
}
```

Subclasses (each in its own file):

```dart
// network_exceptions.dart
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

// api_exceptions.dart
class ApiException extends AppException {
  const ApiException(super.message, {super.code});

  factory ApiException.badRequest({String? message, String? code}) =>
      ApiException(message ?? AppErrors.badRequest, code: code ?? AppErrorCodes.badRequest);
  factory ApiException.forbidden({String? message}) =>
      ApiException(message ?? AppErrors.forbidden, code: AppErrorCodes.forbidden);
  factory ApiException.notFound({String? message}) =>
      ApiException(message ?? AppErrors.notFound, code: AppErrorCodes.notFound);
  factory ApiException.conflict({String? message}) =>
      ApiException(message ?? AppErrors.conflict, code: AppErrorCodes.conflict);
  factory ApiException.unprocessable({String? message}) =>
      ApiException(message ?? AppErrors.unprocessable, code: AppErrorCodes.unprocessable);
  factory ApiException.tooManyRequests({String? message}) =>
      ApiException(message ?? AppErrors.tooManyRequests, code: AppErrorCodes.tooManyRequests);
}

// auth_exceptions.dart
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

// server_exceptions.dart
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

// parsing_exceptions.dart
class ParsingException extends AppException {
  const ParsingException(super.message, {super.code});
}

// cache_exceptions.dart
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

// custom_exceptions.dart
class CustomException extends AppException {
  final Object? originalError;
  final StackTrace? stackTrace;
  const CustomException(super.message, {super.code, this.originalError, this.stackTrace});
}
```

Barrel export (`index.dart`):

```dart
export 'app_exceptions.dart';
export 'network_exceptions.dart';
export 'api_exceptions.dart';
export 'auth_exceptions.dart';
export 'server_exceptions.dart';
export 'parsing_exceptions.dart';
export 'cache_exceptions.dart';
export 'custom_exceptions.dart';
```

### 6. Failure Hierarchy (`core/error/failures/`)

```dart
// failure.dart
import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final String? code;
  const Failure(this.message, {this.code});
  @override
  List<Object?> get props => [message, code];
}

// Each subclass in its own file:
class NetworkFailure extends Failure { const NetworkFailure(super.message, {super.code}); }
class ApiFailure extends Failure { const ApiFailure(super.message, {super.code}); }
class AuthFailure extends Failure { const AuthFailure(super.message, {super.code}); }
class ServerFailure extends Failure { const ServerFailure(super.message, {super.code}); }
class ParsingFailure extends Failure { const ParsingFailure(super.message, {super.code}); }
class CacheFailure extends Failure { const CacheFailure(super.message, {super.code}); }
class CustomFailure extends Failure { const CustomFailure(super.message, {super.code}); }
```

### 7. AppErrors & AppErrorCodes (`core/constants/`)

```dart
// app_errors.dart
abstract class AppErrors {
  static const timeout = 'Connection timeout. Please try again.';
  static const noInternet = 'No internet connection.';
  static const unknownError = 'An unexpected error occurred.';
  static const requestCancelled = 'Request was cancelled.';
  static const badCertificate = 'Invalid security certificate.';
  static const parsingError = 'Failed to parse server response.';
  static const unauthorized = 'Session expired. Please login again.';
  static const forbidden = 'You do not have permission.';
  static const notFound = 'Resource not found.';
  static const serverError = 'Server error. Please try again later.';
  static const badRequest = 'Invalid request.';
  static const conflict = 'Resource conflict.';
  static const tooManyRequests = 'Too many requests. Please wait.';
  static const unprocessable = 'Unable to process request.';
}

// app_error_codes.dart
abstract class AppErrorCodes {
  static const badRequest = 'BAD_REQUEST';
  static const unauthorized = 'UNAUTHORIZED';
  static const forbidden = 'FORBIDDEN';
  static const notFound = 'NOT_FOUND';
  static const conflict = 'CONFLICT';
  static const tooManyRequests = 'TOO_MANY_REQUESTS';
  static const unprocessable = 'UNPROCESSABLE';
  static const serverError = 'SERVER_ERROR';
}
```

### 8. DI Setup

```dart
// injection_names.dart
abstract class InjectionNames {
  static const dioSingleton = 'dioSingleton';
  static const dioBasic = 'dioBasic';
  static const dioAuth = 'dioAuth';
  static const apiClientBasic = 'apiClientBasic';
  static const apiClientAuth = 'apiClientAuth';
}

// injectable_container.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
Future<void> configureDependencies() async => getIt.init();
```

Network module registers:
- `dioSingleton`: bare Dio with BaseConfig
- `dioBasic`: Dio without auth interceptors (for login/register)
- `dioAuth`: Dio with TokenInterceptor + RefreshTokenInterceptor
- `apiClientBasic`: ApiClient wrapping dioBasic
- `apiClientAuth`: ApiClient wrapping dioAuth

External module registers:
- `SharedPreferences` (async singleton)
- `FlutterSecureStorage` (singleton)
- `Connectivity` (singleton)

### 9. Network Info

```dart
// network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
```

### 10. Base Config

```dart
// base_config.dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';

class BaseConfig extends BaseOptions {
  BaseConfig()
      : super(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        );
}
```

### 11. Token Interceptor

```dart
// token_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../data/local/token_storage.dart';

@lazySingleton
class TokenInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  TokenInterceptor({required this.tokenStorage});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

### 12. Refresh Token Interceptor

```dart
// refresh_token_interceptor.dart
// Handles 401 responses:
// 1. Queues failed requests
// 2. Refreshes token using a separate Dio instance (no interceptor loop)
// 3. Retries queued requests with new token
// 4. On refresh failure: clears tokens, rejects all queued requests
// Use Completer pattern to let concurrent 401s wait on a single refresh
```

### 13. Token Storage

```dart
// token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TokenStorage {
  final FlutterSecureStorage _storage;
  TokenStorage(this._storage);

  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);
  Future<void> saveRefreshToken(String token) => _storage.write(key: _refreshTokenKey, value: token);
  Future<void> clearTokens() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
```

### 14. Validation (Strategy Pattern)

```dart
// validation_rule.dart
abstract class ValidationRule {
  const ValidationRule();
  String? validate(String? value);
}

// field_validator.dart
class FieldValidator {
  final List<ValidationRule> _rules;
  const FieldValidator(this._rules);

  String? call(String? value) {
    for (final rule in _rules) {
      final error = rule.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}

// Example rules:
class RequiredRule extends ValidationRule {
  final String message;
  const RequiredRule(this.message);
  @override
  String? validate(String? value) => (value == null || value.trim().isEmpty) ? message : null;
}

class MinLengthRule extends ValidationRule {
  final int minLength;
  final String message;
  const MinLengthRule(this.minLength, this.message);
  @override
  String? validate(String? value) => (value != null && value.length < minLength) ? message : null;
}

class PatternRule extends ValidationRule {
  final RegExp pattern;
  final String message;
  const PatternRule(this.pattern, this.message);
  @override
  String? validate(String? value) => (value != null && !pattern.hasMatch(value)) ? message : null;
}

// app_validators.dart — pre-composed:
class AppValidators {
  static final email = FieldValidator([
    const RequiredRule(ValidationMessages.emailRequired),
    const EmailRule(ValidationMessages.emailInvalid),
  ]);
  static final phone = FieldValidator([
    const RequiredRule(ValidationMessages.phoneRequired),
    const PhoneRule(ValidationMessages.phoneInvalid),
  ]);
  // Add more as needed
}
```

### 15. App Config & Flavor

```dart
// flavor.dart
enum Flavor { dev, staging, prod }

// app_config.dart
class AppConfig {
  static late Flavor _flavor;
  static late String _baseUrl;

  static void init(Flavor flavor) {
    _flavor = flavor;
    _baseUrl = switch (flavor) {
      Flavor.dev => 'https://dev-api.example.com',
      Flavor.staging => 'https://staging-api.example.com',
      Flavor.prod => 'https://api.example.com',
    };
  }

  static Flavor get flavor => _flavor;
  static String get baseUrl => _baseUrl;
  static bool get isDev => _flavor == Flavor.dev;
}
```

### 16. Entry Points

```dart
// main_dev.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(Flavor.dev);
  await configureDependencies();
  runApp(const App());
}

// main_staging.dart — same with Flavor.staging
// main_prod.dart — same with Flavor.prod
```

### 17. Logger

```dart
// app_logger.dart
abstract class AppLogger {
  void d(String message);
  void i(String message);
  void w(String message);
  void e(String message, [Object? error, StackTrace? stackTrace]);
}

// console_app_logger.dart
import 'package:logger/logger.dart' as lib;
import 'app_logger.dart';

final logger = ConsoleAppLogger();

class ConsoleAppLogger implements AppLogger {
  final lib.Logger _logger = lib.Logger();

  @override
  void d(String message) => _logger.d(message);
  @override
  void i(String message) => _logger.i(message);
  @override
  void w(String message) => _logger.w(message);
  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
```

## Cubit/State Patterns

### Form State (Equatable + copyWith)

```dart
class ExampleFormState extends Equatable {
  final String fieldName;
  final String? fieldNameError;
  final ExampleOperationState operationState;
  final bool submitted;

  const ExampleFormState({
    required this.fieldName,
    required this.operationState,
    this.fieldNameError,
    this.submitted = false,
  });

  const ExampleFormState.initial()
    : fieldName = '',
      operationState = const ExampleOperationIdle(),
      fieldNameError = null,
      submitted = false;

  ExampleFormState copyWith({
    String? fieldName,
    String? Function()? fieldNameError,  // nullable wrapper pattern
    ExampleOperationState? operationState,
    bool? submitted,
  }) {
    return ExampleFormState(
      fieldName: fieldName ?? this.fieldName,
      operationState: operationState ?? this.operationState,
      fieldNameError: fieldNameError != null ? fieldNameError() : this.fieldNameError,
      submitted: submitted ?? this.submitted,
    );
  }

  bool get isValid => fieldNameError == null && fieldName.isNotEmpty;

  @override
  List<Object?> get props => [fieldName, fieldNameError, operationState, submitted];
  // ^^^ EVERY field MUST be here
}
```

### Operation Sub-States (union pattern)

```dart
abstract class ExampleOperationState extends Equatable {
  const ExampleOperationState();
}

class ExampleOperationIdle extends ExampleOperationState {
  const ExampleOperationIdle();
  @override
  List<Object?> get props => [];
}

class ExampleOperationLoading extends ExampleOperationState {
  const ExampleOperationLoading();
  @override
  List<Object?> get props => [];
}

class ExampleOperationSuccess extends ExampleOperationState {
  final SomeEntity entity;
  const ExampleOperationSuccess(this.entity);
  @override
  List<Object?> get props => [entity];
}

class ExampleOperationFailure extends ExampleOperationState {
  final String message;
  final String? code;
  const ExampleOperationFailure(this.message, {this.code});
  @override
  List<Object?> get props => [message, code];
}
```

### Cubit

```dart
@injectable
class ExampleFormCubit extends Cubit<ExampleFormState> {
  ExampleFormCubit(this._usecase) : super(const ExampleFormState.initial());

  final SomeUsecase _usecase;

  void onFieldChanged(String value) {
    emit(state.copyWith(
      fieldName: value,
      fieldNameError: () => state.submitted ? AppValidators.fieldName(value) : null,
    ));
  }

  bool validate() {
    emit(state.copyWith(
      submitted: true,
      fieldNameError: () => AppValidators.fieldName(state.fieldName),
    ));
    return state.isValid;
  }

  // MUST be Future<void>, not void
  Future<void> submit(SomeParams params) async {
    if (!validate()) return;
    emit(state.copyWith(operationState: const ExampleOperationLoading()));
    final result = await _usecase.call(params);
    result.fold(
      (failure) => emit(state.copyWith(
        operationState: ExampleOperationFailure(failure.message, code: failure.code),
      )),
      (entity) => emit(state.copyWith(
        operationState: ExampleOperationSuccess(entity),
      )),
    );
  }
}
```

## JSON Model Patterns

### Request Model (fromJson + toJson)

```dart
import 'package:json_annotation/json_annotation.dart';
part 'example_request_model.g.dart';

@JsonSerializable()
class ExampleRequestModel {
  final String name;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  ExampleRequestModel({required this.name, required this.phoneNumber});

  factory ExampleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExampleRequestModelToJson(this);
}
```

### Response Model (fromJson only + toEntity)

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/example_entity.dart';
part 'example_response_model.g.dart';

@JsonSerializable(createToJson: false)
class ExampleResponseModel {
  @JsonKey(name: 'registration_id')
  final String registrationId;
  final String? message;

  ExampleResponseModel({required this.registrationId, this.message});

  factory ExampleResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleResponseModelFromJson(json);

  ExampleEntity get toEntity => ExampleEntity(registrationId: registrationId);
}
```

### Entity (plain Equatable)

```dart
import 'package:equatable/equatable.dart';

class ExampleEntity extends Equatable {
  final String registrationId;
  const ExampleEntity({required this.registrationId});

  @override
  List<Object?> get props => [registrationId];
}
```

## Rules

1. Every feature follows `data/domain/presentation` strictly
2. Data source: interface in one file, implementation in separate `_impl.dart` file
3. Repository interface in domain, implementation in data (extends `BaseRepository`)
4. One UseCase per operation, params extend `Params` (Equatable)
5. Cubit async methods MUST return `Future<void>`, never `void ... async`
6. Every Equatable state field MUST be in `props` — missing fields = silent BlocBuilder bugs
7. Form state uses nullable copyWith wrapper: `String? Function()?`
8. Operation sub-states: `{Feature}OperationState` -> Idle / Loading / Success / Failure
9. Models use `json_serializable` — request: `toJson + fromJson`, response: `fromJson` only + `.toEntity` getter
10. Entities are plain Equatable classes — no annotations
11. Use `const` constructors wherever possible (states, sub-states, widgets)
12. Use `AppErrors`/`AppSizes`/`AppStrings` constants — NO magic strings/numbers
13. NEVER log sensitive data (tokens, OTP, passwords, PII)
14. Trailing commas everywhere for formatting
15. Use `@Injectable(as: Interface)` for DI bindings
16. Use `@lazySingleton` for interceptors, storage, network info
17. Use `@injectable` for cubits, usecases, repositories, data sources

## Commands

```bash
# Code generation (after model/DI changes)
flutter pub run build_runner build --delete-conflicting-outputs

# Run dev
flutter run -t lib/main_dev.dart

# Analyze
flutter analyze

# Test
flutter test

# Clean rebuild
flutter clean && flutter pub get
```

## What to Generate

Generate ALL core files listed above with full implementations. Leave `features/` empty — I will add features separately. Include `pubspec.yaml` with all dependencies. Include `analysis_options.yaml` with recommended lints. After generation, the project should compile with `flutter analyze` showing zero issues.
