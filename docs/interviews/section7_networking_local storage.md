# Section 7: Networking & Local Storage

---

## NETWORKING

---

**Q:** What are the key differences between the `http` package and Dio? Why is Dio generally preferred in production Flutter apps?

**A:** The `http` package is Dart's basic HTTP client — minimal, lightweight, and good for simple GET/POST calls. Dio is a full-featured HTTP client that wraps and extends that capability with features production apps actually need.

Here's how they compare:

```
+---------------------+------------------+------------------------------+
| Feature             | http             | Dio                          |
+---------------------+------------------+------------------------------+
| Interceptors        | No               | Yes (request/response/error) |
| Cancel requests     | No               | Yes (CancelToken)            |
| Timeout config      | Limited          | Per-request & global         |
| Upload progress     | No               | Yes (onSendProgress)         |
| Download progress   | No               | Yes (onReceiveProgress)      |
| FormData / multipart| Manual           | Built-in                     |
| Retry logic         | Manual           | Via interceptor or plugin    |
| Base URL / defaults | Manual           | Built-in BaseOptions         |
| Transformer         | No               | Yes (custom JSON parsing)    |
+---------------------+------------------+------------------------------+
```

The `http` package forces you to build all of these by hand. Dio gives you an architecture where cross-cutting concerns — auth, logging, retry — live in interceptors rather than being scattered across every API call.

**Example:**

```dart
// --- http package: manual headers every call ---
import 'package:http/http.dart' as http;

final response = await http.get(
  Uri.parse('https://api.example.com/users'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
);
// Must manually check statusCode, parse JSON, handle errors...

// --- Dio: configure once, use everywhere ---
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 15),
  headers: {'Content-Type': 'application/json'},
));

// Auth token injected via interceptor (shown in next question)
final response = await dio.get('/users');
// response.data is already parsed from JSON
```

**Why it matters:** The interviewer wants to know you've built real apps. Anyone who has dealt with token refresh, upload progress, or request cancellation in production knows why a thin wrapper like `http` isn't enough.

**Common mistake:** Saying "Dio is better because it's more popular." That's not a technical answer. Focus on interceptors, cancellation, and progress tracking — the actual architectural advantages.

---

**Q:** How do Dio interceptors work? How do you inject an auth token, and how do you handle a 401 with token refresh and a retry queue?

**A:** Dio interceptors sit in a pipeline — every request passes through `onRequest`, every response through `onResponse`, and every error through `onError`. You can modify, reject, or retry at each stage.

Token injection is straightforward: read the token in `onRequest` and attach it. The hard part is the 401 flow — when a token expires mid-flight, you need to refresh it *once*, then replay all queued requests that failed during the refresh.

```
Request Flow with Token Refresh:

  Request ──► onRequest (attach token) ──► Server
                                              │
                                         401 Unauthorized
                                              │
                                     ◄── onError ──┐
                                              │     │
                              ┌───────────────┘     │
                              ▼                     │
                    Is refresh in progress?         │
                     │              │               │
                    YES            NO               │
                     │              │               │
               Queue request   Lock + refresh       │
                     │              │               │
                     │         Get new token        │
                     │              │               │
                     │         Retry all queued ────┘
                     │              │
                     └──────► Retry with new token
```

**Example:**

```dart
class AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._dio, this._tokenStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        // QueuedInterceptor ensures only ONE refresh runs at a time.
        // All other 401s queue behind it automatically.
        final newToken = await _refreshToken();
        await _tokenStorage.saveAccessToken(newToken);

        // Retry the original request with the new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';
        final response = await _dio.fetch(options);
        handler.resolve(response);
      } catch (e) {
        // Refresh failed — force logout
        await _tokenStorage.clear();
        handler.reject(err);
      }
    } else {
      handler.next(err);
    }
  }

  Future<String> _refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    // Use a SEPARATE Dio instance to avoid interceptor loop
    final freshDio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
    ));
    final response = await freshDio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    return response.data['access_token'];
  }
}

// Registration — order matters
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
dio.interceptors.add(AuthInterceptor(dio, tokenStorage));
dio.interceptors.add(LogInterceptor()); // runs after auth
```

The critical detail: extend `QueuedInterceptor`, not `Interceptor`. `QueuedInterceptor` serializes error handling — so when three requests all get 401 simultaneously, only one triggers the refresh, and the other two wait in a queue. With plain `Interceptor`, you'd fire three refresh calls at once, likely invalidating tokens in a race condition.

**Why it matters:** Token refresh with retry is one of the most common real-world networking challenges. The interviewer is checking whether you've built it properly or if you'd introduce race conditions.

**Common mistake:** Using a regular `Interceptor` instead of `QueuedInterceptor`, or using the *same* Dio instance for the refresh call (which sends it through the interceptor again, creating an infinite loop).

---

**Q:** How do you implement global error handling in Dio? What are the `DioException` types and how do you handle each centrally?

**A:** Global error handling means catching every network error in one place — typically an interceptor — so individual API calls don't repeat the same try/catch logic. Dio wraps all HTTP failures into `DioException` with a `type` field that tells you exactly what went wrong.

```
DioExceptionType mapping:

  connectionTimeout  ──► Server didn't accept connection in time
  sendTimeout        ──► Request body took too long to upload
  receiveTimeout     ──► Server took too long to respond
  badCertificate     ──► SSL/TLS certificate validation failed
  badResponse        ──► Server responded with error status (4xx, 5xx)
  cancel             ──► Request was cancelled via CancelToken
  connectionError    ──► No connection (DNS failure, no internet)
  unknown            ──► Anything else (parsing error, etc.)
```

**Example:**

```dart
class GlobalErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToAppFailure(err);
    // You can log, show snackbar via event bus, or transform error
    handler.next(err.copyWith(error: failure));
  }

  AppFailure _mapToAppFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppFailure.timeout(
          'Server is taking too long. Please try again.',
        );

      case DioExceptionType.connectionError:
        return AppFailure.noConnection(
          'No internet connection. Check your network.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(err.response!);

      case DioExceptionType.badCertificate:
        return AppFailure.security(
          'Secure connection failed. Update the app.',
        );

      case DioExceptionType.cancel:
        return AppFailure.cancelled('Request was cancelled.');

      case DioExceptionType.unknown:
      default:
        return AppFailure.unexpected(
          'Something went wrong: ${err.message}',
        );
    }
  }

  AppFailure _handleBadResponse(Response response) {
    switch (response.statusCode) {
      case 400:
        return AppFailure.badRequest(
          response.data['message'] ?? 'Invalid request',
        );
      case 401:
        return AppFailure.unauthorized('Session expired.');
      case 403:
        return AppFailure.forbidden('Access denied.');
      case 404:
        return AppFailure.notFound('Resource not found.');
      case 422:
        return AppFailure.validation(response.data['errors']);
      case 429:
        return AppFailure.rateLimited('Too many requests.');
      case >= 500:
        return AppFailure.server('Server error. Try again later.');
      default:
        return AppFailure.unexpected('Error: ${response.statusCode}');
    }
  }
}

// Sealed class for typed error handling in UI
sealed class AppFailure {
  final String message;
  const AppFailure(this.message);

  factory AppFailure.timeout(String msg) = TimeoutFailure;
  factory AppFailure.noConnection(String msg) = NoConnectionFailure;
  factory AppFailure.server(String msg) = ServerFailure;
  factory AppFailure.unauthorized(String msg) = UnauthorizedFailure;
  factory AppFailure.forbidden(String msg) = ForbiddenFailure;
  factory AppFailure.notFound(String msg) = NotFoundFailure;
  factory AppFailure.badRequest(String msg) = BadRequestFailure;
  factory AppFailure.validation(dynamic errors) = ValidationFailure;
  factory AppFailure.rateLimited(String msg) = RateLimitedFailure;
  factory AppFailure.security(String msg) = SecurityFailure;
  factory AppFailure.cancelled(String msg) = CancelledFailure;
  factory AppFailure.unexpected(String msg) = UnexpectedFailure;
}
```

**Why it matters:** Shows you don't scatter try/catch blocks everywhere. The interviewer wants to see a centralized, typed error model that the UI can pattern-match on — not raw status codes leaking into widgets.

**Common mistake:** Catching all `DioException` as a single generic "network error." Each type has a different user-facing message and a different recovery strategy (retry for timeout, show offline banner for connectionError, force logout for 401).

---

**Q:** What are the key differences between REST and GraphQL? What are the trade-offs in a mobile context?

**A:** REST organizes APIs around resources with fixed endpoints — each URL returns a predetermined shape of data. GraphQL exposes a single endpoint where the client specifies exactly which fields it needs in a query.

```
REST: Multiple endpoints, fixed responses

  GET /users/42            → { id, name, email, avatar, bio, ... }
  GET /users/42/posts      → [{ id, title, body, createdAt, ... }]
  GET /users/42/followers  → [{ id, name, avatar, ... }]

  3 round trips, lots of unused fields on mobile

GraphQL: Single endpoint, flexible queries

  POST /graphql
  query {
    user(id: 42) {
      name
      avatar
      posts(first: 5) { title }
      followersCount
    }
  }

  1 round trip, only the fields the screen needs
```

Key differences in a mobile context:

*Over-fetching/Under-fetching:* REST endpoints return fixed payloads. A profile screen might only need `name` and `avatar`, but the endpoint returns 20 fields. With GraphQL, the client asks for exactly what it needs — critical on slow mobile connections.

*Round trips:* A single screen often aggregates data from multiple resources. REST requires multiple calls (or custom BFF endpoints). GraphQL composes it into one query.

*Caching:* REST caching is straightforward — HTTP caching by URL. GraphQL caching is harder because everything goes through POST to one URL. You need a normalized cache (like Apollo or Ferry in Flutter).

*File uploads:* REST handles multipart uploads natively. GraphQL requires the multipart-request spec or a separate REST endpoint for uploads.

*Error handling:* REST uses HTTP status codes. GraphQL always returns 200 and puts errors inside the response body, which makes global error interception trickier.

*Tooling in Flutter:* REST with Dio is mature and simple. GraphQL in Flutter uses `graphql_flutter` or `ferry` — more setup, code generation, but strong type safety.

**Example:**

```dart
// REST approach with Dio
final response = await dio.get('/users/42');
final user = UserModel.fromJson(response.data);
// If you need posts, that's a second call
final postsResponse = await dio.get('/users/42/posts');

// GraphQL approach with graphql_flutter
const query = r'''
  query GetUserProfile($id: ID!) {
    user(id: $id) {
      name
      avatar
      posts(first: 5) {
        title
        createdAt
      }
    }
  }
''';

final result = await client.query(
  QueryOptions(
    document: gql(query),
    variables: {'id': '42'},
  ),
);
// One call, exact data shape
```

**Why it matters:** The interviewer is testing whether you pick tools based on trade-offs, not hype. Many mobile apps are better served by REST + a thin BFF layer than full GraphQL.

**Common mistake:** Declaring GraphQL is "always better" because it solves over-fetching. In practice, the caching complexity, error handling quirks, and larger query payloads can outweigh the benefits for simple CRUD apps.

---

**Q:** What is certificate pinning, why does it matter, and how do you implement it in Flutter?

**A:** Certificate pinning means your app only trusts a specific certificate (or public key) for your server — not just any certificate signed by a Certificate Authority. This prevents man-in-the-middle (MITM) attacks where an attacker with a compromised or rogue CA certificate intercepts HTTPS traffic.

```
Normal HTTPS (trusts any valid CA):

  App ──► TLS Handshake ──► Server presents cert
                               │
                          Is it signed by ANY trusted CA?
                               │
                              YES → Connection accepted
                              (Attacker with rogue CA cert also passes ✓)

With Certificate Pinning:

  App ──► TLS Handshake ──► Server presents cert
                               │
                          Does the cert's public key match
                          the PIN hardcoded in our app?
                               │
                              YES → Connection accepted
                              NO  → Connection REJECTED
                              (Rogue CA cert fails ✗)
```

There are two pinning strategies: *certificate pinning* (pin the whole cert — must update app when cert rotates) and *public key pinning* (pin the key — survives cert renewal as long as the key stays the same). Public key pinning is preferred.

**Example:**

```dart
// Using dio + native pinning via dio_http2_adapter or custom
// SecurityContext approach for Dart's HttpClient:

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

Dio createPinnedDio() {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // Compare the SHA-256 fingerprint of the server's certificate
      // against our pinned value
      final pinnedFingerprint =
          'A1:B2:C3:D4:...'; // Your cert's SHA-256

      final serverFingerprint = cert.sha256Fingerprint;

      return serverFingerprint == pinnedFingerprint;
    };
    return client;
  };

  return dio;
}

// For more robust pinning, many teams use packages like
// flutter_cert_pinner or handle it in native code
// via TrustManager (Android) and URLSessionDelegate (iOS)
// using platform channels.
```

In practice, many production apps implement pinning at the native layer (using OkHttp's `CertificatePinner` on Android, `URLSession` delegate on iOS) via method channels, because Dart's `SecurityContext` has limitations — especially with public key extraction.

**Why it matters:** Interviewers ask this to gauge your security awareness. Apps handling financial data, health records, or auth tokens should pin certificates. It shows you think beyond "HTTPS is enough."

**Common mistake:** Pinning the leaf certificate instead of the public key. When the certificate rotates (every 90 days with Let's Encrypt), the app breaks unless you ship an update. Pin the public key or an intermediate CA key for safer rotation.

---

**Q:** How do you configure timeout and retry strategy in Flutter networking? What's the difference between connection timeout and receive timeout?

**A:** Connection timeout is how long the client waits to *establish a TCP connection* with the server. Receive timeout is how long it waits for the server to *send data* after the connection is already open. They protect against different failure modes.

```
Timeline of an HTTP request:

  ├── connectTimeout ──┤                       ├── receiveTimeout ──┤
  │                    │                       │                    │
  DNS ► TCP Handshake ► TLS ► Send Request ► Server Processing ► Response
       └─ connection ─┘                    └── receiving data ──────┘
       established here                       first byte to last byte

  sendTimeout covers: ├─ time to upload request body ─┤
```

*Connection timeout:* Set short (5–10s). If you can't connect in 10 seconds, the server is likely down or unreachable. Retrying makes sense here.

*Receive timeout:* Set based on your API's expected response time. A search endpoint might need 15s; a file download might need 60s. Retrying is less useful — the server might be processing.

*Send timeout:* Relevant for uploads. Set generous for large files.

**Example:**

```dart
// Global defaults
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: const Duration(seconds: 8),
  receiveTimeout: const Duration(seconds: 15),
  sendTimeout: const Duration(seconds: 15),
));

// Override per request for slow endpoints
final response = await dio.get(
  '/reports/generate',
  options: Options(
    receiveTimeout: const Duration(seconds: 60),
  ),
);

// Retry interceptor with exponential backoff
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < maxRetries) {
        final delay = Duration(
          milliseconds: 1000 * pow(2, retryCount).toInt(), // 1s, 2s, 4s
        );
        await Future.delayed(delay);

        err.requestOptions.extra['retryCount'] = retryCount + 1;

        try {
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Fall through to handler.next
        }
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}
```

Key retry rules: retry on timeouts and 5xx server errors, never retry on 4xx (client errors — resending the same bad request won't help), and use exponential backoff to avoid hammering a struggling server.

**Why it matters:** Shows you understand the network lifecycle and can make informed trade-offs. Aggressive retries without backoff can DDoS your own server during outages.

**Common mistake:** Setting a single large timeout (60s for everything) instead of tuning each timeout type. Also: retrying 400 or 422 errors, which are deterministic client-side failures.

---

**Q:** What is the Either/Result type pattern? Why is it better than throwing exceptions across layers, and how do you implement it?

**A:** The Either/Result type makes function signatures *honest* — the return type tells you "this can succeed with data OR fail with an error." Instead of throwing exceptions that callers might forget to catch, you return a value that forces the caller to handle both cases.

```
Exception approach (hidden failure path):

  Future<User> getUser()    ← Signature says "returns User"
                            ← Actually can throw 5 different exceptions
                            ← Caller might not know about any of them

Either approach (explicit contract):

  Future<Either<Failure, User>> getUser()
                            ← Signature says "returns Failure OR User"
                            ← Caller MUST handle both cases
                            ← No hidden control flow
```

Exceptions should stay at the boundary (network layer, database layer). Once you cross into your domain/business logic, use typed return values.

**Example:**

```dart
// Minimal Either using Dart 3 sealed classes
sealed class Either<L, R> {
  const Either();
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
}

// Extension for ergonomic use
extension EitherX<L, R> on Either<L, R> {
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    return switch (this) {
      Left(:final value) => onLeft(value),
      Right(:final value) => onRight(value),
    };
  }
}

// --- Usage in repository ---
class UserRepository {
  final Dio _dio;
  UserRepository(this._dio);

  Future<Either<AppFailure, User>> getUser(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      final user = User.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(AppFailure.unexpected(e.toString()));
    }
  }

  AppFailure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return AppFailure.noConnection('No internet');
    }
    return AppFailure.server('Server error');
  }
}

// --- Usage in ViewModel / Cubit ---
class UserCubit extends Cubit<UserState> {
  final UserRepository _repo;
  UserCubit(this._repo) : super(UserInitial());

  Future<void> loadUser(String id) async {
    emit(UserLoading());

    final result = await _repo.getUser(id);

    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
    // No try/catch needed — failure is a VALUE, not an exception
  }
}
```

In production, most teams use the `dartz` or `fpdart` package for a battle-tested `Either` type with `map`, `flatMap`, and other functional combinators.

**Why it matters:** This shows you design API boundaries intentionally. The interviewer is checking for clean architecture thinking — exceptions for truly exceptional situations, typed values for expected failures like "user not found" or "no internet."

**Common mistake:** Using `Either` but then calling `.fold()` only for the success case and ignoring the left/failure side. Also: wrapping *everything* in Either, including internal utility functions where a simple throw is fine.

---

**Q:** How do you handle no internet connection gracefully in a Flutter app?

**A:** Handling no-connectivity gracefully requires multiple layers: detecting the state, informing the user without blocking them, and serving cached data when possible.

```
Connectivity handling layers:

  ┌──────────────────────────────┐
  │  UI Layer                    │
  │  - Offline banner / snackbar │
  │  - Disable/enable actions    │
  │  - Show cached data          │
  └──────────┬───────────────────┘
             │
  ┌──────────▼───────────────────┐
  │  State Layer                 │
  │  - ConnectivityCubit         │
  │  - Stream-based monitoring   │
  └──────────┬───────────────────┘
             │
  ┌──────────▼───────────────────┐
  │  Network Layer               │
  │  - Dio interceptor           │
  │  - Fallback to cache         │
  │  - Queue writes for sync     │
  └──────────────────────────────┘
```

**Example:**

```dart
// 1. Monitor connectivity with connectivity_plus
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  late final StreamSubscription _sub;

  ConnectivityCubit() : super(ConnectivityStatus.online) {
    _sub = Connectivity()
        .onConnectivityChanged
        .listen((results) async {
      // connectivity_plus tells you the INTERFACE (wifi, mobile),
      // NOT whether the internet actually works.
      // Always verify with a real ping.
      final hasInternet = await _checkActualInternet();
      emit(hasInternet
          ? ConnectivityStatus.online
          : ConnectivityStatus.offline);
    });
  }

  Future<bool> _checkActualInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}

// 2. Dio interceptor: fall back to cache on connection errors
class OfflineCacheInterceptor extends Interceptor {
  final LocalCacheSource _cache;

  OfflineCacheInterceptor(this._cache);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Cache successful GET responses
    if (response.requestOptions.method == 'GET') {
      final key = response.requestOptions.uri.toString();
      _cache.put(key, response.data);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError &&
        err.requestOptions.method == 'GET') {
      final key = err.requestOptions.uri.toString();
      final cached = _cache.get(key);
      if (cached != null) {
        handler.resolve(Response(
          requestOptions: err.requestOptions,
          data: cached,
          statusCode: 200,
          statusMessage: 'FROM_CACHE',
        ));
        return;
      }
    }
    handler.next(err);
  }
}

// 3. UI: show persistent offline banner
class AppShell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (context, status) {
        return Column(
          children: [
            if (status == ConnectivityStatus.offline)
              const MaterialBanner(
                content: Text('You are offline. Showing cached data.'),
                actions: [SizedBox.shrink()],
                backgroundColor: Colors.orange,
              ),
            Expanded(child: MainContent()),
          ],
        );
      },
    );
  }
}
```

**Why it matters:** Mobile apps *will* lose connectivity. The interviewer wants to see you've designed for it — not just caught the error, but provided a degraded experience that still functions.

**Common mistake:** Relying solely on `connectivity_plus` to determine internet status. It only reports the *interface type* (wifi, cellular). You can be connected to wifi with no actual internet. Always verify with a real DNS lookup or ping.

---

## LOCAL STORAGE

---

**Q:** What does `SharedPreferences` store, is it thread-safe, and what are its limitations?

**A:** `SharedPreferences` is a key-value store backed by `NSUserDefaults` on iOS and `SharedPreferences` (XML file) on Android. It stores primitive types: `String`, `int`, `double`, `bool`, and `List<String>`. That's it — no maps, no custom objects.

```
SharedPreferences architecture:

  Dart code
     │
     ▼
  SharedPreferences plugin
     │
     ├──► iOS: NSUserDefaults (plist file)
     │
     └──► Android: SharedPreferences (XML in /data/data/<pkg>/shared_prefs/)
```

Thread safety: The Flutter plugin reads the entire file into memory at `getInstance()` and writes asynchronously. Within a single isolate, it's safe. Across isolates or with native code writing to the same file, you can get race conditions.

Limitations: no encryption, no complex types, the entire file is loaded into memory (bad if it grows large), no query capability, and it's not designed for large datasets. It's a settings store, not a database.

**Example:**

```dart
// Write
final prefs = await SharedPreferences.getInstance();
await prefs.setString('locale', 'en');
await prefs.setBool('onboarding_complete', true);
await prefs.setInt('launch_count', 5);

// Read
final locale = prefs.getString('locale') ?? 'en';
final onboarded = prefs.getBool('onboarding_complete') ?? false;

// Remove
await prefs.remove('locale');

// Storing complex objects — must serialize manually
import 'dart:convert';
final userJson = jsonEncode(user.toJson());
await prefs.setString('cached_user', userJson);
// This is a code smell — use Hive or SQLite instead
```

**Why it matters:** Interviewers want to confirm you know what SharedPreferences is *for* — small, simple settings — and that you wouldn't try to store a list of 10,000 products in it.

**Common mistake:** Storing sensitive data (tokens, passwords) in SharedPreferences. It's plain text on disk. Use `flutter_secure_storage` for anything sensitive. Also: serializing complex JSON into SharedPreferences — that's what Hive or SQLite is for.

---

**Q:** What is Hive, what are boxes and TypeAdapters, and when should you prefer it over SharedPreferences?

**A:** Hive is a lightweight, pure-Dart, NoSQL key-value database. It's fast because it's written entirely in Dart (no platform channels), stores data in binary format, and supports custom objects natively through TypeAdapters.

A *box* is Hive's equivalent of a table or collection — a named container of key-value pairs. You open a box, read/write to it, and close it when done. Boxes can be encrypted.

A *TypeAdapter* tells Hive how to serialize and deserialize your custom Dart objects to/from binary. You register adapters before opening boxes.

```
SharedPreferences vs Hive:

  ┌───────────────────┬──────────────────┬─────────────────────┐
  │ Feature           │ SharedPreferences │ Hive                │
  ├───────────────────┼──────────────────┼─────────────────────┤
  │ Data types        │ Primitives only  │ Any (via adapters)  │
  │ Speed             │ Slow (XML parse) │ Fast (binary)       │
  │ Encryption        │ No               │ Yes (AES-256)       │
  │ Platform channels │ Yes              │ No (pure Dart)      │
  │ Lazy loading      │ No (loads all)   │ Yes (LazyBox)       │
  │ Complex objects   │ JSON workaround  │ Native support      │
  │ Use case          │ Simple settings  │ Structured cache    │
  └───────────────────┴──────────────────┴─────────────────────┘
```

**Example:**

```dart
// 1. Define model with annotations (uses hive_generator)
import 'package:hive/hive.dart';

part 'task.g.dart'; // generated file

@HiveType(typeId: 0) // unique ID per type, never reuse
class Task extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late bool completed;

  @HiveField(2) // new fields get new indices; never change old ones
  late DateTime createdAt;
}

// 2. Register adapter and open box (in main.dart)
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter()); // generated adapter
  await Hive.openBox<Task>('tasks');
  runApp(MyApp());
}

// 3. CRUD operations
final box = Hive.box<Task>('tasks');

// Create
final task = Task()
  ..title = 'Buy groceries'
  ..completed = false
  ..createdAt = DateTime.now();
await box.add(task); // auto-incrementing int key

// Read
final allTasks = box.values.toList();
final singleTask = box.getAt(0);

// Update
task.completed = true;
await task.save(); // HiveObject provides save()

// Delete
await task.delete();

// Encrypted box
final encryptionKey = Hive.generateSecureKey();
// Store encryptionKey in flutter_secure_storage
await Hive.openBox<Task>(
  'secure_tasks',
  encryptionCipher: HiveAesCipher(encryptionKey),
);
```

Prefer Hive over SharedPreferences when: you need to store custom objects, need encryption, have more than ~20 key-value pairs, need lazy loading for large datasets, or want to avoid platform channel overhead.

**Why it matters:** Interviewers check that you choose storage solutions based on requirements. Hive fills the gap between "simple settings" (SharedPreferences) and "relational data" (SQLite).

**Common mistake:** Reusing `typeId` values across different classes or changing `@HiveField` indices after release — both corrupt stored data. Also: forgetting to call `Hive.registerAdapter()` before opening a box that contains that type.

---

**Q:** When do you need SQLite / Drift (formerly Moor) in Flutter, and how do you write basic queries in Drift?

**A:** You need a relational database when your data has relationships (users → posts → comments), you need complex queries (joins, aggregation, full-text search), or you need ACID transactions. SharedPreferences and Hive are key-value stores — they can't efficiently answer "give me all orders from the last 7 days grouped by status."

Drift is a reactive, type-safe SQLite wrapper for Dart. You define tables as Dart classes, and Drift generates the query API, migrations, and data classes at build time.

```
Storage decision tree:

  Need to store data?
       │
  Simple key-value (settings, flags)?
       │── YES → SharedPreferences
       │
  Structured objects, moderate size, no relations?
       │── YES → Hive
       │
  Relations, complex queries, joins, transactions?
       │── YES → SQLite / Drift
```

**Example:**

```dart
import 'package:drift/drift.dart';

part 'database.g.dart'; // generated

// Define tables as Dart classes
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().unique()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class Posts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  IntColumn get authorId => integer().references(Users, #id)();
  BoolColumn get published =>
      boolean().withDefault(const Constant(false))();
}

// Database class
@DriftDatabase(tables: [Users, Posts])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  // Queries — type-safe, auto-completed
  Future<List<User>> getAllUsers() => select(users).get();

  Future<User> getUserById(int id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingle();

  Stream<List<User>> watchAllUsers() => select(users).watch();
  // ^ Reactive! Emits new list whenever users table changes.

  Future<int> insertUser(UsersCompanion user) =>
      into(users).insert(user);

  // Joins: get posts with author name
  Future<List<({Post post, String authorName})>> getPostsWithAuthors() {
    final query = select(posts).join([
      innerJoin(users, users.id.equalsExp(posts.authorId)),
    ]);
    return query.map((row) {
      return (
        post: row.readTable(posts),
        authorName: row.readTable(users).name,
      );
    }).get();
  }

  // Filtered query
  Future<List<Post>> getPublishedPostsByUser(int userId) {
    return (select(posts)
          ..where((p) =>
              p.authorId.equals(userId) & p.published.equals(true))
          ..orderBy([(p) => OrderingTerm.desc(p.id)]))
        .get();
  }

  // Transaction
  Future<void> createUserWithPost(String name, String email,
      String title, String body) {
    return transaction(() async {
      final userId = await into(users).insert(UsersCompanion.insert(
        name: name,
        email: email,
      ));
      await into(posts).insert(PostsCompanion.insert(
        title: title,
        body: body,
        authorId: userId,
      ));
    });
  }
}
```

**Why it matters:** The interviewer is checking whether you'd reach for SQLite at the right time — not force a key-value store into a relational role, and not use a relational DB for simple settings.

**Common mistake:** Writing raw SQL strings instead of using Drift's type-safe API (losing compile-time checks), or skipping migration logic and breaking existing users' local data on schema changes.

---

**Q:** What does Flutter Secure Storage use under the hood, and when should you use it?

**A:** `flutter_secure_storage` provides encrypted key-value storage. On iOS, it uses the **Keychain** — Apple's hardware-backed secure enclave. On Android, it uses the **Android Keystore** system to generate an AES key, which encrypts values stored in `EncryptedSharedPreferences` (API 23+).

```
flutter_secure_storage architecture:

  ┌────────────────────┐
  │  Dart API           │
  │  read / write / del │
  └────────┬───────────┘
           │
     ┌─────┴──────┐
     ▼            ▼
  ┌───────┐   ┌──────────────────────────────┐
  │  iOS  │   │  Android                     │
  │       │   │                              │
  │Keychain│   │ Keystore (generates AES key) │
  │       │   │       ↓                      │
  │(HW-   │   │ EncryptedSharedPreferences   │
  │backed)│   │ (AES-256 encrypted values)   │
  └───────┘   └──────────────────────────────┘
```

Use it for: auth tokens, refresh tokens, API keys, encryption keys for Hive, biometric-gated secrets, and any PII that must be encrypted at rest.

Do *not* use it for: large datasets, frequently accessed data (it's slower than SharedPreferences due to encryption), or non-sensitive settings.

**Example:**

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Store tokens after login
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // Read
  Future<String?> getAccessToken() =>
      _storage.read(key: 'access_token');

  // Delete on logout
  Future<void> clearAll() => _storage.deleteAll();

  // Store Hive encryption key securely
  Future<void> saveHiveKey(List<int> key) async {
    final encoded = base64Encode(key);
    await _storage.write(key: 'hive_encryption_key', value: encoded);
  }

  Future<List<int>?> getHiveKey() async {
    final encoded = await _storage.read(key: 'hive_encryption_key');
    if (encoded == null) return null;
    return base64Decode(encoded);
  }
}
```

**Why it matters:** Storing tokens in plain text SharedPreferences is a real security vulnerability on rooted/jailbroken devices. The interviewer wants to see that you know where secrets belong.

**Common mistake:** Using `flutter_secure_storage` for all data (including non-sensitive settings) — it's slow. Also: not setting `encryptedSharedPreferences: true` on Android, which falls back to a less secure AES implementation on older versions.

---

**Q:** How do you implement offline-first architecture in Flutter?

**A:** Offline-first means the local database is the single source of truth for the UI. The app reads from local storage first, displays immediately, then syncs with the server in the background. Network calls update the local store, and the UI reacts to local store changes.

```
Offline-first data flow:

  ┌──────────────────────────────────────────────────┐
  │                                                  │
  │   UI ◄──── watches ────── Local DB (source of    │
  │                           truth)                 │
  │                              ▲                   │
  │                              │                   │
  │                         writes to                │
  │                              │                   │
  │                        Repository                │
  │                         ▲       │                │
  │                         │       ▼                │
  │                    sync when   fetch from        │
  │                    online      API               │
  │                         │       │                │
  │                         └───┬───┘                │
  │                             ▼                    │
  │                         Remote API               │
  └──────────────────────────────────────────────────┘

Write flow (offline-first):

  1. User creates item
  2. Save to local DB immediately (with syncStatus = pending)
  3. UI updates instantly (from local DB stream)
  4. Background: try to push to server
  5. On success: update syncStatus = synced
  6. On failure: keep as pending, retry later
```

**Example:**

```dart
// Domain model with sync metadata
class Task {
  final String id;
  final String title;
  final bool completed;
  final SyncStatus syncStatus; // pending, synced, failed
  final DateTime updatedAt;
  // ...
}

enum SyncStatus { pending, synced, failed }

// Repository — local-first, server-second
class TaskRepository {
  final TaskLocalSource _local;   // Drift or Hive
  final TaskRemoteSource _remote; // Dio API client

  // UI subscribes to this — always reads from local DB
  Stream<List<Task>> watchTasks() => _local.watchAll();

  // Create: save locally first, then sync
  Future<void> createTask(String title) async {
    final task = Task(
      id: const Uuid().v4(), // client-generated UUID
      title: title,
      completed: false,
      syncStatus: SyncStatus.pending,
      updatedAt: DateTime.now(),
    );

    await _local.insert(task); // UI updates instantly via stream

    try {
      await _remote.create(task);
      await _local.updateSyncStatus(task.id, SyncStatus.synced);
    } catch (_) {
      // Will be retried by SyncManager
    }
  }

  // Pull fresh data from server
  Future<void> refresh() async {
    try {
      final serverTasks = await _remote.fetchAll();
      await _local.upsertAll(serverTasks); // merge into local DB
    } catch (_) {
      // Offline — UI still shows local data
    }
  }
}

// Background sync manager
class SyncManager {
  final TaskLocalSource _local;
  final TaskRemoteSource _remote;
  final ConnectivityCubit _connectivity;

  void startSync() {
    // When connection is restored, push pending items
    _connectivity.stream
        .where((s) => s == ConnectivityStatus.online)
        .listen((_) => _pushPendingChanges());
  }

  Future<void> _pushPendingChanges() async {
    final pending = await _local.getByStatus(SyncStatus.pending);
    for (final task in pending) {
      try {
        await _remote.upsert(task);
        await _local.updateSyncStatus(task.id, SyncStatus.synced);
      } catch (_) {
        await _local.updateSyncStatus(task.id, SyncStatus.failed);
      }
    }
  }
}
```

**Why it matters:** Offline-first is expected in modern mobile apps. The interviewer is checking if you can design the local-DB-as-source-of-truth pattern, handle conflict resolution, and manage sync state.

**Common mistake:** Making the network call the source of truth and only caching as a fallback. That's "offline-capable," not "offline-first." True offline-first means the UI *never* waits for a network call to display data.

---

**Q:** How do you keep local cached data in sync with the server?

**A:** There are several sync strategies, and the right one depends on your conflict model and data volume.

```
Sync strategies:

  1. Pull-to-refresh (simplest)
     Client pulls all data on demand. No conflict handling.
     Good for: read-heavy, infrequent changes.

  2. Timestamp-based delta sync
     Client sends lastSyncedAt, server returns only changes since then.
     Good for: moderate data, server is authority.

  3. Event queue / change log
     Client queues mutations locally, pushes when online.
     Server applies or rejects. Good for: offline-heavy.

  4. CRDT / operational transform
     Automatic conflict resolution via data structure math.
     Good for: collaborative, concurrent edits (complex).
```

**Example:**

```dart
// Timestamp-based delta sync — most common in production

class SyncService {
  final LocalDatabase _local;
  final ApiClient _remote;
  final SharedPreferences _prefs;

  Future<void> sync() async {
    await _pushLocalChanges();
    await _pullRemoteChanges();
  }

  // Push: send locally modified items to server
  Future<void> _pushLocalChanges() async {
    final pendingItems = await _local.getPending();

    for (final item in pendingItems) {
      try {
        final serverItem = await _remote.upsert(item);
        // Server may modify the item (add server timestamp, etc.)
        await _local.upsert(serverItem.copyWith(
          syncStatus: SyncStatus.synced,
        ));
      } on ConflictException catch (e) {
        // Server version wins (or present conflict to user)
        await _local.upsert(e.serverVersion.copyWith(
          syncStatus: SyncStatus.synced,
        ));
      }
    }
  }

  // Pull: get changes since last sync
  Future<void> _pullRemoteChanges() async {
    final lastSync = _prefs.getString('last_sync_at');

    final changes = await _remote.getChanges(since: lastSync);

    for (final change in changes) {
      switch (change.type) {
        case ChangeType.upsert:
          await _local.upsert(change.item.copyWith(
            syncStatus: SyncStatus.synced,
          ));
        case ChangeType.delete:
          await _local.delete(change.itemId);
      }
    }

    await _prefs.setString(
      'last_sync_at',
      DateTime.now().toUtc().toIso8601String(),
    );
  }
}

// API contract for delta sync
// GET /items?since=2025-01-01T00:00:00Z
// Response: {
//   "changes": [
//     { "type": "upsert", "item": {...}, "updatedAt": "..." },
//     { "type": "delete", "itemId": "abc", "deletedAt": "..." }
//   ]
// }
```

For conflict resolution, the most common strategies are: *last-write-wins* (simpler, based on timestamp), *server-wins* (server always authoritative), *client-wins* (dangerous, rarely used), and *manual merge* (show user both versions).

**Why it matters:** The interviewer wants to see that you've thought about the hard parts: conflict resolution, partial failures mid-sync, and idempotent operations. Sync is where most offline architectures fall apart.

**Common mistake:** Using `createdAt` instead of `updatedAt` for delta sync — you'd miss all edits. Also: not making push operations idempotent. If a sync push succeeds but the local status update fails, the next sync resends the same item — the server must handle duplicates gracefully.

---

**Q:** How do you encrypt local data in Flutter?

**A:** There are three layers of encryption depending on what you're storing:

```
Encryption options by use case:

  ┌──────────────────┬─────────────────────┬──────────────────┐
  │ Data type        │ Solution            │ Encryption       │
  ├──────────────────┼─────────────────────┼──────────────────┤
  │ Secrets/tokens   │ flutter_secure_     │ Keychain/Keystore│
  │                  │ storage             │ (OS-managed)     │
  │                  │                     │                  │
  │ Structured cache │ Hive encrypted box  │ AES-256 (key     │
  │ (objects)        │                     │ stored securely) │
  │                  │                     │                  │
  │ Relational data  │ SQLCipher via       │ AES-256 on whole │
  │                  │ sqflite_sqlcipher   │ DB file           │
  │                  │                     │                  │
  │ Arbitrary files  │ encrypt package     │ AES / Salsa20    │
  │                  │ or pointycastle     │ (manual)         │
  └──────────────────┴─────────────────────┴──────────────────┘
```

The key principle: *never hardcode encryption keys in Dart code*. Generate them and store them in `flutter_secure_storage`, which delegates to the OS-level keychain/keystore.

**Example:**

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

// === Strategy 1: Hive encrypted box ===

class EncryptedHiveStorage {
  static const _secureStorage = FlutterSecureStorage();
  static const _keyName = 'hive_aes_key';

  static Future<List<int>> _getOrCreateKey() async {
    final existing = await _secureStorage.read(key: _keyName);
    if (existing != null) {
      return base64Decode(existing);
    }
    final newKey = Hive.generateSecureKey(); // 32 bytes
    await _secureStorage.write(
      key: _keyName,
      value: base64Encode(newKey),
    );
    return newKey;
  }

  static Future<Box<T>> openEncryptedBox<T>(String name) async {
    final key = await _getOrCreateKey();
    return Hive.openBox<T>(
      name,
      encryptionCipher: HiveAesCipher(key),
    );
  }
}

// Usage
final box = await EncryptedHiveStorage.openEncryptedBox<Task>('tasks');

// === Strategy 2: SQLCipher for encrypted SQLite ===

// pubspec.yaml: sqflite_sqlcipher: ^x.x.x
import 'package:sqflite_sqlcipher/sqflite_sqlcipher.dart';

final db = await openDatabase(
  'app.db',
  password: await _getDbPassword(), // from secure storage
  version: 1,
  onCreate: (db, version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  },
);

// === Strategy 3: Manual file encryption ===

class FileEncryptor {
  final encrypt.Key _key;
  final encrypt.IV _iv;
  late final encrypt.Encrypter _encrypter;

  FileEncryptor(List<int> keyBytes)
      : _key = encrypt.Key(Uint8List.fromList(keyBytes)),
        _iv = encrypt.IV.fromLength(16) {
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  String encryptText(String plaintext) {
    return _encrypter.encrypt(plaintext, iv: _iv).base64;
  }

  String decryptText(String ciphertext) {
    return _encrypter.decrypt64(ciphertext, iv: _iv);
  }
}
```

**Why it matters:** Data-at-rest encryption is a compliance requirement for health, finance, and government apps. The interviewer is testing whether you understand the key management chain — encryption is only as strong as where you store the key.

**Common mistake:** Generating an encryption key and storing it in SharedPreferences or hardcoding it in source code. If the key isn't protected by the OS keychain/keystore, the encryption is theater — anyone with device access can read the key and decrypt the data. Another mistake: using a static IV for AES — each encryption operation should ideally use a unique IV.
