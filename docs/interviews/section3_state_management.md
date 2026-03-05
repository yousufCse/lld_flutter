# Section 3: State Management

---

**Q:** What is "state" in Flutter? What are the types of state?

**A:** State is any data that can change over time and affects what the UI renders. Flutter distinguishes between two types:

**Ephemeral state** (also called UI state or local state): State that belongs to a single widget — you don't need to access it from anywhere else. Examples include the current page in a `PageView`, the current progress of a complex animation, or the selected tab in a `BottomNavigationBar`.

**App state** (also called shared state): State that you need in many parts of your app, across multiple screens or that must survive between sessions. Examples include user login info, a shopping cart, notification preferences, or read/unread status in a news app.

The boundary isn't always crisp. A "selected tab" starts as ephemeral but might become app state if deep-linking requires you to restore it. The guiding question is: "Who else needs this data?"

```
+-----------------------------------------------+
|               All Flutter State                |
|                                                |
|  +------------------+  +--------------------+  |
|  | Ephemeral State  |  |    App State        | |
|  |                  |  |                     | |
|  | - Current tab    |  | - User session      ||
|  | - Form input     |  | - Shopping cart      ||
|  | - Animation val  |  | - Notifications      ||
|  | - Hover/focus    |  | - Theme preference   ||
|  |                  |  |                     | |
|  | Managed with     |  | Managed with        | |
|  | setState()       |  | Provider/BLoC/      | |
|  |                  |  | Riverpod/etc.       | |
|  +------------------+  +--------------------+  |
+-----------------------------------------------+
```

**Example:**
```dart
// Ephemeral: only this widget cares about _isExpanded
class FaqTile extends StatefulWidget {
  @override
  _FaqTileState createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Column(
        children: [
          Text('Question'),
          if (_isExpanded) Text('Answer details...'),
        ],
      ),
    );
  }
}

// App state: many screens need the cart
// → Use Provider, BLoC, Riverpod, etc.
```

**Why it matters:** Interviewers want to see if you understand why multiple state management tools exist. If you can't classify state, you'll either over-engineer a toggle with BLoC or under-engineer auth state with `setState`.

**Common mistake:** Saying "just use Provider for everything" or "setState is bad." Neither is true. `setState` is the right tool for ephemeral state. The mistake is using it for state that must be shared.

---

**Q:** How does `setState` work internally? What does it trigger, and when should you NOT use it?

**A:** When you call `setState(fn)`, here's the internal sequence:

1. The closure `fn` is executed **synchronously** — this is where you mutate your state variables.
2. The `State` object's `_element` is marked as dirty by calling `_element!.markNeedsBuild()`.
3. The framework schedules a new frame (if one isn't already scheduled).
4. On the next frame, the framework calls `build()` on this widget (and its subtree) to produce a new widget tree.
5. The element tree diffs the old and new widget trees and applies minimal changes to the render tree.

```
setState(fn)
    │
    ▼
Execute fn() synchronously   ← your state changes happen here
    │
    ▼
markNeedsBuild() on Element   ← element flagged as dirty
    │
    ▼
SchedulerBinding schedules frame
    │
    ▼
On next frame: build() called
    │
    ▼
Element tree reconciles (diffing)
    │
    ▼
RenderObject tree updates → pixels on screen
```

**When NOT to use setState:**

- **Cross-widget state sharing:** If a sibling widget, a distant ancestor, or a screen across a Navigator boundary needs the same state, `setState` forces you to lift state up awkwardly and pass callbacks down.
- **Large subtree rebuilds:** If your `setState` sits at the root of a deep tree and only a leaf needs to update, you're rebuilding hundreds of widgets unnecessarily.
- **Async workflows with complex lifecycle:** If you set state after an `await` and the widget is already disposed, you get `setState() called after dispose()`.
- **Business logic mixing:** `setState` encourages putting business logic directly in the UI layer, making it hard to test.

**Example:**
```dart
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;  // Step 1: closure executes, _count is now updated
    });
    // Step 2-5 happen automatically on the next frame
  }

  @override
  Widget build(BuildContext context) {
    // This entire build method re-runs on every setState call
    return Column(
      children: [
        Text('$_count'),
        ElevatedButton(onPressed: _increment, child: Text('+')),
        // Imagine 200 other widgets here — all rebuilt unnecessarily
        HeavyWidget(),
      ],
    );
  }
}
```

**Why it matters:** Interviewers want to know if you understand the rebuild pipeline. Knowing that `setState` marks the element dirty and triggers a full `build()` on the subtree reveals whether you'll write performant code.

**Common mistake:** Calling `setState` with an empty closure and mutating state above it: `_count++; setState(() {});`. This works but is misleading — the closure should contain the mutation so the intent is clear. Another mistake: calling `setState` in `initState` or `build`, which causes errors or infinite loops.

---

**Q:** How does `InheritedWidget` propagate state? What does `updateShouldNotify` do?

**A:** `InheritedWidget` is Flutter's built-in mechanism for passing data **down** the widget tree efficiently without threading it through every constructor.

**How it works:**

1. An `InheritedWidget` sits high in the tree holding some data.
2. Any descendant widget calls `context.dependOnInheritedWidgetOfExactType<MyInherited>()` to read that data.
3. When that call is made, the framework **registers** that element as a dependent of the `InheritedWidget`'s element.
4. When the `InheritedWidget` is rebuilt with new data, the framework calls `updateShouldNotify(oldWidget)`.
5. If `updateShouldNotify` returns `true`, the framework calls `didChangeDependencies()` on every registered dependent and marks them for rebuild.
6. If it returns `false`, dependents are **not** rebuilt — even though the `InheritedWidget` itself was rebuilt.

```
       MyApp
         │
    InheritedData (holds "count: 5")
       /    \
  ScreenA   ScreenB
    │          │
 WidgetX    WidgetY
 (depends)  (depends)

When count changes to 6:
  1. InheritedData rebuilds
  2. updateShouldNotify(old) → old.count != new.count → true
  3. WidgetX.didChangeDependencies() → rebuild
  4. WidgetY.didChangeDependencies() → rebuild
  5. ScreenA/ScreenB NOT rebuilt (unless they also depend)
```

**Example:**
```dart
class ThemeData {
  final Color primaryColor;
  final double fontSize;
  ThemeData({required this.primaryColor, required this.fontSize});
}

class ThemeInherited extends InheritedWidget {
  final ThemeData themeData;

  const ThemeInherited({
    required this.themeData,
    required Widget child,
  }) : super(child: child);

  // Convenience accessor
  static ThemeData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ThemeInherited>()!
        .themeData;
  }

  @override
  bool updateShouldNotify(ThemeInherited oldWidget) {
    // Only rebuild dependents if data actually changed
    return themeData.primaryColor != oldWidget.themeData.primaryColor ||
           themeData.fontSize != oldWidget.themeData.fontSize;
  }
}

// Usage in any descendant:
class MyLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeInherited.of(context);
    return Text(
      'Hello',
      style: TextStyle(
        color: theme.primaryColor,
        fontSize: theme.fontSize,
      ),
    );
  }
}
```

**Why it matters:** `InheritedWidget` is the foundation under `Theme.of(context)`, `MediaQuery.of(context)`, and `Provider` itself. Understanding it means you understand how all higher-level state management works under the hood.

**Common mistake:** Confusing `dependOnInheritedWidgetOfExactType` (registers a dependency, triggers rebuild) with `getInheritedWidgetOfExactType` (reads data without registering — no rebuild on change). Using the wrong one causes either missed updates or unnecessary rebuilds. Another mistake: returning `true` unconditionally from `updateShouldNotify`, which defeats the optimization entirely.

---

**Q:** Explain Provider in Flutter — ChangeNotifier, Consumer, Selector, ProxyProvider, and the difference between `context.watch`, `context.read`, and `context.select`.

**A:** Provider is a wrapper around `InheritedWidget` that makes dependency injection and state propagation less boilerplate-heavy.

**ChangeNotifier + ChangeNotifierProvider:** Your model extends `ChangeNotifier` and calls `notifyListeners()` when data changes. The provider listens and rebuilds consumers.

**Consumer:** A widget that rebuilds only its `builder` portion when the provided value changes. Useful to scope rebuilds to a subtree.

**Selector:** Like `Consumer`, but only rebuilds when a **specific field** changes. It compares the selected value with the previous one using `==`.

**ProxyProvider:** Creates a provided value that depends on another provided value. Useful when one service needs another injected.

**`context.watch<T>()`** — Listens to `T` and rebuilds the widget when `T` changes. Use in `build()`.

**`context.read<T>()`** — Reads `T` once without listening. Use in callbacks (`onPressed`, `initState`-like code). Never in `build()`.

**`context.select<T, R>(selector)`** — Listens only to a derived value `R` from `T`. Rebuilds only if `R` changes. Finest-grained option.

```
context.watch<T>()    → Rebuilds on ANY change to T
context.select<T,R>() → Rebuilds only when R (subset of T) changes
context.read<T>()     → One-time read, no rebuild subscription
```

**Example:**
```dart
// Model
class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => List.unmodifiable(_items);
  int get totalCount => _items.length;
  double get totalPrice => _items.fold(0, (sum, i) => sum + i.price);

  void add(Item item) {
    _items.add(item);
    notifyListeners(); // triggers rebuilds for all watchers
  }
}

// Provide it
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MyApp(),
    ),
  );
}

// Consumer — rebuilds only the Text, not the whole Scaffold
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return Text('Items: ${cart.totalCount}');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // read — not watching, just a one-time access in a callback
          context.read<CartModel>().add(Item('Shoes', 59.99));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Selector — only rebuilds when totalPrice changes,
// ignores changes to anything else in CartModel
class PriceBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final price = context.select<CartModel, double>(
      (cart) => cart.totalPrice,
    );
    return Text('Total: \$${price.toStringAsFixed(2)}');
  }
}

// ProxyProvider — AuthService depends on ApiClient
MultiProvider(
  providers: [
    Provider<ApiClient>(create: (_) => ApiClient()),
    ProxyProvider<ApiClient, AuthService>(
      update: (_, api, __) => AuthService(api),
    ),
  ],
  child: MyApp(),
)
```

**Why it matters:** Provider is the officially recommended beginner-to-intermediate solution. Interviewers test whether you know the performance implications of `watch` vs `read` and whether you can scope rebuilds with `Selector`/`Consumer`.

**Common mistake:** Using `context.watch` inside a callback (`onPressed`) — this causes a runtime error because watch subscribes to changes, but callbacks aren't part of the build phase. Conversely, using `context.read` inside `build()` means the widget won't rebuild when data changes.

---

**Q:** Explain the BLoC pattern — Streams, events, states, the Bloc class, and how `mapEventToState` works.

**A:** BLoC (Business Logic Component) separates business logic from UI using **Streams**. The UI sends **events** into the BLoC and listens to a **stream of states** coming out.

```
  ┌────────────┐    Event     ┌───────────────┐    State    ┌────────────┐
  │            │ ──────────▶  │               │ ──────────▶ │            │
  │     UI     │              │     BLoC      │             │     UI     │
  │            │ ◀────────── │               │             │  (rebuilds)│
  └────────────┘   Stream     └───────────────┘             └────────────┘
                  of States
                              Event comes in →
                              BLoC processes →
                              New State emitted →
                              UI rebuilds
```

**Key concepts:**

- **Event:** An input — user tapped a button, page loaded, form submitted. Events are classes (often sealed/union types).
- **State:** An output — loading, loaded with data, error. Also classes.
- **Bloc class:** Extends `Bloc<Event, State>`. Contains the mapping logic.
- **`mapEventToState`** (legacy, pre-v8): An `async*` generator method that yields new states for each incoming event. It was replaced by `on<Event>` handlers in bloc v8+.

In modern bloc (v8+), you register event handlers in the constructor using `on<EventType>()`. Each handler receives the event and an `Emitter<State>` to emit new states.

**Example:**
```dart
// Events
sealed class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}
class LogoutRequested extends AuthEvent {}

// States
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

// BLoC (modern v8+ style)
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  AuthBloc(this._repo) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repo.login(event.email, event.password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repo.logout();
    emit(AuthInitial());
  }
}

// Legacy mapEventToState (pre-v8, for reference):
// @override
// Stream<AuthState> mapEventToState(AuthEvent event) async* {
//   if (event is LoginRequested) {
//     yield AuthLoading();
//     try {
//       final user = await _repo.login(event.email, event.password);
//       yield AuthSuccess(user);
//     } catch (e) {
//       yield AuthFailure(e.toString());
//     }
//   }
// }
```

**Why it matters:** BLoC is one of the most widely used patterns in production Flutter apps. Interviewers want to know that you understand the event-driven, stream-based architecture and can articulate why separating events from states makes code testable and predictable.

**Common mistake:** Mixing up the old `mapEventToState` (deprecated) with the new `on<Event>` handler API. Also, trying to call `emit()` after an `await` without checking if the bloc is still open — this throws a `StateError`. Another mistake: creating giant monolithic blocs instead of splitting by feature.

---

**Q:** What is Cubit? How does it differ from BLoC, and when should you prefer it?

**A:** `Cubit` is a simpler subset of `Bloc`. It extends `BlocBase<State>` — the same base class `Bloc` extends — but removes the event layer entirely. You call methods directly on the Cubit, and those methods call `emit(newState)`.

```
BLoC:   UI → Event → Bloc.on<Event> → emit(State) → UI
Cubit:  UI → Cubit.method()         → emit(State) → UI

┌───────────────────────────────────────────────┐
│               BlocBase<State>                 │
│       (stream, emit, state, isClosed)         │
│                                               │
│    ┌─────────────┐     ┌──────────────────┐   │
│    │   Cubit      │     │     Bloc          │  │
│    │              │     │                   │  │
│    │ - Methods    │     │ - Events          │  │
│    │ - emit()     │     │ - on<E>() handler │  │
│    │ - No events  │     │ - Traceable       │  │
│    └─────────────┘     └──────────────────┘   │
└───────────────────────────────────────────────┘
```

**Key differences:**

| Aspect | Cubit | Bloc |
|---|---|---|
| Input | Direct method calls | Event objects |
| Traceability | Harder to log | Every event is a logged object (great for `onTransition`) |
| Boilerplate | Less — no event classes | More — event classes required |
| Testability | Test methods directly | Test by adding events, verifying state stream |
| Transformations | Not available | `EventTransformer` for debounce, throttle, etc. |

**When to prefer Cubit:** For straightforward logic — counters, toggles, simple form state, settings. If there's no need for event traceability or stream transformations, Cubit is the right choice.

**When to prefer Bloc:** When you need a log of what happened (event sourcing), when you need to debounce/throttle events (e.g., search-as-you-type), or when the complexity of the feature justifies the extra structure.

**Example:**
```dart
// Cubit — direct and simple
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
}

// Usage
final cubit = CounterCubit();
cubit.increment(); // state is now 1
cubit.increment(); // state is now 2
cubit.reset();     // state is now 0

// Equivalent Bloc — more ceremony for the same logic
sealed class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }
}

// Usage
final bloc = CounterBloc();
bloc.add(Increment()); // must create event object
```

**Why it matters:** Interviewers want to see pragmatism. Choosing Cubit for simple cases shows you value simplicity; choosing Bloc for complex event-driven flows shows you understand traceability. The worst answer is "always use Bloc."

**Common mistake:** Claiming Cubit can't be used with `BlocBuilder`/`BlocListener` — it absolutely can, because both extend `BlocBase`. Another mistake: not realizing that Cubit loses event-level traceability, which can be a real downside in debugging complex flows.

---

**Q:** When do you use `BlocBuilder` vs `BlocListener` vs `BlocConsumer`?

**A:**

**`BlocBuilder<B, S>`** — Rebuilds a widget subtree in response to state changes. Use it when the UI should reflect state visually.

**`BlocListener<B, S>`** — Executes a side-effect **once per state change** without rebuilding. Use it for navigation, showing a SnackBar, or launching a dialog — actions that should fire once, not on every rebuild.

**`BlocConsumer<B, S>`** — Combines both. It has a `listener` AND a `builder`. Use it when you need to both react with side-effects and rebuild the UI on the same state change.

```
State Change
     │
     ├──▶ BlocBuilder   → Rebuilds widget (visual)
     │
     ├──▶ BlocListener  → Fires side-effect once (navigate, snackbar)
     │
     └──▶ BlocConsumer  → Both: side-effect + rebuild
```

**Example:**
```dart
// BlocBuilder — show loading spinner or data
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    if (state is AuthSuccess) return Text('Welcome, ${state.user.name}');
    if (state is AuthFailure) return Text('Error: ${state.message}');
    return LoginForm();
  },
)

// BlocListener — navigate on success, show snackbar on error
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    }
    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: LoginForm(), // child is NOT rebuilt
)

// BlocConsumer — both navigate AND rebuild the UI
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  },
  builder: (context, state) {
    if (state is AuthLoading) {
      return ElevatedButton(
        onPressed: null,
        child: CircularProgressIndicator(),
      );
    }
    return ElevatedButton(
      onPressed: () => context.read<AuthBloc>().add(
        LoginRequested(email, password),
      ),
      child: Text('Login'),
    );
  },
)
```

**Why it matters:** This directly tests whether you know when to rebuild UI vs when to perform a one-shot side-effect. Getting this wrong causes bugs like dialogs opening multiple times on rebuild or navigation that never fires.

**Common mistake:** Using `BlocBuilder` to show a SnackBar — the builder re-runs on rebuild, causing the SnackBar to appear repeatedly. The correct tool is `BlocListener` because SnackBars are imperative side-effects. Conversely, using `BlocListener` when you need to display state on screen does nothing because `BlocListener` has no `builder`.

---

**Q:** What do `buildWhen` and `listenWhen` do, and why do they matter for performance?

**A:** Both are filter callbacks that let you skip unnecessary rebuilds or listener invocations.

**`buildWhen`** is a parameter on `BlocBuilder` and `BlocConsumer`. It receives the `previous` and `current` state and returns a `bool`. If `false`, the builder does **not** re-run, even though state changed.

**`listenWhen`** is the same concept for `BlocListener` and `BlocConsumer`. If `false`, the listener callback is skipped.

They matter because a Bloc/Cubit might emit states that are irrelevant to a particular widget. Without these filters, every state change triggers every connected builder/listener.

**Example:**
```dart
// A Bloc that manages a complex form state
class FormState {
  final String name;
  final String email;
  final bool isSubmitting;
  FormState({required this.name, required this.email, this.isSubmitting = false});
}

// Only rebuild the name field when name actually changes
BlocBuilder<FormBloc, FormState>(
  buildWhen: (previous, current) => previous.name != current.name,
  builder: (context, state) {
    return Text('Name: ${state.name}');
  },
)

// Only listen for submission results, ignore field changes
BlocListener<FormBloc, FormState>(
  listenWhen: (previous, current) =>
      previous.isSubmitting && !current.isSubmitting,
  listener: (context, state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form submitted!')),
    );
  },
  child: FormBody(),
)

// Combined in BlocConsumer
BlocConsumer<AuthBloc, AuthState>(
  buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
  listenWhen: (prev, curr) => curr is AuthFailure,
  listener: (context, state) {
    if (state is AuthFailure) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    return switch (state) {
      AuthLoading()  => CircularProgressIndicator(),
      AuthSuccess()  => HomePage(),
      _              => LoginForm(),
    };
  },
)
```

**Why it matters:** In real apps, a single Bloc might emit dozens of state changes per second (think search-as-you-type). Without `buildWhen`, every keystroke rebuilds every connected widget. This is the difference between a smooth app and a janky one.

**Common mistake:** Forgetting that `buildWhen` defaults to `(prev, curr) => true` — meaning "always rebuild." Candidates often claim BlocBuilder is "smart by default." It's not; you must opt into filtering. Another mistake: putting complex or slow logic inside `buildWhen` itself — it should be a cheap comparison.

---

**Q:** Explain Riverpod — how it differs from Provider, and cover StateProvider, FutureProvider, StreamProvider, StateNotifierProvider, and the differences between `ref.watch`, `ref.read`, and `ref.listen`.

**A:** Riverpod (an anagram of "Provider") was created by the same author to fix fundamental limitations of Provider:

| Problem with Provider | How Riverpod fixes it |
|---|---|
| Depends on widget tree (BuildContext) | Providers are global, compile-time safe, tree-independent |
| Runtime errors if provider not found | Caught at compile time |
| Can't have two providers of the same type | Each provider has a unique variable reference |
| Hard to combine providers | Built-in provider dependencies via `ref` |
| No built-in auto-dispose | `autoDispose` modifier |

**Provider types:**

- **`Provider<T>`** — Exposes a read-only value. Computed/derived values.
- **`StateProvider<T>`** — Exposes a simple mutable value (int, bool, enum). Overkill for anything complex.
- **`FutureProvider<T>`** — Exposes an `AsyncValue<T>` from a `Future`. Great for one-shot async reads.
- **`StreamProvider<T>`** — Same but for `Stream<T>`. Real-time data, WebSockets, Firestore snapshots.
- **`StateNotifierProvider<N, T>`** — Exposes a `StateNotifier<T>` with complex state logic. (Being replaced by `NotifierProvider` in Riverpod 2.0+.)
- **`NotifierProvider<N, T>`** (Riverpod 2.0+) — Modern replacement for `StateNotifierProvider` using the `Notifier` class.

**`ref.watch`** — Listens to the provider and rebuilds the widget when the value changes. Use in `build()`.

**`ref.read`** — Reads the current value once without subscribing. Use in callbacks.

**`ref.listen`** — Listens for changes and executes a side-effect callback (like `BlocListener`). Use for navigation, snackbars, etc.

**Example:**
```dart
// Providers are declared globally — no tree dependency
final counterProvider = StateProvider<int>((ref) => 0);

final todosProvider = FutureProvider<List<Todo>>((ref) async {
  final repo = ref.watch(todoRepositoryProvider);
  return repo.fetchAll();
});

final chatProvider = StreamProvider<List<Message>>((ref) {
  return ref.watch(chatRepositoryProvider).messageStream();
});

// StateNotifierProvider for complex logic
class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void add(Todo todo) => state = [...state, todo];
  void remove(String id) =>
      state = state.where((t) => t.id != id).toList();
  void toggle(String id) => state = [
    for (final t in state)
      if (t.id == id) t.copyWith(done: !t.done) else t,
  ];
}

final todosNotifierProvider =
    StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

// Consumer widget
class TodoPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch — rebuilds when todos change
    final todos = ref.watch(todosNotifierProvider);

    // ref.listen — fires side-effect, doesn't rebuild
    ref.listen<List<Todo>>(todosNotifierProvider, (prev, next) {
      if (next.length > (prev?.length ?? 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Todo added!')),
        );
      }
    });

    return ListView(
      children: todos.map((t) => ListTile(
        title: Text(t.title),
        onTap: () {
          // ref.read — one-time access in a callback
          ref.read(todosNotifierProvider.notifier).toggle(t.id);
        },
      )).toList(),
    );
  }
}

// FutureProvider with AsyncValue pattern
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (user) => Text('Hello, ${user.name}'),
    );
  }
}
```

**Why it matters:** Riverpod is increasingly the preferred state management choice for new Flutter projects. Interviewers want to see that you understand its advantages over Provider and can work with its different provider types and ref methods correctly.

**Common mistake:** Using `ref.read` in `build()` — the widget won't rebuild when the value changes. Using `ref.watch` in a callback creates an unnecessary subscription. Another common mistake: forgetting `.autoDispose` and leaking providers that hold resources like streams or controllers.

---

**Q:** Explain GetX — Controllers, Obx, GetBuilder — overview and trade-offs.

**A:** GetX is an all-in-one package that bundles state management, dependency injection, and route management. It favors minimal boilerplate and convention over configuration.

**Controllers:** Extend `GetxController`. Hold your business logic and reactive state.

**Reactive state (`.obs` + `Obx`):** You make a variable reactive by appending `.obs`. Any `Obx(() => ...)` widget that reads that variable automatically rebuilds when it changes. This uses RxDart-like observables under the hood.

**`GetBuilder`:** A manual, non-reactive approach. The controller calls `update()` to notify `GetBuilder` widgets to rebuild. Similar to `setState` but scoped to the controller.

```
GetX State Management:

Reactive:   var count = 0.obs;  →  Obx(() => Text('${ctrl.count}'))
            Automatic rebuild. No boilerplate.

Manual:     int count = 0;      →  GetBuilder<Ctrl>(builder: ...)
            Call update() to rebuild. Less memory.
```

**Example:**
```dart
// Controller
class CartController extends GetxController {
  // Reactive approach
  var items = <Item>[].obs;
  var total = 0.0.obs;

  void addItem(Item item) {
    items.add(item);
    total.value = items.fold(0, (sum, i) => sum + i.price);
  }
}

// Dependency injection
Get.put(CartController()); // or Get.lazyPut(() => CartController())

// Reactive UI — auto-rebuilds when items changes
Obx(() {
  final ctrl = Get.find<CartController>();
  return Text('Items: ${ctrl.items.length}, Total: ${ctrl.total}');
})

// Manual UI — rebuilds only when update() is called
class CounterController extends GetxController {
  int count = 0;
  void increment() {
    count++;
    update(); // manually trigger rebuild
  }
}

GetBuilder<CounterController>(
  init: CounterController(),
  builder: (ctrl) => Text('${ctrl.count}'),
)
```

**Trade-offs:**

| Pros | Cons |
|---|---|
| Very low boilerplate | Implicit magic — hard to trace data flow |
| Fast prototyping | Global singletons make testing harder |
| Built-in routing + DI | Not endorsed by Flutter team |
| Good docs, large community | Tight coupling to GetX ecosystem |
| | Reactive `.obs` can mask performance issues in large lists |
| | Harder to enforce architecture boundaries |

**Why it matters:** Interviewers may not use GetX themselves, but they want to see that you can evaluate tools critically. Knowing the trade-offs shows maturity — especially being able to articulate when GetX's convenience becomes a liability at scale.

**Common mistake:** Saying "GetX is bad" or "GetX is the best" without nuance. The correct answer acknowledges its strengths for prototyping and small apps, while identifying specific drawbacks for large teams and complex apps (global state, implicit dependency on `Get.find`, difficulty mocking in tests).

---

**Q:** How do you share state between two completely unrelated screens?

**A:** "Unrelated" means neither is an ancestor of the other in the widget tree. You need to lift the state above both screens — into a shared ancestor or outside the tree entirely.

**Approaches (best to most complex):**

1. **Provider / Riverpod / BLoC at a common ancestor:** Place the state provider above both screens in the widget tree (e.g., at `MaterialApp` level). Both screens can access it via context or ref.

2. **Global provider (Riverpod):** Since Riverpod providers are tree-independent, both screens can `ref.watch` the same provider regardless of their position.

3. **Service locator (GetIt):** Register a singleton service. Both screens access it via `GetIt.I<CartService>()`. Simple but less reactive — you still need a notification mechanism.

4. **Event bus / Stream:** A shared `StreamController` that both screens listen to. More decoupled but harder to debug.

5. **Navigator result / callbacks:** Only works for simple cases where Screen B pops and returns data to Screen A.

```
Approach 1 & 2 (Recommended):

        MaterialApp
            │
    ChangeNotifierProvider<CartModel>  ← lives above both
        /               \
   /orders route     /catalog route
      │                  │
   OrdersScreen      CatalogScreen
   (watches cart)    (writes to cart)
```

**Example:**
```dart
// With Riverpod — no tree dependency at all

final sharedCartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Screen A — somewhere deep in tab 1
class OrdersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(sharedCartProvider);
    return Text('You have ${cart.items.length} items in cart');
  }
}

// Screen B — somewhere deep in tab 2, completely unrelated
class CatalogScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(sharedCartProvider.notifier).addItem(someItem);
      },
      child: Text('Add to cart'),
    );
  }
}
```

**Why it matters:** This is a practical architecture question. Interviewers want to see that you think in terms of dependency injection and scoping — not passing callbacks through 15 widgets.

**Common mistake:** Reaching for global variables or static singletons with no reactivity. The state changes but the UI doesn't update. Another mistake: creating separate instances of the same controller in each screen, so they each have their own isolated state.

---

**Q:** How do you choose a state management solution for a project?

**A:** There is no single correct answer, but here's a decision framework:

```
Start here:
    │
    ▼
Is the state local to one widget?
    ├── YES → setState()
    │
    ▼
Is it a small/medium app or a prototype?
    ├── YES → Provider or Riverpod
    │
    ▼
Does the team need strong architecture enforcement?
    ├── YES → BLoC (strict event/state separation)
    │
    ▼
Do you need fine-grained reactivity with minimal boilerplate?
    ├── YES → Riverpod
    │
    ▼
Is rapid prototyping the priority, small team?
    ├── YES → GetX (with caution about long-term cost)
    │
    ▼
Complex async event processing (debounce, throttle, merge)?
    └── YES → BLoC with EventTransformers
```

**Factors to weigh:**

- **Team familiarity:** A team that knows BLoC well will be faster with BLoC than learning Riverpod mid-project.
- **Testability requirements:** BLoC and Riverpod are highly testable. GetX is harder to mock.
- **App complexity:** A counter app doesn't need BLoC. An enterprise banking app benefits from its structure.
- **Code review and onboarding:** BLoC's explicitness is easier for new team members to follow. GetX's implicitness can be confusing.
- **Mixing is OK:** You can use `setState` for ephemeral state, Provider/Riverpod for app-wide state, and BLoC for specific complex features — all in the same project.

**Example:**
```dart
// It's perfectly valid to mix approaches:

// Ephemeral UI state
class _DropdownState extends State<Dropdown> {
  bool _isOpen = false; // setState is fine here
}

// App-wide auth — BLoC for complex event handling
BlocProvider(create: (_) => AuthBloc(repo))

// Theme preference — simple value, use StateProvider
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Shopping cart — medium complexity, use StateNotifierProvider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>(...);
```

**Why it matters:** This is a senior-level question. Interviewers don't want a partisan answer — they want evidence that you can evaluate trade-offs, consider team dynamics, and make pragmatic decisions.

**Common mistake:** Dogmatically defending one solution. "BLoC is the only professional choice" or "Riverpod is always better" are red flags. Another mistake: choosing a heavy solution for a simple app, or a lightweight one for a complex app, without explaining the reasoning.

---

**Q:** How do you test BLoC/Cubit state logic?

**A:** The `bloc_test` package provides a declarative way to test Blocs and Cubits. The key function is `blocTest`, which sets up a Bloc, performs actions, and verifies the emitted states.

**Testing flow:**
1. Create the Bloc/Cubit with mocked dependencies.
2. Trigger actions (add events for Bloc, call methods for Cubit).
3. Assert the sequence of emitted states.

```
Test Structure:

  build:  () => CounterCubit()          ← create instance
  act:    (cubit) => cubit.increment()  ← trigger action
  expect: () => [1]                     ← verify emitted states
```

**Example:**
```dart
// The Cubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

// Tests
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

void main() {
  group('CounterCubit', () {
    blocTest<CounterCubit, int>(
      'emits [1] when increment is called',
      build: () => CounterCubit(),
      act: (cubit) => cubit.increment(),
      expect: () => [1],
    );

    blocTest<CounterCubit, int>(
      'emits [1, 2, 3] when increment is called three times',
      build: () => CounterCubit(),
      act: (cubit) {
        cubit.increment();
        cubit.increment();
        cubit.increment();
      },
      expect: () => [1, 2, 3],
    );

    blocTest<CounterCubit, int>(
      'emits [-1] when decrement is called from initial state',
      build: () => CounterCubit(),
      act: (cubit) => cubit.decrement(),
      expect: () => [-1],
    );
  });

  // Testing a Bloc with mocked dependencies
  group('AuthBloc', () {
    late MockAuthRepository mockRepo;

    setUp(() {
      mockRepo = MockAuthRepository();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] on successful login',
      setUp: () {
        when(() => mockRepo.login(any(), any()))
            .thenAnswer((_) async => User(name: 'Alice'));
      },
      build: () => AuthBloc(mockRepo),
      act: (bloc) => bloc.add(LoginRequested('a@b.com', 'pass')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>().having((s) => s.user.name, 'name', 'Alice'),
      ],
      verify: (_) {
        verify(() => mockRepo.login('a@b.com', 'pass')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] on failed login',
      setUp: () {
        when(() => mockRepo.login(any(), any()))
            .thenThrow(Exception('Invalid credentials'));
      },
      build: () => AuthBloc(mockRepo),
      act: (bloc) => bloc.add(LoginRequested('a@b.com', 'wrong')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>(),
      ],
    );
  });
}
```

**Why it matters:** Testability is a primary reason teams choose BLoC/Cubit. If you can't demonstrate how to test them, the benefit of the pattern is theoretical. Interviewers expect you to know `blocTest`, mocking, and how to verify state sequences.

**Common mistake:** Testing only the happy path. Interviewers want to see error state tests, edge cases (like calling methods on a closed Cubit), and proper use of `setUp`/`tearDown`. Another mistake: asserting against the initial state in `expect` — `blocTest` automatically skips the initial state, so `expect: () => [0, 1]` for a counter starting at 0 would fail.

---

**Q:** What is the difference between `emit()` and `setState()`? What happens if you call `emit()` after a Cubit is closed?

**A:** These serve similar purposes (trigger UI update with new state) but operate in completely different systems:

| Aspect | `setState()` | `emit()` |
|---|---|---|
| Where it lives | `State<T>` class (StatefulWidget) | `Cubit` / `Bloc` (BlocBase) |
| What it does | Marks element dirty, schedules rebuild | Pushes new state onto the Bloc's stream |
| Who rebuilds | The widget's own `build()` method | Any `BlocBuilder`, `BlocListener`, etc. listening to the stream |
| State scope | Local to one widget | Available to any widget that accesses the Bloc |
| Rebuild scope | Entire widget subtree | Only widgets subscribed via BlocBuilder etc. |
| Lifecycle guard | Throws if called after `dispose()` | Throws `StateError` if called after `close()` |

**What happens when you call `emit()` after close:**

Calling `emit()` on a closed Cubit/Bloc throws a `StateError` with the message: "Cannot emit new states after calling close." This commonly happens when an async operation completes after the user has navigated away and the Bloc has been disposed.

**Example:**
```dart
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repo) : super(SearchInitial());
  final SearchRepository _repo;

  Future<void> search(String query) async {
    emit(SearchLoading());
    try {
      final results = await _repo.search(query); // takes 3 seconds
      // If user navigated away during those 3 seconds,
      // this Cubit is closed, and the next line THROWS:
      emit(SearchSuccess(results)); // 💥 StateError!
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }
}

// Fix: guard with isClosed
Future<void> search(String query) async {
  emit(SearchLoading());
  try {
    final results = await _repo.search(query);
    if (!isClosed) {  // ← guard before emitting
      emit(SearchSuccess(results));
    }
  } catch (e) {
    if (!isClosed) {
      emit(SearchFailure(e.toString()));
    }
  }
}

// Alternative fix in Bloc: use emit from the handler
// (bloc's on<Event> handlers automatically ignore emits after close
//  starting from bloc v8.1.0+, but explicit guards are still good practice)
```

**Why it matters:** This tests your understanding of both the widget lifecycle and the Bloc lifecycle. In production, the "emit after close" bug is one of the most common crash sources in Bloc-based apps.

**Common mistake:** Not guarding `emit()` calls after async gaps. Candidates say "the framework handles it" — it does not; it throws. Also, confusing `setState`'s "after dispose" error with `emit`'s "after close" error — they're analogous but from different systems.

---

**Q:** How do you handle loading, success, and error states cleanly using a sealed union pattern?

**A:** The sealed class pattern (available in Dart 3+) lets you model states as a closed set of subtypes. The compiler enforces exhaustive handling, so you can't accidentally forget a state.

```
Sealed State Union:

        ResultState<T>
        /     |       \
  Loading   Success   Error
              |          |
           data: T    message: String

Compiler enforces: every switch must handle ALL variants.
No "else" needed. No forgotten states.
```

**Example:**
```dart
// Define the state union
sealed class ResultState<T> {
  const ResultState();
}

class Loading<T> extends ResultState<T> {
  const Loading();
}

class Success<T> extends ResultState<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ResultState<T> {
  final String message;
  final Object? error;
  const Failure(this.message, {this.error});
}

// Use in a Cubit
class UserProfileCubit extends Cubit<ResultState<UserProfile>> {
  UserProfileCubit(this._repo) : super(const Loading());
  final UserRepository _repo;

  Future<void> load() async {
    emit(const Loading());
    try {
      final profile = await _repo.getProfile();
      emit(Success(profile));
    } catch (e, stack) {
      emit(Failure('Failed to load profile', error: e));
    }
  }

  Future<void> refresh() async {
    // Don't show loading on refresh — keep current data visible
    try {
      final profile = await _repo.getProfile();
      emit(Success(profile));
    } catch (e) {
      // On refresh failure, keep old data if available
      if (state is! Success) {
        emit(Failure('Failed to refresh', error: e));
      }
    }
  }
}

// Use in the UI — Dart 3 exhaustive switch
class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, ResultState<UserProfile>>(
      builder: (context, state) {
        return switch (state) {
          Loading()           => const Center(
                                   child: CircularProgressIndicator(),
                                 ),
          Success(:final data) => Column(
                                   children: [
                                     Text(data.name),
                                     Text(data.email),
                                   ],
                                 ),
          Failure(:final message) => Column(
                                      children: [
                                        Text(message),
                                        ElevatedButton(
                                          onPressed: () => context
                                              .read<UserProfileCubit>()
                                              .load(),
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
        };
        // No default case needed — compiler guarantees exhaustiveness
      },
    );
  }
}

// Reusable generic widget for any ResultState
class AsyncStateWidget<T> extends StatelessWidget {
  final ResultState<T> state;
  final Widget Function(T data) onSuccess;
  final VoidCallback? onRetry;

  const AsyncStateWidget({
    required this.state,
    required this.onSuccess,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      Loading()               => const Center(
                                   child: CircularProgressIndicator(),
                                 ),
      Success(:final data)    => onSuccess(data),
      Failure(:final message) => Center(
                                   child: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Text(message),
                                       if (onRetry != null)
                                         ElevatedButton(
                                           onPressed: onRetry,
                                           child: const Text('Retry'),
                                         ),
                                     ],
                                   ),
                                 ),
    };
  }
}
```

**Why it matters:** This is a design pattern question. Interviewers want to see that you model states explicitly rather than using fragile combinations of booleans (`isLoading`, `hasError`, `data != null`) that can end up in impossible combinations (loading AND error AND has data). Sealed classes make illegal states unrepresentable.

**Common mistake:** Using multiple boolean flags instead of a sealed union:
```dart
// BAD — allows impossible states like isLoading=true AND error!=null
class BadState {
  bool isLoading = false;
  String? error;
  UserProfile? data;
}
```
Another mistake: adding a `default` case to the switch, which silently hides missing state handling and defeats the purpose of exhaustiveness checking.

---

*End of Section 3: State Management*
