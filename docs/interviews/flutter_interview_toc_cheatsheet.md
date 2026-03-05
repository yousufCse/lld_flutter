# Senior Flutter Engineer — Interview Prep
## Table of Contents & Quick Reference Cheat Sheet

---

# PART I: TABLE OF CONTENTS

---

## Section 1: Dart Language Fundamentals
- Null safety, sound type system, and the `?`, `!`, `??`, `late` keywords
- `var`, `final`, `const` — compile-time vs runtime constants
- Extension methods, mixins, and abstract classes
- Generics, type inference, and the `dynamic` type
- Named, positional, and required parameters

## Section 2: Dart Async Programming
- `Future`, `async`/`await`, and the event loop
- `Stream` — single-subscription vs broadcast
- `Completer` — manual Future control
- Error handling in async code: `try/catch` vs `.catchError()`
- `Future.wait`, `Future.any`, `Future.delayed`

## Section 3: Flutter Widget Architecture
- `StatelessWidget` vs `StatefulWidget` — when and why
- The Widget/Element/RenderObject tree (the three trees)
- `BuildContext` — what it is and why it matters
- `InheritedWidget` — how data propagates down the tree
- `const` constructors and widget rebuild optimization

## Section 4: State Management
- `setState` and when it's enough
- Provider — `ChangeNotifier`, `Consumer`, `Selector`
- Riverpod — `ref.watch`, `ref.read`, `ref.listen`, providers
- BLoC/Cubit — event-driven state, `StreamController`, `emit`
- Redux — store, reducers, middleware
- Choosing the right approach for project scale

## Section 5: Flutter Rendering Pipeline
- The three phases: Build → Layout → Paint
- `RenderObject` vs `Widget` — roles and responsibilities
- `RepaintBoundary` and isolating repaints
- How `CustomPaint` and `Canvas` work
- Layer tree and compositing

## Section 6: Performance Optimization
- `const` widgets and the widget rebuild problem
- `ListView.builder` vs `ListView` — lazy loading
- `AutomaticKeepAliveClientMixin` — preserving state in lists
- `Keys` — `ValueKey`, `ObjectKey`, `GlobalKey` — why they matter
- `compute()` function — offloading to background isolates
- Profiling with Flutter DevTools: CPU, memory, jank

## Section 7: Isolates & Concurrency
- Dart's single-threaded model and the event loop
- What isolates are and how they differ from threads
- Spawning isolates with `Isolate.spawn` and `compute()`
- Message passing with `SendPort` / `ReceivePort`
- `IsolateGroup` and background isolates (Flutter 3+)
- When NOT to use isolates

## Section 8: Navigation & Routing
- `Navigator 1.0` — `push`, `pop`, `pushReplacement`, named routes
- `Navigator 2.0` — `Router`, `RouteInformationParser`, `RouterDelegate`
- `go_router` — declarative routing, guards, deep linking
- Deep linking on Android (intent filters) and iOS (universal links)
- Passing arguments between routes safely

## Section 9: Networking & HTTP
- `http` package vs `Dio` — features and tradeoffs
- RESTful API calls — GET, POST, PUT, DELETE patterns
- Interceptors for auth headers, logging, and retry logic
- JSON serialization — `json_serializable`, `freezed`
- Error handling: HTTP errors vs network errors vs parsing errors
- Certificate pinning and HTTPS best practices

## Section 10: Local Storage & Persistence
- `SharedPreferences` — key-value, limitations
- `Hive` — NoSQL, fast, offline-first
- `sqflite` / `drift` — relational data
- Secure storage with `flutter_secure_storage`
- Choosing a persistence strategy for your use case

## Section 11: Platform Channels & Native Integration
- `MethodChannel` — call native code from Dart
- `EventChannel` — stream data from native to Dart
- `BasicMessageChannel` — raw binary messaging
- Writing a plugin: Android (Kotlin) + iOS (Swift) side
- FFI (Foreign Function Interface) — calling C libraries directly

## Section 12: Animations
- `AnimationController`, `Tween`, `AnimatedBuilder`
- Implicit animations — `AnimatedContainer`, `AnimatedOpacity`, etc.
- Explicit animations — when you need full control
- `Hero` animations — shared element transitions
- `Rive` and `Lottie` — complex vector animations
- `CustomPainter` animation with canvas drawing

## Section 13: Testing in Flutter
- Unit tests — pure Dart logic, no Flutter dependencies
- Widget tests — `pumpWidget`, `find`, `tap`, `expect`
- Integration tests — `flutter_test`, `patrol`
- Mocking with `mockito` and `mocktail`
- Golden tests — pixel-perfect UI regression
- Test coverage and CI integration

## Section 14: Clean Architecture & Design Patterns
- Clean Architecture layers: Presentation → Domain → Data
- Repository pattern — abstracting data sources
- SOLID principles applied to Flutter/Dart
- Dependency Injection — `get_it`, `injectable`
- Factory, Singleton, Observer patterns in Flutter
- Feature-first vs layer-first folder structure

## Section 15: Flutter Web & Desktop
- How Flutter Web renders: CanvasKit vs HTML renderer
- Web-specific limitations: no isolates, CORS, SEO
- Responsive design — `LayoutBuilder`, `MediaQuery`, `AdaptiveScaffold`
- Desktop-specific: keyboard shortcuts, window management, menus
- Code sharing strategy across platforms

## Section 16: CI/CD & DevOps for Flutter
- `fastlane` — automating builds, signing, and deployment
- GitHub Actions / Bitrise — Flutter pipeline setup
- Code signing: Android keystores, iOS provisioning profiles
- Flavors — dev, staging, production environments
- Firebase App Distribution vs TestFlight for beta delivery
- Semantic versioning and automated version bumping

## Section 17: Security in Flutter Apps
- Storing secrets: never in source code, use `.env` + `--dart-define`
- Obfuscation with `--obfuscate` and `--split-debug-info`
- Certificate pinning to prevent MITM attacks
- `flutter_secure_storage` vs `SharedPreferences` for sensitive data
- Jailbreak/root detection patterns
- OWASP Mobile Top 10 awareness

## Section 18: Streams & Reactive Programming
- `Stream` vs `Future` — the core difference
- `StreamController` — creating and managing streams
- Common stream operators: `map`, `where`, `debounce`, `distinct`
- `RxDart` — `BehaviorSubject`, `PublishSubject`, `ReplaySubject`
- Stream lifecycle: listen, pause, cancel, error handling
- Backpressure and stream buffering

## Section 19: Accessibility & Internationalisation
- `Semantics` widget — screen reader support
- `SemanticsLabel`, `excludeSemantics`, focus management
- `flutter_localizations` + ARB files for i18n
- RTL (right-to-left) language support
- Dynamic font scaling — `MediaQuery.textScaleFactor`
- Testing accessibility with TalkBack / VoiceOver

## Section 20: Error Handling & Observability
- `FlutterError.onError` — catching Flutter framework errors
- `PlatformDispatcher.instance.onError` — uncaught async errors
- `Zone` — wrapping the entire app for error capture
- `Either` type pattern for functional error handling
- Crash reporting: Firebase Crashlytics, Sentry integration
- Structured logging and log levels in production

## Section 21: App Architecture & Scalability
- Monorepo vs multi-repo for large Flutter projects
- Module federation — feature packages, shared packages
- `melos` — managing multi-package Flutter monorepos
- Code generation: `build_runner`, `freezed`, `json_serializable`
- Handling breaking API changes — versioning strategies
- Feature flags and remote configuration

## Section 22: Flutter Internals & Advanced Dart
- How `BuildContext` implements `Element`
- `GlobalKey` — direct widget state access and its performance cost
- How hot reload works (and why it sometimes fails)
- Tree shaking and AOT vs JIT compilation
- Dart VM service protocol and DevTools internals
- The scheduler and frame pipeline: `SchedulerBinding`, `WidgetsBinding`

---
---

# PART II: QUICK REFERENCE CHEAT SHEET
### Last-Night Review — Know These Cold

---

**Section 1: Dart Language Fundamentals**
- `const` = compile-time constant (immutable, canonicalized); `final` = runtime constant (set once)
- Null safety: `?` makes nullable, `!` asserts non-null (throws at runtime if null), `late` defers init
- Mixins use `with`, cannot have constructors; `extends` = single inheritance; `implements` = contract only

---

**Section 2: Dart Async Programming**
- Dart is single-threaded; `async/await` is syntax sugar over Futures — it does NOT create threads
- Single-subscription streams can only have one listener; broadcast streams can have many
- `Completer` lets you create a Future and resolve it manually — useful for wrapping callback APIs

---

**Section 3: Flutter Widget Architecture**
- Three trees: Widget (blueprint/immutable) → Element (lifecycle/state) → RenderObject (layout/paint)
- `BuildContext` IS the `Element` — it knows the widget's position in the tree
- `InheritedWidget` propagates data down; `of(context)` registers the calling widget as a dependent (auto-rebuilds)

---

**Section 4: State Management**
- `setState` rebuilds the entire `build()` method — fine for local, isolated state only
- BLoC: events go IN, states come OUT — never expose `StreamController` directly; use `Stream` getter
- Riverpod's `ref.watch` rebuilds on change; `ref.read` is read-once (use in callbacks/side effects only)

---

**Section 5: Flutter Rendering Pipeline**
- Order is always: Build → Layout → Paint — you cannot paint before layout
- `RepaintBoundary` creates a separate compositing layer — use to isolate frequently repainting widgets
- `RenderObject` does the real work (size, position, paint); `Widget` is just a configuration object

---

**Section 6: Performance Optimization**
- `const` widgets are never rebuilt and are canonicalized in memory — use them everywhere possible
- `ListView.builder` creates items lazily (on demand); `ListView` builds ALL children at once
- Never do heavy computation in `build()` — it runs on the UI thread and blocks the frame

---

**Section 7: Isolates & Concurrency**
- Isolates have separate memory heaps — no shared state, communicate only via message passing
- `compute(fn, arg)` is a convenience wrapper that spawns an isolate and returns a Future
- Don't use isolates for quick tasks — spawning has overhead; use them for >16ms CPU work

---

**Section 8: Navigation & Routing**
- Navigator 1.0 is imperative (push/pop); Navigator 2.0 is declarative (URL-driven state)
- `go_router` handles deep links, redirects (guards), and nested navigation cleanly
- Always use `GoRouter.of(context).go()` vs `push()` — `go` replaces stack (no back button), `push` adds

---

**Section 9: Networking & HTTP**
- Dio supports interceptors, cancellation, FormData, and timeout config out of the box; `http` is minimal
- Always handle three failure types separately: HTTP status error, network/timeout error, parse error
- Never store API keys in Dart source — use `--dart-define=KEY=value` and access via `const String.fromEnvironment`

---

**Section 10: Local Storage & Persistence**
- `SharedPreferences` is NOT encrypted — never store tokens, passwords, or PII there
- Hive is faster than SQLite for simple objects because it's binary and doesn't need parsing
- `drift` (formerly moor) = type-safe SQLite with reactive queries via streams

---

**Section 11: Platform Channels & Native Integration**
- `MethodChannel` is async and bidirectional — Dart calls native, native can call Dart back
- `EventChannel` is for continuous streams from native (e.g., sensors, Bluetooth) to Dart
- FFI is faster than MethodChannel for CPU-bound native calls — no serialization overhead

---

**Section 12: Animations**
- `AnimationController` drives all explicit animations — requires a `Ticker` (from `SingleTickerProviderStateMixin`)
- `Tween.animate(controller)` = CurvedAnimation + value mapping; `AnimatedBuilder` rebuilds only its subtree
- `Hero` animation requires matching `tag` on both source and destination widgets

---

**Section 13: Testing in Flutter**
- Unit test = pure Dart, no Flutter; widget test = `pumpWidget` + fake Flutter environment; integration test = real device
- `pump()` advances one frame; `pumpAndSettle()` advances until no more animations or pending futures
- Golden tests compare pixel output to a saved `.png` — great for preventing visual regressions in CI

---

**Section 14: Clean Architecture & Design Patterns**
- Dependency rule: outer layers depend on inner layers; Domain layer has ZERO Flutter/external dependencies
- Repository pattern hides whether data comes from API, cache, or database — the caller doesn't care
- `get_it` is a service locator (not true DI); use `injectable` for constructor injection with code generation

---

**Section 15: Flutter Web & Desktop**
- CanvasKit renderer = pixel-perfect, heavy (2MB WASM download); HTML renderer = lighter, less fidelity
- `LayoutBuilder` gives you parent constraints; `MediaQuery` gives you screen dimensions — use both for responsive UI
- Flutter Web has no isolate support — use `web workers` via JS interop for background work on web

---

**Section 16: CI/CD & DevOps for Flutter**
- Flavors = separate `main_dev.dart`, `main_prod.dart` entry points + Android productFlavors + iOS schemes
- Never commit keystores or `.p12` files — use CI secret stores and inject at build time
- `fastlane match` manages iOS certs/profiles in a git repo — team members sync with one command

---

**Section 17: Security in Flutter Apps**
- `--obfuscate --split-debug-info=./symbols` makes reverse engineering much harder; keep symbols for crash symbolication
- Certificate pinning: store expected cert hash in app, reject connections that don't match — defeats MITM
- `flutter_secure_storage` uses Android Keystore / iOS Keychain — OS-level hardware-backed encryption

---

**Section 18: Streams & Reactive Programming**
- A `StreamController` exposes `.stream` for listening and `.sink` for adding events — never expose the controller itself
- `BehaviorSubject` (RxDart) replays the last value to new subscribers — use for state; `PublishSubject` does not
- Always cancel stream subscriptions in `dispose()` — uncancelled subscriptions are a common memory leak source

---

**Section 19: Accessibility & Internationalisation**
- Wrap non-text widgets in `Semantics(label: '...')` so screen readers can describe them
- ARB files define string keys + translations; `flutter gen-l10n` generates type-safe accessor classes
- `MediaQuery.of(context).textScaleFactor` > 1 means the user has enlarged system font — your layout must handle it

---

**Section 20: Error Handling & Observability**
- `FlutterError.onError` catches widget/framework errors; `PlatformDispatcher.instance.onError` catches unhandled async errors — set BOTH
- Wrap `runApp()` in `runZonedGuarded()` to catch synchronous errors that escape both handlers
- `Either<Failure, Success>` (from `dartz`) forces callers to handle both paths — no silent failures

---

**Section 21: App Architecture & Scalability**
- `melos` bootstraps a monorepo: links local packages, runs scripts across all packages simultaneously
- Feature packages import `core` and `domain` packages only — never import other feature packages directly
- `build_runner watch` in development re-runs code generation on file change — `build_runner build --delete-conflicting-outputs` for CI

---

**Section 22: Flutter Internals & Advanced Dart**
- Hot reload reloads widget tree but does NOT re-run `initState()` or `main()` — state is preserved
- AOT (Ahead of Time) = compiled to native ARM in release mode → fast startup, no JIT overhead
- `SchedulerBinding.instance.addPostFrameCallback()` runs code after the next frame — use instead of `Future.delayed(Duration.zero)`

---

*End of Quick Reference Cheat Sheet*
