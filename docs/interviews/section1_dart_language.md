# Section 1: Dart Language

---

**Q:** What is null safety in Dart? Explain `?`, `!`, `late`, and the `required` keyword.

**A:** Null safety, introduced in Dart 2.12, makes types non-nullable by default. A variable declared as `String name` can never hold `null` — the compiler enforces this at compile time, eliminating an entire class of null-reference crashes.

- `?` (nullable type): Adding `?` after a type opts that variable into nullability. `String? name` means `name` can be either a `String` or `null`.
- `!` (null assertion operator): Tells the compiler "I guarantee this is not null right now." If it is null at runtime, it throws a runtime exception. Use sparingly — it defeats the purpose of null safety.
- `late`: Declares a non-nullable variable that will be initialized after declaration but before first use. The compiler trusts you. If you access it before assigning, it throws a `LateInitializationError` at runtime.
- `required`: Used with named parameters to make them mandatory. Before null safety, all named parameters were optional. Now, if a named parameter is non-nullable and has no default, you must mark it `required`.

**Example:**
```dart
// Nullable type
String? nickname; // Can be null
print(nickname?.length); // Safe access — returns null if nickname is null

// Null assertion
String? email = getUserEmail();
print(email!.length); // Crashes if email is null

// late
class UserProfile {
  late String bio; // Will be set before first read

  void loadBio() {
    bio = fetchBioFromApi();
  }
}

// required keyword
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});
}
```

**Why it matters:** The interviewer is checking if you understand sound null safety — the idea that the type system guarantees a non-nullable variable can never be null. This is foundational to writing safe Dart code.

**Common mistake:** Candidates overuse `!` everywhere to silence the compiler. That is just null safety with extra steps — you are moving the crash from compile time to runtime. Another mistake is using `late` on fields that might never be initialized, turning a compile-time guarantee into a runtime gamble.

---

**Q:** What are the differences between `var`, `dynamic`, `Object`, `final`, and `const` in Dart?

**A:** These keywords control type inference, type flexibility, and mutability — three different axes.

- `var`: The compiler infers the type from the right-hand side. Once inferred, the type is fixed. `var x = 10;` makes `x` an `int` permanently.
- `dynamic`: Opts out of static type checking entirely. You can call any method on a `dynamic` variable — the compiler will not complain, but you get a runtime error if the method does not exist.
- `Object`: The root of the Dart type hierarchy (except `null`). Unlike `dynamic`, the compiler only allows methods defined on `Object` itself (like `toString()`, `hashCode`). It is type-safe.
- `final`: The variable can be assigned exactly once. The value can be determined at runtime. The object it points to can still be mutated internally (e.g., adding items to a `final List`).
- `const`: The value must be a compile-time constant. Deeply immutable — the object and everything it contains is frozen. `const` objects are canonicalized (identical values share the same instance in memory).

**Example:**
```dart
var name = 'Alice';       // Inferred as String, cannot assign int later
// name = 42;             // Compile error

dynamic anything = 'Hi';
anything = 42;            // Fine — no type constraint
anything.nonExistentMethod(); // Compiles, crashes at runtime

Object obj = 'Hello';
// obj.length;            // Compile error — Object has no .length
(obj as String).length;   // Works with explicit cast

final now = DateTime.now();      // Assigned once, value determined at runtime
// now = DateTime.now();         // Compile error — already assigned

const pi = 3.14159;             // Compile-time constant
const list = [1, 2, 3];        // Deeply immutable
// list.add(4);                 // Runtime error — cannot modify const list

final mutableList = [1, 2, 3];
mutableList.add(4);             // Works — final only locks the reference
```

**Why it matters:** This question tests whether you understand Dart's type system depth — inference vs. erasure vs. safety, and immutability semantics. Interviewers want to know if you choose the right tool for the right constraint.

**Common mistake:** Confusing `final` and `const`. Saying "final means constant" is wrong. `final` locks the binding, `const` freezes the value. Also, using `dynamic` when `Object` would suffice — `dynamic` skips type checking entirely, which is almost never what you want.

---

**Q:** What are Futures in Dart? How does `async`/`await` work under the hood?

**A:** A `Future<T>` represents a value that will be available at some point in the future — the result of an asynchronous operation. It can complete with a value (`T`) or with an error.

Under the hood, Dart runs on a single-threaded event loop (like JavaScript). When you call an async operation (e.g., an HTTP request), Dart hands that work off to the underlying system (OS-level I/O, timers, etc.) and moves on. When the result comes back, it is placed on the event queue. The event loop picks it up and runs the registered callback.

`async`/`await` is syntactic sugar over Futures. When the compiler sees `await`, it transforms the function into a state machine. Everything after `await` becomes a `.then()` callback behind the scenes. The function suspends at the `await` point, yields control back to the event loop, and resumes when the Future completes.

Key: `await` does NOT block the thread. It only suspends that particular async function.

**Example:**
```dart
// What you write:
Future<String> fetchUser() async {
  final response = await http.get(Uri.parse('https://api.example.com/user'));
  final decoded = jsonDecode(response.body);
  return decoded['name'];
}

// What the compiler roughly transforms it into:
Future<String> fetchUser() {
  return http.get(Uri.parse('https://api.example.com/user')).then((response) {
    final decoded = jsonDecode(response.body);
    return decoded['name'];
  });
}

// Error handling
Future<void> loadData() async {
  try {
    final data = await fetchUser();
    print(data);
  } catch (e) {
    print('Error: $e');
  }
}

// Running Futures in parallel
final results = await Future.wait([fetchUser(), fetchPosts(), fetchSettings()]);
```

**Why it matters:** This is core to every Flutter app. Interviewers check whether you understand that Dart is single-threaded and that `await` is non-blocking — it does not spin up another thread. They want to see that you can reason about execution order.

**Common mistake:** Saying `await` "blocks the thread" or "pauses execution." It suspends only the current function's execution — the event loop continues processing other events. Another mistake is awaiting Futures sequentially when they could run in parallel with `Future.wait()`.

---

**Q:** Explain Streams in Dart — single-subscription vs. broadcast, `StreamController`, and `StreamBuilder`.

**A:** A `Stream<T>` is a sequence of asynchronous events over time. While a `Future` delivers one value, a `Stream` delivers zero or more values.

**Single-subscription stream**: Can only have one listener at a time. If you try to listen twice, it throws. Most streams (file I/O, HTTP response bodies) are single-subscription because the data sequence should only be consumed once.

**Broadcast stream**: Can have multiple listeners. Each listener receives events from the point it starts listening — it does not replay past events. Use `stream.asBroadcastStream()` to convert, or create with `StreamController.broadcast()`.

**StreamController**: Lets you create a stream and push events into it manually. It is the "write side" of a stream. You get a `sink` to add data and a `stream` property for consumers.

**StreamBuilder**: A Flutter widget that rebuilds itself whenever a new event arrives on a stream. It provides an `AsyncSnapshot` with the current connection state and latest data or error.

**Example:**
```dart
// StreamController
final controller = StreamController<int>();
controller.sink.add(1);
controller.sink.add(2);
controller.stream.listen((value) => print(value)); // Prints 1, 2
controller.close(); // Always close when done

// Broadcast stream
final broadcastController = StreamController<int>.broadcast();
broadcastController.stream.listen((v) => print('Listener A: $v'));
broadcastController.stream.listen((v) => print('Listener B: $v'));
broadcastController.add(42); // Both listeners receive 42

// Stream transformations
final stream = Stream.periodic(Duration(seconds: 1), (i) => i);
stream
    .where((i) => i.isEven)
    .map((i) => 'Even: $i')
    .take(5)
    .listen(print);

// StreamBuilder in Flutter
StreamBuilder<int>(
  stream: counterStream,
  initialData: 0,
  builder: (context, snapshot) {
    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    if (!snapshot.hasData) return CircularProgressIndicator();
    return Text('Count: ${snapshot.data}');
  },
)
```

**Why it matters:** Streams are everywhere in Flutter — Firebase Firestore snapshots, BLoC pattern, form validation, WebSockets. The interviewer wants to see if you can choose the right stream type and handle its lifecycle (closing controllers to prevent memory leaks).

**Common mistake:** Forgetting to close `StreamController`, leading to memory leaks. Also, trying to listen to a single-subscription stream multiple times without converting it to broadcast first. Another frequent error is not handling the `ConnectionState` properly in `StreamBuilder`.

---

**Q:** Why is Dart single-threaded? What do Isolates solve, and what is the `compute()` function?

**A:** Dart uses a single-threaded event loop model for its main execution. This means all your Dart code, UI rendering, and event handling run on one thread — no shared mutable state, no locks, no race conditions by default. This is a deliberate design choice that makes concurrent programming dramatically simpler.

The problem: CPU-intensive work (image processing, JSON parsing of large payloads, encryption) runs on that same thread and blocks the UI, causing jank.

**Isolates** are Dart's solution. An Isolate is an independent worker with its own memory heap and event loop. Isolates do NOT share memory — they communicate exclusively by passing messages (which are copied, not shared). This eliminates data races entirely at the language level.

**`compute()`** (from the Flutter framework, now `Isolate.run()` in Dart 2.19+) is a convenience function that spawns an Isolate, runs a single function, returns the result, and kills the Isolate. It is the simplest way to offload a one-shot heavy computation.

**Example:**
```dart
// Using Isolate.run (Dart 2.19+)
Future<List<Product>> parseProducts(String jsonString) async {
  return await Isolate.run(() {
    final list = jsonDecode(jsonString) as List;
    return list.map((e) => Product.fromJson(e)).toList();
  });
}

// Using Flutter's compute()
Future<List<Product>> parseProducts(String jsonString) async {
  return await compute(_parseJson, jsonString);
}

// Must be a top-level or static function
List<Product> _parseJson(String jsonString) {
  final list = jsonDecode(jsonString) as List;
  return list.map((e) => Product.fromJson(e)).toList();
}

// Full Isolate with bidirectional communication
Future<void> longRunningTask() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_worker, receivePort.sendPort);

  receivePort.listen((message) {
    print('Received from isolate: $message');
  });
}

void _worker(SendPort sendPort) {
  // Heavy computation here
  sendPort.send('Result from isolate');
}
```

**Why it matters:** Interviewers test this to see if you understand performance optimization in Flutter. If your app drops frames, and you do not know about Isolates, you have no solution for CPU-bound work. They also want to verify you know the difference between I/O-bound (use Futures) and CPU-bound (use Isolates) work.

**Common mistake:** Thinking Isolates are like threads with shared memory. They are not — data is copied across Isolate boundaries, so sending huge objects is expensive. Also, passing closures that capture state to `compute()` fails because the function must be top-level or static.

---

**Q:** What are extension methods in Dart? What is the syntax, and what are the limitations?

**A:** Extension methods let you add new functionality to existing types without modifying them or creating subclasses. They were introduced in Dart 2.7. You can add methods, getters, setters, and operators to any type — including types you do not own (like `String`, `int`, or third-party classes).

**Limitations:**
- Extensions are resolved statically, not dynamically. If a variable is typed as `dynamic`, extension methods will not work.
- You cannot override existing methods — if the type already has a method with that name, the original wins.
- Extensions cannot add instance state (fields). They can only add behavior.
- They do not appear in the type's interface — they are syntactic sugar for static dispatch.

**Example:**
```dart
// Basic extension
extension StringExtras on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  bool get isEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
}

// Usage
print('hello'.capitalize());  // Hello
print('user@test.com'.isEmail); // true

// Extension on generic type
extension ListExtras<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;

  List<T> separatedBy(T separator) {
    return expand((item) => [item, separator]).toList()..removeLast();
  }
}

// Named extensions for disambiguation
extension DateFormatting on DateTime {
  String get ymd => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

// Limitation: does not work with dynamic
dynamic val = 'hello';
// val.capitalize(); // Runtime error — extension not resolved on dynamic
(val as String).capitalize(); // Works — cast to String first
```

**Why it matters:** Extensions show you write idiomatic Dart. Interviewers look for whether you use them to keep code clean and cohesive rather than scattering utility functions. It also tests your understanding of static vs. dynamic dispatch.

**Common mistake:** Expecting extension methods to work on `dynamic` types. The compiler resolves extensions at compile time based on the static type, so `dynamic` bypasses them entirely. Another mistake is trying to use extensions to add stored properties — they can only add computed behavior.

---

**Q:** What are mixins in Dart? Explain the `with` keyword, `on` keyword, and the difference from an abstract class.

**A:** A mixin is a way to reuse a class's code in multiple class hierarchies. Dart's single inheritance means a class can only `extend` one parent. Mixins solve this by letting you compose behaviors from multiple sources using the `with` keyword.

- `with`: Applies one or more mixins to a class. `class Dog extends Animal with Barking, Fetching {}` means `Dog` inherits from `Animal` and mixes in both `Barking` and `Fetching`.
- `on`: Restricts which classes can use the mixin. `mixin Swimmer on Animal {}` means only classes that extend `Animal` (or `Animal` itself) can use `Swimmer`. It also lets the mixin call methods from that superclass.

**Mixin vs. abstract class:**
- An abstract class can have constructors; a mixin declared with the `mixin` keyword cannot.
- A class can use multiple mixins but can only extend one abstract class.
- Mixins are for composing behavior horizontally; abstract classes are for defining a vertical inheritance hierarchy.
- With the `mixin` keyword, the class cannot be instantiated directly or extended — it can only be mixed in.

**Example:**
```dart
mixin Logging {
  void log(String message) => print('[LOG] $message');
}

mixin Caching {
  final Map<String, dynamic> _cache = {};

  void cacheValue(String key, dynamic value) => _cache[key] = value;
  dynamic getCached(String key) => _cache[key];
}

// Using multiple mixins
class ApiService with Logging, Caching {
  Future<String> fetchData(String url) async {
    final cached = getCached(url);
    if (cached != null) {
      log('Cache hit for $url');
      return cached;
    }
    log('Fetching $url');
    final data = await _httpGet(url);
    cacheValue(url, data);
    return data;
  }
}

// Restricting with 'on'
abstract class Widget {
  void build();
}

mixin Draggable on Widget {
  void onDrag() {
    build(); // Can call Widget's methods because of 'on Widget'
    print('Dragging...');
  }
}

class DraggableCard extends Widget with Draggable {
  @override
  void build() => print('Building card');
}

// This would be a compile error:
// class NotAWidget with Draggable {} // Error: Draggable requires Widget
```

**Why it matters:** Mixins test your understanding of Dart's composition model. In Flutter, mixins appear constantly — `TickerProviderStateMixin`, `WidgetsBindingObserver`, `AutomaticKeepAliveClientMixin`. The interviewer wants to know you understand the linearization order and when to use a mixin vs. inheritance.

**Common mistake:** Not understanding mixin linearization order. When multiple mixins define the same method, the last one in the `with` clause wins. Also, confusing `mixin` with `mixin class` (Dart 3) — `mixin class` can be both extended AND mixed in, while a pure `mixin` cannot be extended.

---

**Q:** Why do generics exist in Dart? Explain bounded generics and generic methods.

**A:** Generics let you write code that works with multiple types while retaining type safety. Without generics, you would either duplicate code for each type or use `dynamic` and lose compile-time checks. Generics give you reusability without sacrificing safety.

Dart generics are **reified** — the type information is preserved at runtime (unlike Java, where it is erased). This means you can check `list is List<int>` at runtime and get a correct answer.

**Bounded generics** constrain the type parameter to be a subtype of a given type. `T extends Comparable<T>` means `T` must implement `Comparable`, so you can safely call `.compareTo()` on it.

**Generic methods** parameterize a single method rather than an entire class.

**Example:**
```dart
// Generic class
class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
}

// Usage — type is inferred or explicit
final result = Result<User>.success(user);
final errorResult = Result<String>.failure('Not found');

// Bounded generic
class SortedList<T extends Comparable<T>> {
  final List<T> _items = [];

  void add(T item) {
    _items.add(item);
    _items.sort(); // Safe — T is guaranteed to have compareTo()
  }
}

// Generic method
T firstWhere<T>(List<T> items, bool Function(T) predicate) {
  for (final item in items) {
    if (predicate(item)) return item;
  }
  throw StateError('No element');
}

// Reified generics — runtime type checking works
void checkType(List list) {
  if (list is List<int>) {
    print('This is a list of integers');
  }
}

checkType([1, 2, 3]);     // Prints: This is a list of integers
checkType(['a', 'b']);     // Does not print
```

**Why it matters:** Generics are fundamental to how Flutter and Dart libraries work — `Future<T>`, `Stream<T>`, `ValueNotifier<T>`, `Provider<T>`. The interviewer is checking if you can write type-safe, reusable abstractions and if you know Dart generics are reified.

**Common mistake:** Not knowing Dart generics are reified. Candidates coming from Java assume type erasure and avoid runtime type checks. Another mistake is making everything `dynamic` instead of using a proper generic constraint — this throws away compiler help.

---

**Q:** What are closures in Dart? Explain lexical scope and variable capture.

**A:** A closure is a function that captures variables from its enclosing lexical scope. Even after the enclosing scope has finished executing, the closure retains a live reference to those variables — not a copy of their values.

**Lexical scope** means a function can access variables from all surrounding scopes, determined by where the function is written in the source code (not where it is called).

**Variable capture** means the closure holds a reference to the variable itself. If the variable changes after the closure is created, the closure sees the updated value.

**Example:**
```dart
// Basic closure
Function makeCounter() {
  int count = 0; // This variable is captured
  return () {
    count++;
    return count;
  };
}

final counter = makeCounter();
print(counter()); // 1
print(counter()); // 2 — count persists between calls

// Variable capture — captures the variable, not the value
var callbacks = <Function>[];
for (var i = 0; i < 3; i++) {
  callbacks.add(() => print(i));
}
callbacks.forEach((cb) => cb()); // Prints: 0, 1, 2
// Each iteration creates a new 'i' because var in for-loop is scoped per iteration

// Contrast with a shared variable
var shared = 0;
var fns = <Function>[];
for (shared = 0; shared < 3; shared++) {
  fns.add(() => print(shared));
}
fns.forEach((fn) => fn()); // Prints: 3, 3, 3 — all closures see the same 'shared'

// Practical use — event handlers
Widget buildButton(String label, VoidCallback onTap) {
  return ElevatedButton(
    onPressed: () {
      print('Tapped $label'); // Captures 'label' from parameter
      onTap();                // Captures 'onTap' from parameter
    },
    child: Text(label),
  );
}
```

**Why it matters:** Closures are the backbone of Dart's functional programming features. Every callback you pass to `.map()`, `.where()`, `setState()`, or gesture handlers is a closure. The interviewer wants to know if you understand variable capture semantics, especially in loops.

**Common mistake:** Assuming closures capture the value at creation time. They capture the variable reference. The classic loop-closure bug (all callbacks printing the same final value) catches many candidates. In Dart, `for (var i ...)` creates a new variable per iteration which avoids this, but using an external variable does not.

---

**Q:** What is cascade notation (`..`) in Dart? When should you use it, and how is it different from method chaining?

**A:** Cascade notation (`..`) lets you perform multiple operations on the same object without repeating its name. Each `..` operation returns the original object, not the result of the operation.

**Method chaining** relies on each method explicitly returning `this`. Cascade notation works even when methods return `void` or something else entirely — the `..` always evaluates to the original receiver.

You can also use `?..` for null-aware cascades.

**Example:**
```dart
// Without cascade — repetitive
var paint = Paint();
paint.color = Colors.red;
paint.strokeWidth = 2.0;
paint.style = PaintingStyle.stroke;

// With cascade — concise
var paint = Paint()
  ..color = Colors.red
  ..strokeWidth = 2.0
  ..style = PaintingStyle.stroke;

// Cascades work even when the method returns void
var list = <int>[]
  ..add(1)      // add() returns void, but cascade returns the list
  ..add(2)
  ..addAll([3, 4])
  ..sort();

// Method chaining — requires each method to return 'this'
class QueryBuilder {
  QueryBuilder where(String clause) { /* ... */ return this; }
  QueryBuilder orderBy(String field) { /* ... */ return this; }
  QueryBuilder limit(int n) { /* ... */ return this; }
}

// Chaining only works because each method explicitly returns QueryBuilder
final query = QueryBuilder().where('age > 18').orderBy('name').limit(10);

// Null-aware cascade
user?..name = 'Alice'
     ..email = 'alice@example.com';
// Does nothing if user is null
```

**Why it matters:** Cascade notation is distinctly Dart. Interviewers use it to check if you write idiomatic Dart. It also reveals whether you understand the difference between an operator that returns the receiver vs. a method that returns `this`.

**Common mistake:** Confusing cascade with method chaining and thinking the method's return value matters. With cascades, the return value of each operation is discarded — you always get back the original object. Another mistake is using cascades when you actually need the return value of a method call.

---

**Q:** Explain the spread operator (`...`) and collection `if`/`for` in Dart.

**A:** These are collection literals features that let you build lists, sets, and maps declaratively.

- **Spread (`...`)**: Unpacks all elements of a collection into another collection. `...?` is the null-aware variant — it does nothing if the collection is `null`.
- **Collection `if`**: Conditionally includes an element based on a boolean condition.
- **Collection `for`**: Generates elements from a loop inline.

These are evaluated at build time (for `const`) or runtime, and they compose naturally. They are particularly powerful in Flutter for building widget trees conditionally.

**Example:**
```dart
// Spread operator
final base = [1, 2, 3];
final extended = [0, ...base, 4]; // [0, 1, 2, 3, 4]

// Null-aware spread
List<int>? maybeList;
final safe = [0, ...?maybeList]; // [0] — no crash

// Merging maps
final defaults = {'theme': 'light', 'lang': 'en'};
final overrides = {'theme': 'dark'};
final config = {...defaults, ...overrides}; // theme is 'dark'

// Collection if
final isLoggedIn = true;
final nav = [
  'Home',
  'Search',
  if (isLoggedIn) 'Profile',
  if (!isLoggedIn) 'Login',
]; // ['Home', 'Search', 'Profile']

// Collection for
final squares = [
  for (var i = 1; i <= 5; i++) i * i,
]; // [1, 4, 9, 16, 25]

// Flutter widget tree — where this shines
Column(
  children: [
    Header(),
    ...menuItems.map((item) => MenuTile(item)),
    if (isAdmin) AdminPanel(),
    for (var notification in alerts)
      NotificationBanner(notification),
  ],
)
```

**Why it matters:** In Flutter, you build UI declaratively. Collection `if`/`for` and spread are how you conditionally render widgets and compose lists without imperative code. Interviewers want to see that you can construct widget trees cleanly.

**Common mistake:** Using separate builder methods with `if/else` blocks and `addAll()` when collection `if`/`for` would be cleaner. Also forgetting `...?` when the list might be null and getting a crash at runtime.

---

**Q:** Explain named, positional, and optional parameters in Dart. When do you use each?

**A:** Dart has three kinds of parameters:

1. **Required positional**: Defined without braces or brackets. Order matters. Always required.
2. **Optional positional**: Wrapped in `[]`. Order matters. Can have default values.
3. **Named**: Wrapped in `{}`. Order does not matter when calling. Optional by default unless marked `required`.

You cannot mix optional positional and named parameters in the same function — it is one or the other (after any required positional parameters).

**Example:**
```dart
// Required positional
int add(int a, int b) => a + b;
add(2, 3); // Must be in order

// Optional positional with defaults
String greet(String name, [String greeting = 'Hello', String? suffix]) {
  return '$greeting, $name${suffix ?? ''}';
}
greet('Alice');                  // Hello, Alice
greet('Alice', 'Hi');            // Hi, Alice
greet('Alice', 'Hey', '!');      // Hey, Alice!

// Named parameters (the Flutter convention)
void createUser({
  required String name,
  required String email,
  int age = 0,
  String? phone,
}) {
  // ...
}

createUser(email: 'a@b.com', name: 'Alice'); // Order doesn't matter
createUser(name: 'Bob', email: 'b@b.com', age: 30);

// Flutter widget constructors — always named
class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });
}
```

**When to use each:**
- **Required positional**: When you have 1–2 obvious arguments (like `add(a, b)`). Order is self-evident.
- **Optional positional**: Rare in Flutter. Useful for functions where an optional argument has an obvious position (like `List.generate(length, generator, [growable])`).
- **Named**: The default choice in Flutter. Use for constructors, configuration methods, and anything with more than 2 parameters. Self-documenting at the call site.

**Why it matters:** Flutter APIs are almost entirely named parameters. The interviewer checks if you understand why (readability, flexibility, self-documentation) and if you use `required` correctly for non-nullable named parameters.

**Common mistake:** Using optional positional parameters in widget constructors — it makes the call site unreadable. Also, forgetting `required` on non-nullable named parameters that have no default, which causes a compile error.

---

**Q:** What are factory constructors in Dart? How do they differ from regular constructors, and what is a redirect factory?

**A:** A `factory` constructor is a constructor that does not always create a new instance. Unlike a regular constructor, it can return an existing instance, a subclass instance, or even `null` (if the return type allows it). It does not have access to `this`.

**Key differences from a regular constructor:**
- A regular (generative) constructor always creates a new instance and initializes `this`.
- A factory constructor has a body like a regular method, must explicitly return an instance, and cannot access `this` or initialize fields via initializer lists.
- Factory constructors can implement caching (return a previously created instance), return a subtype, or run logic to decide what to return.

**Redirect factory constructor** uses `= ClassName.constructor` to redirect to another constructor directly. The compiler can inline this.

**Example:**
```dart
// Factory for caching (singleton pattern)
class Database {
  static final Database _instance = Database._internal();

  factory Database() => _instance; // Always returns the same instance

  Database._internal(); // The real constructor, private
}

final db1 = Database();
final db2 = Database();
print(identical(db1, db2)); // true — same instance

// Factory returning a subtype
abstract class Shape {
  double get area;

  factory Shape.circle(double radius) => Circle(radius);
  factory Shape.square(double side) => Square(side);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
  @override
  double get area => 3.14159 * radius * radius;
}

class Square implements Shape {
  final double side;
  Square(this.side);
  @override
  double get area => side * side;
}

// Factory with fromJson pattern
class User {
  final String name;
  final int age;

  User(this.name, this.age);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'] as String, json['age'] as int);
  }
}

// Redirect factory constructor
class Logger {
  factory Logger() = _ConsoleLogger; // Redirects to _ConsoleLogger
}

class _ConsoleLogger implements Logger {
  // implementation
}
```

**Why it matters:** Factory constructors appear in almost every Flutter/Dart codebase — singletons, `fromJson` deserialization, abstract class instantiation patterns. Interviewers test whether you understand when `factory` is the right tool vs. a named or generative constructor.

**Common mistake:** Using `factory` when a named constructor would suffice (e.g., `factory User.fromJson` when there is no conditional logic — a plain named constructor works fine and is simpler). Also, trying to use initializer lists or `this` inside a factory constructor.

---

**Q:** Dart has no `interface` keyword. How do you achieve both abstract classes and interfaces?

**A:** In Dart, every class implicitly defines an interface. When you write `class Foo { ... }`, you are also defining an interface that contains all of Foo's public members. Any class can `implement` Foo to adopt that interface — it must then provide its own implementation of every member.

- `extends` (inheritance): Inherits implementation. Single inheritance only.
- `implements` (interface): Adopts the interface contract only. Must override every member. Can implement multiple classes.
- `abstract class`: Cannot be instantiated directly. Can have both abstract (unimplemented) and concrete (implemented) methods.

The pattern in Dart is: use `abstract class` when you want to define a contract with some shared implementation. Use `implements` when you only care about the API shape.

**Example:**
```dart
// Abstract class — partial implementation
abstract class Animal {
  String get name; // Abstract — subclass must implement

  void breathe() => print('$name is breathing'); // Concrete — inherited
}

class Dog extends Animal {
  @override
  String get name => 'Dog';
  // breathe() is inherited
}

// Any class as an interface
class Printer {
  void printDocument(String doc) => print(doc);
}

class MockPrinter implements Printer {
  @override
  void printDocument(String doc) {
    // Must provide own implementation — nothing is inherited
    print('[MOCK] $doc');
  }
}

// Multiple interfaces
abstract class Readable {
  String read();
}

abstract class Writable {
  void write(String data);
}

class File implements Readable, Writable {
  @override
  String read() => 'file contents';

  @override
  void write(String data) => print('Writing: $data');
}

// Dart 3: 'interface class' modifier
interface class Serializable {
  String serialize() => '{}';
}

// Can implement but cannot extend
class Config implements Serializable {
  @override
  String serialize() => '{"setting": true}';
}

// class SubConfig extends Serializable {} // Compile error in Dart 3
```

**Why it matters:** This is a classic Dart question that tests whether you understand the "implicit interface" concept. In Flutter, you see this everywhere — implementing `ChangeNotifier`, `Listenable`, etc. The interviewer is evaluating your understanding of OOP in Dart.

**Common mistake:** Saying "Dart doesn't have interfaces." It does — every class IS an interface. The nuance is that there is no separate `interface` keyword (until Dart 3 added `interface class` as a modifier). Another mistake is using `extends` when `implements` is more appropriate, accidentally inheriting behavior you did not want.

---

**Q:** What are enhanced enums in Dart? Can enums have methods, fields, and implement interfaces?

**A:** Since Dart 2.17, enums are full-featured classes. They can have fields (instance variables), constructors, methods, getters, and can even implement interfaces. Each enum value is a compile-time constant instance of the enum class.

**Constraints:**
- Constructors must be `const`.
- You cannot extend an enum.
- Instance fields must be `final`.
- The `index` and `values` properties are automatically provided.
- Generative constructors must produce all values at the enum declaration.

**Example:**
```dart
enum Planet implements Comparable<Planet> {
  mercury(diameter: 4879, distanceFromSun: 57.9),
  venus(diameter: 12104, distanceFromSun: 108.2),
  earth(diameter: 12756, distanceFromSun: 149.6),
  mars(diameter: 6792, distanceFromSun: 227.9);

  final double diameter; // km
  final double distanceFromSun; // million km

  const Planet({required this.diameter, required this.distanceFromSun});

  // Methods
  bool get isInnerPlanet => distanceFromSun < 200;
  String get description => '$name: ${diameter}km, ${distanceFromSun}M km from Sun';

  // Implementing Comparable
  @override
  int compareTo(Planet other) => distanceFromSun.compareTo(other.distanceFromSun);
}

// Usage
print(Planet.earth.isInnerPlanet);   // true
print(Planet.earth.description);     // earth: 12756.0km, 149.6M km from Sun

final sorted = Planet.values.toList()..sort();
print(sorted.first); // Planet.mercury

// Practical Flutter example
enum AppRoute {
  home(path: '/', icon: Icons.home),
  search(path: '/search', icon: Icons.search),
  profile(path: '/profile', icon: Icons.person);

  final String path;
  final IconData icon;

  const AppRoute({required this.path, required this.icon});
}
```

**Why it matters:** Enhanced enums replace many cases where you would previously use a class with static constants. The interviewer checks whether you leverage this feature for cleaner, more expressive code — especially in routing, theming, and configuration.

**Common mistake:** Forgetting that enum constructors must be `const` and fields must be `final`. Trying to add mutable state to an enum value will not compile. Also, not knowing this feature exists and writing verbose class hierarchies when a simple enhanced enum would do.

---

**Q:** What is `typedef` in Dart, and when is it useful?

**A:** `typedef` creates a named alias for a type, most commonly for function signatures. It improves readability by giving a meaningful name to a complex type, and it makes it easier to change the type in one place.

Since Dart 2.13, `typedef` works with any type, not just functions.

**Example:**
```dart
// Function typedef — the classic use case
typedef Predicate<T> = bool Function(T item);
typedef JsonMap = Map<String, dynamic>;
typedef VoidCallback = void Function(); // This is defined in Flutter

// Without typedef — hard to read
void filter(List<int> items, bool Function(int) test) { /* ... */ }

// With typedef — self-documenting
void filter(List<int> items, Predicate<int> test) { /* ... */ }

// Non-function typedef (Dart 2.13+)
typedef StringList = List<String>;
typedef UserJson = Map<String, dynamic>;
typedef Callback<T> = void Function(T value);

// Practical use — API layer
typedef ApiResponse<T> = Future<Result<T>>;
typedef FromJson<T> = T Function(JsonMap json);

class ApiClient {
  ApiResponse<T> get<T>(String url, {required FromJson<T> parser}) async {
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body) as JsonMap;
    return Result.success(parser(json));
  }
}

// Makes callback types readable in class definitions
typedef OnUserSelected = void Function(User user);
typedef OnError = void Function(String message, int code);

class UserPicker extends StatelessWidget {
  final OnUserSelected onSelected;
  final OnError? onError;
  // ...
}
```

**Why it matters:** Typedefs show that you value code readability and maintainability. In larger codebases, function types get complex fast. The interviewer is checking if you use typedefs to tame that complexity.

**Common mistake:** Overusing typedefs for trivial types — aliasing `int` as `UserId` can be confusing because Dart typedefs are transparent aliases (not distinct types), so a `UserId` and a plain `int` are interchangeable. For truly distinct types, you need a wrapper class or an extension type (Dart 3).

---

**Q:** What are sealed classes in Dart 3, and how do they relate to pattern matching?

**A:** A `sealed` class restricts which classes can directly extend or implement it — only classes within the same library (same file) can do so. Outside that file, the sealed class cannot be extended, implemented, or mixed in.

The key benefit: the compiler knows ALL subtypes at compile time. This enables **exhaustiveness checking** in switch expressions. If you match on a sealed type, the compiler warns you if you miss a case — no need for a `default` branch.

This is Dart's version of algebraic data types (ADTs), similar to Kotlin's `sealed class` or Rust's `enum`.

**Example:**
```dart
// All subtypes must be in the same file
sealed class AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class Loading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// Exhaustive switch — compiler checks all cases
String describeState(AuthState state) {
  return switch (state) {
    Authenticated(user: var u) => 'Welcome, ${u.name}',
    Unauthenticated()          => 'Please sign in',
    Loading()                  => 'Loading...',
    AuthError(message: var m)  => 'Error: $m',
    // No default needed — compiler knows these are all cases
  };
}

// If you add a new subtype and forget to update the switch,
// the compiler gives a warning — this prevents bugs

// Practical use with BLoC/Cubit
sealed class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {
  final int value;
  Reset(this.value);
}
```

**Why it matters:** Sealed classes are the foundation of type-safe state management in modern Dart. They replace the error-prone pattern of `if (state is X) else if (state is Y)` with compiler-verified exhaustive switches. Interviewers look for this to gauge your Dart 3 proficiency.

**Common mistake:** Placing subtypes in different files — the compiler loses exhaustiveness checking. Another mistake is using an abstract class instead of a sealed class for state types, giving up the compiler guarantee that all cases are handled.

---

**Q:** What are records in Dart 3? What is the syntax, and how do you destructure them?

**A:** Records are anonymous, immutable, aggregate types. Think of them as lightweight, value-type tuples with optional named fields. They are compared by structure and value (structural equality), not by identity.

Records solve the problem of returning multiple values from a function without creating a dedicated class.

**Syntax:** Parentheses with comma-separated fields. Named fields use curly braces within the record type.

**Example:**
```dart
// Positional record
(int, String) userInfo = (1, 'Alice');
print(userInfo.$1); // 1 (positional fields use $1, $2, ...)
print(userInfo.$2); // Alice

// Named fields
({String name, int age}) person = (name: 'Bob', age: 30);
print(person.name); // Bob
print(person.age);  // 30

// Mixed positional and named
(int, {String name, bool active}) record = (42, name: 'Test', active: true);
print(record.$1);     // 42
print(record.name);   // Test

// Returning multiple values from a function
(double lat, double lng) getCoordinates(String city) {
  return (23.8103, 90.4125); // Dhaka
}

final (lat, lng) = getCoordinates('Dhaka'); // Destructuring
print('$lat, $lng');

// Structural equality
final a = (1, 'hello');
final b = (1, 'hello');
print(a == b); // true — same structure and values

// Destructuring in pattern matching
final (String name, int age) = ('Alice', 25);

// With switch
sealed class Shape {}
class Circle extends Shape { final double radius; Circle(this.radius); }
class Rect extends Shape { final double w, h; Rect(this.w, this.h); }

(String, double) describe(Shape shape) => switch (shape) {
  Circle(radius: var r) => ('circle', 3.14 * r * r),
  Rect(w: var w, h: var h) => ('rectangle', w * h),
};
```

**Why it matters:** Records eliminate the need for throwaway data classes. Before Dart 3, returning two values required creating a class or using a `Map`. The interviewer checks whether you know this and can use destructuring effectively to write concise code.

**Common mistake:** Confusing records with `Map` or `List`. Records are typed, fixed-size, immutable, and compared by value. Also, forgetting that positional fields are accessed via `$1`, `$2` (not `$0` — it is 1-indexed).

---

**Q:** Explain pattern matching and switch expressions in Dart 3.

**A:** Dart 3 overhauls `switch` from a statement into an expression and adds full pattern matching. Patterns let you destructure and test the shape and content of a value simultaneously.

**Switch expression**: Returns a value. Uses `=>` instead of `case:` and has no fall-through.

**Pattern types include:**
- **Constant patterns**: `case 42`, `case 'hello'`
- **Variable patterns**: `case var x` (binds the value to `x`)
- **Object patterns**: `case Circle(radius: var r)` (destructures an object)
- **Logical patterns**: `case > 0 && < 100` (combines conditions)
- **List/Map patterns**: `case [var first, ...var rest]`
- **Record patterns**: `case (var x, var y)`
- **Null-check patterns**: `case var x?` (matches non-null)
- **Guard clauses**: `case var x when x > 0`

**Example:**
```dart
// Switch expression — returns a value
String describe(int n) => switch (n) {
  0 => 'zero',
  1 => 'one',
  >= 2 && <= 9 => 'single digit',
  _ => 'large number', // _ is the wildcard (default)
};

// Object destructuring pattern
sealed class Notification {}
class Email extends Notification { final String subject; Email(this.subject); }
class SMS extends Notification { final String number; SMS(this.number); }
class Push extends Notification { final String title; final int badge; Push(this.title, this.badge); }

String handle(Notification n) => switch (n) {
  Email(subject: var s) => 'Email: $s',
  SMS(number: var num) => 'SMS from $num',
  Push(title: var t, badge: var b) when b > 0 => '$t ($b new)',
  Push(title: var t) => t,
};

// List patterns
final list = [1, 2, 3, 4, 5];
final [first, second, ...rest] = list;
print(first); // 1
print(rest);  // [3, 4, 5]

// If-case — pattern matching in if statements
void processResponse(Object response) {
  if (response case {'status': int code, 'data': Map data} when code == 200) {
    print('Success: $data');
  }
}

// Map patterns
final json = {'name': 'Alice', 'age': 25};
if (json case {'name': String name, 'age': int age}) {
  print('$name is $age years old');
}

// Null-check pattern
String? maybeNull = getNullableValue();
if (maybeNull case var value?) {
  print(value.length); // value is promoted to non-null String
}

// Practical: parsing API responses
Widget buildFromResponse(Map<String, dynamic> response) {
  return switch (response) {
    {'error': String msg} => ErrorWidget(msg),
    {'data': List items} when items.isNotEmpty => ListWidget(items),
    {'data': List _} => EmptyWidget(),
    _ => UnknownWidget(),
  };
}
```

**Why it matters:** Pattern matching and switch expressions are the most significant Dart 3 features. They transform how you write conditional logic. The interviewer wants to see if you have adopted Dart 3 idioms or are still writing chains of `if-else` and `is` checks.

**Common mistake:** Forgetting the `_` wildcard as the default case, which can cause a compile error if the switch is not exhaustive. Also, not using `when` guards and instead nesting `if` statements inside case bodies. Another mistake is not realizing that `if-case` exists for single-pattern checks.

---

**Q:** What are the Dart compilation modes — JIT vs. AOT? When is each used?

**A:** Dart supports two compilation modes that serve fundamentally different purposes:

**JIT (Just-In-Time):**
- Compiles code on-the-fly during execution.
- Used during **development** (`flutter run` in debug mode).
- Enables **hot reload** and **hot restart** — you change code and see results in under a second without losing app state.
- Includes the full Dart VM with a runtime compiler, debugging info, and assertions.
- Produces larger binaries and slower execution, but the development experience is fast.
- Also supports dart's Observatory (DevTools) for profiling and debugging.

**AOT (Ahead-Of-Time):**
- Compiles to native machine code before the app runs.
- Used for **release builds** (`flutter build apk`, `flutter build ios`).
- Produces small, fast, optimized binaries. No runtime compiler is included.
- Startup is much faster because there is no compilation step at runtime.
- Does not support hot reload or reflection (`dart:mirrors` is unavailable).
- Tree shaking removes unused code, reducing binary size.

**The brilliance of Dart for Flutter is having both:** fast development with JIT, high-performance releases with AOT.

**Example:**
```dart
// Debug mode (JIT) — assertions run
assert(price >= 0, 'Price must be non-negative');
// This line disappears in release (AOT) builds

// You can check the mode at runtime
void main() {
  // kDebugMode is a const bool from Flutter
  if (kDebugMode) {
    print('Running in debug mode');
  }

  // kReleaseMode for release checks
  if (kReleaseMode) {
    // Initialize crash reporting, analytics, etc.
    initCrashlytics();
  }
}

// Compilation targets:
// flutter run                → JIT (debug, hot reload)
// flutter run --profile      → AOT (profiling, no hot reload, DevTools)
// flutter build apk          → AOT (release, optimized, tree-shaken)
// flutter build ios          → AOT (release, optimized)
// dart compile exe app.dart  → AOT native executable (server/CLI)
// dart run app.dart          → JIT (Dart scripts)
```

**Why it matters:** This explains why Flutter's development experience is fast AND why release apps are performant. The interviewer is testing whether you understand the compilation pipeline and can reason about what works in debug vs. release (e.g., `dart:mirrors` only in JIT, assertions stripped in AOT).

**Common mistake:** Thinking hot reload works in release builds — it requires the JIT compiler, which is stripped from release binaries. Also, testing performance in debug mode and drawing conclusions — debug mode includes the JIT overhead and is significantly slower than release. Always benchmark on release builds.

---

**Q:** What is the Dart VM? How does it execute Dart code, and what does "virtual machine" mean in the Dart context?

**A:** The Dart VM is the runtime environment that executes Dart code. But calling it a "virtual machine" is slightly misleading — it is not a traditional bytecode interpreter like the JVM. The Dart VM is a collection of components that work together to run Dart programs, and the way it executes code changes dramatically depending on the compilation mode.

**What the Dart VM actually contains:**

- **A runtime system**: Memory management (garbage collector), type system enforcement, isolate infrastructure, and native API bindings.
- **A JIT compiler** (in development mode): Parses Dart source into an intermediate representation called kernel binary (`.dill` format), then compiles it to native machine code on the fly during execution. The JIT can use runtime profiling data to optimize hot code paths — it may recompile a function multiple times as it learns which branches are taken most often.
- **An interpreter** (optional): The VM can interpret kernel binary directly without compiling to machine code. This is used in some debugging scenarios.
- **A debugger and profiler**: Provides the Dart Observatory / DevTools service protocol for breakpoints, stepping, heap inspection, and CPU profiling.

**In AOT mode**, the Dart VM is stripped down. There is no JIT compiler, no parser, no source-level tooling. What ships with your release Flutter app is a lean **Dart runtime** — essentially just the garbage collector, isolate support, and type checking infrastructure. The actual Dart code has already been compiled to native machine code by the AOT compiler at build time.

So "Dart VM" in practice means two things depending on context:
1. **During development**: A full-featured runtime with JIT compilation, debugging, and hot reload support.
2. **In production**: A minimal runtime that manages memory, isolates, and dispatches already-compiled native code.

**Example:**
```dart
// How Dart code flows through the VM:

// 1. SOURCE → KERNEL
//    Dart source (.dart) is parsed by the Common Front End (CFE)
//    into Kernel Binary (.dill) — a platform-independent AST format
//    dart compile kernel app.dart → produces app.dill

// 2a. KERNEL → JIT (development)
//    The VM loads the .dill, JIT compiles to native code on-the-fly
//    dart run app.dart  (internally: parse → kernel → JIT → execute)

// 2b. KERNEL → AOT (production)
//    The AOT compiler takes the .dill and compiles it to native code
//    before the app ever runs
//    dart compile exe app.dart  (internally: parse → kernel → AOT → native binary)

// You can actually inspect the kernel format:
// dart compile kernel app.dart    → produces app.dill
// dart run app.dill               → VM executes the kernel binary via JIT

// In Flutter:
// flutter run          → Full Dart VM with JIT (hot reload works)
// flutter build apk    → AOT compiler runs at build time,
//                         only the slim Dart runtime ships in the APK

// The runtime services available in both modes:
void main() {
  // Garbage collection — always available
  // (You don't call it directly, but you can observe it via DevTools)

  // Isolate infrastructure — always available
  Isolate.spawn(heavyWork, data);

  // Type checking — always available
  if (someVar is String) { /* runtime type check works in AOT too */ }

  // dart:mirrors — JIT ONLY, not available in AOT/Flutter
  // This is why reflection-based libraries don't work in Flutter release builds
}
```

**Why it matters:** This question reveals whether you understand what actually runs on a user's device. Interviewers ask this to distinguish candidates who know Flutter's runtime architecture from those who just write widgets. It also explains practical constraints — why `dart:mirrors` is unavailable in Flutter, why release builds are faster, and why hot reload is a development-only feature.

**Common mistake:** Describing the Dart VM as a bytecode interpreter like the JVM. It is not — in JIT mode, it compiles to native machine code (not bytecode interpretation), and in AOT mode, there is no "VM" running at all in the traditional sense, just a runtime. Another mistake is not knowing about the Kernel intermediate format (`.dill`) and thinking Dart compiles source code directly to machine code.

---

**Q:** Explain the Dart event loop. What are the microtask queue and event queue? How are `async`/`await` and Futures scheduled under the hood? Why is Dart single-threaded but non-blocking?

**A:** The Dart event loop is the core execution model. Every Dart isolate has exactly one thread and one event loop. The event loop continuously pulls tasks from two queues and executes them one at a time, to completion, before picking up the next task.

**The two queues:**

1. **Microtask queue** (high priority): Small, quick tasks that must run before the event loop processes the next event. Microtasks are typically internal continuations — for example, the resolution of a `Future` that completes synchronously, or tasks scheduled via `scheduleMicrotask()`. The event loop drains the entire microtask queue before looking at the event queue.

2. **Event queue** (normal priority): External events like I/O completions, timer callbacks (`Timer`, `Future.delayed`), UI events (taps, gestures), repaint signals, and messages from other isolates. These are processed one at a time, in order.

**The loop cycle:**
```
while (true) {
  while (microtaskQueue.isNotEmpty) {
    run(microtaskQueue.removeFirst());   // Drain ALL microtasks first
  }
  if (eventQueue.isNotEmpty) {
    run(eventQueue.removeFirst());       // Then process ONE event
  }
  // Repeat — check microtasks again after each event
}
```

**How `async`/`await` and Futures are scheduled:**

When a `Future` completes, its `.then()` callback is not run immediately — it is placed on the **microtask queue**. This means:
- `Future.value(42).then((v) => print(v))` schedules the print as a microtask, not synchronously.
- `await` suspends the function and registers a continuation. When the awaited Future completes, the continuation is enqueued as a microtask.
- `Future(() => work())` schedules `work()` on the **event queue** (not microtask).
- `Future.microtask(() => work())` explicitly schedules on the **microtask queue**.
- `Future.delayed(duration, callback)` creates a timer — the callback lands on the **event queue** when the timer fires.

**Why single-threaded but non-blocking:**

Dart delegates all blocking operations (network, file I/O, timers) to the operating system or a thread pool managed by the Dart runtime. Your Dart code never waits for I/O — it registers a callback and moves on. When the OS signals that data is ready, the runtime places the callback on the event queue. This is the same model Node.js uses.

**Example:**
```dart
import 'dart:async';

void main() {
  print('1: main start');

  // Scheduled on the EVENT queue
  Future(() => print('5: Future (event queue)'));

  // Scheduled on the MICROTASK queue
  Future.microtask(() => print('3: microtask'));

  // Also microtask — .then() on a completed future
  Future.value('done').then((_) => print('4: Future.value.then (microtask)'));

  // scheduleMicrotask — directly enqueues a microtask
  scheduleMicrotask(() => print('2: scheduleMicrotask'));

  print('1.5: main end');
}

// Output (deterministic):
// 1: main start
// 1.5: main end
// 2: scheduleMicrotask
// 3: microtask
// 4: Future.value.then (microtask)
// 5: Future (event queue)

// Explanation:
// - Synchronous code runs first (1, 1.5)
// - Then ALL microtasks drain (2, 3, 4) — in the order they were scheduled
// - Then the event queue is checked (5)

// Practical consequence — microtask flooding
void badIdea() {
  // If you keep scheduling microtasks endlessly, the event queue
  // (including UI repaints) NEVER gets processed → frozen app
  Future.microtask(() {
    Future.microtask(() {
      Future.microtask(() {
        // This starves the event queue
      });
    });
  });
}

// How await interacts with the event loop
Future<void> fetchData() async {
  print('A: before await');

  // At this point, fetchData() suspends.
  // The event loop is FREE to process other events (UI, timers).
  // When the HTTP response arrives (event queue), the continuation
  // is scheduled as a microtask.
  final data = await http.get(Uri.parse('https://api.example.com'));

  // This line runs as a microtask after the event loop picks up the
  // I/O completion event and the Future completes.
  print('B: after await — got ${data.statusCode}');
}

// Timer resolution and the event queue
Future<void> timerExample() async {
  print('start');

  await Future.delayed(Duration.zero); // Yields to event queue
  print('after zero-delay'); // Runs on next event loop iteration

  // Common pattern: yielding to let the UI repaint
  // between heavy synchronous chunks
  for (var i = 0; i < bigList.length; i++) {
    processItem(bigList[i]);
    if (i % 100 == 0) {
      await Future.delayed(Duration.zero); // Let UI breathe
    }
  }
}
```

**Why it matters:** This is the most important systems-level Dart question. Interviewers ask it to test whether you can debug timing bugs, understand why the UI freezes, and reason about the execution order of asynchronous code. If you understand the event loop, you can explain why `setState` after `await` might run on stale data, why heavy synchronous code causes jank, and how microtask flooding can lock up an app.

**Common mistake:** Saying microtasks and events are the same queue. They are not — microtasks have strict priority over events, and the entire microtask queue drains before each event. Another mistake is thinking `Future(() => ...)` and `Future.microtask(() => ...)` behave the same — they schedule on different queues with different priorities. The most dangerous mistake in practice is not realizing that an infinite chain of microtasks will starve the event queue and freeze the UI, because the event loop will never get past the microtask phase.

---

**Q:** How does Dart manage memory? Explain Dart's garbage collection, generational GC (new space vs. old space), and what triggers a GC cycle.

**A:** Dart uses automatic garbage collection (GC) to manage memory. You allocate objects freely, and the runtime reclaims memory when objects are no longer reachable. Dart's GC is specifically optimized for the Flutter use case — short-lived, widget-heavy object allocation patterns where many small objects are created every frame and die quickly.

**Generational hypothesis:** Most objects die young. A widget tree rebuild creates thousands of temporary objects (layout constraints, paint commands, short-lived closures) that become garbage almost immediately. Dart's GC exploits this by splitting the heap into two generations:

**1. New space (young generation):**
- A small, fixed-size memory area (typically a few MB).
- Uses a **semi-space** (copying) collector with two halves: "from space" and "to space."
- When new space fills up, the GC copies all surviving (reachable) objects from "from space" to "to space," then swaps the roles of the two halves. Unreachable objects are not copied — their memory is reclaimed instantly by the swap.
- This is extremely fast — cost is proportional to the number of **surviving** objects, not the total number of allocated objects. If most objects are dead (which they usually are), the GC does almost no work.
- Objects that survive multiple new-space collections are **promoted** to old space.

**2. Old space (old generation):**
- A larger memory region for long-lived objects (app state, singletons, cached data, images).
- Uses a **mark-sweep** (or mark-compact) collector. The GC traverses all reachable objects from root references (global variables, stack, isolate state), marks them as alive, then sweeps through memory and frees unmarked objects.
- Old-space GC is more expensive and runs less frequently.
- Dart's old-space collector can run **concurrently** — it does much of its work on a background thread, pausing the main thread only briefly for a final synchronization step. This minimizes UI jank.

**What triggers a GC cycle:**
- **New-space GC**: Triggers when the new space fills up. This happens frequently (potentially every frame) but is very fast (sub-millisecond typically).
- **Old-space GC**: Triggers based on memory pressure heuristics — when old space usage crosses a threshold relative to its total size, or when the system is under memory pressure. The runtime dynamically adjusts these thresholds.
- **Idle-time GC**: The Dart runtime is aware of the Flutter engine's frame schedule. It can perform GC work during idle time between frames, further reducing jank.
- The runtime may also trigger GC when an Isolate is paused or terminated.

**Example:**
```dart
// Understanding allocation patterns and GC impact

// GOOD: Short-lived objects — perfect for new-space GC
Widget build(BuildContext context) {
  // These objects are created every build, die immediately after layout/paint.
  // New-space GC handles this extremely efficiently.
  final padding = EdgeInsets.all(16.0);     // Short-lived
  final style = TextStyle(fontSize: 14);     // Short-lived
  return Padding(
    padding: padding,
    child: Text('Hello', style: style),
  );
}

// BETTER: const objects skip GC entirely — they live in read-only memory
Widget build(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),       // Compile-time constant, never GC'd
    child: Text('Hello', style: TextStyle(fontSize: 14)),
  );
}

// PROBLEMATIC: Large object churn promotes objects to old space unnecessarily
void processImages(List<Uint8List> images) {
  for (final image in images) {
    // Each iteration allocates large buffers that may survive
    // a new-space GC and get promoted to old space
    final processed = applyFilter(image);      // Large allocation
    final resized = resize(processed, 800);    // Another large allocation
    saveToCache(resized);
  }
  // The intermediate buffers are now in old space, requiring
  // a more expensive mark-sweep collection
}

// BETTER: Process in isolate — its entire heap is reclaimed when it exits
Future<void> processImages(List<Uint8List> images) async {
  await Isolate.run(() {
    for (final image in images) {
      final processed = applyFilter(image);
      final resized = resize(processed, 800);
      saveToCache(resized);
    }
    // When this isolate exits, ALL its memory is freed instantly
    // — no GC needed, the entire heap is discarded
  });
}

// Monitoring GC in DevTools:
// 1. Open Flutter DevTools → Memory tab
// 2. Watch for GC events (shown as vertical markers on the timeline)
// 3. Look for "GC jank" — pauses >16ms during old-space collection
//
// Key metrics to watch:
// - Dart heap used / allocated
// - Number of GC events per second
// - Old-space vs new-space collection frequency
// - External allocations (native memory via FFI, images)

// Common memory leak patterns that defeat GC:
class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _sub = someStream.listen((data) {
      setState(() { /* update UI */ });
    });
  }

  // FORGETTING THIS = memory leak
  // The subscription holds a reference to this State object,
  // preventing GC even after the widget is removed from the tree
  @override
  void dispose() {
    _sub.cancel(); // Always cancel subscriptions
    super.dispose();
  }
}
```

**Why it matters:** This question separates senior engineers from mid-level ones. Understanding GC explains why `const` constructors matter (they skip allocation entirely), why Isolates are useful for memory-heavy work (their heap is freed in bulk), and why uncancelled streams cause leaks. Interviewers want to know you can diagnose and prevent memory issues in production Flutter apps using DevTools.

**Common mistake:** Saying Dart uses reference counting — it does not; it uses tracing garbage collection. Another mistake is not understanding why `const` widgets help performance — they are canonicalized and never need to be collected. The most practical mistake is ignoring `dispose()` in StatefulWidgets, leaving dangling references (stream subscriptions, animation controllers, focus nodes) that prevent the GC from reclaiming entire widget subtrees.
