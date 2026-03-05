# Section 14: Design Patterns (Gang of Four)

> **Flutter Senior Engineer Interview Prep**
> All examples in Dart · Real-world Flutter usage · GoF patterns applied to modern mobile development

---

## Table of Contents

### Creational Patterns
1. [Singleton](#1-singleton)
2. [Factory Method](#2-factory-method)
3. [Abstract Factory](#3-abstract-factory)
4. [Builder](#4-builder)

### Structural Patterns
5. [Adapter](#5-adapter)
6. [Decorator](#6-decorator)
7. [Facade](#7-facade)
8. [Proxy](#8-proxy)
9. [Composite](#9-composite)

### Behavioral Patterns
10. [Observer](#10-observer)
11. [Strategy](#11-strategy)
12. [Command](#12-command)
13. [State Pattern](#13-state-pattern)
14. [Template Method](#14-template-method)
15. [Iterator](#15-iterator)

---

## CREATIONAL PATTERNS

---

### 1. Singleton

---

**Q:** What is the Singleton pattern, how do you implement it in Dart, and what is the thread-safety concern? Give a real Flutter example.

**A:** Singleton ensures that **only one instance of a class ever exists** across the entire app lifetime. Every caller gets the same object. It's useful when you need a single, shared point of access — like a service locator, a config store, or a database connection.

In Dart, the standard implementation uses a **factory constructor** that always returns the same private instance:

```dart
// Basic Singleton in Dart
class AppConfig {
  // 1. Private static instance — lives at the class level
  static final AppConfig _instance = AppConfig._internal();

  // 2. Private named constructor — prevents external instantiation
  AppConfig._internal();

  // 3. Factory constructor — always returns the same instance
  factory AppConfig() => _instance;

  // Actual fields / methods
  String apiBaseUrl = 'https://api.example.com';
  bool isDarkMode = false;
}

void main() {
  final a = AppConfig();
  final b = AppConfig();
  print(identical(a, b)); // true — same instance
}
```

**Thread-safety concern:**

Dart is **single-threaded within an isolate**. The event loop processes one task at a time, so there is no classic race condition when creating the singleton — `static final` fields are initialized lazily and safely.

However, if you spawn **multiple Isolates**, each gets its own memory heap and its own singleton instance. There is no shared memory between isolates, so a singleton is not truly global across isolates. Communicate between isolates via `SendPort`/`ReceivePort` instead.

```
Single Isolate (safe):
┌──────────────────────────────────┐
│  Event Loop (single-threaded)    │
│  ┌──────────┐                    │
│  │ Singleton│ ← all callers      │
│  │ instance │   get this one     │
│  └──────────┘                    │
└──────────────────────────────────┘

Multiple Isolates (not shared):
┌────────────┐    ┌────────────┐
│ Isolate A  │    │ Isolate B  │
│ Singleton1 │    │ Singleton2 │  ← DIFFERENT objects!
└────────────┘    └────────────┘
```

**Flutter Real-World Example — GetIt Service Locator:**

`GetIt` is the most popular service locator in Flutter. It is itself a singleton that registers and resolves other singletons (and factories).

```dart
// pubspec.yaml: get_it: ^7.6.0
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance; // The one global GetIt singleton

// setup.dart — run once at app startup
void setupLocator() {
  // Register ApiService as a lazy singleton
  // (created only when first requested)
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // Register AuthRepository as a singleton
  sl.registerSingleton<AuthRepository>(AuthRepository(sl<ApiService>()));
}

// Usage anywhere in the app — no BuildContext needed
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _auth = sl<AuthRepository>(); // same instance every time
  LoginCubit() : super(LoginInitial());
}

// main.dart
void main() {
  setupLocator();
  runApp(const MyApp());
}
```

**When to USE it:**
- Service locators / dependency injection containers
- App-wide configuration or settings
- Database or network client wrappers that are expensive to create
- Logger instances

**When NOT to use it:**
- As a replacement for proper state management (it becomes global mutable state)
- When you need separate instances per test — singletons make unit testing painful unless you reset them
- When multiple isolates genuinely need independent state

**Why it matters:** The interviewer is checking whether you understand memory models, Dart's concurrency model (isolates vs threads), and that you know the pitfalls of global state in large apps.

**Common mistake:** Candidates say "Dart is thread-safe so singleton is always fine." That ignores isolates entirely. Also, many confuse `registerLazySingleton` with `registerFactory` in GetIt — one creates one instance, the other creates a new one each time.

---

### 2. Factory Method

---

**Q:** What is the Factory Method pattern and when would you use it in a Dart/Flutter codebase?

**A:** Factory Method defines an **interface for creating an object, but lets subclasses decide which class to instantiate**. The creator class delegates the "which type to create" decision to its subclasses. This decouples client code from concrete implementations.

Think of it this way: the parent class says *"I need a Logger — go make me one"* but doesn't care if it's a `FileLogger` or `ConsoleLogger`. The subclass makes that decision.

```
Creator (abstract)
    │
    ├── factoryMethod() → Product   ← abstract method
    │
    ├── ConcreteCreatorA
    │       └── factoryMethod() → ConcreteProductA
    │
    └── ConcreteCreatorB
            └── factoryMethod() → ConcreteProductB
```

**Example:**

```dart
// Abstract product
abstract class Logger {
  void log(String message);
}

// Concrete products
class ConsoleLogger implements Logger {
  @override
  void log(String message) => print('[CONSOLE] $message');
}

class FileLogger implements Logger {
  @override
  void log(String message) => print('[FILE] Writing: $message');
}

class RemoteLogger implements Logger {
  @override
  void log(String message) => print('[REMOTE] Sending: $message');
}

// Abstract creator with the factory method
abstract class LoggerFactory {
  // This IS the factory method
  Logger createLogger();

  // The creator uses its own factory method internally
  void logEvent(String event) {
    final logger = createLogger(); // delegates creation to subclass
    logger.log(event);
  }
}

// Concrete creators
class DebugLoggerFactory extends LoggerFactory {
  @override
  Logger createLogger() => ConsoleLogger();
}

class ProductionLoggerFactory extends LoggerFactory {
  @override
  Logger createLogger() => RemoteLogger();
}

void main() {
  // Swap this one line to change the entire logging strategy
  final LoggerFactory factory = const bool.fromEnvironment('dart.vm.product')
      ? ProductionLoggerFactory()
      : DebugLoggerFactory();

  factory.logEvent('App started');
}
```

**Flutter Real-World Usage — `PageRoute` factories:**

```dart
// Flutter's Navigator uses factory method internally.
// You define WHICH route to create, Flutter calls the factory.
MaterialPageRoute(builder: (context) => const HomeScreen())
CupertinoPageRoute(builder: (context) => const HomeScreen())

// You can create your own:
abstract class AppRoute {
  Route<dynamic> createRoute(RouteSettings settings);
}

class FadeRoute extends AppRoute {
  @override
  Route<dynamic> createRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => settings.arguments as Widget,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
```

**When to USE it:**
- When the exact type of object to create isn't known until runtime
- When you want subclasses to control what gets created
- When you need to swap implementations without changing client code (debug vs prod, platform-specific)

**When NOT to use it:**
- When there's only one possible product type — overkill
- When a simple `if/switch` or constructor call solves the problem cleanly

**Why it matters:** Tests whether you understand the open/closed principle — open for extension (add a new factory subclass), closed for modification (existing client code doesn't change).

**Common mistake:** Confusing Factory Method (class-based, uses inheritance) with the simpler "static factory" pattern (just a static method that returns an instance). They are different patterns.

---

### 3. Abstract Factory

---

**Q:** What is the Abstract Factory pattern and how does it differ from Factory Method?

**A:** Abstract Factory provides an **interface for creating families of related objects** without specifying their concrete classes. Where Factory Method creates *one* product via subclassing, Abstract Factory creates *multiple related products* through *composition* — you hand a factory object to clients, and the factory knows how to create a coordinated set of things.

```
                    AbstractFactory (interface)
                   /                           \
        LightThemeFactory               DarkThemeFactory
        ├── createButton() → LightBtn   ├── createButton() → DarkBtn
        └── createCard()   → LightCard  └── createCard()   → DarkCard
```

The key difference:

| | Factory Method | Abstract Factory |
|---|---|---|
| Mechanism | Inheritance (subclass overrides) | Composition (inject a factory object) |
| Creates | ONE product type | A FAMILY of related products |
| Extensibility | Add new creator subclass | Add new factory class |

**Example — UI Theme Factory:**

```dart
// Abstract products
abstract class AppButton {
  Widget build(String label, VoidCallback onTap);
}

abstract class AppCard {
  Widget build(Widget child);
}

// Concrete products — Light theme
class LightButton implements AppButton {
  @override
  Widget build(String label, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }
}

class LightCard implements AppCard {
  @override
  Widget build(Widget child) {
    return Card(color: Colors.white, elevation: 2, child: child);
  }
}

// Concrete products — Dark theme
class DarkButton implements AppButton {
  @override
  Widget build(String label, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

class DarkCard implements AppCard {
  @override
  Widget build(Widget child) {
    return Card(color: Colors.grey[850], elevation: 4, child: child);
  }
}

// Abstract Factory interface
abstract class UIFactory {
  AppButton createButton();
  AppCard createCard();
}

// Concrete factories
class LightUIFactory implements UIFactory {
  @override AppButton createButton() => LightButton();
  @override AppCard createCard() => LightCard();
}

class DarkUIFactory implements UIFactory {
  @override AppButton createButton() => DarkButton();
  @override AppCard createCard() => DarkCard();
}

// Client — only knows UIFactory, not the concrete classes
class ProductScreen extends StatelessWidget {
  final UIFactory factory;
  const ProductScreen({required this.factory, super.key});

  @override
  Widget build(BuildContext context) {
    return factory.createCard().build(
      factory.createButton().build('Buy Now', () {}),
    );
  }
}

// At app root — swap one line to change the whole family
final UIFactory uiFactory = isDarkMode ? DarkUIFactory() : LightUIFactory();
```

**When to USE it:**
- When you need to ensure a set of products work together (a "family")
- Cross-platform UI (Material vs Cupertino widgets)
- Theme systems where multiple components must be coordinated

**When NOT to use it:**
- When products don't have meaningful relationships to each other
- When you only have one product type (use Factory Method instead)
- When the number of product families is small and unlikely to grow

**Why it matters:** Tests understanding of abstraction boundaries and the difference between creating objects via inheritance vs via injected factory objects. Common in platform-abstraction layers.

**Common mistake:** Candidates describe Abstract Factory as "just a factory with more methods." The key insight is the *family* guarantee — all products from one factory are designed to work together.

---

### 4. Builder

---

**Q:** What is the Builder pattern and where does it appear in Flutter?

**A:** Builder separates the **construction of a complex object from its representation**. Instead of a constructor with 15 parameters (some optional, some interdependent), you use a builder object that lets you set properties step by step and then call `build()` to get the final object.

```
Director
   │
   └── uses ──► Builder (interface)
                    │
                    ├── setPartA()
                    ├── setPartB()
                    ├── setPartC()
                    └── build() → Product
```

**Example — HTTP Request Builder:**

```dart
class HttpRequest {
  final String url;
  final String method;
  final Map<String, String> headers;
  final String? body;
  final Duration timeout;

  const HttpRequest._({
    required this.url,
    required this.method,
    required this.headers,
    this.body,
    required this.timeout,
  });
}

class HttpRequestBuilder {
  String? _url;
  String _method = 'GET';
  final Map<String, String> _headers = {};
  String? _body;
  Duration _timeout = const Duration(seconds: 30);

  HttpRequestBuilder url(String url) {
    _url = url;
    return this; // returns self for chaining
  }

  HttpRequestBuilder method(String method) {
    _method = method;
    return this;
  }

  HttpRequestBuilder header(String key, String value) {
    _headers[key] = value;
    return this;
  }

  HttpRequestBuilder body(String body) {
    _body = body;
    return this;
  }

  HttpRequestBuilder timeout(Duration timeout) {
    _timeout = timeout;
    return this;
  }

  HttpRequest build() {
    assert(_url != null, 'URL must be set before building');
    return HttpRequest._(
      url: _url!,
      method: _method,
      headers: Map.unmodifiable(_headers),
      body: _body,
      timeout: _timeout,
    );
  }
}

// Usage — reads like a sentence, impossible to get parameter order wrong
final request = HttpRequestBuilder()
    .url('https://api.example.com/users')
    .method('POST')
    .header('Authorization', 'Bearer token123')
    .header('Content-Type', 'application/json')
    .body('{"name": "Alice"}')
    .timeout(const Duration(seconds: 10))
    .build();
```

**Flutter Real-World — `ThemeData.copyWith`:**

`ThemeData` is immutable and has 50+ fields. `copyWith` is the Builder pattern applied to immutable objects — create a modified copy without touching unrelated fields:

```dart
// Without Builder — fragile, must remember all parameters
final theme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blue,
  // ... 50 more fields you must repeat
);

// With copyWith (Builder variant on immutable objects)
final darkTheme = Theme.of(context).copyWith(
  brightness: Brightness.dark,
  primaryColor: Colors.indigo,
  // Only specify what changes — everything else stays the same
);
```

**Flutter Real-World — Dio `BaseOptions`:**

```dart
final dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Authorization': 'Bearer $token'},
  ),
);
```

**When to USE it:**
- Objects with many optional or interdependent fields
- When construction logic needs to be reusable and testable in isolation
- Immutable objects that need many variants (use `copyWith`)

**When NOT to use it:**
- Simple objects with 2–3 fields — just use a constructor
- When all fields are always required — Builder adds no value over a normal constructor

**Why it matters:** Tests awareness of API design and immutability. Interviewers want to see you recognize that Flutter itself uses this pattern heavily.

**Common mistake:** Thinking `copyWith` is not Builder. It absolutely is — it's Builder applied to immutable value objects.

---

## STRUCTURAL PATTERNS

---

### 5. Adapter

---

**Q:** What is the Adapter pattern, when would you use it, and can you show a Dart example?

**A:** Adapter is a **structural bridge between two incompatible interfaces**. It wraps an existing class (the Adaptee) and exposes a different interface that the client expects — without modifying the original class.

Think of it like a power plug adapter: your laptop expects a round socket, the wall has a flat socket, the adapter converts one to the other.

```
Client ──► Target Interface
                │
           Adapter (wraps)
                │
           Adaptee (existing, incompatible class)
```

**Example — Adapting a legacy payment SDK:**

```dart
// Your app's expected interface (Target)
abstract class PaymentGateway {
  Future<bool> charge({required String userId, required double amount});
  Future<bool> refund({required String transactionId});
}

// A third-party SDK you have no control over (Adaptee)
class StripeSDK {
  Future<Map<String, dynamic>> createCharge(
      String customerId, int amountInCents, String currency) async {
    // Stripe-specific implementation
    return {'id': 'ch_123', 'status': 'succeeded'};
  }

  Future<void> issueRefund(String chargeId) async {
    // Stripe refund logic
  }
}

// Adapter — wraps StripeSDK, exposes PaymentGateway interface
class StripeAdapter implements PaymentGateway {
  final StripeSDK _stripe;
  StripeAdapter(this._stripe);

  @override
  Future<bool> charge({required String userId, required double amount}) async {
    final result = await _stripe.createCharge(
      userId,
      (amount * 100).toInt(), // dollars → cents
      'usd',
    );
    return result['status'] == 'succeeded';
  }

  @override
  Future<bool> refund({required String transactionId}) async {
    try {
      await _stripe.issueRefund(transactionId);
      return true;
    } catch (_) {
      return false;
    }
  }
}

// Client code — only knows PaymentGateway, not Stripe
class CheckoutService {
  final PaymentGateway _gateway;
  CheckoutService(this._gateway);

  Future<void> processOrder(String userId, double total) async {
    final success = await _gateway.charge(userId: userId, amount: total);
    if (!success) throw Exception('Payment failed');
  }
}

// Wiring
void main() {
  final gateway = StripeAdapter(StripeSDK());
  // Swap to PayPalAdapter() tomorrow — CheckoutService doesn't change
  final service = CheckoutService(gateway);
}
```

**Flutter Real-World Usage:**
- Wrapping `SharedPreferences` or `Hive` behind a `LocalStorage` interface
- Adapting Firebase Auth to your own `AuthService` interface
- Wrapping platform channels behind a clean Dart API

**When to USE it:**
- When integrating a third-party library whose interface doesn't match yours
- When you want to swap providers without modifying client code
- When migrating from one library to another incrementally

**When NOT to use it:**
- When you control both sides — just design the interface correctly from the start
- When the API differences are so large that the adapter becomes a full rewrite — consider a Facade instead

**Why it matters:** Tests understanding of dependency inversion and interface segregation — key for making codebases testable and swappable.

**Common mistake:** Confusing Adapter with Facade. Adapter converts an existing interface to a *different* one. Facade creates a *simplified* interface over something complex. The intent is different.

---

### 6. Decorator

---

**Q:** What is the Decorator pattern and how does Flutter use it?

**A:** Decorator **attaches additional responsibilities to an object dynamically** by wrapping it in another object with the same interface. You stack decorators like Russian dolls — each adds behavior while delegating the core work to the object inside.

It's an alternative to subclassing for extending behavior. Instead of `TextFieldWithBorder extends TextField`, you wrap the TextField in a Container that adds a border.

```
Component (interface)
    │
ConcreteComponent          ← real object
    │
DecoratorA (wraps Component, adds behavior A)
    │
DecoratorB (wraps DecoratorA, adds behavior B)
```

**Example — Logging and caching HTTP client decorator:**

```dart
// Component interface
abstract class HttpClient {
  Future<String> get(String url);
}

// Concrete component
class RealHttpClient implements HttpClient {
  @override
  Future<String> get(String url) async {
    // actual network call
    return 'response from $url';
  }
}

// Decorator 1: Logging
class LoggingHttpClient implements HttpClient {
  final HttpClient _inner;
  LoggingHttpClient(this._inner);

  @override
  Future<String> get(String url) async {
    print('→ GET $url');
    final result = await _inner.get(url);
    print('← Response received');
    return result;
  }
}

// Decorator 2: Caching
class CachingHttpClient implements HttpClient {
  final HttpClient _inner;
  final Map<String, String> _cache = {};
  CachingHttpClient(this._inner);

  @override
  Future<String> get(String url) async {
    if (_cache.containsKey(url)) {
      print('Cache hit: $url');
      return _cache[url]!;
    }
    final result = await _inner.get(url);
    _cache[url] = result;
    return result;
  }
}

// Stack decorators — order matters!
final HttpClient client = CachingHttpClient(
  LoggingHttpClient(
    RealHttpClient(),
  ),
);
// Request flows: Caching → Logging → Real → Logging → Caching
```

**Flutter Real-World — Widget Composition IS Decorator:**

In Flutter, widgets decorating other widgets IS the Decorator pattern in action:

```dart
// Padding decorates its child — adds padding behavior
Padding(
  padding: const EdgeInsets.all(16),
  child: // ← the decorated widget

  // GestureDetector decorates with tap behavior
  GestureDetector(
    onTap: () => print('tapped'),
    child:

    // Opacity decorates with transparency
    Opacity(
      opacity: 0.8,
      child:

      // The actual "real component"
      const Text('Hello'),
    ),
  ),
),

// InputDecoration decorates TextField with label, hint, suffix, border
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'you@example.com',
    prefixIcon: const Icon(Icons.email),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {},
    ),
  ),
),
```

**When to USE it:**
- When you want to add behavior without modifying the original class
- When subclassing would create an explosion of combinations (LoggingCachingRetryClient vs CachingClient vs LoggingClient...)
- Flutter widget composition — wrapping widgets to add padding, gestures, opacity

**When NOT to use it:**
- When only one extra behavior is needed — just subclass or extend
- When the stacking order would confuse teammates — document clearly

**Why it matters:** In Flutter, the entire widget system is built on this pattern. Understanding it deeply means understanding how widget composition works.

**Common mistake:** Candidates confuse Decorator with Proxy. Decorator **adds** new behavior; Proxy **controls access** to the same behavior. Intent is the key differentiator.

---

### 7. Facade

---

**Q:** What is the Facade pattern and how does a Repository in Flutter act as a Facade?

**A:** Facade provides a **simple, unified interface to a complex subsystem**. The subsystem might have many classes, many steps, many interactions — the Facade hides all that and gives the client a clean, easy-to-use API.

```
Client
  │
  └──► Facade (simple API)
           │
           ├──► SubsystemA (Database)
           ├──► SubsystemB (Network)
           ├──► SubsystemC (Cache)
           └──► SubsystemD (Event Bus)
```

**Example — Repository as a Facade:**

A `UserRepository` hides the complexity of choosing between cache, local DB, and remote API:

```dart
// Subsystems — each complex on its own
class UserApiService {
  Future<Map<String, dynamic>> fetchUser(String id) async {
    // HTTP call, token refresh, retry logic, error mapping...
    return {'id': id, 'name': 'Alice'};
  }
}

class UserDao {
  Future<Map<String, dynamic>?> findUser(String id) async {
    // SQL query, cursor management, migration handling...
    return null;
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    // Insert/upsert logic, transaction handling...
  }
}

class UserCache {
  final Map<String, dynamic> _store = {};
  dynamic get(String key) => _store[key];
  void set(String key, dynamic value) => _store[key] = value;
  void invalidate(String key) => _store.remove(key);
}

// Model
class User {
  final String id;
  final String name;
  const User({required this.id, required this.name});

  factory User.fromMap(Map<String, dynamic> map) =>
      User(id: map['id'], name: map['name']);
}

// FACADE — the Repository
class UserRepository {
  final UserApiService _api;
  final UserDao _dao;
  final UserCache _cache;

  UserRepository({
    required UserApiService api,
    required UserDao dao,
    required UserCache cache,
  })  : _api = api,
        _dao = dao,
        _cache = cache;

  // Client calls this one simple method
  Future<User> getUser(String id) async {
    // 1. Check memory cache
    final cached = _cache.get(id);
    if (cached != null) return User.fromMap(cached);

    // 2. Check local database
    final local = await _dao.findUser(id);
    if (local != null) {
      _cache.set(id, local);
      return User.fromMap(local);
    }

    // 3. Fetch from network
    final remote = await _api.fetchUser(id);
    await _dao.saveUser(remote); // persist locally
    _cache.set(id, remote);     // warm the cache
    return User.fromMap(remote);
  }

  Future<void> invalidateUser(String id) async {
    _cache.invalidate(id);
    // Could also delete from DB or mark as stale
  }
}

// Client (Cubit) — only sees the Facade
class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _repo; // clean, simple
  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> loadProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final user = await _repo.getUser(userId); // one call, all complexity hidden
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
```

**When to USE it:**
- Any time a client needs to interact with a complex subsystem (network + DB + cache)
- Repositories in clean architecture
- Platform wrappers (hiding method channels behind a clean Dart API)
- SDK wrappers (Firebase, Stripe, Analytics)

**When NOT to use it:**
- When the subsystem is simple — Facade adds a layer of indirection for no benefit
- When clients need fine-grained control over subsystem behavior — Facade hides too much

**Why it matters:** Tests understanding of layered architecture. In clean architecture (used in most Flutter apps), the Repository IS the Facade between domain and data layers.

**Common mistake:** Thinking Repository is just "where you put API calls." The Facade intent — hiding complexity, providing a simple API, coordinating multiple sources — is the real architectural value.

---

### 8. Proxy

---

**Q:** What is the Proxy pattern and what are common Flutter use cases?

**A:** Proxy provides a **surrogate or placeholder for another object to control access to it**. The proxy implements the same interface as the real object but intercepts calls to add behavior: authorization checks, lazy loading, caching, logging, or rate limiting — all transparently.

```
Client ──► Proxy (same interface as RealSubject)
               │
               └──► RealSubject (actual work)
```

**Types of Proxy:**

| Type | Purpose |
|---|---|
| **Virtual (Lazy)** | Defers expensive creation until needed |
| **Protection** | Checks permissions before delegating |
| **Caching** | Returns cached result, skips real call |
| **Remote** | Hides that the real object is on another machine |
| **Logging** | Records access transparently |

**Example — Caching Proxy:**

```dart
abstract class ImageLoader {
  Future<Uint8List> loadImage(String url);
}

class NetworkImageLoader implements ImageLoader {
  @override
  Future<Uint8List> loadImage(String url) async {
    print('Downloading: $url');
    // Expensive network download
    return Uint8List(0);
  }
}

// Caching Proxy — same interface, adds caching transparently
class CachedImageLoader implements ImageLoader {
  final ImageLoader _real;
  final Map<String, Uint8List> _cache = {};

  CachedImageLoader(this._real);

  @override
  Future<Uint8List> loadImage(String url) async {
    if (_cache.containsKey(url)) {
      print('Cache hit: $url');
      return _cache[url]!;
    }
    final bytes = await _real.loadImage(url);
    _cache[url] = bytes;
    return bytes;
  }
}
```

**Example — Protection Proxy (Auth Guard):**

```dart
abstract class ApiService {
  Future<String> getSensitiveData();
}

class RealApiService implements ApiService {
  @override
  Future<String> getSensitiveData() async => 'secret data';
}

class AuthApiProxy implements ApiService {
  final ApiService _real;
  final AuthService _auth;

  AuthApiProxy(this._real, this._auth);

  @override
  Future<String> getSensitiveData() async {
    if (!_auth.isLoggedIn) {
      throw UnauthorizedException('Please log in first');
    }
    if (_auth.currentUser?.role != 'admin') {
      throw ForbiddenException('Admin access required');
    }
    return _real.getSensitiveData();
  }
}
```

**Flutter Real-World Usage:**

- `CachedNetworkImage` package is a **Caching Proxy** for `Image.network`
- Dio interceptors act as **Logging/Auth Proxies** around HTTP calls
- `flutter_secure_storage` wraps platform keychain APIs as a **Protection Proxy**

```dart
// Dio interceptor = Auth Proxy pattern
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // Auth check before every request
      options.headers['Authorization'] = 'Bearer ${authService.token}';
      handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        // Token refresh — transparent to calling code
        await authService.refreshToken();
        handler.resolve(await dio.fetch(error.requestOptions));
      }
    },
  ),
);
```

**When to USE it:**
- Adding cross-cutting concerns (auth, logging, caching) without modifying the real object
- Lazy initialization of expensive objects
- Intercepting/throttling access to rate-limited services

**When NOT to use it:**
- When the extra indirection makes code harder to trace and debug
- When Decorator better fits (you're adding behavior vs controlling access)

**Why it matters:** Tests understanding of transparent interception — a key concept behind interceptors, middleware, and aspect-oriented design.

**Common mistake:** Conflating Proxy with Decorator. Both wrap an object. Proxy controls *access* (auth, caching). Decorator *adds* new behavior. The intent is different even if implementation looks similar.

---

### 9. Composite

---

**Q:** What is the Composite pattern and why is Flutter's widget tree a classic example of it?

**A:** Composite lets you **treat individual objects and compositions of objects uniformly**. You build tree structures where both leaf nodes (single items) and branch nodes (containers of items) implement the same interface. Client code doesn't need to know if it's dealing with one item or a whole subtree.

```
Component (interface)
├── Leaf (no children)      — e.g. Text, Icon, Image
└── Composite (has children) — e.g. Column, Row, Stack
        ├── Leaf
        ├── Leaf
        └── Composite
                └── Leaf
```

**Flutter Widget Tree IS Composite:**

Every Flutter `Widget` is a `Component`. `StatelessWidget` / `StatefulWidget` that contain children are `Composites`. `Text`, `Icon`, `Image` are `Leaves`. The `build()` method is the uniform operation applied to the whole tree.

```dart
// Dart example — file system as Composite
abstract class FileSystemItem {
  String get name;
  int get size;
  void display(int depth);
}

// Leaf — no children
class File implements FileSystemItem {
  @override
  final String name;
  @override
  final int size;

  File(this.name, this.size);

  @override
  void display(int depth) {
    print('${'  ' * depth}📄 $name ($size bytes)');
  }
}

// Composite — has children (both Files and Directories)
class Directory implements FileSystemItem {
  @override
  final String name;
  final List<FileSystemItem> _children = [];

  Directory(this.name);

  void add(FileSystemItem item) => _children.add(item);
  void remove(FileSystemItem item) => _children.remove(item);

  @override
  int get size => _children.fold(0, (sum, item) => sum + item.size);

  @override
  void display(int depth) {
    print('${'  ' * depth}📁 $name (${size} bytes)');
    for (final child in _children) {
      child.display(depth + 1); // uniform call — doesn't matter if leaf or composite
    }
  }
}

void main() {
  final root = Directory('root')
    ..add(File('readme.txt', 1024))
    ..add(
      Directory('src')
        ..add(File('main.dart', 2048))
        ..add(File('app.dart', 4096)),
    )
    ..add(File('pubspec.yaml', 512));

  root.display(0);
  print('Total size: ${root.size} bytes');
}
```

**Flutter Widget Tree:**

```dart
// Flutter uses Composite — every widget handles itself recursively
Column(               // Composite — has children
  children: [
    Text('Title'),    // Leaf
    Row(              // Composite
      children: [
        Icon(Icons.star),   // Leaf
        Text('Rating'),     // Leaf
      ],
    ),
    Image.network('...'),   // Leaf
  ],
)

// Flutter's rendering engine walks this tree uniformly:
// widget.build() is the uniform "display" operation
// It doesn't care if a widget is a leaf or composite
```

**When to USE it:**
- Tree structures where you want to treat nodes and leaves the same way
- File systems, organization charts, UI widget trees, expression parsers
- Menu systems (MenuItem vs SubMenu with children MenuItems)

**When NOT to use it:**
- Flat lists — the pattern adds complexity without benefit
- When leaf and composite behaviors are too different to share an interface meaningfully

**Why it matters:** Directly tests whether you understand WHY Flutter's widget system is designed the way it is. The Composite pattern is the foundation of the entire widget tree model.

**Common mistake:** Candidates know Flutter has a widget tree but can't name the pattern or explain why it works this way. The Composite pattern explains both the design choice and the recursive `build()` mechanism.

---

## BEHAVIORAL PATTERNS

---

### 10. Observer

---

**Q:** What is the Observer pattern and how do Dart Streams and BLoC implement it?

**A:** Observer defines a **one-to-many dependency**: when one object (Subject/Observable) changes state, all its dependents (Observers) are notified and updated automatically. Observers subscribe; they don't poll.

```
Subject (Observable)
    │
    ├── subscribe(observer)
    ├── unsubscribe(observer)
    └── notify()
            │
            ├── Observer A → update()
            ├── Observer B → update()
            └── Observer C → update()
```

**Dart Streams — Built-in Observer:**

`Stream` is Dart's native Observer implementation. The stream is the Subject; `StreamSubscription`s are the Observers.

```dart
// StreamController = Subject
final StreamController<int> _controller = StreamController<int>.broadcast();

// Observers subscribe (listen)
final sub1 = _controller.stream.listen(
  (value) => print('Observer 1: $value'),
);
final sub2 = _controller.stream.listen(
  (value) => print('Observer 2: $value'),
);

// Subject notifies all observers
_controller.add(1); // Observer 1: 1, Observer 2: 1
_controller.add(2); // Observer 1: 2, Observer 2: 2

// Observer unsubscribes
await sub1.cancel();
_controller.add(3); // Only Observer 2: 3

await _controller.close();
```

**BLoC Pattern — Observer via Streams:**

```dart
// BLoC events flow:
// UI (Observer of state) ← BLoC (Subject of state)
// BLoC (Observer of events) ← UI (Subject of events)

// State is emitted (Subject notifies)
// UI rebuilds via BlocBuilder (Observer reacts)

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<IncrementEvent>((event, emit) => emit(state + 1));
  }
  // Internally, Bloc uses StreamController for both events and states
}

// BlocBuilder is the Observer — it subscribes to state changes
BlocBuilder<CounterBloc, int>(
  builder: (context, count) {
    // Called every time BLoC emits a new state
    return Text('Count: $count');
  },
)

// BlocListener is another Observer — for side effects
BlocListener<CounterBloc, int>(
  listener: (context, count) {
    if (count == 10) ScaffoldMessenger.of(context).showSnackBar(...);
  },
  child: const SizedBox.shrink(),
)
```

**Manual Observer pattern in Dart:**

```dart
// Custom Observer without streams
abstract class StockObserver {
  void onPriceChanged(String ticker, double price);
}

class StockMarket {
  final Map<String, List<StockObserver>> _observers = {};

  void subscribe(String ticker, StockObserver observer) {
    _observers.putIfAbsent(ticker, () => []).add(observer);
  }

  void unsubscribe(String ticker, StockObserver observer) {
    _observers[ticker]?.remove(observer);
  }

  void updatePrice(String ticker, double price) {
    _observers[ticker]?.forEach((o) => o.onPriceChanged(ticker, price));
  }
}

class PriceAlert implements StockObserver {
  final double threshold;
  PriceAlert(this.threshold);

  @override
  void onPriceChanged(String ticker, double price) {
    if (price > threshold) print('ALERT: $ticker hit \$${price}!');
  }
}
```

**When to USE it:**
- Any time changes in one part of the app must propagate to others: stock prices, chat messages, form validation, state management
- Reactive systems, event buses, pub/sub architectures

**When NOT to use it:**
- When you have a simple one-time callback — just pass a `Function`
- When observer chains become too deep — debugging becomes a nightmare ("who emitted this?")
- Memory leaks are a risk — always cancel subscriptions

**Why it matters:** This pattern underpins ALL of Flutter's reactive state management. Understanding it means understanding why BLoC, Riverpod, and Provider work the way they do.

**Common mistake:** Forgetting to cancel `StreamSubscription` in `dispose()` — a very common memory leak in Flutter:

```dart
// ❌ Memory leak — subscription never cancelled
class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    someStream.listen((event) { /* ... */ }); // leaked!
  }
}

// ✅ Correct — cancel in dispose
class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _sub = someStream.listen((event) { /* ... */ });
  }

  @override
  void dispose() {
    _sub.cancel(); // always cancel
    super.dispose();
  }
}
```

---

### 11. Strategy

---

**Q:** What is the Strategy pattern and can you show a Dart example with sorting?

**A:** Strategy defines a **family of algorithms, encapsulates each one, and makes them interchangeable**. The context object holds a reference to a strategy and delegates algorithm execution to it. You can swap strategies at runtime without changing the context.

```
Context
  │
  └── strategy: SortStrategy ← can be swapped at runtime
                    │
                    ├── BubbleSort
                    ├── QuickSort
                    └── MergeSort
```

**Example — Sorting Strategies:**

```dart
// Strategy interface
abstract class SortStrategy<T> {
  List<T> sort(List<T> items, Comparator<T> comparator);
}

// Concrete strategies
class BubbleSortStrategy<T> implements SortStrategy<T> {
  @override
  List<T> sort(List<T> items, Comparator<T> comparator) {
    final list = List<T>.from(items);
    for (int i = 0; i < list.length - 1; i++) {
      for (int j = 0; j < list.length - i - 1; j++) {
        if (comparator(list[j], list[j + 1]) > 0) {
          final temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }
    }
    return list;
  }
}

class DartNativeSortStrategy<T> implements SortStrategy<T> {
  @override
  List<T> sort(List<T> items, Comparator<T> comparator) {
    return List<T>.from(items)..sort(comparator);
  }
}

// Context — holds and uses a strategy
class ProductList {
  final List<Product> _products;
  SortStrategy<Product> _strategy;

  ProductList(this._products, {SortStrategy<Product>? strategy})
      : _strategy = strategy ?? DartNativeSortStrategy();

  // Swap strategy at runtime
  void setStrategy(SortStrategy<Product> strategy) {
    _strategy = strategy;
  }

  List<Product> sortByPrice() {
    return _strategy.sort(_products, (a, b) => a.price.compareTo(b.price));
  }

  List<Product> sortByName() {
    return _strategy.sort(_products, (a, b) => a.name.compareTo(b.name));
  }
}

class Product {
  final String name;
  final double price;
  const Product(this.name, this.price);
}

void main() {
  final list = ProductList([
    const Product('Banana', 0.5),
    const Product('Apple', 1.2),
    const Product('Cherry', 3.0),
  ]);

  // Runtime swap
  list.setStrategy(DartNativeSortStrategy());
  print(list.sortByPrice().map((p) => p.name).toList());
  // [Banana, Apple, Cherry]
}
```

**Flutter Real-World — Validation Strategies:**

```dart
abstract class ValidationStrategy {
  String? validate(String value);
}

class RequiredValidation implements ValidationStrategy {
  @override
  String? validate(String value) =>
      value.isEmpty ? 'This field is required' : null;
}

class EmailValidation implements ValidationStrategy {
  @override
  String? validate(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value) ? null : 'Enter a valid email';
  }
}

class CompositeValidation implements ValidationStrategy {
  final List<ValidationStrategy> _validators;
  CompositeValidation(this._validators);

  @override
  String? validate(String value) {
    for (final v in _validators) {
      final error = v.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}

// Usage in TextFormField
TextFormField(
  validator: CompositeValidation([
    RequiredValidation(),
    EmailValidation(),
  ]).validate,
)
```

**When to USE it:**
- Multiple algorithms that do the same job differently (sort, validate, compress, encrypt)
- When you want to swap behavior at runtime (user picks sort order)
- When `if/switch` chains switching between algorithm variants is getting large

**When NOT to use it:**
- Only one algorithm exists or will ever exist
- The strategy interface is so generic it adds no real abstraction
- Simple cases where passing a function (`Comparator`, `VoidCallback`) is cleaner

**Why it matters:** Tests knowledge of composition over inheritance and the open/closed principle. Common in form validation, analytics, payment processing.

**Common mistake:** Using inheritance instead ("SortedProductList extends ProductList"). Strategy via composition is more flexible — you can combine and swap at runtime, not just at compile time.

---

### 12. Command

---

**Q:** What is the Command pattern and how is it useful for undo/redo in Flutter?

**A:** Command **encapsulates a request as an object**, letting you parameterize actions, queue them, log them, and support undoable operations. Instead of directly calling `receiver.doSomething()`, you create a `Command` object that knows both the action and how to reverse it.

```
Invoker (button, gesture)
   │
   └──► Command (encapsulates request)
              │
              ├── execute() → calls Receiver.action()
              └── undo()    → reverses Receiver.action()
```

**Example — Text Editor with Undo/Redo:**

```dart
// Command interface
abstract class EditorCommand {
  void execute();
  void undo();
}

// Receiver — the actual state
class TextDocument {
  String _text = '';
  String get text => _text;

  void insert(int position, String content) {
    _text = _text.substring(0, position) + content + _text.substring(position);
  }

  void delete(int position, int length) {
    _text = _text.substring(0, position) + _text.substring(position + length);
  }
}

// Concrete Commands
class InsertCommand implements EditorCommand {
  final TextDocument _doc;
  final int _position;
  final String _text;

  InsertCommand(this._doc, this._position, this._text);

  @override
  void execute() => _doc.insert(_position, _text);

  @override
  void undo() => _doc.delete(_position, _text.length);
}

class DeleteCommand implements EditorCommand {
  final TextDocument _doc;
  final int _position;
  final int _length;
  late String _deletedText; // store for undo

  DeleteCommand(this._doc, this._position, this._length);

  @override
  void execute() {
    _deletedText = _doc.text.substring(_position, _position + _length);
    _doc.delete(_position, _length);
  }

  @override
  void undo() => _doc.insert(_position, _deletedText);
}

// Invoker — manages the command history
class EditorHistory {
  final _undoStack = <EditorCommand>[];
  final _redoStack = <EditorCommand>[];

  void execute(EditorCommand command) {
    command.execute();
    _undoStack.add(command);
    _redoStack.clear(); // new action clears redo history
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    final command = _undoStack.removeLast();
    command.undo();
    _redoStack.add(command);
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final command = _redoStack.removeLast();
    command.execute();
    _undoStack.add(command);
  }
}

void main() {
  final doc = TextDocument();
  final history = EditorHistory();

  history.execute(InsertCommand(doc, 0, 'Hello'));
  print(doc.text); // Hello

  history.execute(InsertCommand(doc, 5, ' World'));
  print(doc.text); // Hello World

  history.undo();
  print(doc.text); // Hello

  history.redo();
  print(doc.text); // Hello World
}
```

**Flutter Real-World — Form Actions:**

```dart
// Each user action in a form is a Command
abstract class FormCommand {
  void execute();
  void undo();
}

class SetFieldValueCommand implements FormCommand {
  final Map<String, String> formState;
  final String field;
  final String newValue;
  late String _previousValue;

  SetFieldValueCommand(this.formState, this.field, this.newValue);

  @override
  void execute() {
    _previousValue = formState[field] ?? '';
    formState[field] = newValue;
  }

  @override
  void undo() => formState[field] = _previousValue;
}

// Shopping cart operations as Commands:
// AddToCartCommand, RemoveFromCartCommand, ApplyCouponCommand
// all with undo() support
```

**When to USE it:**
- Undo/redo functionality (text editors, drawing apps, form wizards)
- Macro recording (a sequence of commands to replay)
- Queuing operations for later execution or async processing
- Transaction rollback

**When NOT to use it:**
- Simple one-time actions with no need for undo, logging, or queuing
- When the overhead of creating Command objects for every tiny action outweighs the benefit

**Why it matters:** Tests understanding of encapsulating behavior as data — fundamental to transactional systems and user-friendly UX patterns.

**Common mistake:** Not storing enough state in the command for `undo()` to work. The command must capture the full context at `execute()` time to be reversible.

---

### 13. State Pattern

---

**Q:** What is the State pattern (GoF) and how does it differ from managing state with Cubit?

**A:** The GoF State pattern allows an object to **alter its behavior when its internal state changes**. The object appears to change its class. Instead of giant `if/switch` chains checking a state variable, you extract each state into its own class and delegate behavior to the current state object.

```
Context
  │
  └── currentState: State (reference, changes at runtime)
                        │
                        ├── StateA → handles() → transitions to StateB
                        ├── StateB → handles() → transitions to StateC
                        └── StateC → handles() → stays or goes back
```

**GoF State Pattern in Dart:**

```dart
// Abstract State — defines the interface for all states
abstract class TrafficLightState {
  void handle(TrafficLight light);
  String get displayColor;
}

// The Context
class TrafficLight {
  TrafficLightState _state;

  TrafficLight() : _state = RedState();

  void setState(TrafficLightState state) => _state = state;
  void change() => _state.handle(this);
  String get color => _state.displayColor;
}

// Concrete States — each knows what comes next
class RedState implements TrafficLightState {
  @override
  void handle(TrafficLight light) => light.setState(GreenState());

  @override
  String get displayColor => '🔴 RED — Stop';
}

class GreenState implements TrafficLightState {
  @override
  void handle(TrafficLight light) => light.setState(YellowState());

  @override
  String get displayColor => '🟢 GREEN — Go';
}

class YellowState implements TrafficLightState {
  @override
  void handle(TrafficLight light) => light.setState(RedState());

  @override
  String get displayColor => '🟡 YELLOW — Caution';
}

void main() {
  final light = TrafficLight();
  print(light.color); // 🔴 RED — Stop
  light.change();
  print(light.color); // 🟢 GREEN — Go
  light.change();
  print(light.color); // 🟡 YELLOW — Caution
  light.change();
  print(light.color); // 🔴 RED — Stop
}
```

**Difference from Cubit:**

| | GoF State Pattern | Cubit/BLoC State |
|---|---|---|
| **Where logic lives** | In the state object itself | In the Cubit (central) |
| **State knows transitions** | Yes — state calls `context.setState(Next())` | No — Cubit decides next state |
| **State is** | A behavior-containing object | Typically a data class (immutable) |
| **Transitions from** | The current state object | The Cubit method |
| **Use case** | Complex state-specific behavior | UI state management, simpler transitions |

```dart
// Cubit approach — state is data, Cubit owns logic
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading()); // Cubit decides next state
    try {
      final user = await _authService.login(email, password);
      emit(AuthAuthenticated(user)); // Cubit decides
    } catch (e) {
      emit(AuthError(e.toString())); // Cubit decides
    }
  }
}

// GoF State — each state object decides what comes next
// (better for complex, state-specific behavior — e.g., a game character
//  that can only Attack from CombatState, only Rest from IdleState)
```

**When to USE GoF State pattern:**
- State-specific behavior that's complex enough to warrant its own class
- State machines where each state has meaningfully different behavior
- When `if (state == X) doA() else if (state == Y) doB()` is getting large

**When NOT to use it:**
- Simple UI state (loading/success/error) — Cubit/sealed classes are cleaner
- Few states with little behavioral difference — overkill
- When states don't have meaningfully different behavior, just different data

**Why it matters:** Tests whether you can distinguish between the GoF design pattern (behavior delegation) and Flutter's state management (data emission). Many candidates conflate these.

**Common mistake:** Describing Cubit as "the State pattern." They're related in name only. GoF State is about delegating behavior to state objects. Cubit is about emitting state values to the UI.

---

### 14. Template Method

---

**Q:** What is the Template Method pattern and can you show a Dart example?

**A:** Template Method defines the **skeleton of an algorithm in a base class, deferring specific steps to subclasses**. The base class says "here's the overall flow — step 1, step 2, step 3" but lets subclasses override individual steps without changing the sequence.

```
AbstractClass
  │
  └── templateMethod() ← final — defines the algorithm skeleton
          │
          ├── step1()   ← concrete — same for all subclasses
          ├── step2()   ← abstract — must be overridden
          ├── step3()   ← abstract — must be overridden
          └── hook()    ← optional — subclass can override if needed
```

**Example — Data Export Pipeline:**

```dart
abstract class DataExporter {
  // Template method — the skeleton. 'final' prevents override.
  Future<void> export(List<Map<String, dynamic>> data) async {
    final validated = validate(data);
    final transformed = transform(validated);
    final formatted = format(transformed);
    await writeOutput(formatted);
    onExportComplete(); // hook — optional
  }

  // Step 1: common validation for all exporters
  List<Map<String, dynamic>> validate(List<Map<String, dynamic>> data) {
    return data.where((row) => row.isNotEmpty).toList();
  }

  // Step 2: subclasses define transformation
  List<Map<String, dynamic>> transform(List<Map<String, dynamic>> data);

  // Step 3: subclasses define formatting
  String format(List<Map<String, dynamic>> data);

  // Step 4: subclasses define output
  Future<void> writeOutput(String content);

  // Hook — default is no-op; subclass may override
  void onExportComplete() {}
}

// CSV Exporter
class CsvExporter extends DataExporter {
  @override
  List<Map<String, dynamic>> transform(List<Map<String, dynamic>> data) {
    return data.map((row) => row.map(
      (k, v) => MapEntry(k, v.toString().replaceAll(',', ';'))
    )).toList();
  }

  @override
  String format(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return '';
    final headers = data.first.keys.join(',');
    final rows = data.map((row) => row.values.join(',')).join('\n');
    return '$headers\n$rows';
  }

  @override
  Future<void> writeOutput(String content) async {
    // write to file system
    print('Writing CSV:\n$content');
  }

  @override
  void onExportComplete() => print('CSV export done ✓');
}

// JSON Exporter — same skeleton, different steps
class JsonExporter extends DataExporter {
  @override
  List<Map<String, dynamic>> transform(List<Map<String, dynamic>> data) {
    return data; // no transformation needed for JSON
  }

  @override
  String format(List<Map<String, dynamic>> data) {
    // Convert to JSON string
    return data.toString(); // simplified
  }

  @override
  Future<void> writeOutput(String content) async {
    print('Writing JSON:\n$content');
  }
}

void main() async {
  final data = [
    {'name': 'Alice', 'score': 95},
    {'name': 'Bob', 'score': 87},
  ];

  await CsvExporter().export(data);
  await JsonExporter().export(data);
}
```

**Flutter Real-World Usage:**

Flutter's `StatefulWidget` lifecycle IS Template Method:

```dart
// Flutter defines the lifecycle skeleton:
// createState() → initState() → didChangeDependencies() →
// build() → didUpdateWidget() → dispose()

// You override specific steps:
class _MyWidgetState extends State<MyWidget> {
  // Template method steps you can override:
  @override
  void initState() { /* your init logic */ }

  @override
  Widget build(BuildContext context) { /* required */ }

  @override
  void dispose() { /* your cleanup */ }
  // Flutter's framework calls them in the right order — you don't control that
}
```

**When to USE it:**
- When multiple classes share the same algorithm structure but differ in specific steps
- When you want to enforce an invariant sequence of steps (the algorithm order can't be changed by subclasses)
- Data processing pipelines, lifecycle hooks, report generators

**When NOT to use it:**
- When subclasses need to change the *order* of steps, not just their implementation — use Strategy instead
- Deep inheritance hierarchies are fragile — prefer composition when possible
- When there's only one variant (no need to abstract)

**Why it matters:** Tests understanding of inversion of control — the framework calls you, you don't call the framework (Hollywood Principle). Flutter's own widget lifecycle is the best real-world example.

**Common mistake:** Confusing Template Method with Strategy. Template Method uses **inheritance** (fixed skeleton, override steps). Strategy uses **composition** (inject a whole algorithm object). If you can swap the algorithm entirely at runtime, it's Strategy.

---

### 15. Iterator

---

**Q:** What is the Iterator pattern and how does Dart implement it with `Iterable` and `Iterator`?

**A:** Iterator provides a way to **sequentially access elements of a collection without exposing its underlying representation**. Whether the collection is an array, a tree, a graph, or a lazy stream — the iterator gives you a uniform `moveNext()` / `current` interface.

```
Client
  │
  └──► Iterator (interface)
            │
            ├── moveNext() → bool
            └── current    → T

  IterableCollection
            │
            └── iterator  → returns an Iterator
```

**Dart's Built-in `Iterator` Interface:**

```dart
abstract class Iterator<E> {
  bool moveNext();  // advance cursor, returns false when done
  E get current;   // the element at the current cursor
}

abstract class Iterable<E> {
  Iterator<E> get iterator;
  // + all the derived goodies: map, where, fold, toList, etc.
}
```

**Custom Iterator — Fibonacci sequence:**

```dart
// Custom Iterator — generates Fibonacci numbers lazily
class FibonacciIterator implements Iterator<int> {
  int _a = 0, _b = 1;
  int _current = 0;
  final int _limit;

  FibonacciIterator(this._limit);

  @override
  bool moveNext() {
    if (_a >= _limit) return false; // stop condition
    _current = _a;
    final next = _a + _b;
    _a = _b;
    _b = next;
    return true;
  }

  @override
  int get current => _current;
}

// Custom Iterable wrapping the Iterator
class FibonacciSequence extends Iterable<int> {
  final int limit;
  FibonacciSequence(this.limit);

  @override
  Iterator<int> get iterator => FibonacciIterator(limit);
}

void main() {
  final fibs = FibonacciSequence(100);

  // for-in loop uses the Iterator protocol automatically
  for (final n in fibs) {
    print(n); // 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89
  }

  // All Iterable methods work for free
  print(fibs.where((n) => n.isEven).toList()); // [0, 2, 8, 34]
  print(fibs.reduce((a, b) => a + b));         // 232
}
```

**Custom Tree Iterator — breadth-first traversal:**

```dart
class TreeNode<T> {
  T value;
  List<TreeNode<T>> children;
  TreeNode(this.value, [this.children = const []]);
}

class BreadthFirstIterator<T> implements Iterator<T> {
  final Queue<TreeNode<T>> _queue;
  TreeNode<T>? _current;

  BreadthFirstIterator(TreeNode<T> root)
      : _queue = Queue()..add(root);

  @override
  bool moveNext() {
    if (_queue.isEmpty) return false;
    _current = _queue.removeFirst();
    _queue.addAll(_current!.children);
    return true;
  }

  @override
  T get current => _current!.value;
}

class TreeIterable<T> extends Iterable<T> {
  final TreeNode<T> _root;
  TreeIterable(this._root);

  @override
  Iterator<T> get iterator => BreadthFirstIterator(_root);
}

void main() {
  final tree = TreeNode(1, [
    TreeNode(2, [TreeNode(4), TreeNode(5)]),
    TreeNode(3, [TreeNode(6)]),
  ]);

  print(TreeIterable(tree).toList()); // [1, 2, 3, 4, 5, 6] — breadth-first
}
```

**Flutter Real-World — Lazy loading with Iterator:**

```dart
// Dart generators are sugar over Iterator — perfect for lazy sequences
Iterable<Widget> buildProductTiles(List<Product> products) sync* {
  for (final product in products) {
    yield ProductTile(product: product); // lazy — only built when iterated
    yield const Divider();
  }
}

// Usage in Column
Column(
  children: buildProductTiles(products).toList(),
)
```

**When to USE it:**
- When you want to traverse a complex data structure (tree, graph, lazy sequence) without exposing internals
- When you need multiple traversal strategies for the same collection
- Custom lazy sequences (pagination, infinite scroll data sources)
- When you want Dart's full `Iterable` API (map, where, fold) on your custom collection

**When NOT to use it:**
- Simple `List` or `Map` — Dart's built-in iterables handle everything already
- When random access is needed — Iterator is sequential only
- When the collection is so simple that `for` with an index is clearer

**Why it matters:** Tests understanding of Dart's collection protocol and lazy evaluation. Demonstrates you can build memory-efficient data sources (important for pagination and large datasets in Flutter).

**Common mistake:** Candidates forget that `for-in` loops, `map()`, `where()`, `fold()` — ALL of these use the `Iterator` protocol under the hood. Implementing `Iterable` unlocks the entire Dart collection API for free.

---

## Quick Reference Summary

| Pattern | Category | Core Intent | Flutter Example |
|---|---|---|---|
| **Singleton** | Creational | One instance globally | GetIt service locator |
| **Factory Method** | Creational | Subclass decides what to create | `PageRoute` subclasses |
| **Abstract Factory** | Creational | Family of related objects | Material vs Cupertino widget families |
| **Builder** | Creational | Step-by-step complex construction | `ThemeData.copyWith`, Dio options |
| **Adapter** | Structural | Convert one interface to another | Third-party SDK wrappers |
| **Decorator** | Structural | Add behavior by wrapping | `Padding`, `GestureDetector`, `Opacity` |
| **Facade** | Structural | Simplified interface to subsystem | `Repository` class |
| **Proxy** | Structural | Control access to an object | `CachedNetworkImage`, Dio interceptors |
| **Composite** | Structural | Treat leaf and tree uniformly | Widget tree (`Column`, `Row`, `Text`) |
| **Observer** | Behavioral | Notify dependents of changes | `Stream`, BLoC, `ChangeNotifier` |
| **Strategy** | Behavioral | Swap algorithms at runtime | Form validators, sort comparators |
| **Command** | Behavioral | Encapsulate request as object | Undo/redo, queued user actions |
| **State** | Behavioral | Delegate behavior to state object | Traffic light, game state machine |
| **Template Method** | Behavioral | Skeleton with overridable steps | Widget lifecycle (`initState`, `build`) |
| **Iterator** | Behavioral | Sequential access to collection | `Iterable<T>`, `sync*` generators |

---

*End of Section 14: Design Patterns*
