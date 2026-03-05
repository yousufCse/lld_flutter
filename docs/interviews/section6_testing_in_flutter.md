# Section 6: Testing in Flutter

---

**Q:** What are the three types of Flutter tests — unit, widget, and integration — and when do you use each?

**A:** Flutter provides three layers of testing, each targeting a different scope of your application:

**Unit tests** verify a single function, method, or class in isolation. They don't touch any UI. They're the fastest to write and run because no rendering engine is involved. Use them for business logic, utilities, data transformations, and repository/service methods.

**Widget tests** (also called component tests) verify a single widget or a small widget subtree. They use a simulated rendering environment (`TestWidgetsFlutterBinding`) — faster than a real device but still renders the widget tree. Use them to verify UI behavior: does tapping a button trigger the right callback? Does a list show the correct items?

**Integration tests** verify an entire app or a large portion of it running on a real device or emulator. They exercise the full stack — UI, business logic, platform channels, network (or mocked network). Use them for critical user flows like login, checkout, or onboarding.

```
Scope and Speed Comparison:

  Scope        Speed        Confidence    Cost
  ─────        ─────        ──────────    ────
  Unit         Fastest      Low-Medium    Cheapest
  Widget       Medium       Medium-High   Moderate
  Integration  Slowest      Highest       Most expensive
```

**Example:**

```dart
// Unit test — tests pure logic, no widgets
test('Counter increments', () {
  final counter = Counter();
  counter.increment();
  expect(counter.value, 1);
});

// Widget test — tests a button widget renders and responds
testWidgets('Tap increments counter text', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: CounterPage()));
  expect(find.text('0'), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});

// Integration test — runs on real device via integration_test package
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full counter flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });
}
```

**Why it matters:** Interviewers want to know you understand the tradeoffs — not just that three types exist, but *why* you'd choose one over another. It shows you make pragmatic testing decisions instead of writing only one kind.

**Common mistake:** Saying "unit tests test units, widget tests test widgets" — a tautology that reveals no understanding. Another mistake is believing widget tests launch a device/emulator; they run entirely in the Dart VM with a test rendering engine.

---

**Q:** What is the test pyramid and how do you balance unit vs widget vs integration tests?

**A:** The test pyramid is a testing strategy that recommends having many fast, cheap tests at the bottom and fewer slow, expensive tests at the top:

```
          /\
         /  \
        / IT \          ← Few integration tests (critical paths)
       /──────\
      / Widget  \       ← Moderate widget tests (UI interactions)
     /────────────\
    /    Unit       \   ← Many unit tests (logic, models, repos)
   /──────────────────\
```

The rationale is economic: unit tests are fast (milliseconds each), cheap to maintain, and give rapid feedback. Integration tests are slow (seconds to minutes), flaky, and expensive to maintain — but they catch issues that unit tests can't (like widget A not wiring correctly to service B).

A healthy Flutter project might aim for roughly 70% unit, 20% widget, 10% integration — but this is a guideline, not a rule. A UI-heavy app might have more widget tests. A data-processing app might be almost entirely unit tests.

The key principle: **push testing down**. If you can verify a behavior with a unit test, don't use a widget test. If you can verify it with a widget test, don't use an integration test.

**Example:**

```
Feature: "Add to Cart" button

Unit tests (many):
  - CartBloc emits correct state when AddToCart event fires
  - CartRepository.addItem() calls API correctly
  - Price calculation logic handles discounts

Widget tests (some):
  - AddToCartButton renders enabled/disabled states
  - Tapping button dispatches AddToCart event to BLoC
  - Snackbar shows on success

Integration tests (one or two):
  - User browses product → taps Add → sees cart badge update
```

**Why it matters:** Shows you think about test ROI — not just "we should test everything" but where each dollar of testing effort gives the most return.

**Common mistake:** Inverting the pyramid — writing many integration tests and few unit tests. This leads to slow CI, flaky pipelines, and tests that are painful to debug because a single failure could be caused by anything in the stack.

---

**Q:** Explain the core unit testing primitives — `test()`, `expect()`, `group()`, `setUp()`, `tearDown()`.

**A:**

`test()` defines a single test case. It takes a description string and a callback containing your assertions.

`expect()` is the assertion function. It takes the actual value and a matcher. Flutter provides rich matchers: `equals`, `isTrue`, `throwsA`, `isA<Type>()`, `contains`, etc.

`group()` organizes related tests under a shared label. Groups can be nested. They're useful for structuring output and sharing setup/teardown.

`setUp()` runs before **each** test in the current group. Use it to initialize fresh instances so tests don't share mutable state.

`tearDown()` runs after **each** test. Use it to clean up resources like stream subscriptions, controllers, or file handles.

There are also `setUpAll()` and `tearDownAll()` which run once for the entire group — useful for expensive one-time setup like loading fixtures.

**Example:**

```dart
import 'package:test/test.dart';

void main() {
  group('Calculator', () {
    late Calculator calc;

    setUp(() {
      // Runs before EACH test — fresh instance every time
      calc = Calculator();
    });

    tearDown(() {
      // Runs after EACH test — clean up if needed
      calc.dispose();
    });

    test('adds two numbers', () {
      expect(calc.add(2, 3), equals(5));
    });

    test('throws on division by zero', () {
      expect(
        () => calc.divide(10, 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    group('subtraction', () {
      test('subtracts positive numbers', () {
        expect(calc.subtract(5, 3), equals(2));
      });

      test('handles negative results', () {
        expect(calc.subtract(3, 5), equals(-2));
      });
    });
  });
}
```

**Why it matters:** These are the absolute foundation. If you can't fluently use these primitives, every other testing topic falls apart. Interviewers check that you structure tests cleanly with proper isolation.

**Common mistake:** Sharing mutable state across tests by initializing objects outside `setUp()`. Tests then become order-dependent and produce intermittent failures. Each test should start from a known, clean state.

---

**Q:** How does widget testing work — explain `pumpWidget`, `find`, `tap`, `pump`, and `pumpAndSettle`.

**A:** Widget testing uses the `WidgetTester` provided by `testWidgets()` to render widgets in a headless test environment and interact with them.

`pumpWidget(widget)` — Inflates and renders the given widget tree. This is your "launch the screen" step. You almost always wrap your widget in `MaterialApp` because many widgets depend on inherited widgets like `MediaQuery`, `Theme`, or `Navigator`.

`find` — A top-level object providing finders to locate widgets in the tree:
- `find.byType(MyWidget)` — finds by runtime type
- `find.byKey(Key('myKey'))` — finds by the widget's key
- `find.text('Hello')` — finds `Text` widgets containing that string
- `find.byIcon(Icons.add)` — finds `Icon` widgets

`tap(finder)` — Simulates a tap gesture on the widget found by the finder. If the finder matches multiple widgets, use `find.byType(X).first`.

`pump()` — Triggers a single frame rebuild. After a `tap` or `setState`, the UI doesn't automatically rebuild in tests — you must call `pump()` to advance the framework by one frame.

`pumpAndSettle()` — Keeps pumping frames until there are no more pending animations or scheduled frames. Use this when your widget has animations (e.g., page transitions, `AnimatedContainer`). It has a timeout to prevent infinite loops.

```
Test lifecycle:

  pumpWidget(...)    →  Widget tree built, first frame rendered
       │
  find.byText('X')  →  Locates widget (doesn't rebuild anything)
       │
  tap(finder)        →  Dispatches gesture event
       │
  pump()             →  Rebuilds one frame — state changes appear
       │
  expect(...)        →  Assert the new UI state
```

**Example:**

```dart
testWidgets('Login button is disabled until form is valid', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: LoginScreen()),
  );

  // Initially the button should be disabled
  final button = find.byType(ElevatedButton);
  expect(tester.widget<ElevatedButton>(button).enabled, isFalse);

  // Enter valid email
  await tester.enterText(find.byKey(const Key('email_field')), 'user@test.com');
  await tester.pump();

  // Enter valid password
  await tester.enterText(find.byKey(const Key('password_field')), 'Secure123!');
  await tester.pump();

  // Now button should be enabled
  expect(tester.widget<ElevatedButton>(button).enabled, isTrue);

  // Tap and wait for any animations
  await tester.tap(button);
  await tester.pumpAndSettle();

  // Verify navigation happened
  expect(find.byType(HomePage), findsOneWidget);
});
```

**Why it matters:** Widget testing is where Flutter's testing story really shines compared to other frameworks. Interviewers want to see that you can fluently drive UI in tests and understand the manual frame-pumping model.

**Common mistake:** Forgetting to call `pump()` after `tap()` and then wondering why `expect` fails — the UI hasn't rebuilt yet. Another classic: not wrapping with `MaterialApp` and getting "No MediaQuery widget ancestor" errors.

---

**Q:** How do you test async code in Flutter — async tests, `fakeAsync`, and `advanceTimeBy`?

**A:** There are two approaches for testing async code:

**1. Real async with `async/await`:** You mark your test callback as `async`, and `await` any futures. The test runner waits for the future to complete. This is simple and works when the async operation is fast (like a mocked API call).

**2. `fakeAsync` with manual time control:** Wraps your test in a synthetic time zone where `Timer`, `Future.delayed`, and `Stream.periodic` don't actually wait. You advance time manually with `fakeAsync`'s clock. This is essential for testing debounce logic, polling intervals, timeouts, or any code with `Future.delayed`.

Inside `fakeAsync`, you use:
- `tester.pump(duration)` — advances time by that duration in widget tests
- `fakeAsync((FakeAsync async) => async.elapse(duration))` — in pure unit tests
- The key function in widget tests is passing the duration to `pump`

**Example:**

```dart
// Approach 1: Real async — for fast mocked operations
test('fetchUser returns user from API', () async {
  when(() => mockApi.getUser(1)).thenAnswer(
    (_) async => User(id: 1, name: 'Alice'),
  );

  final user = await repository.fetchUser(1);

  expect(user.name, 'Alice');
});

// Approach 2: fakeAsync — for time-dependent logic
testWidgets('Debounced search waits 500ms before calling API',
    (tester) async {
  await tester.pumpWidget(MaterialApp(home: SearchScreen()));

  // Type a query
  await tester.enterText(find.byType(TextField), 'flutter');
  
  // After 200ms — API should NOT have been called yet
  await tester.pump(const Duration(milliseconds: 200));
  verifyNever(() => mockSearchApi.search(any()));

  // After another 300ms (total 500ms) — NOW it fires
  await tester.pump(const Duration(milliseconds: 300));
  verify(() => mockSearchApi.search('flutter')).called(1);
});

// Pure unit test with fakeAsync
test('Retry logic retries after 2 seconds', () {
  fakeAsync((async) {
    final service = RetryService();
    int attempts = 0;
    service.doWithRetry(() {
      attempts++;
      if (attempts < 3) throw Exception('fail');
    });

    async.elapse(const Duration(seconds: 0)); // first attempt
    expect(attempts, 1);

    async.elapse(const Duration(seconds: 2)); // second attempt
    expect(attempts, 2);

    async.elapse(const Duration(seconds: 2)); // third attempt
    expect(attempts, 3);
  });
});
```

**Why it matters:** Real applications are heavily async. Interviewers want to see you can test time-dependent behavior deterministically — no `sleep()`, no flaky waits, full control over the clock.

**Common mistake:** Using `await Future.delayed(Duration(seconds: 2))` in a test to wait for a debounce. This makes your test suite slow and non-deterministic. Always use `fakeAsync` + time advancement for anything time-dependent.

---

**Q:** How does mocking with Mockito work in Flutter — `@GenerateMocks`, `when`/`thenReturn`, `verify`?

**A:** The `mockito` package for Dart uses **code generation** to create mock classes. You annotate a test file, run build_runner, and it generates type-safe mocks.

**Step 1:** Annotate with `@GenerateMocks` and run code generation.

**Step 2:** Use `when(...).thenReturn(...)` to stub method return values. For async methods, use `when(...).thenAnswer((_) async => value)`.

**Step 3:** Use `verify(...)` to assert a method was called (optionally with specific arguments or call counts).

```
Mockito Workflow:

  @GenerateMocks([MyService])
         │
   build_runner generates
         │
   MockMyService class
         │
  when(mock.method()).thenReturn(value)   ← Stub
         │
  systemUnderTest.doWork()                ← Exercise
         │
  verify(mock.method()).called(1)         ← Verify
```

**Example:**

```dart
// File: user_repository_test.dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([ApiClient])  // Generates MockApiClient
import 'user_repository_test.mocks.dart';

void main() {
  late MockApiClient mockApi;
  late UserRepository repo;

  setUp(() {
    mockApi = MockApiClient();
    repo = UserRepository(api: mockApi);
  });

  test('getUser calls API and returns parsed user', () async {
    // Stub — define what the mock returns
    when(mockApi.get('/users/1')).thenAnswer(
      (_) async => Response(data: {'id': 1, 'name': 'Alice'}),
    );

    // Act
    final user = await repo.getUser(1);

    // Assert value
    expect(user.name, 'Alice');

    // Verify interaction
    verify(mockApi.get('/users/1')).called(1);
    verifyNoMoreInteractions(mockApi);
  });

  test('getUser throws when API fails', () {
    when(mockApi.get(any)).thenThrow(NetworkException());

    expect(
      () => repo.getUser(1),
      throwsA(isA<NetworkException>()),
    );
  });
}
```

Then run: `dart run build_runner build --delete-conflicting-outputs`

**Why it matters:** Mockito is the most widely used mocking library in the Dart ecosystem. Knowing the generate → stub → verify cycle is essential for any testable architecture.

**Common mistake:** Using `thenReturn` for async methods instead of `thenAnswer`. `thenReturn(Future.value(x))` returns the *same* Future instance every call, which can cause subtle bugs. Always use `thenAnswer((_) async => x)` for async stubs. Another mistake: forgetting to run `build_runner` after adding `@GenerateMocks`, then being confused by missing class errors.

---

**Q:** How does Mocktail differ from Mockito and when would you choose it?

**A:** `mocktail` is a mocking library that requires **no code generation**. You create mocks by extending `Mock` and implementing the interface manually. This eliminates the `build_runner` step entirely.

Key differences:

- **No `@GenerateMocks`** — just write `class MockApiClient extends Mock implements ApiClient {}`
- **No build_runner dependency** — faster setup, no generated files to manage
- **Uses `when(() => ...)` with a closure** — note the `() =>` lambda syntax vs Mockito's direct call
- **`any()` requires `registerFallbackValue`** — for custom types used with argument matchers

Mocktail is increasingly popular in the Flutter community because it simplifies the development workflow, especially in projects that already use other code-gen-heavy packages (freezed, json_serializable) and want to minimize build times.

Choose Mockito when: your team already uses it, you prefer generated type safety, or your project's build_runner pipeline is already established.

Choose Mocktail when: you want simpler setup, faster test iteration (no code gen), or you're starting a new project and want minimal ceremony.

**Example:**

```dart
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// No code generation — just extend Mock
class MockApiClient extends Mock implements ApiClient {}

// Required for argument matchers with custom types
class FakeUserRequest extends Fake implements UserRequest {}

void main() {
  late MockApiClient mockApi;
  late UserRepository repo;

  setUpAll(() {
    // Register fallback values for custom types used with any()
    registerFallbackValue(FakeUserRequest());
  });

  setUp(() {
    mockApi = MockApiClient();
    repo = UserRepository(api: mockApi);
  });

  test('creates user via API', () async {
    // Note: when(() => ...) — closure syntax
    when(() => mockApi.createUser(any())).thenAnswer(
      (_) async => User(id: 1, name: 'Alice'),
    );

    final user = await repo.createUser(
      UserRequest(name: 'Alice'),
    );

    expect(user.id, 1);
    verify(() => mockApi.createUser(any())).called(1);
  });
}
```

**Why it matters:** Interviewers want to see you've worked with real testing workflows and can articulate *why* you choose a tool, not just how. Knowing both libraries and their tradeoffs shows maturity.

**Common mistake:** Forgetting `registerFallbackValue()` in Mocktail when using `any()` — this causes a runtime error about missing fallback values. Another mistake: using Mockito syntax (`when(mock.method())`) in Mocktail instead of the closure syntax (`when(() => mock.method())`).

---

**Q:** How do you test a BLoC or Cubit using `bloc_test`?

**A:** The `bloc_test` package provides a `blocTest` function that follows a structured pattern: **build → seed (optional) → act → expect → verify (optional)**. It captures all states emitted during `act` and compares them against the expected states list.

`build` — creates the BLoC/Cubit instance (with mocked dependencies).

`seed` — optionally sets an initial state before `act` runs (useful for testing behavior from a specific starting state).

`act` — performs the action (add an event for BLoC, call a method for Cubit).

`expect` — a list of states expected to be emitted **after** the initial state. The initial state itself is NOT included in this list.

`errors` — verifies that specific errors were thrown.

`verify` — runs after the test for additional assertions (like `verify(mock.method()).called(1)`).

**Example:**

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
  });

  group('UserCubit', () {
    blocTest<UserCubit, UserState>(
      'emits [loading, loaded] when fetchUser succeeds',
      build: () {
        when(() => mockRepo.getUser(1)).thenAnswer(
          (_) async => User(id: 1, name: 'Alice'),
        );
        return UserCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.fetchUser(1),
      expect: () => [
        UserLoading(),              // First emitted state
        UserLoaded(User(id: 1, name: 'Alice')),  // Second
      ],
    );

    blocTest<UserCubit, UserState>(
      'emits [loading, error] when fetchUser fails',
      build: () {
        when(() => mockRepo.getUser(any()))
            .thenThrow(ServerException('500'));
        return UserCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.fetchUser(1),
      expect: () => [
        UserLoading(),
        const UserError('Failed to load user'),
      ],
    );

    blocTest<UserCubit, UserState>(
      'refresh from loaded state re-fetches user',
      build: () {
        when(() => mockRepo.getUser(1)).thenAnswer(
          (_) async => User(id: 1, name: 'Bob'),
        );
        return UserCubit(repository: mockRepo);
      },
      seed: () => UserLoaded(User(id: 1, name: 'Alice')),  // Start from this state
      act: (cubit) => cubit.fetchUser(1),
      expect: () => [
        UserLoading(),
        UserLoaded(User(id: 1, name: 'Bob')),
      ],
      verify: (_) {
        verify(() => mockRepo.getUser(1)).called(1);
      },
    );
  });
}
```

**Why it matters:** BLoCs and Cubits are the most common state management in production Flutter apps. `bloc_test` is the standard way to test them. Interviewers expect you to know this pattern cold.

**Common mistake:** Including the initial state in the `expect` list. `blocTest` only checks states emitted *after* the initial state — the initial/seed state is excluded. Another mistake: not making state classes equatable (override `==` and `hashCode` or use `Equatable`), which causes expect comparisons to fail even when the values match.

---

**Q:** How do you test a repository that calls an HTTP API — how do you mock Dio or http?

**A:** You never make real HTTP calls in unit tests. Instead, you mock the HTTP client at the boundary. The strategy differs slightly for `http` vs `Dio`, but the principle is the same: inject the client, mock it in tests.

**For the `http` package:** Create a `MockClient` using `http.testing`:

```dart
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

test('fetchUser parses response correctly', () async {
  final mockClient = MockClient((request) async {
    // Verify the request
    expect(request.url.path, '/api/users/1');
    expect(request.method, 'GET');

    // Return a fake response
    return http.Response(
      '{"id": 1, "name": "Alice"}',
      200,
      headers: {'content-type': 'application/json'},
    );
  });

  final repo = UserRepository(client: mockClient);
  final user = await repo.fetchUser(1);

  expect(user.name, 'Alice');
});
```

**For Dio:** Mock the `Dio` instance using Mocktail or use Dio's `HttpClientAdapter`:

```dart
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late UserRepository repo;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    repo = UserRepository(dio: mockDio);
  });

  test('fetchUser returns user on 200', () async {
    when(() => mockDio.get('/users/1')).thenAnswer(
      (_) async => Response(
        data: {'id': 1, 'name': 'Alice'},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/users/1'),
      ),
    );

    final user = await repo.fetchUser(1);
    expect(user.name, 'Alice');
  });

  test('fetchUser throws on 404', () async {
    when(() => mockDio.get('/users/999')).thenThrow(
      DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: '/users/999'),
        ),
        requestOptions: RequestOptions(path: '/users/999'),
      ),
    );

    expect(
      () => repo.fetchUser(999),
      throwsA(isA<UserNotFoundException>()),
    );
  });
}
```

**Architecture tip:** Define an abstract interface for your API client so that the repository depends on an abstraction, not directly on Dio/http. This makes swapping mocks trivial:

```dart
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path);
}

class DioApiClient implements ApiClient { /* wraps Dio */ }
class MockApiClient extends Mock implements ApiClient {}
```

**Why it matters:** HTTP mocking is a practical, everyday skill. Interviewers want to see you can test the data layer without flaky network calls and that you understand dependency injection as a prerequisite for testability.

**Common mistake:** Hardcoding `Dio()` or `http.Client()` inside the repository with no way to inject a mock. If you `new` up the client internally, you can't test the repository in isolation. Always inject the client through the constructor.

---

**Q:** What are golden tests, how do you create and update them, and when should you use them?

**A:** Golden tests (also called snapshot tests) capture a pixel-by-pixel image of a rendered widget and compare it against a previously saved "golden" image file. If the pixels differ, the test fails — this catches unintended visual regressions.

**How they work:**

1. You write a test that renders a widget and calls `expectLater` with `matchesGoldenFile`.
2. First run: generate the golden image with `--update-goldens`.
3. Subsequent runs: the rendered output is compared pixel-for-pixel to the saved image.
4. If someone changes the widget's appearance intentionally, you regenerate the goldens.

```
Golden Test Lifecycle:

  First time:  flutter test --update-goldens
                   │
               Renders widget → Saves PNG as reference
                   │
  CI / future: flutter test
                   │
               Renders widget → Compares with saved PNG
                   │
              Match? ──── Yes → Pass
                   │
                   No → FAIL (visual regression detected)
```

**Example:**

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileCard golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileCard(
            name: 'Alice',
            role: 'Engineer',
            avatarUrl: 'https://example.com/avatar.png',
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(ProfileCard),
      matchesGoldenFile('goldens/profile_card.png'),
    );
  });
}
```

**Generating/updating goldens:**
```bash
# Generate or update golden files
flutter test --update-goldens

# Normal test run — compares against goldens
flutter test
```

**When to use them:**
- Custom-painted widgets (`CustomPainter`)
- Complex layout components where spacing matters
- Design system components that must remain pixel-perfect
- Charts and data visualizations

**When NOT to use them:**
- Standard Material widgets (Flutter already tests those)
- Screens that change frequently during development
- Widgets whose text content varies (localization, dynamic data)

**Example:**

Golden images are platform-sensitive (font rendering differs across macOS, Linux, Windows). Teams typically generate goldens on CI (Linux) and compare only there to avoid cross-platform mismatches.

**Why it matters:** Golden tests show you understand visual regression testing — a concern in design-heavy apps. Interviewers check if you know when they add value vs when they become maintenance burdens.

**Common mistake:** Generating goldens on your Mac and running CI on Linux — font rendering differences cause every golden to fail. Always generate and compare on the same platform (typically the CI environment).

---

**Q:** How does integration testing work in Flutter — `integration_test` package and running on real devices?

**A:** Flutter's `integration_test` package runs full-app tests on a real device or emulator. Unlike widget tests (which use a headless engine), integration tests exercise the complete rendering pipeline, platform channels, and real widget binding.

**Setup:**

1. Add `integration_test` (and `flutter_test`) as dev dependencies.
2. Create a `integration_test/` directory at the project root.
3. Write test files using `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`.

**Project structure:**
```
my_app/
├── lib/
│   └── main.dart
├── test/                      ← unit and widget tests
│   └── widget_test.dart
├── integration_test/          ← integration tests
│   └── app_test.dart
└── pubspec.yaml
```

**Example:**

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('user can log in and see home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'user@test.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.pumpAndSettle();

      // Tap login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verify we reached home
      expect(find.text('Welcome back!'), findsOneWidget);
    });
  });
}
```

**Running:**
```bash
# On a connected device or emulator
flutter test integration_test/app_test.dart

# On a specific device
flutter test integration_test/app_test.dart -d <device_id>

# On Chrome (for web)
flutter test integration_test/app_test.dart -d chrome
```

**Why it matters:** Integration tests are the final safety net before shipping. Interviewers want to know you've tested beyond isolated units — especially for critical flows.

**Common mistake:** Confusing `flutter_driver` (the legacy approach) with `integration_test` (the current recommended approach). `flutter_driver` runs in a separate process and communicates over a protocol; `integration_test` runs in the same process as the app, which is faster and gives direct access to the widget tree. Always use `integration_test` for new projects.

---

**Q:** How do you generate and measure code coverage in Flutter?

**A:** Flutter has built-in coverage support via `lcov`.

**Generating coverage:**
```bash
# Run tests with coverage collection
flutter test --coverage

# This produces: coverage/lcov.info
```

**Viewing the report:**
```bash
# Install lcov (if not present)
# macOS: brew install lcov
# Linux: sudo apt-get install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

**Filtering out generated files:**
```bash
# Remove generated files from coverage report
lcov --remove coverage/lcov.info \
  '**/*.g.dart' \
  '**/*.freezed.dart' \
  '**/generated/**' \
  -o coverage/lcov_filtered.info
```

**Example CI integration (GitHub Actions snippet concept):**
```yaml
# Conceptual — in your CI pipeline:
# 1. flutter test --coverage
# 2. Filter generated files
# 3. Enforce minimum threshold
# 4. Upload to Codecov / Coveralls
```

**What coverage measures:** Line coverage tracks which lines of code were executed during testing. It does NOT tell you whether your tests are *good* — only which lines were reached. 80% coverage with well-designed tests is far better than 100% coverage with shallow assertions.

**Practical targets:**
- 80%+ for business logic / domain layer
- 70%+ for repositories / data layer
- 50%+ for UI layer (widget tests are more expensive)
- Don't chase 100% — diminishing returns set in quickly

**Why it matters:** Interviewers check if you understand coverage as a *metric*, not a *goal*. They want to know you can set up the tooling and interpret the results pragmatically.

**Common mistake:** Treating coverage percentage as a quality indicator. 95% coverage doesn't mean your tests are good — you could hit every line without meaningful assertions. Coverage shows you what's *not* tested, not that what *is* tested is well-tested.

---

**Q:** How do you test a screen that depends on a Cubit?

**A:** You mock the Cubit and provide it to the widget tree using `BlocProvider.value`. This isolates the widget test from real business logic — you control exactly what state the screen sees.

**Strategy:**

1. Create a mock of your Cubit (using Mocktail).
2. Stub the `state` getter to return the state you want to test.
3. Stub the `stream` getter to return the states you want emitted during the test.
4. Wrap the screen in `BlocProvider.value(value: mockCubit, child: ScreenUnderTest())`.
5. Assert the UI renders correctly for that state.

**Example:**

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// MockCubit using bloc_test's MockCubit helper
class MockUserCubit extends MockCubit<UserState> implements UserCubit {}

void main() {
  late MockUserCubit mockCubit;

  setUp(() {
    mockCubit = MockUserCubit();
  });

  testWidgets('shows loading spinner when state is UserLoading',
      (tester) async {
    // Stub the cubit to emit loading state
    when(() => mockCubit.state).thenReturn(UserLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserCubit>.value(
          value: mockCubit,
          child: const UserScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows user name when state is UserLoaded',
      (tester) async {
    when(() => mockCubit.state).thenReturn(
      UserLoaded(User(id: 1, name: 'Alice')),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserCubit>.value(
          value: mockCubit,
          child: const UserScreen(),
        ),
      ),
    );

    expect(find.text('Alice'), findsOneWidget);
  });

  testWidgets('shows error message and retry button on error state',
      (tester) async {
    when(() => mockCubit.state).thenReturn(
      const UserError('Connection failed'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserCubit>.value(
          value: mockCubit,
          child: const UserScreen(),
        ),
      ),
    );

    expect(find.text('Connection failed'), findsOneWidget);
    expect(find.byKey(const Key('retry_button')), findsOneWidget);

    // Tap retry and verify cubit method is called
    await tester.tap(find.byKey(const Key('retry_button')));
    verify(() => mockCubit.fetchUser(any())).called(1);
  });
}
```

**Note:** `MockCubit` from `bloc_test` automatically handles stubbing `state` and `stream` correctly. If you manually extend `Mock`, you need to stub both `state` and `stream` yourself.

**Why it matters:** This is one of the most common real-world testing scenarios in Flutter. Every screen backed by BLoC/Cubit needs this pattern. Interviewers will likely ask you to write this on the spot.

**Common mistake:** Providing a real Cubit in a widget test and mocking its dependencies — this turns your widget test into a quasi-integration test and makes it brittle. Mock the Cubit directly to keep the widget test focused on UI behavior. Another mistake: using `BlocProvider(create: ...)` instead of `BlocProvider.value(value: ...)` in tests — the `create` variant manages the Cubit lifecycle, but in tests you want explicit control over the mock.

---

**Q:** What is the Fake pattern vs the Mock pattern — when do you use each?

**A:** Both are test doubles, but they serve different purposes:

**Mock:** A generated or manually created object that records interactions. You stub methods (`when/thenReturn`) and verify calls (`verify`). Mocks are about *behavior verification* — did method X get called with argument Y?

**Fake:** A real, hand-written implementation of an interface, but with simplified logic. No stubbing syntax. No verification. Fakes are about *providing a working substitute* — typically an in-memory implementation.

```
Decision Flow:

  Do you need to verify HOW the dependency was called?
      │
      Yes → Use a Mock
      │       (verify call count, arguments, order)
      │
      No → Do you need a working implementation
           with simplified behavior?
           │
           Yes → Use a Fake
           │       (in-memory DB, local cache, etc.)
           │
           No → Maybe you don't need a test double at all
```

**Example:**

```dart
// FAKE — a real implementation with simplified internals
class FakeUserRepository implements UserRepository {
  final List<User> _users = [];

  @override
  Future<void> addUser(User user) async {
    _users.add(user);
  }

  @override
  Future<User?> getUser(int id) async {
    return _users.where((u) => u.id == id).firstOrNull;
  }

  @override
  Future<List<User>> getAllUsers() async {
    return List.unmodifiable(_users);
  }
}

// Used in test — no stubbing needed
test('UserService adds and retrieves user', () async {
  final fakeRepo = FakeUserRepository();
  final service = UserService(repository: fakeRepo);

  await service.registerUser('Alice');
  final users = await service.listUsers();

  expect(users, hasLength(1));
  expect(users.first.name, 'Alice');
});


// MOCK — when you care about interaction
test('UserService calls repository.addUser exactly once', () async {
  final mockRepo = MockUserRepository();
  when(() => mockRepo.addUser(any())).thenAnswer((_) async {});
  final service = UserService(repository: mockRepo);

  await service.registerUser('Alice');

  verify(() => mockRepo.addUser(any())).called(1);
});
```

**When to use Fakes:**
- You're testing behavior that depends on state building up over multiple calls (like an in-memory database)
- The stubbing ceremony would be too verbose for many methods
- You want tests that read more naturally without `when/thenReturn` noise

**When to use Mocks:**
- You need to verify *that* a method was called (and how many times, with what arguments)
- The dependency has side effects you want to prevent (network calls, disk writes)
- You want to simulate specific failure modes (`thenThrow`)

**Why it matters:** Shows you understand that "mocking" isn't one-size-fits-all. Choosing the right test double makes tests more readable and maintainable. This is a sign of testing maturity.

**Common mistake:** Using mocks for everything, even when a simple fake would be cleaner. Over-mocking leads to tests that are tightly coupled to implementation details. If you mock every method and verify every call, a simple refactor breaks dozens of tests even though behavior didn't change.

---

**Q:** How do you keep tests maintainable as the codebase grows?

**A:** Test maintainability is an architecture problem, not just a testing problem. Here are the key practices:

**1. Follow the test pyramid faithfully.** Most logic should be tested at the unit level. If a unit test can catch it, don't duplicate that verification in a widget or integration test.

**2. Use helper functions and factory methods for test setup.** When multiple tests need the same widget tree or data setup, extract it:

```dart
// BAD — duplicated across 20 tests
await tester.pumpWidget(
  MaterialApp(
    home: BlocProvider.value(
      value: mockCubit,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: mockAuthCubit),
          BlocProvider.value(value: mockThemeCubit),
        ],
        child: const MyScreen(),
      ),
    ),
  ),
);

// GOOD — extracted helper
Future<void> pumpMyScreen(WidgetTester tester, {
  UserState? userState,
  AuthState? authState,
}) async {
  when(() => mockUserCubit.state).thenReturn(
    userState ?? UserLoading(),
  );
  when(() => mockAuthCubit.state).thenReturn(
    authState ?? Authenticated(),
  );

  await tester.pumpWidget(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>.value(value: mockUserCubit),
          BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        ],
        child: const MyScreen(),
      ),
    ),
  );
}
```

**3. Use `Key` widgets strategically.** Find widgets by `Key` rather than `byType` when there are multiple instances. But don't over-key — it adds noise.

**4. Keep tests focused — one concept per test.** A test named `test('everything works')` that checks 15 things is unmaintainable. When it fails, you don't know what broke.

**5. Treat test code like production code.** Apply DRY, clear naming, and refactoring. Use `group()` to organize. Name tests as behaviors: `'emits error state when repository throws'` not `'test 3'`.

**6. Don't over-mock.** Mock only direct dependencies. If `ServiceA` depends on `RepoB` which depends on `ApiClientC`, the test for `ServiceA` should mock `RepoB` — not `ApiClientC`. Testing too many layers deep makes tests fragile.

**7. Run tests in CI on every PR.** Tests that aren't run regularly rot. Flaky tests must be fixed or deleted immediately — never ignored.

```
Maintainability checklist:

  ✓  Each test verifies ONE behavior
  ✓  Helpers reduce duplication without hiding intent
  ✓  Mocks only at the immediate dependency boundary
  ✓  State classes implement Equatable
  ✓  No magic numbers — use named constants or factories
  ✓  Tests run in < 2 minutes on CI
  ✓  Flaky tests are fixed, not skipped
  ✓  Golden tests generated on CI, not local machines
```

**Why it matters:** Every team writes tests initially. The difference between good and struggling teams is whether those tests stay maintainable at scale. Interviewers ask this to gauge whether you've lived through test suite rot and learned from it.

**Common mistake:** Writing tests that mirror implementation instead of behavior. If you test that `method A calls method B then calls method C in order`, any refactoring breaks the test even if the observable behavior is identical. Test *what* happens, not *how* it happens internally.
