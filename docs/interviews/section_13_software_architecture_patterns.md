# Section 13: Software Architecture Patterns

---

**Q:** What is Layered Architecture and what are the typical layers in a mobile app?

**A:** Layered Architecture organizes code into horizontal layers where each layer has a specific responsibility and can only communicate with the layer directly below it. It enforces separation of concerns by forbidding upper layers from reaching past their immediate neighbor.

In a typical Flutter mobile app, the layers look like this:

```
┌──────────────────────────────────┐
│         Presentation Layer       │  ← UI widgets, screens, state management
├──────────────────────────────────┤
│         Application Layer        │  ← Use cases, orchestration logic
├──────────────────────────────────┤
│           Domain Layer           │  ← Entities, business rules, interfaces
├──────────────────────────────────┤
│            Data Layer            │  ← API calls, local DB, repositories
├──────────────────────────────────┤
│         Infrastructure Layer     │  ← Network, device, platform services
└──────────────────────────────────┘
```

Each layer only imports from the layer immediately beneath it. The Presentation layer never talks directly to the Data layer. This makes each layer independently testable and replaceable.

**Example:**
```dart
// ❌ BAD - Presentation reaching past domain directly into data
class UserScreen extends StatelessWidget {
  final ApiService apiService; // UI depending on data layer directly
  ...
}

// ✅ GOOD - Presentation depends only on domain interface
class UserScreen extends StatelessWidget {
  final GetUserUseCase getUserUseCase; // depends on domain
  ...
}
```

**Why it matters:** The interviewer is checking whether you understand structural discipline — not just "what layers exist" but *why* the strict directional dependency matters for maintainability and testability.

**Common mistake:** Candidates list the layers correctly but then describe them talking to each other freely ("oh the UI can call the API directly if it's a simple screen"). That immediately signals they don't practice what they preach.

---

**Q:** Explain Clean Architecture in Flutter — what are the 3 layers, and why must the domain layer not depend on data or presentation?

**A:** Clean Architecture (popularized by Robert C. Martin) organizes an app into 3 concentric layers. The key rule is the **Dependency Rule**: dependencies always point *inward*, never outward. Inner layers know nothing about outer layers.

```
          ┌─────────────────────────────┐
          │       Presentation          │  Widgets, BLoC, Cubit, ViewModel
          │   ┌─────────────────────┐   │
          │   │       Domain        │   │  Entities, Use Cases, Repo Interfaces
          │   │  ┌─────────────┐   │   │
          │   │  │    Data     │   │   │  ← NO. Data is OUTER, not inner.
          │   │  └─────────────┘   │   │
          │   └─────────────────────┘   │
          └─────────────────────────────┘

Correct diagram (dependency arrows point INWARD):

  Presentation ──depends on──► Domain ◄──depends on── Data
                                  │
                      (Domain knows nothing about
                       Presentation or Data)
```

**The 3 Layers:**

- **Domain (innermost):** Pure Dart. Entities (plain data classes), Use Cases (business logic), and abstract Repository interfaces. Zero Flutter imports. Zero third-party imports.
- **Data (outer):** Implements the repository interfaces defined in Domain. Calls APIs, databases, caches. Maps raw responses to domain entities.
- **Presentation (outer):** Flutter widgets, BLoC/Cubit. Calls use cases. Renders state.

**Why domain must not depend on data or presentation:**
- Domain is your business logic — the most valuable and most stable part of the app
- If Domain depends on Data, swapping your API or database forces changes to your business logic, which is wrong
- If Domain depends on Presentation, your business logic breaks when you change the UI framework
- By keeping Domain pure, you can test all business rules without Flutter, without a network, without a database

**Example:**
```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  User({required this.id, required this.name});
}

// domain/repositories/user_repository.dart  (INTERFACE, not implementation)
abstract class UserRepository {
  Future<User> getUserById(String id);
}

// domain/usecases/get_user.dart
class GetUserUseCase {
  final UserRepository repository; // depends on INTERFACE, not concrete class

  GetUserUseCase(this.repository);

  Future<User> call(String id) => repository.getUserById(id);
}

// data/repositories/user_repository_impl.dart  (IMPLEMENTATION)
class UserRepositoryImpl implements UserRepository {
  final ApiService api;
  UserRepositoryImpl(this.api);

  @override
  Future<User> getUserById(String id) async {
    final json = await api.get('/users/$id');
    return User(id: json['id'], name: json['name']);
  }
}

// presentation/cubit/user_cubit.dart
class UserCubit extends Cubit<UserState> {
  final GetUserUseCase getUser;
  UserCubit(this.getUser) : super(UserInitial());

  Future<void> load(String id) async {
    emit(UserLoading());
    final user = await getUser(id);
    emit(UserLoaded(user));
  }
}
```

**Why it matters:** Clean Architecture is the most commonly evaluated architecture pattern in senior Flutter interviews. Interviewers want to see you understand *why* the dependency rule exists, not just that you can draw the diagram.

**Common mistake:** Candidates say "Domain is in the middle" without explaining that the dependency arrows point inward. Then they show domain importing from data ("to get the model class") — which violates the entire principle.

---

**Q:** What is MVC (Model-View-Controller) and how does it apply to mobile development?

**A:** MVC splits an application into 3 components:

```
┌────────┐  user action   ┌────────────┐  updates  ┌───────┐
│  View  │ ─────────────► │ Controller │ ─────────► │ Model │
│  (UI)  │ ◄────────────  └────────────┘            └───────┘
└────────┘   re-renders         │                       │
                                └───────────────────────┘
                                     reads/writes data
```

- **Model:** Data and business logic (user, product, order)
- **View:** What the user sees — renders the model
- **Controller:** Handles user input, coordinates model updates, tells view to refresh

In classic MVC the View and Model can communicate directly, which is a weakness — it creates tight coupling.

**In Flutter context:**
Flutter doesn't have a built-in MVC, but you can apply the pattern manually:
```dart
// Model
class CounterModel {
  int count = 0;
  void increment() => count++;
}

// Controller
class CounterController {
  final CounterModel model = CounterModel();

  void onIncrementTapped() {
    model.increment();
    // notify view to rebuild — typically via setState or ChangeNotifier
  }

  int get currentCount => model.count;
}

// View
class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final controller = CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('${controller.currentCount}'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.onIncrementTapped();
          setState(() {}); // crude but valid for simple MVC
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

MVC is less popular in Flutter compared to MVVM or BLoC because the View–Controller coupling is often too tight for reactive UI frameworks.

**Why it matters:** Interviewers use MVC as a baseline to see if you understand the evolution of architecture patterns and why the Flutter community moved toward MVVM and BLoC.

**Common mistake:** Confusing MVC with MVVM. In MVC, the Controller is aware of the View. In MVVM, the ViewModel has no reference to the View at all.

---

**Q:** What is MVVM and how does Cubit or BLoC map to it?

**A:** MVVM separates the UI from business logic using a ViewModel that exposes state to the View through an observable stream or notifier. The critical difference from MVC: the **ViewModel has no reference to the View**.

```
┌────────┐  observes state   ┌───────────┐  calls   ┌────────┐
│  View  │ ◄──────────────── │ ViewModel │ ────────► │ Model  │
│(Widget)│  sends events     └───────────┘           │(Domain)│
└────────┘ ─────────────────►                        └────────┘
```

- **View:** Flutter widgets. Observes ViewModel state. Sends user events.
- **ViewModel:** Holds and manages UI state. Calls domain/model. Exposes a stream of states.
- **Model:** Domain entities, use cases, repositories.

**How Cubit maps to MVVM:**
```dart
// ViewModel = Cubit
class UserCubit extends Cubit<UserState> {
  final GetUserUseCase getUser;

  UserCubit(this.getUser) : super(UserInitial());

  // Called by View — like a ViewModel method
  Future<void> loadUser(String id) async {
    emit(UserLoading());
    try {
      final user = await getUser(id);
      emit(UserLoaded(user)); // exposes state — View observes this
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}

// View = Widget
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) return CircularProgressIndicator();
        if (state is UserLoaded) return Text(state.user.name);
        if (state is UserError) return Text(state.message);
        return ElevatedButton(
          onPressed: () => context.read<UserCubit>().loadUser('123'),
          child: Text('Load'),
        );
      },
    );
  }
}
```

**How BLoC maps to MVVM:**
BLoC is stricter MVVM — the ViewModel (Bloc) only reacts to *Events* (not direct method calls), making the input/output contract explicit:
- Input: Events (user actions)
- Output: States (UI state stream)
- The View emits events and observes states — it never touches the Model directly

**Why it matters:** This question tests whether you see the pattern beneath the framework. Many candidates use BLoC without realizing it's an opinionated implementation of MVVM.

**Common mistake:** Saying "MVVM is when you use Provider." Provider is a state management mechanism — MVVM is a structural pattern. You can implement MVVM with Provider, Cubit, BLoC, Riverpod, or plain ChangeNotifier.

---

**Q:** What is MVP (Model-View-Presenter) and how is it different from MVVM?

**A:** MVP is similar to MVC but with one key change: the Presenter handles all UI logic and the View becomes purely passive (a "dumb" view). The Presenter *does* hold a reference to the View interface — which is the main difference from MVVM.

```
MVP:
┌────────┐  calls interface  ┌───────────┐  calls   ┌────────┐
│  View  │ ◄──────────────── │ Presenter │ ────────► │ Model  │
│(Widget)│ ─────────────────►│           │           │        │
└────────┘  delegates events └───────────┘           └────────┘
  (passive)        Presenter knows about View via interface

MVVM:
┌────────┐  observes stream  ┌───────────┐  calls   ┌────────┐
│  View  │ ◄──────────────── │ ViewModel │ ────────► │ Model  │
│(Widget)│ ─────────────────►│           │           │        │
└────────┘  sends events     └───────────┘           └────────┘
  (reactive)    ViewModel does NOT know about View
```

**Key differences:**

| | MVP | MVVM |
|---|---|---|
| Presenter/VM knows View? | Yes (via interface) | No |
| View is... | Passive, delegates everything | Reactive, observes state |
| Testing | Mock the View interface | No View needed at all |
| Coupling | Moderate | Lower |

**Example in Flutter (MVP style):**
```dart
// View interface (contract)
abstract class LoginView {
  void showLoading();
  void showError(String message);
  void navigateToHome();
}

// Presenter
class LoginPresenter {
  final LoginView view;
  final AuthRepository auth;

  LoginPresenter(this.view, this.auth);

  Future<void> login(String email, String password) async {
    view.showLoading();
    try {
      await auth.login(email, password);
      view.navigateToHome();
    } catch (e) {
      view.showError(e.toString());
    }
  }
}

// View (Widget implements the interface)
class LoginScreen extends StatefulWidget implements LoginView {
  @override
  void showLoading() { /* show spinner */ }

  @override
  void showError(String message) { /* show snackbar */ }

  @override
  void navigateToHome() { /* push route */ }
}
```

MVP was popular in Android (Java) development. In Flutter, MVVM with BLoC/Cubit is preferred because Flutter's reactive widget system aligns naturally with state streams.

**Why it matters:** This question is asked to see if you can articulate *why* the Flutter community converged on MVVM/BLoC rather than MVP — the answer is Flutter's reactive rebuild model.

**Common mistake:** Saying MVP and MVVM are "basically the same thing." The Presenter's direct reference to the View is the critical distinction — it creates tighter coupling and makes testing slightly harder.

---

**Q:** What is the Repository Pattern, what problem does it solve, and how is it structured in Clean Architecture?

**A:** The Repository Pattern creates an abstraction layer between your business logic (domain) and your data sources (API, database, cache). Instead of your use cases knowing *where* data comes from, they ask a repository interface and the implementation handles the details.

**Problem it solves:**
- Without it: business logic directly calls `http.get(...)` or `db.query(...)` — you can't test it without a real network or database
- With it: business logic calls `repository.getUser(id)` — you can inject a fake repository in tests

```
  Domain Layer                    Data Layer
┌─────────────────┐            ┌──────────────────────────┐
│ UserRepository  │◄implements─│ UserRepositoryImpl        │
│ (abstract)      │            │                           │
│ + getUser(id)   │            │ + RemoteDataSource (API)  │
│ + saveUser(u)   │            │ + LocalDataSource (DB)    │
└─────────────────┘            └──────────────────────────┘
         ▲
   Use Cases depend
   on this interface
   (not the impl)
```

**Example:**
```dart
// domain/repositories/product_repository.dart
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<void> saveProduct(Product product);
}

// data/repositories/product_repository_impl.dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService remoteSource;
  final ProductDao localSource; // local database

  ProductRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
  });

  @override
  Future<List<Product>> getProducts() async {
    try {
      // Try remote first
      final products = await remoteSource.fetchProducts();
      await localSource.cacheProducts(products); // cache locally
      return products;
    } catch (_) {
      // Fallback to cache
      return localSource.getCachedProducts();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    final json = await remoteSource.fetchProduct(id);
    return ProductMapper.fromJson(json); // maps DTO to domain entity
  }

  @override
  Future<void> saveProduct(Product product) async {
    await remoteSource.postProduct(ProductMapper.toJson(product));
  }
}

// In tests — use a fake implementation
class FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async => [
    Product(id: '1', name: 'Test Product'),
  ];
  // ...
}
```

**Why it matters:** The Repository Pattern is foundational to testable Flutter apps. Interviewers want to see that you place the *interface* in the domain layer and the *implementation* in the data layer — not both in the same place.

**Common mistake:** Putting the repository interface in the data layer. This forces domain to import from data, violating the dependency rule. The interface belongs in domain — it's a *contract* the domain defines, which data fulfills.

---

**Q:** What is the Use Case (Interactor) pattern? When should you use it and when is it overkill?

**A:** A Use Case (sometimes called an Interactor) is a class that encapsulates a single piece of business logic. It sits in the domain layer and orchestrates entities and repositories to accomplish one specific task. Each use case does one thing only — this is single-responsibility applied at the business logic level.

```
Presentation Layer          Domain Layer             Data Layer
┌──────────────┐         ┌──────────────────┐      ┌──────────┐
│   Cubit/BLoC │────────►│  GetOrderUseCase │─────►│ OrderRepo│
└──────────────┘         │                  │      └──────────┘
                         │  PlaceOrderUse   │
                         │  Case            │
                         │                  │
                         │  CancelOrderUse  │
                         │  Case            │
                         └──────────────────┘
```

**Example:**
```dart
// Each use case = one file, one class, one public method (call)
class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  // Dart convention: make it callable
  Future<List<Order>> call(String userId) async {
    final orders = await repository.getOrdersByUser(userId);
    // Business logic lives here — not in the repository, not in the Cubit
    return orders.where((o) => o.isActive).toList();
  }
}

class PlaceOrderUseCase {
  final OrderRepository orderRepository;
  final InventoryRepository inventoryRepository;
  final NotificationService notificationService;

  PlaceOrderUseCase({
    required this.orderRepository,
    required this.inventoryRepository,
    required this.notificationService,
  });

  Future<Order> call(OrderRequest request) async {
    // Validate stock
    final inStock = await inventoryRepository.checkStock(request.productId);
    if (!inStock) throw InsufficientStockException();

    // Place order
    final order = await orderRepository.create(request);

    // Notify user
    await notificationService.sendConfirmation(order);

    return order;
  }
}

// Usage in Cubit
class OrderCubit extends Cubit<OrderState> {
  final GetOrdersUseCase getOrders;
  final PlaceOrderUseCase placeOrder;

  OrderCubit({required this.getOrders, required this.placeOrder})
      : super(OrderInitial());

  Future<void> loadOrders(String userId) async {
    final orders = await getOrders(userId); // callable
    emit(OrdersLoaded(orders));
  }
}
```

**When to use:**
- Complex business logic that involves multiple repositories or services
- Logic that needs to be reused across multiple ViewModels/Cubits
- Any logic you want to unit test in isolation from UI and data

**When it's overkill:**
- Simple CRUD with no business rules (a `GetUsersUseCase` that just calls `repository.getAll()` adds ceremony with zero value)
- Rapid prototypes or internal tooling apps
- Single-developer projects where the architecture overhead slows you down

**Why it matters:** Use Cases are the heart of Clean Architecture. Interviewers want to see you understand what belongs in a use case vs. a repository vs. a Cubit, and that you can recognize when the pattern adds value vs. noise.

**Common mistake:** Putting every piece of logic in the repository ("the repo applies filters and sorts") or in the Cubit ("the Cubit orchestrates multiple repos"). Both are violations — repositories fetch and persist, Cubits manage UI state. Business logic belongs in Use Cases.

---

**Q:** What is Dependency Injection? Why do we use it, and how does `get_it` implement it in Flutter?

**A:** Dependency Injection (DI) is a technique where an object's dependencies are *provided to it from outside* rather than the object creating them internally. The object declares what it needs; something else is responsible for supplying those dependencies.

**Without DI (tight coupling):**
```dart
class UserCubit extends Cubit<UserState> {
  // Creates its own dependency internally — can't test without real API
  final repository = UserRepositoryImpl(ApiService()); // ❌ hardcoded
  ...
}
```

**With DI (loose coupling):**
```dart
class UserCubit extends Cubit<UserState> {
  final UserRepository repository; // ✅ injected from outside

  UserCubit(this.repository); // accepts any implementation
  ...
}
```

Now you can inject `FakeUserRepository` in tests and `UserRepositoryImpl` in production.

**How `get_it` implements it:**

`get_it` is a service locator (discussed separately) that acts as a DI container. You register dependencies once, then resolve them anywhere.

```dart
// di/injection.dart
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // service locator singleton

void setupDependencies() {
  // Infrastructure
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());

  // Data layer
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<ApiService>()),
  );

  // Domain layer
  sl.registerFactory<GetUserUseCase>(
    () => GetUserUseCase(sl<UserRepository>()),
  );

  // Presentation layer
  sl.registerFactory<UserCubit>(
    () => UserCubit(sl<GetUserUseCase>()),
  );
}

// main.dart
void main() {
  setupDependencies();
  runApp(MyApp());
}

// Anywhere in the app
final cubit = sl<UserCubit>(); // resolved with all deps wired
```

**Registration types in get_it:**

| Type | Behavior |
|---|---|
| `registerSingleton` | Creates once immediately, same instance always |
| `registerLazySingleton` | Creates once on first access, same instance always |
| `registerFactory` | Creates a new instance on every call |

**Why it matters:** DI is fundamental to testable, maintainable code. Interviewers evaluate whether you understand *why* you inject dependencies, not just that `get_it` is the popular package.

**Common mistake:** Calling `sl<X>()` directly inside constructors or methods ("resolving inside the class"), which defeats the purpose. DI means you receive dependencies from outside — resolving inside is just a hidden dependency, not injection.

---

**Q:** What is the difference between Service Locator and Dependency Injection? What are the trade-offs?

**A:** These are two different strategies for managing dependencies. They're often confused because tools like `get_it` can be used for both.

**Dependency Injection (DI):** Dependencies are *pushed into* a class from outside — typically via constructor. The class doesn't know how to obtain them; it just declares what it needs.

**Service Locator:** Dependencies are *pulled by* the class itself by calling a central registry. The class knows about the locator and asks for what it needs.

```
Dependency Injection (push):
┌──────────────┐  provides dep  ┌──────────┐
│  DI Container│ ──────────────►│  Class A │
└──────────────┘                └──────────┘
  Class A has no reference to the container

Service Locator (pull):
┌──────────────┐               ┌──────────┐
│  Service     │◄──sl.get()────│  Class A │
│  Locator     │               └──────────┘
└──────────────┘
  Class A knows about and calls the locator
```

**Code comparison:**
```dart
// Service Locator pattern — class pulls its own dependencies
class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial()) {
    _repo = sl<OrderRepository>(); // class is aware of sl
    _useCase = sl<PlaceOrderUseCase>();
  }

  late final OrderRepository _repo;
  late final PlaceOrderUseCase _useCase;
}

// Pure DI pattern — dependencies pushed in via constructor
class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _repo;
  final PlaceOrderUseCase _useCase;

  OrderCubit(this._repo, this._useCase) : super(OrderInitial());
  // Class has zero knowledge of how it got its deps
}
```

**Trade-offs:**

| Aspect | Service Locator | Pure DI |
|---|---|---|
| Explicitness | Implicit — hard to see what a class needs | Explicit — constructor shows all dependencies |
| Testability | Harder — must set up the locator in tests | Easier — just pass mock in constructor |
| Coupling to container | Yes — class depends on `sl` | None |
| Simplicity | Simple to use anywhere | Slightly more setup |
| Discoverability | Hidden dependencies | Self-documenting via constructor |

In Flutter practice, most teams use `get_it` as a **composition root** (registering and wiring in `main.dart` or `injection.dart`) but inject via constructor everywhere else. This gives the best of both worlds.

**Why it matters:** This is a senior-level question. Interviewers want to see you know the difference and can articulate *why* pure DI is generally more testable than service locator — while acknowledging that pure service locator is pragmatic and widely used.

**Common mistake:** Saying "Service Locator IS Dependency Injection." They solve the same problem (managing dependencies) but in opposite directions (push vs. pull). Using `get_it` everywhere inside classes is Service Locator, not DI.

---

**Q:** What is event-driven architecture and how does BLoC use this concept?

**A:** Event-driven architecture is a pattern where components communicate by producing and consuming **events** rather than calling each other directly. A producer emits an event; interested consumers react to it. The producer doesn't know who's listening or how they'll respond.

```
Event-Driven Flow:

[User taps button] ──► [Event: LoginRequested] ──► [BLoC]
                                                       │
                                               handles event
                                                       │
                                                       ▼
                                          [State: LoginLoading]
                                          [State: LoginSuccess]
                                          [State: LoginFailure]
                                                       │
                                              [Widget rebuilds]
```

**How BLoC implements event-driven architecture:**

BLoC has a strict one-directional flow:
- **Input:** Events (produced by the View, external triggers, other BLoCs)
- **Output:** States (consumed by the View)
- The BLoC reacts to events using `on<EventType>(handler)` — pure event handling

```dart
// Events (what can happen)
abstract class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}
class LogoutRequested extends AuthEvent {}

// States (what UI renders)
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// BLoC — pure event handler, no UI references
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase login;
  final LogoutUseCase logout;

  AuthBloc({required this.login, required this.logout})
      : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logout();
    emit(AuthInitial());
  }
}

// View fires events — doesn't call methods directly
ElevatedButton(
  onPressed: () => context.read<AuthBloc>().add(
    LoginRequested(email: emailController.text, password: passController.text),
  ),
  child: Text('Login'),
)
```

BLoC is also event-driven at a higher level — BLoCs can listen to other BLoCs' state streams, reacting to changes without direct coupling between them.

**Why it matters:** The interviewer is evaluating whether you understand BLoC not just as "a state management library" but as a principled event-driven system — and whether you can explain the architectural reasoning behind the Event → State pipeline.

**Common mistake:** Treating BLoC like a service and calling methods on it directly (`bloc.login(email, pass)`). In proper BLoC, the View can only add events — not call logic methods — which enforces the unidirectional data flow.

---

**Q:** What is "separation of concerns"? Give a real Flutter example of a violation and how to fix it.

**A:** Separation of Concerns (SoC) is the principle that each unit of code should have one clear responsibility and should not know about or handle responsibilities that belong elsewhere. When concerns mix, changing one thing breaks another — and testing becomes painful.

**Classic violation — everything in a Widget:**
```dart
// ❌ BAD — Widget handles UI, network, state, and business logic all at once
class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // ❌ Network call directly in widget
  Future<void> _loadProducts() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://api.example.com/products'));
      final json = jsonDecode(response.body) as List;

      // ❌ JSON parsing in widget
      final parsed = json.map((item) => Product(
        id: item['id'],
        name: item['name'],
        price: (item['price'] as num).toDouble(),
        // ❌ Business logic in widget
        discountedPrice: item['price'] * (1 - item['discount'] / 100),
      )).toList();

      setState(() {
        products = parsed;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return CircularProgressIndicator();
    if (error != null) return Text(error!);
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, i) => ListTile(title: Text(products[i].name)),
    );
  }
}
```

Problems: Widget cannot be tested without a real HTTP call. Changing the discount formula requires touching the widget. Changing the API URL requires opening the widget file.

**Fixed — each concern in the right layer:**
```dart
// ✅ domain/entities/product.dart — pure data + business rule
class Product {
  final String id;
  final String name;
  final double price;
  final double discountPercent;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPercent,
  });

  // Business logic belongs with the entity
  double get discountedPrice => price * (1 - discountPercent / 100);
}

// ✅ domain/repositories/product_repository.dart — interface only
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

// ✅ data/repositories/product_repository_impl.dart — data concern
class ProductRepositoryImpl implements ProductRepository {
  final http.Client client;
  ProductRepositoryImpl(this.client);

  @override
  Future<List<Product>> getProducts() async {
    final response = await client.get(Uri.parse('https://api.example.com/products'));
    final json = jsonDecode(response.body) as List;
    return json.map((item) => Product(
      id: item['id'],
      name: item['name'],
      price: (item['price'] as num).toDouble(),
      discountPercent: (item['discount'] as num).toDouble(),
    )).toList();
  }
}

// ✅ presentation/cubit/product_cubit.dart — state management concern
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;
  ProductCubit(this.repository) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

// ✅ presentation/screens/product_screen.dart — UI concern only
class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) return CircularProgressIndicator();
        if (state is ProductError) return Text(state.message);
        if (state is ProductLoaded) {
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(state.products[i].name),
              subtitle: Text('\$${state.products[i].discountedPrice}'),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
```

Now each layer can be tested independently. Changing the discount formula only touches `Product`. Changing the API only touches `ProductRepositoryImpl`. Changing the UI only touches `ProductScreen`.

**Why it matters:** SoC is not theoretical — it directly affects how long bug fixes take and how painful onboarding new team members is. Interviewers want concrete examples that show you've felt the pain of mixing concerns in production code.

**Common mistake:** Thinking SoC means "put things in separate files." You can have separate files that still mix concerns. The test is: can each unit be changed independently without touching other units?

---

**Q:** What are the trade-offs between Monorepo and Multi-repo for mobile teams?

**A:** These are strategies for organizing code across multiple packages, apps, or services.

```
Monorepo (single repository):          Multi-repo (many repositories):
┌────────────────────────────┐         ┌──────────┐  ┌──────────┐
│  my-company/app            │         │ core-pkg │  │ feature-a│
│  ├── apps/                 │         └──────────┘  └──────────┘
│  │   ├── mobile/           │              ↑              ↑
│  │   └── web/              │         ┌──────────┐  ┌──────────┐
│  ├── packages/             │         │ feature-b│  │ main-app │
│  │   ├── core/             │         └──────────┘  └──────────┘
│  │   ├── design_system/    │         All separate repos, linked
│  │   └── auth/             │         via pub.dev or git refs
│  └── services/             │
│      └── api/              │
└────────────────────────────┘
```

**Monorepo advantages:**
- Atomic changes — update a shared package and the app in one commit
- Easier cross-package refactoring (one search/replace across the whole codebase)
- Shared CI/CD configuration and tooling
- Simpler dependency management — no versioning hell between internal packages
- Easy to see the full impact of a change

**Monorepo disadvantages:**
- Slower CI if not configured with affected-build detection (every PR rebuilds everything)
- Repository access control is coarser — harder to give contractors access to only one module
- Git operations can become slow as history grows
- Requires tooling discipline (Melos for Flutter is standard)

**Multi-repo advantages:**
- Independent versioning and release cycles for each package
- Fine-grained access control — teams own their repos
- CI/CD is isolated — a broken service doesn't block the mobile build
- Conceptually simpler for small teams with clear ownership boundaries

**Multi-repo disadvantages:**
- Cross-package changes require multiple PRs, coordinated merges
- Dependency versioning between internal packages ("which version of `core` does `feature-a` use?")
- Onboarding requires setting up many repos
- Harder to see the full picture

**Flutter-specific tools for Monorepo:**
```yaml
# melos.yaml — Flutter monorepo tooling
name: my_company
packages:
  - apps/**
  - packages/**

scripts:
  test:all:
    run: melos exec -- flutter test
    description: Run tests in all packages
  build:affected:
    run: melos exec --diff=origin/main -- flutter build apk
```

**In practice:** Large Flutter teams (e.g., Verygood.ventures, Very Large FinTech apps) tend toward Monorepo with Melos. Smaller teams or platform teams sharing packages across mobile, web, and backend lean toward multi-repo.

**Why it matters:** This tests your experience managing real team-scale Flutter projects. Interviewers at companies with multiple engineers want to know you've thought about developer experience, not just code quality.

**Common mistake:** Saying "Monorepo is better" or "Multi-repo is better" without trade-offs. The answer always depends on team size, ownership structure, and release cadence requirements.

---

**Q:** What is modular/micro-frontend architecture in Flutter? Why do large teams adopt it?

**A:** Modular architecture in Flutter means splitting the app into self-contained **feature modules** — each a separate Dart package with its own UI, business logic, and tests. These modules are composed into the final app at the top level. The term "micro-frontend" comes from the web world but maps to the same idea: independently developed, independently testable UI features.

```
Traditional ("Big Ball of Mud"):        Modular Architecture:
┌──────────────────────────┐          ┌──────────────────────────┐
│          app/            │          │       app/ (shell)        │
│  lib/                    │          │  imports feature packages │
│  ├── screens/            │          └──────────────────────────┘
│  │   ├── home_screen.dart│                      │
│  │   ├── auth_screen.dart│          ┌───────────┼───────────┐
│  │   ├── cart_screen.dart│          ▼           ▼           ▼
│  │   └── order_screen... │   ┌────────────┐ ┌────────┐ ┌────────┐
│  ├── widgets/            │   │feature_auth│ │feat_   │ │feat_   │
│  ├── blocs/              │   │            │ │cart    │ │orders  │
│  └── repositories/       │   │ - screens  │ │        │ │        │
└──────────────────────────┘   │ - blocs    │ │-screens│ │-screens│
  One giant app package         │ - repos    │ │-blocs  │ │-blocs  │
                                 └────────────┘ └────────┘ └────────┘
                                 Packages that can be developed
                                 and tested in isolation
```

**Why large teams adopt this:**

1. **Build times:** Flutter only rebuilds changed packages. With a monolithic app, every change triggers a full rebuild.
2. **Team autonomy:** Team A owns `feature_checkout`, Team B owns `feature_catalog`. They merge independently with no conflicts.
3. **Enforced boundaries:** A package cannot accidentally import another feature's internals — the compiler enforces it.
4. **Testability:** Each feature package can be run and tested standalone (feature-level integration tests without the full app).
5. **Onboarding:** New developers understand their feature scope without drowning in the full codebase.

**How it's structured:**
```
packages/
  core/                    # shared utilities, base classes
  design_system/           # shared UI components, theme
  feature_auth/            # login, register, forgot password
  feature_product_catalog/ # product listing, search
  feature_cart/            # cart, checkout flow
  feature_orders/          # order history, tracking

apps/
  mobile/                  # shell app that composes the features
    pubspec.yaml:
      dependencies:
        feature_auth:
          path: ../../packages/feature_auth
        feature_cart:
          path: ../../packages/feature_cart
        ...
```

**Navigation between modules:**

Modules must not import each other directly (that creates coupling). Instead, use a routing contract:

```dart
// packages/core/lib/routing/app_routes.dart
abstract class AppRoutes {
  static const String home = '/home';
  static const String cart = '/cart';
  static const String productDetail = '/product/:id';
}

// Each feature registers its own routes but navigates using route names
// The shell app wires them together
class CartFeature {
  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.cart: (_) => CartScreen(),
  };
}
```

**Why it matters:** This is a senior/lead-level architecture question. Interviewers at companies with 10+ Flutter engineers want evidence you've worked at this scale and understand *why* the modular approach exists — not just that you've heard the term.

**Common mistake:** Confusing "modular" with "I put files in folders." Modules are Dart packages with their own `pubspec.yaml` — they have compiler-enforced isolation. Folders inside a single package offer zero enforcement.

---

**Q:** How do you decide which architecture to use for a new Flutter project?

**A:** There's no single correct answer — the right architecture depends on several dimensions. Here's a decision framework with the questions to ask:

```
START HERE
     │
     ▼
How big will this project get?
     │
     ├── Small (1-2 devs, short lifecycle, few features)
     │        │
     │        ▼
     │   Use simple layered arch: folders + Cubit/Provider
     │   → Avoid over-engineering
     │
     └── Medium to Large (3+ devs, long lifecycle, many features)
              │
              ▼
         Will multiple teams work on this?
              │
              ├── Yes → Modular architecture (feature packages)
              │         + Clean Architecture within each module
              │
              └── No  → Clean Architecture (3 layers)
                        + BLoC or Cubit for state management
```

**Key questions to ask:**

1. **Team size and seniority:** A junior team with Clean Architecture without good tooling/templates will produce inconsistent, over-engineered code. A senior team with no architecture will produce a mess. Match complexity to capability.

2. **Domain complexity:** Is this a CRUD app or does it have complex business rules (pricing engines, scheduling, multi-step workflows)? Simple CRUD → simple architecture. Complex domain → Clean Architecture with Use Cases.

3. **Long-term maintenance vs. speed-to-market:** Startups validating an MVP need to ship fast — Clean Architecture slows initial development. Established products with daily ongoing development need the investment.

4. **Testability requirements:** If you need high test coverage (fintech, healthcare), Clean Architecture pays for itself. If testing isn't prioritized, the overhead may not be worth it.

5. **State management needs:** Lots of complex async states, side effects, or inter-screen communication → BLoC. Simple reactive UI → Cubit or Riverpod. Very simple → Provider or setState.

**Practical recommendation by project type:**

| Project Type | Architecture | State Management |
|---|---|---|
| MVP / prototype | Simple layered | Cubit or Provider |
| Medium app (1 team) | Clean Architecture | Cubit or BLoC |
| Large app (multi-team) | Modular + Clean Arch | BLoC |
| SDK / package | Clean Architecture | None (pure Dart) |

**Example reasoning for a real scenario:**
> "We're building an e-commerce app, 5 Flutter devs, expected 2+ years of development. I'd go with modular Clean Architecture — feature packages for auth, catalog, cart, orders — each following Clean Architecture internally (Presentation/Domain/Data). BLoC for state management because we'll have complex async flows, cart sync, and optimistic UI that Cubit doesn't handle as elegantly. We'd use Melos for monorepo management and get_it for DI wiring at the app level."

**Why it matters:** This is the ultimate senior Flutter question. The interviewer isn't looking for the "right" architecture — they're evaluating whether you can reason about trade-offs and make a decision appropriate to context, rather than dogmatically applying the same pattern to every problem.

**Common mistake:** Saying "I always use Clean Architecture with BLoC for everything." This signals you apply patterns without thinking. The best engineers can explain *why* they'd use a lighter approach for a small project and a heavier one for a large one.

---
*End of Section 13: Software Architecture Patterns*
