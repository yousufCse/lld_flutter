# Section 4: Navigation & Routing

---

**Q:** Explain Navigator 1.0 — how does the navigation stack work? Walk through push, pop, pushReplacement, pushAndRemoveUntil, and maybePop.

**A:** Navigator 1.0 manages screens as a stack (Last-In-First-Out). Think of it as a stack of plates — you always interact with the top plate first.

```
Navigator Stack (visual):

  ┌─────────────┐
  │  Screen C   │  ← top (visible)
  ├─────────────┤
  │  Screen B   │
  ├─────────────┤
  │  Screen A   │  ← bottom (root)
  └─────────────┘
```

Here is what each method does:

`push` — Adds a new route on top of the stack. The previous screen stays in memory underneath.

`pop` — Removes the topmost route, revealing the one below.

`pushReplacement` — Pushes a new route and removes the current one. The stack size stays the same. Perfect for login → home transitions where you don't want the user pressing back to go to login.

`pushAndRemoveUntil` — Pushes a new route and pops everything below it until a condition is met. Great for "go to home and clear everything."

`maybePop` — Attempts to pop. If the route is the last one in the stack (nothing below), it does nothing. It respects `WillPopScope`/`PopScope` and platform behavior (on Android root, it won't close the app accidentally).

**Example:**
```dart
// push
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const DetailScreen()),
);

// pop — optionally pass data back
Navigator.pop(context, 'result_data');

// pushReplacement — login → home (no back to login)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const HomeScreen()),
);

// pushAndRemoveUntil — clear entire stack, go to home
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const HomeScreen()),
  (route) => false, // false = remove ALL routes below
);

// maybePop — safe pop that won't close the app
Navigator.maybePop(context);
```

```
pushAndRemoveUntil visualized:

BEFORE:                    AFTER:
┌─────────────┐
│  Screen D   │            ┌─────────────┐
├─────────────┤            │    Home      │  ← pushed
│  Screen C   │   ──────►  └─────────────┘
├─────────────┤            (everything removed)
│  Screen B   │
├─────────────┤
│  Screen A   │
└─────────────┘
```

**Why it matters:** The interviewer wants to see that you understand how the navigation stack works conceptually, not just which method to call. They also want to know you pick the right method for real scenarios like post-login cleanup or preventing accidental app closure.

**Common mistake:** Confusing `pushReplacement` with `pushAndRemoveUntil`. `pushReplacement` only removes the *current* route — everything below it remains. `pushAndRemoveUntil` removes everything until the predicate returns true. Another mistake is using `pop` when `maybePop` is safer, especially on the root screen.

---

**Q:** Why was Navigator 2.0 introduced? What problems does it solve that Navigator 1.0 couldn't?

**A:** Navigator 1.0 is imperative — you explicitly say "push this screen" or "pop that screen" in response to user actions. This works fine for simple mobile apps, but it breaks down in three critical scenarios:

**Problem 1: Deep linking.** If a user taps a link like `myapp.com/products/42`, Navigator 1.0 has no clean way to reconstruct the entire stack (Home → Products → Product 42) from that URL. You'd need fragile manual logic to push multiple routes in sequence.

**Problem 2: Web URL sync.** On Flutter web, the browser URL bar should reflect the current route. With Navigator 1.0, the URL and the actual stack easily get out of sync. There is no built-in mechanism to parse a URL into a stack of pages or to update the URL when navigation changes.

**Problem 3: Back button / system navigation.** The Android system back button and the browser back button need to behave predictably. Navigator 1.0 doesn't give you a declarative way to define what the entire stack should look like at any moment; it only lets you push/pop one route at a time.

```
Navigator 1.0 (Imperative):
  User taps link → you write: push(A), then push(B), then push(C)
  URL changes? You manually parse and push.

Navigator 2.0 (Declarative):
  URL/state changes → you declare: "the stack is [A, B, C]"
  Framework handles the diff and animates transitions.
```

Navigator 2.0 introduces a declarative model — you describe the *desired* stack of pages based on app state, and Flutter figures out the transitions. This is the same mental model as how `build()` works for widgets.

**Example:**
```dart
// Navigator 1.0 — imperative
onTap: () => Navigator.push(context, MaterialPageRoute(
  builder: (_) => ProductScreen(id: 42),
));

// Navigator 2.0 — declarative (conceptual)
// You define pages based on state, not by calling push/pop:
Navigator(
  pages: [
    MaterialPage(child: HomeScreen()),
    if (selectedProductId != null)
      MaterialPage(child: ProductScreen(id: selectedProductId!)),
  ],
  onPopPage: (route, result) {
    selectedProductId = null; // update state, stack rebuilds
    return route.didPop(result);
  },
);
```

**Why it matters:** Interviewers ask this to see if you understand *why* a tool exists, not just how to use it. Understanding the motivation behind Navigator 2.0 shows architectural maturity.

**Common mistake:** Saying Navigator 2.0 "replaces" Navigator 1.0. It doesn't — Navigator 1.0 is still valid and often simpler for basic mobile-only apps. Navigator 2.0 is essential for web, deep linking, and complex navigation state. Also, many candidates confuse Navigator 2.0 raw APIs with packages like GoRouter — GoRouter is a wrapper *over* Navigator 2.0 that simplifies it enormously.

---

**Q:** Explain the core Navigator 2.0 concepts — Router, RouteInformationParser, and RouterDelegate. What does each one do?

**A:** Navigator 2.0 has three key pieces that form a pipeline between the platform (browser URL bar, OS deep link) and your app's page stack:

```
Platform URL / Deep Link
         │
         ▼
┌──────────────────────────┐
│  RouteInformationParser  │  Parses URL string → your route config object
└──────────┬───────────────┘
           │  (route config)
           ▼
┌──────────────────────────┐
│     RouterDelegate       │  Converts route config → List<Page> for Navigator
│  (builds the page stack) │  Also handles pop and notifies when state changes
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│       Navigator          │  Renders the actual widget stack
└──────────────────────────┘
```

**RouteInformationParser** takes a `RouteInformation` (basically a URI string from the platform) and converts it into an app-specific route configuration object that your code defines. It also does the reverse — converts your route config back into a URI to update the browser URL.

**RouterDelegate** is the brain. It holds the navigation state and builds the `Navigator` widget with the correct list of `Page` objects based on the current route configuration. It extends `RouterDelegate<T>` where `T` is your route config type. It implements `build()` to return a `Navigator` with the page stack, and `setNewRoutePath()` to react when the parser hands it a new route.

**Router** is the widget that ties everything together. It sits at the top of your widget tree and coordinates the parser and delegate. You rarely interact with it directly — you pass it a delegate and parser via `MaterialApp.router()`.

**Example:**
```dart
// Simplified — in practice you'd use GoRouter instead of raw APIs

class MyRouteConfig {
  final String? productId;
  MyRouteConfig({this.productId});
}

class MyRouteParser extends RouteInformationParser<MyRouteConfig> {
  @override
  Future<MyRouteConfig> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.uri.toString());
    // /products/42 → MyRouteConfig(productId: '42')
    if (uri.pathSegments.length == 2 && 
        uri.pathSegments[0] == 'products') {
      return MyRouteConfig(productId: uri.pathSegments[1]);
    }
    return MyRouteConfig(); // home
  }

  @override
  RouteInformation? restoreRouteInformation(MyRouteConfig config) {
    if (config.productId != null) {
      return RouteInformation(
        uri: Uri.parse('/products/${config.productId}'),
      );
    }
    return RouteInformation(uri: Uri.parse('/'));
  }
}

class MyRouterDelegate extends RouterDelegate<MyRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRouteConfig> {
  
  String? _selectedProductId;

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  MyRouteConfig get currentConfiguration =>
      MyRouteConfig(productId: _selectedProductId);

  @override
  Future<void> setNewRoutePath(MyRouteConfig config) async {
    _selectedProductId = config.productId;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: HomeScreen()),
        if (_selectedProductId != null)
          MaterialPage(child: ProductScreen(id: _selectedProductId!)),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        _selectedProductId = null;
        notifyListeners();
        return true;
      },
    );
  }
}

// Usage in MaterialApp
MaterialApp.router(
  routerDelegate: MyRouterDelegate(),
  routeInformationParser: MyRouteParser(),
);
```

**Why it matters:** Interviewers are checking whether you understand the architecture, not whether you memorize the boilerplate. In practice, everyone uses GoRouter — but understanding *what GoRouter wraps* shows depth.

**Common mistake:** Trying to memorize the raw Navigator 2.0 APIs for an interview. Instead, understand the three roles (parse URL → determine state → build page stack) and be honest that you use GoRouter in production. Another mistake: forgetting that `RouterDelegate` must call `notifyListeners()` when navigation state changes.

---

**Q:** How does GoRouter work? Explain route declaration, subroutes, path parameters, and query parameters.

**A:** GoRouter is a declarative routing package built on top of Navigator 2.0. You define your entire route tree upfront as a configuration, and GoRouter handles URL parsing, deep linking, transitions, and browser URL sync.

Routes are declared as a tree using `GoRoute` objects. Subroutes are nested inside a parent route's `routes` list — their paths are appended to the parent's path automatically.

Path parameters use `:paramName` syntax in the path. Query parameters don't need declaration — they're available from `GoRouterState`.

```
Route Tree:

  /                          → HomeScreen
  ├── products               → ProductListScreen
  │   └── :productId         → ProductDetailScreen  (full: /products/:productId)
  │       └── reviews        → ReviewsScreen         (full: /products/:productId/reviews)
  └── settings               → SettingsScreen
```

**Example:**
```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Subroute — full path becomes /products
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductListScreen(),
          routes: [
            // Path parameter — full path becomes /products/:productId
            GoRoute(
              path: ':productId',
              builder: (context, state) {
                final productId = state.pathParameters['productId']!;
                return ProductDetailScreen(id: productId);
              },
              routes: [
                // Deeper nesting — /products/:productId/reviews
                GoRoute(
                  path: 'reviews',
                  builder: (context, state) {
                    final productId = state.pathParameters['productId']!;
                    return ReviewsScreen(productId: productId);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

// Navigating with path parameters
context.go('/products/42');

// Navigating with query parameters
// URL: /products?sort=price&category=electronics
context.go('/products?sort=price&category=electronics');

// Reading query parameters in the builder
GoRoute(
  path: 'products',
  builder: (context, state) {
    final sort = state.uri.queryParameters['sort'];         // 'price'
    final category = state.uri.queryParameters['category']; // 'electronics'
    return ProductListScreen(sort: sort, category: category);
  },
),

// Use the router in MaterialApp
MaterialApp.router(
  routerConfig: router,
);
```

The difference between `context.go()` and `context.push()`:
- `go()` — replaces the entire stack to match the route hierarchy. Navigating to `/products/42` builds: Home → Products → Product 42.
- `push()` — pushes a single route on top of whatever is currently in the stack, like Navigator 1.0's push.

**Why it matters:** GoRouter is the de facto standard for Flutter routing in production. The interviewer wants to see that you can design a clean route tree and understand path vs query parameters.

**Common mistake:** Using leading slashes on subroutes. Subroute paths should be relative: `'products'` not `'/products'`. A leading slash makes it a top-level route, not a child. Another mistake: confusing `go()` with `push()` — `go()` rebuilds the stack declaratively, `push()` is imperative.

---

**Q:** How do you implement an auth guard / login guard using GoRouter redirect?

**A:** GoRouter's `redirect` callback runs before every navigation. It receives the target location and returns either `null` (allow navigation) or a new path (redirect). This is the perfect place to implement auth guards.

```
Redirect Flow:

  User navigates to /dashboard
          │
          ▼
  ┌──────────────────┐
  │  redirect() runs │
  │  Is user logged  │──── NO ───► return '/login'
  │  in?             │
  └───────┬──────────┘
          │ YES
          ▼
  return null (allow)
          │
          ▼
  DashboardScreen renders
```

**Example:**
```dart
final router = GoRouter(
  initialLocation: '/',
  
  // This runs on EVERY navigation event
  redirect: (BuildContext context, GoRouterState state) {
    final authCubit = context.read<AuthCubit>();
    final isLoggedIn = authCubit.state.isAuthenticated;
    final isGoingToLogin = state.matchedLocation == '/login';

    // Not logged in and NOT going to login → redirect to login
    if (!isLoggedIn && !isGoingToLogin) {
      // Preserve the original destination so we can redirect back after login
      return '/login?from=${state.matchedLocation}';
    }

    // Logged in but going to login → redirect to home
    if (isLoggedIn && isGoingToLogin) {
      return '/';
    }

    // No redirect needed
    return null;
  },

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final from = state.uri.queryParameters['from'] ?? '/';
        return LoginScreen(redirectTo: from);
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);

// After successful login, navigate to the original destination:
void onLoginSuccess(String redirectTo) {
  context.go(redirectTo);
}
```

For reactive auth (auto-redirect on logout), use `refreshListenable`:

```dart
final router = GoRouter(
  refreshListenable: authCubit.stream.toListenable(), // re-evaluates redirect
  redirect: (context, state) {
    // same logic as above
  },
  routes: [ /* ... */ ],
);

// Extension to convert Stream to Listenable:
// (or use GoRouterRefreshStream from go_router)
```

**Why it matters:** Auth guarding is a universal requirement. The interviewer is checking that you handle edge cases: infinite redirect loops (logged in but going to login), preserving the original destination, and reactive logout.

**Common mistake:** Forgetting to check `isGoingToLogin` — this creates an infinite redirect loop where the redirect sends you to `/login`, which triggers redirect again, which sends you to `/login`, forever. Also, not using `refreshListenable` means the router won't react when the user's auth state changes (e.g., token expires).

---

**Q:** What is GoRouter's ShellRoute? How do you implement nested navigation with a persistent bottom navigation bar?

**A:** `ShellRoute` wraps child routes in a shared UI shell — most commonly a `Scaffold` with a `BottomNavigationBar`. When the user navigates between child routes, only the body area changes while the bottom bar stays persistent and doesn't rebuild.

```
ShellRoute Layout:

┌────────────────────────────┐
│                            │
│     Child route content    │  ← Changes when navigating
│     (rendered inside the   │
│      shell's "child")      │
│                            │
├────────────────────────────┤
│  Home  │ Search │ Profile  │  ← Persistent, never rebuilds
└────────────────────────────┘
```

**Example:**
```dart
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithBottomNav(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            // This subroute still shows the bottom bar
            GoRoute(
              path: 'edit',
              builder: (context, state) => const EditProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Routes OUTSIDE ShellRoute have NO bottom bar
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);

// The shell widget
class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;
  const ScaffoldWithBottomNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateIndex(GoRouterState.of(context).matchedLocation),
        onTap: (index) {
          switch (index) {
            case 0: context.go('/home');
            case 1: context.go('/search');
            case 2: context.go('/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateIndex(String location) {
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }
}
```

For independent navigation stacks per tab (so each tab remembers its own history), use `StatefulShellRoute`:

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return ScaffoldWithNav(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    ]),
  ],
);
```

**Why it matters:** Almost every production app has a bottom nav bar. The interviewer is evaluating whether you know the difference between `ShellRoute` (shared shell, routes replace each other) and `StatefulShellRoute` (each branch maintains its own navigation stack and scroll position).

**Common mistake:** Using a plain `ShellRoute` when you need per-tab state preservation. With `ShellRoute`, switching from Home (scrolled down) to Search and back to Home resets Home's state. `StatefulShellRoute.indexedStack` keeps each branch alive. Another mistake: putting the login route *inside* the ShellRoute, which would show the bottom bar on the login screen.

---

**Q:** What is deep linking? How do you configure it for Android and iOS with GoRouter?

**A:** Deep linking lets an external source (a browser URL, a push notification, another app) open your app directly to a specific screen. Instead of always landing on the home screen, the user goes straight to e.g. the product detail screen.

```
Deep Link Flow:

  User taps: https://myapp.com/products/42
          │
          ▼
  ┌─────────────────┐
  │   OS intercepts  │
  │   (App Links /   │     App not installed → opens browser
  │   Universal      │──── App installed → opens app
  │   Links)         │
  └───────┬─────────┘
          │
          ▼
  GoRouter receives '/products/42'
          │
          ▼
  redirect() runs → builds correct page stack
```

GoRouter handles deep linking out of the box once the platform is configured. The route `/products/:id` will automatically work when the OS passes that URL to your app.

**Android Configuration (App Links):**

In `android/app/src/main/AndroidManifest.xml`, add an intent filter inside the `<activity>` tag:

```xml
<activity ...>
  <!-- Deep link intent filter -->
  <intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
      android:scheme="https"
      android:host="myapp.com" />
  </intent-filter>
</activity>
```

For verified App Links, you also need to host a `.well-known/assetlinks.json` file on your domain with your app's SHA-256 fingerprint.

**iOS Configuration (Universal Links):**

1. In `ios/Runner/Runner.entitlements`, add associated domains:

```xml
<key>com.apple.developer.associated-domains</key>
<array>
  <string>applinks:myapp.com</string>
</array>
```

2. Host an `apple-app-site-association` (AASA) file at `https://myapp.com/.well-known/apple-app-site-association`:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.example.myapp",
        "paths": ["/products/*", "/settings"]
      }
    ]
  }
}
```

**GoRouter side — no extra code needed:**

```dart
// GoRouter already handles the incoming URL.
// Your route tree processes /products/42 as normal.
GoRoute(
  path: 'products/:productId',
  builder: (context, state) {
    final id = state.pathParameters['productId']!;
    return ProductDetailScreen(id: id);
  },
),
```

**Why it matters:** Deep linking is a must for any production app — it's required for marketing campaigns, push notifications, and web-to-app flows. The interviewer wants to know you can configure both platforms, not just the Dart side.

**Common mistake:** Forgetting the platform-side configuration (AndroidManifest, AASA file) and thinking GoRouter alone is enough. Also, mixing up custom schemes (`myapp://`) with Universal/App Links (`https://`). Custom schemes don't go through verification and won't work from browsers. Production apps should use `https` with verified links.

---

**Q:** What is the difference between named routes and typed routes (go_router_builder)?

**A:** Named routes use string-based names to navigate. You define a `name` on each `GoRoute` and call `context.goNamed('product', pathParameters: {'id': '42'})`. This is the default GoRouter approach.

Typed routes use code generation via the `go_router_builder` package. You define route classes annotated with `@TypedGoRoute`, run `build_runner`, and get compile-time-safe navigation with generated extension methods.

```
Named Routes:
  context.goNamed('product', pathParameters: {'id': '42'})
  ─── runtime error if you typo 'product' or forget 'id' ───

Typed Routes:
  const ProductRoute(id: '42').go(context)
  ─── compile-time error if anything is wrong ───
```

**Example:**
```dart
// ── Named routes (default GoRouter) ──

GoRoute(
  name: 'product',
  path: '/products/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductScreen(id: id);
  },
),

// Navigation — string-based, no compile-time safety
context.goNamed(
  'product',
  pathParameters: {'id': '42'},
  queryParameters: {'tab': 'reviews'},
);


// ── Typed routes (go_router_builder) ──

// Step 1: Define route class
@TypedGoRoute<ProductRoute>(path: '/products/:id')
class ProductRoute extends GoRouteData {
  final String id;
  const ProductRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductScreen(id: id);
  }
}

// Step 2: Run build_runner
//   dart run build_runner build

// Step 3: Navigate — fully type-safe
const ProductRoute(id: '42').go(context);
```

**Why it matters:** This tests whether you care about type safety and maintainability. In large codebases, string-based routes become error-prone — a typo in a route name or a missing parameter silently breaks at runtime.

**Common mistake:** Saying typed routes are "better in every way." Typed routes add build_runner overhead and more boilerplate for small apps. Named routes are perfectly fine for small-to-medium projects. The right answer is knowing the trade-off: typed routes shine in large teams and complex apps; named routes are simpler for smaller ones.

---

**Q:** How do you pass arguments between screens? What is the safe (typed) way versus the unsafe way?

**A:** There are several approaches, ranging from type-safe to completely untyped.

**Unsafe way — using `extra` with dynamic types:**

GoRouter's `state.extra` is typed as `Object?`. You can pass anything, but you lose type safety and it breaks on web (since `extra` is not serializable to the URL).

**Safe way — using path/query parameters or typed routes:**

Path and query parameters are always strings (which is URL-safe), and typed routes give compile-time guarantees.

**Example:**
```dart
// ── UNSAFE: using extra ──
// Passing
context.go('/detail', extra: MyObject(id: 42, name: 'Widget'));

// Receiving — requires a cast, can fail at runtime
GoRoute(
  path: '/detail',
  builder: (context, state) {
    final data = state.extra as MyObject; // runtime crash if wrong type
    return DetailScreen(data: data);
  },
),
// Problems:
//   1. Casting can throw if extra is null or wrong type
//   2. Lost on web page refresh (extra is in-memory only)
//   3. Not reflected in the URL, so deep linking breaks


// ── SAFE: path + query parameters ──
// Navigation
context.go('/products/42?name=Widget');

// Route definition
GoRoute(
  path: '/products/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;       // always a String
    final name = state.uri.queryParameters['name']; // nullable String
    return ProductScreen(id: id, name: name);
  },
),
// Pros: survives web refresh, works with deep links


// ── SAFEST: typed routes (go_router_builder) ──
@TypedGoRoute<ProductRoute>(path: '/products/:id')
class ProductRoute extends GoRouteData {
  final String id;
  final String? name; // becomes a query param automatically
  const ProductRoute({required this.id, this.name});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductScreen(id: id, name: name);
  }
}

// Navigation — compiler enforces required params
const ProductRoute(id: '42', name: 'Widget').go(context);
```

**Why it matters:** The interviewer is testing two things: awareness of type safety, and understanding of web compatibility. If you rely on `extra`, your app breaks on web page refresh. Production apps need URL-serializable parameters.

**Common mistake:** Defaulting to `extra` for all argument passing because it's the easiest. This works on mobile but is a ticking time bomb for web and deep linking. Another mistake: not handling the case where `extra` is null (user refreshed the page or opened a deep link).

---

**Q:** How does `PopScope` work? How do you intercept the back button press?

**A:** `PopScope` (which replaced the deprecated `WillPopScope` in Flutter 3.12+) wraps a widget and controls whether the current route can be popped. It's used to intercept the system back button (Android), the back swipe gesture (iOS), and the `Navigator.pop()` call.

It has two key properties:
- `canPop` — a boolean. If `false`, the route cannot be popped by system gestures or back button. Calling `Navigator.pop()` directly still works.
- `onPopInvokedWithResult` — a callback that fires when a pop is attempted. Receives whether the pop was actually handled. This is where you show a confirmation dialog.

**Example:**
```dart
// Prevent accidental back navigation on a form with unsaved changes
class EditFormScreen extends StatefulWidget {
  const EditFormScreen({super.key});

  @override
  State<EditFormScreen> createState() => _EditFormScreenState();
}

class _EditFormScreenState extends State<EditFormScreen> {
  bool _hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges, // block pop when there are unsaved changes
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          // Pop already happened (canPop was true), nothing to do
          return;
        }
        // Pop was blocked — show confirmation dialog
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text('You have unsaved changes.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        );
        if (shouldLeave == true && context.mounted) {
          Navigator.pop(context); // manually pop after confirmation
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Form')),
        body: TextField(
          onChanged: (_) => setState(() => _hasUnsavedChanges = true),
        ),
      ),
    );
  }
}
```

**Why it matters:** This is extremely common in forms, checkout flows, and editors. The interviewer is checking that you know the modern API (`PopScope`) and not the deprecated one (`WillPopScope`), and that you handle the flow correctly without breaking the UX.

**Common mistake:** Still using `WillPopScope` — it was deprecated. Also, a subtle but important mistake: checking `didPop` wrong. When `canPop` is `false`, `didPop` will be `false` in the callback — that's when you should show the dialog. If `didPop` is `true`, the pop already happened and you shouldn't try to pop again or show a dialog.

---

**Q:** How do you handle 404 / unknown routes in GoRouter?

**A:** GoRouter provides an `errorBuilder` (or `errorPageBuilder`) that handles any navigation to an undefined path. This is GoRouter's equivalent of a 404 page.

When a user navigates to a path that doesn't match any defined route — whether via a typo, a stale deep link, or manually editing the URL on web — GoRouter invokes the error builder instead of crashing.

**Example:**
```dart
final router = GoRouter(
  routes: [ /* ... your routes ... */ ],

  // Called for any unmatched route
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '404',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('No route found for: ${state.matchedLocation}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);
```

If you don't provide an `errorBuilder`, GoRouter shows a default red error screen in debug mode.

You can also redirect unknown routes instead of showing an error page:

```dart
redirect: (context, state) {
  // GoRouter already handles unmatched routes via errorBuilder,
  // but if you want to redirect specific patterns:
  if (state.matchedLocation.startsWith('/old-path')) {
    return '/new-path';
  }
  return null;
},
```

**Why it matters:** On web, users can type any URL. In mobile, deep links from old app versions might point to removed routes. Handling unknown routes gracefully is a production requirement. Interviewers want to see you think about edge cases.

**Common mistake:** Not setting an `errorBuilder` at all and leaving the default error screen. Also, some candidates confuse `errorBuilder` with `redirect` — `redirect` runs for *matched* routes (e.g., auth guard), while `errorBuilder` is specifically for unmatched routes.

---

**Q:** How do you navigate from outside the widget tree — for example, from a Cubit, Service, or repository?

**A:** The core problem is that `context.go()` requires a `BuildContext`, which doesn't exist outside the widget tree. There are three practical approaches:

**Approach 1 (Recommended): Use a global navigator key.**

Create a `GlobalKey<NavigatorState>` and pass it to GoRouter. Any code with access to this key can navigate without context.

**Approach 2: Pass a callback from the UI layer.**

The Cubit emits a state, the UI reacts to it and navigates. This keeps navigation in the widget tree where it belongs.

**Approach 3: Use GoRouter's static instance.**

Access the router directly via a global reference.

**Example:**
```dart
// ── Approach 1: Global Navigator Key ──

// navigation_service.dart
final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [ /* ... */ ],
);

// In a Cubit or Service — no context needed
void onPaymentComplete() {
  rootNavigatorKey.currentContext?.let((ctx) {
    GoRouter.of(ctx).go('/success');
  });
  // Or even simpler, keep a reference to the router:
  router.go('/success');
}


// ── Approach 2: Reactive — UI listens to state (preferred with BLoC) ──

// In the Cubit
class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future<void> processPayment() async {
    // ... process ...
    emit(PaymentSuccess()); // just emit state, don't navigate
  }
}

// In the Widget — UI decides navigation based on state
BlocListener<PaymentCubit, PaymentState>(
  listener: (context, state) {
    if (state is PaymentSuccess) {
      context.go('/success');
    }
  },
  child: PaymentForm(),
),


// ── Approach 3: Direct router reference ──

// Make router accessible (e.g., via GetIt or a global)
final getIt = GetIt.instance;
getIt.registerSingleton<GoRouter>(router);

// In any service
getIt<GoRouter>().go('/success');
```

**Why it matters:** This is a very practical question that comes up in every real project. The interviewer wants to see that you understand separation of concerns — ideally, business logic (Cubits/services) should not directly depend on navigation. The reactive pattern (Approach 2) is the cleanest architecturally.

**Common mistake:** Storing `BuildContext` in a Cubit or service. This is dangerous — context can become stale if the widget is disposed, leading to crashes. It also couples business logic to the UI framework. Another mistake: not knowing that `GoRouter` itself can be called directly if you keep a reference to it.

---

**Q:** When do you need nested navigators? How does BottomNavigationBar use separate navigation stacks?

**A:** You need nested navigators when different sections of your app should maintain independent navigation histories. The classic example is a bottom navigation bar where each tab has its own stack of screens — tapping "Home" and drilling into a detail screen, then switching to "Search" and back to "Home" should restore the detail screen, not reset to the Home root.

```
Nested Navigators — each tab owns a separate stack:

Root Navigator
├── Tab 0 Navigator (Home)
│   ├── HomeScreen
│   └── HomeDetailScreen     ← user drilled in here
│
├── Tab 1 Navigator (Search)
│   ├── SearchScreen
│   └── SearchResultScreen
│
└── Tab 2 Navigator (Profile)
    └── ProfileScreen

Switching tabs swaps which Navigator is visible.
Each tab's Navigator remembers its own stack independently.
```

Without nested navigators, pushing a detail screen would replace the entire view including the bottom bar, or switching tabs would reset the history.

**Example (manual nested navigators):**
```dart
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Each tab gets its own GlobalKey → its own Navigator
  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildNavigator(0, const HomeScreen()),
          _buildNavigator(1, const SearchScreen()),
          _buildNavigator(2, const ProfileScreen()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) {
            // Tapping the current tab pops to root
            _navigatorKeys[index].currentState?.popUntil(
              (route) => route.isFirst,
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavigator(int index, Widget root) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => root),
    );
  }
}
```

**With GoRouter, use `StatefulShellRoute` (the modern way):**
```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return Scaffold(
      body: navigationShell, // renders the current branch
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  },
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'detail/:id',
            builder: (_, state) => HomeDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/search',
        builder: (_, __) => const SearchScreen(),
      ),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
    ]),
  ],
);
```

**Why it matters:** This is one of the most common UX patterns in mobile apps (Instagram, YouTube, Twitter all use it). The interviewer wants to see that you understand why a single navigator is insufficient and how `IndexedStack` + multiple navigators (or `StatefulShellRoute`) solves the problem.

**Common mistake:** Using a single Navigator for everything and losing tab state on switch. Another mistake: forgetting `IndexedStack` — using a plain `Stack` or conditional rendering would rebuild tabs on switch, losing scroll position and navigation history. With GoRouter, the mistake is using `ShellRoute` instead of `StatefulShellRoute` and wondering why tab state doesn't persist.
