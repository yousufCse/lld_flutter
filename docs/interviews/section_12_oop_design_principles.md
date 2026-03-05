# Section 12: OOP & Design Principles

---

**Q:** What are the four pillars of Object-Oriented Programming? Give a brief definition and Dart example for each.

**A:**
The four pillars are **Encapsulation**, **Abstraction**, **Inheritance**, and **Polymorphism**. Together they give you a way to model real-world concepts in code that is maintainable, reusable, and extensible.

```
┌─────────────────────────────────────────────────┐
│              Four Pillars of OOP                │
├────────────────┬────────────────────────────────┤
│ Encapsulation  │ Hide internal state, expose API │
│ Abstraction    │ Hide complexity, show interface │
│ Inheritance    │ Reuse behaviour from a parent   │
│ Polymorphism   │ Same interface, different forms │
└────────────────┴────────────────────────────────┘
```

**Example:**
```dart
// ── Encapsulation ──────────────────────────────────────────
class BankAccount {
  double _balance = 0; // private field

  void deposit(double amount) {
    if (amount > 0) _balance += amount;
  }

  double get balance => _balance; // controlled read access
}

// ── Abstraction ────────────────────────────────────────────
abstract class Shape {
  double area(); // callers don't care HOW it's calculated
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;
}

// ── Inheritance ────────────────────────────────────────────
class Animal {
  void breathe() => print('Breathing...');
}

class Dog extends Animal {
  void bark() => print('Woof!');
}

// ── Polymorphism ───────────────────────────────────────────
class Cat extends Animal {
  void speak() => print('Meow');
}

class Parrot extends Animal {
  void speak() => print('Hello!');
}

void makeSpeak(dynamic animal) => animal.speak();
// makeSpeak(Cat()) → "Meow"
// makeSpeak(Parrot()) → "Hello!"
```

**Why it matters:** Interviewers want to know you understand the *purpose* of each pillar — not just their names. Expect follow-up questions drilling into each one.

**Common mistake:** Candidates list the four pillars but define them vaguely (e.g., "inheritance is when a class inherits from another class"). You must explain the *why* — what problem each pillar solves.

---

**Q:** Explain Encapsulation in Dart. How do you implement it and why does it matter?

**A:**
Encapsulation means **bundling data (fields) and the behaviour that operates on that data (methods) together inside a class, and restricting direct access to the internal state**.

In Dart, privacy is **file-level**: any identifier prefixed with `_` is private to the **library** (the file). There are no `private` or `protected` keywords.

You control access through **getters** and **setters**, which let you validate, compute, or restrict what can be read or written.

```
  External Code
       │
       ▼
  ┌──────────────────────┐
  │  Public API          │  ← getter / setter / methods
  │  ┌────────────────┐  │
  │  │  _privateField │  │  ← hidden internal state
  │  └────────────────┘  │
  └──────────────────────┘
```

**Example:**
```dart
class Temperature {
  double _celsius; // private — direct access blocked outside this file

  Temperature(this._celsius);

  // Getter — read-only computed property
  double get fahrenheit => _celsius * 9 / 5 + 32;

  // Getter for celsius
  double get celsius => _celsius;

  // Setter — with validation
  set celsius(double value) {
    if (value < -273.15) {
      throw ArgumentError('Temperature below absolute zero is not possible.');
    }
    _celsius = value;
  }
}

void main() {
  final temp = Temperature(25);
  print(temp.fahrenheit); // 77.0

  temp.celsius = 100;
  print(temp.celsius); // 100

  temp.celsius = -300; // throws ArgumentError ✓
}
```

**Why it matters:** Encapsulation protects the integrity of your object's state. If you expose `_celsius` directly, any caller can set it to `-1000` and break your invariants. The setter is the single gate that enforces the rule.

**Common mistake:** Thinking Dart's `_` prefix makes a field private to the *class* (like Java). It's private to the *file/library*. Two classes in the same file can access each other's `_` members — which is rarely what you want, so keep one class per file.

---

**Q:** How does Inheritance work in Dart? Explain `extends`, `super`, `@override`, and when to use them.

**A:**
Inheritance lets a **child class (subclass)** reuse and extend the behaviour of a **parent class (superclass)**. In Dart you use `extends`. Dart supports **single inheritance** only — a class can extend exactly one parent.

- `extends` — declares the parent class  
- `super` — refers to the parent class (to call its constructor or methods)  
- `@override` — annotation that tells the compiler "I'm intentionally replacing a parent method" — it's not mandatory but strongly recommended as a safety net

```
       Animal
      /      \
    Dog      Cat       ← single inheritance; each extends Animal
```

**Example:**
```dart
class Animal {
  final String name;

  Animal(this.name);

  void speak() => print('$name makes a sound.');

  void breathe() => print('$name is breathing.');
}

class Dog extends Animal {
  final String breed;

  // Call parent constructor via super
  Dog(String name, this.breed) : super(name);

  @override
  void speak() {
    super.speak(); // optionally call parent's version first
    print('$name says: Woof!');
  }
}

class GoldenRetriever extends Dog {
  GoldenRetriever(String name) : super(name, 'Golden Retriever');

  @override
  void speak() => print('$name says: Woof woof! (friendly)');
}

void main() {
  final dog = GoldenRetriever('Buddy');
  dog.speak();   // Buddy says: Woof woof! (friendly)
  dog.breathe(); // Buddy is breathing. — inherited from Animal
}
```

**Why it matters:** Interviewers test whether you know Dart's single-inheritance constraint and whether you understand `super` chaining in multi-level hierarchies.

**Common mistake:** Forgetting to call `super(...)` in the child constructor when the parent has a required positional parameter. This is a compile error, but candidates often get confused about named vs positional super calls.

---

**Q:** What is Polymorphism in Dart? Explain compile-time vs runtime polymorphism — and how Dart handles method overloading.

**A:**
**Polymorphism** means "many forms" — the same interface behaves differently depending on the actual object type at runtime.

```
         Shape (abstract)
        /       |       \
   Circle   Rectangle  Triangle
    area()   area()     area()
      ↕         ↕          ↕
  different implementations, same method name
```

**Two types:**

| Type | Also called | Dart support |
|---|---|---|
| Compile-time | Static dispatch / Method overloading | ❌ Not natively supported |
| Runtime | Dynamic dispatch / Method overriding | ✅ Fully supported |

**Runtime Polymorphism (Dart natively supports this):**
```dart
abstract class Shape {
  double area();
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
  @override
  double area() => 3.14159 * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);
  @override
  double area() => width * height;
}

void printArea(Shape shape) {
  // At runtime, Dart dispatches to the correct area()
  print('Area: ${shape.area()}');
}

void main() {
  printArea(Circle(5));       // Area: 78.53...
  printArea(Rectangle(4, 6)); // Area: 24.0
}
```

**Method Overloading workaround in Dart:**

Dart does NOT support method overloading (same method name, different parameter types/counts). You work around it using **optional parameters** or **named constructors**:

```dart
class Logger {
  // Workaround: optional/named parameters instead of overloading
  void log(String message, {String level = 'INFO', bool timestamp = false}) {
    final prefix = timestamp ? '[${DateTime.now()}] ' : '';
    print('$prefix[$level] $message');
  }
}

void main() {
  final logger = Logger();
  logger.log('App started');
  logger.log('Error occurred', level: 'ERROR', timestamp: true);
}
```

**Why it matters:** Many candidates claim Dart supports method overloading — it doesn't. The interviewer is probing whether you *actually* know Dart versus speaking generically about OOP.

**Common mistake:** Saying "Dart supports method overloading like Java." It does not. Be explicit: Dart only supports runtime polymorphism through method overriding, and uses optional/named parameters to simulate overloading behaviour.

---

**Q:** What is Abstraction? Explain the difference between `abstract class` and using `implements` as an interface in Dart.

**A:**
**Abstraction** means exposing *what* an object does without revealing *how* it does it. You define a contract — the method signatures — and leave the implementation to the subclasses.

In Dart there is **no `interface` keyword**. Every class implicitly defines an interface. You use:

- `abstract class` — to define a partially or fully abstract type; can have concrete methods and fields
- `implements` — to force a class to provide its own implementation for *every* member of the target class/abstract class
- `extends` — to inherit and optionally override

```
┌──────────────────────────────────────────────────────┐
│  abstract class (contract + optional implementation) │
│  ┌────────────────┐   ┌──────────────────────────┐  │
│  │ abstract void  │   │ concrete void helper() { │  │
│  │ doWork();      │   │   // shared logic         │  │
│  └────────────────┘   └──────────────────────────┘  │
└──────────────────────────────────────────────────────┘

   extends → inherits concrete methods + must implement abstracts
   implements → must implement EVERYTHING (no free methods)
```

**Example:**
```dart
// Abstract class — can mix concrete + abstract members
abstract class PaymentProcessor {
  String get providerName; // abstract getter

  void validateCard(String cardNumber); // abstract method

  // Concrete method shared by all subclasses
  void logTransaction(double amount) {
    print('[$providerName] Processing \$$amount');
  }
}

class StripeProcessor extends PaymentProcessor {
  @override
  String get providerName => 'Stripe';

  @override
  void validateCard(String cardNumber) {
    print('Stripe validating: $cardNumber');
  }
}

// Using implements — must implement EVERYTHING yourself
class MockProcessor implements PaymentProcessor {
  @override
  String get providerName => 'Mock';

  @override
  void validateCard(String cardNumber) => print('Mock validate');

  @override
  void logTransaction(double amount) => print('Mock log: \$$amount');
  // Notice: you don't get logTransaction for free — must rewrite it
}
```

**Why it matters:** Understanding the difference between `extends` and `implements` is a favourite Dart-specific interview question. It reveals whether you truly understand Dart's type system versus copying Java mental models.

**Common mistake:** Assuming `implements` gives you the parent's concrete methods for free. It doesn't — you must implement every single member. Use `extends` when you want shared implementation; use `implements` when you only want the contract.

---

**Q:** What is "Composition over Inheritance"? When should you prefer it and why?

**A:**
**Composition over inheritance** means building complex behaviour by **combining simpler objects** (has-a relationship) rather than extending a class hierarchy (is-a relationship).

The problem with deep inheritance:
```
Vehicle
  └── MotorVehicle
        └── Car
              └── ElectricCar
                    └── ElectricSportsCar  ← fragile, hard to change
```

If `Vehicle` changes, the entire chain breaks. With composition, you plug in only what you need:

```
ElectricSportsCar
  ├── has-a: Engine (electric)
  ├── has-a: Battery
  └── has-a: SportsMode
```

**Example:**
```dart
// ── Behaviour classes (composable units) ───────────────────
class Logger {
  void log(String msg) => print('[LOG] $msg');
}

class NetworkService {
  Future<String> fetch(String url) async {
    return 'data from $url';
  }
}

class CacheService {
  final _cache = <String, String>{};

  void store(String key, String value) => _cache[key] = value;
  String? retrieve(String key) => _cache[key];
}

// ── Composed class — no inheritance needed ──────────────────
class UserRepository {
  final NetworkService _network;
  final CacheService _cache;
  final Logger _logger;

  // Dependencies are injected — easy to swap in tests
  UserRepository({
    required NetworkService network,
    required CacheService cache,
    required Logger logger,
  })  : _network = network,
        _cache = cache,
        _logger = logger;

  Future<String> getUser(String id) async {
    final cached = _cache.retrieve(id);
    if (cached != null) {
      _logger.log('Cache hit for $id');
      return cached;
    }
    _logger.log('Fetching user $id');
    final data = await _network.fetch('https://api.example.com/users/$id');
    _cache.store(id, data);
    return data;
  }
}
```

**Prefer Composition when:**
- Behaviour needs to change at runtime
- You want to reuse behaviour across unrelated class hierarchies
- The relationship is "has-a" not "is-a"
- You want easier unit testing (inject mocks)

**Prefer Inheritance when:**
- There is a genuine "is-a" relationship (a `Dog` IS-A `Animal`)
- You want to share and reuse implementation cleanly
- The hierarchy is shallow and stable

**Why it matters:** This is a senior-level design question. Interviewers want to see that you don't reach for inheritance by default — that you consciously choose based on the problem.

**Common mistake:** Building a 4-level inheritance chain when three separate composable classes would have been cleaner, more testable, and more flexible.

---

**Q:** What is the difference between Mixins, Abstract Classes, and Interfaces in Dart? When do you use each?

**A:**

```
┌──────────────────┬────────────────────────────────────────────────┐
│ Tool             │ Best used for                                  │
├──────────────────┼────────────────────────────────────────────────┤
│ abstract class   │ Shared base + partial implementation           │
│ mixin            │ Reusable behaviour injected into any class     │
│ implements       │ Enforcing a contract with no shared code       │
└──────────────────┴────────────────────────────────────────────────┘
```

**Example:**
```dart
// ── Abstract class — shared base with some implementation ───
abstract class Animal {
  String get name;
  void breathe() => print('$name is breathing'); // concrete
  void speak(); // abstract — subclass must implement
}

// ── Mixin — reusable behaviour, not a base class ────────────
mixin Swimmable {
  void swim() => print('$runtimeType is swimming');
}

mixin Flyable {
  void fly() => print('$runtimeType is flying');
}

// ── Concrete classes ────────────────────────────────────────
class Duck extends Animal with Swimmable, Flyable {
  @override
  String get name => 'Duck';

  @override
  void speak() => print('Quack!');
}

class Fish extends Animal with Swimmable {
  @override
  String get name => 'Fish';

  @override
  void speak() => print('...');
}

// ── implements — pure contract, no shared code ───────────────
abstract class Serializable {
  Map<String, dynamic> toJson();
  String toJsonString();
}

class User implements Serializable {
  final String name;
  final int age;
  User(this.name, this.age);

  @override
  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  @override
  String toJsonString() => toJson().toString();
}

void main() {
  final duck = Duck();
  duck.speak();   // Quack!
  duck.swim();    // Duck is swimming
  duck.fly();     // Duck is flying
  duck.breathe(); // Duck is breathing — from Animal
}
```

**Decision guide:**

| Scenario | Use |
|---|---|
| Share implementation between related types | `abstract class` + `extends` |
| Add reusable capability to unrelated classes | `mixin` |
| Define a contract without sharing code | `implements` |
| A class needs multiple unrelated behaviours | `mixin` (can apply many) |

**Why it matters:** Dart's mixin system is unique and powerful. Interviewers who work with Flutter expect you to know this because mixins appear throughout the Flutter SDK (e.g., `ChangeNotifier`, `TickerProviderStateMixin`).

**Common mistake:** Using `abstract class` as an interface AND trying to mix in multiple of them with `extends` — Dart only allows one `extends`. Mixins exist precisely to solve this.

---

**Q:** What are the different constructor types in Dart? Explain default, named, factory, and const constructors.

**A:**

```
┌─────────────────┬──────────────────────────────────────────────┐
│ Constructor     │ Purpose                                      │
├─────────────────┼──────────────────────────────────────────────┤
│ Default         │ Basic instantiation                          │
│ Named           │ Multiple creation paths with clear intent    │
│ factory         │ Custom creation logic, caching, subtypes     │
│ const           │ Compile-time constant, immutable instances   │
└─────────────────┴──────────────────────────────────────────────┘
```

**Example:**
```dart
class Color {
  final int r, g, b;

  // ── Default constructor ─────────────────────────────────
  Color(this.r, this.g, this.b);

  // ── Named constructors — multiple creation paths ────────
  Color.red() : this(255, 0, 0);
  Color.green() : this(0, 255, 0);
  Color.fromHex(String hex)
      : r = int.parse(hex.substring(1, 3), radix: 16),
        g = int.parse(hex.substring(3, 5), radix: 16),
        b = int.parse(hex.substring(5, 7), radix: 16);

  // ── const constructor — compile-time constant ───────────
  // All fields must be final for this to work
  const Color.white() : r = 255, g = 255, b = 255;

  @override
  String toString() => 'Color($r, $g, $b)';
}

// ── factory constructor — custom logic / caching ────────────
class DatabaseConnection {
  static DatabaseConnection? _instance;

  final String host;

  DatabaseConnection._(this.host); // private named constructor

  factory DatabaseConnection(String host) {
    // Return cached instance (Singleton pattern)
    _instance ??= DatabaseConnection._(host);
    return _instance!;
  }
}

// ── factory returning a subtype ─────────────────────────────
abstract class Logger {
  factory Logger(String type) {
    if (type == 'file') return FileLogger();
    return ConsoleLogger();
  }
  void log(String message);
}

class ConsoleLogger implements Logger {
  @override
  void log(String message) => print('[CONSOLE] $message');
}

class FileLogger implements Logger {
  @override
  void log(String message) => print('[FILE] $message');
}

void main() {
  final c1 = Color.fromHex('#FF5733');
  print(c1); // Color(255, 87, 51)

  const white = Color.white(); // compile-time constant
  const white2 = Color.white();
  print(identical(white, white2)); // true — same object in memory

  final db1 = DatabaseConnection('localhost');
  final db2 = DatabaseConnection('localhost');
  print(identical(db1, db2)); // true — singleton via factory

  final logger = Logger('file');
  logger.log('test'); // [FILE] test
}
```

**Why it matters:** Factory constructors are used everywhere in Flutter (e.g., `TextStyle`, JSON deserialization). `const` constructors are critical for Flutter performance — they allow the widget tree to skip rebuilds.

**Common mistake:** Thinking `factory` constructors always create a new object. They don't — that's the whole point. A factory can return a cached instance, call a private constructor, or return a subtype. Also: a `const` constructor does NOT guarantee the result is const — the *call site* must use the `const` keyword.

---

**Q:** When and why should you use `static` members in Dart?

**A:**
A `static` member belongs to the **class itself**, not to any instance. All instances share the same static field, and static methods can be called without creating an object.

```
                 MyClass (class level)
                 ┌──────────────────┐
                 │ static int count │  ← shared by ALL instances
                 │ static void reset│
                 └──────────────────┘
                    ↑        ↑
              obj1            obj2  ← both see the same count
```

**Example:**
```dart
class AppConfig {
  // ── Static field — shared application-wide constant ─────
  static const String appName = 'MyFlutterApp';
  static const String version = '2.1.0';

  // ── Static mutable counter — shared state ───────────────
  static int _instanceCount = 0;

  final String userId;

  AppConfig(this.userId) {
    _instanceCount++;
  }

  static int get instanceCount => _instanceCount;

  // ── Static utility method — no instance needed ──────────
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

void main() {
  print(AppConfig.appName);   // MyFlutterApp — no instance needed
  print(AppConfig.isValidEmail('test@example.com')); // true

  AppConfig('user_1');
  AppConfig('user_2');
  print(AppConfig.instanceCount); // 2
}
```

**When to use `static`:**
- Constants shared across all instances (`static const`)
- Utility/helper functions that don't depend on instance state
- Counters, caches, or singleton-style shared state
- Factory-style named constructors (rarely — usually use `factory` instead)

**When NOT to use `static`:**
- When the value differs per instance (use instance fields)
- When you need polymorphism (static methods can't be overridden)
- When it creates hidden global mutable state (makes testing hard)

**Why it matters:** Overuse of `static` mutable state is a code smell that breaks testability. Interviewers want to see that you use `static` deliberately.

**Common mistake:** Using `static` for everything to avoid passing objects around — this creates tightly coupled, hard-to-test code. Prefer dependency injection over static singletons.

---

**Q:** What is covariance and contravariance in Dart? Give a simple explanation.

**A:**
These terms describe how **type relationships between generics** relate to the type relationships of the types they contain.

- **Covariance**: If `Dog extends Animal`, then `List<Dog>` can be treated as `List<Animal>`. You're allowing a *more specific* type where a *more general* one is expected. (Safe for reading, unsafe for writing.)
- **Contravariance**: The reverse — a consumer of `Animal` can be used where a consumer of `Dog` is expected. (Safe for writing/consuming.)

In Dart, **generic types are covariant by default** for class types:

```dart
class Animal {}
class Dog extends Animal {}

void processAnimals(List<Animal> animals) {
  print(animals.length);
}

void main() {
  List<Dog> dogs = [Dog(), Dog()];

  // Dart allows this (covariance) — List<Dog> is a subtype of List<Animal>
  processAnimals(dogs); // ✓ works at runtime

  // But this is UNSOUND — if you add inside:
  // animals.add(Animal()) — that's adding an Animal to a List<Dog>!
  // Dart allows this but throws a runtime CastError if you mutate
}
```

**Covariant keyword — opt-in for parameters:**
```dart
class Repository<T extends Animal> {
  // Without covariant: Dog repo can't be passed where Animal repo is expected
  void process(covariant T animal) {
    print('Processing $animal');
  }
}

// With covariant, Dart relaxes the type check at compile time
// and enforces it at runtime
```

**Why it matters:** This is an advanced question. Interviewers ask it to gauge depth of type-system understanding, particularly important when working with generics in state management or repositories.

**Common mistake:** Confusing covariance with "it's safe to pass a subtype anywhere." Covariance is safe for *producers* (reading from a list) but unsafe for *consumers* (writing to a list) — hence Dart's runtime checks.

---

**Q:** What is the difference between method overriding and method hiding in Dart?

**A:**

| | Method Overriding | Method Hiding |
|---|---|---|
| How | `@override` in subclass | Dart doesn't support it directly |
| Dispatch | Runtime (dynamic) | Compile-time (static) |
| Polymorphism | ✅ Yes | ❌ No |
| Dart support | ✅ Full | ⚠️ Via `static` methods only |

**Method Overriding — runtime dispatch:**
```dart
class Animal {
  void speak() => print('Animal speaks');
}

class Dog extends Animal {
  @override
  void speak() => print('Dog barks');
}

void main() {
  Animal a = Dog(); // reference type is Animal, actual type is Dog
  a.speak(); // "Dog barks" — runtime dispatch uses actual type ✓
}
```

**Method Hiding — compile-time (static methods only):**

In Dart, **static methods cannot be overridden** — they are resolved at compile-time based on the reference type:
```dart
class Parent {
  static void greet() => print('Hello from Parent');
}

class Child extends Parent {
  // This does NOT override — it HIDES the parent's static method
  static void greet() => print('Hello from Child');
}

void main() {
  Parent.greet(); // Hello from Parent
  Child.greet();  // Hello from Child

  // No polymorphism — the call is resolved by the class name, not runtime type
}
```

**Key rule in Dart:** Instance methods support overriding (runtime polymorphism). Static methods support hiding only (no polymorphism).

**Why it matters:** Understanding method hiding helps explain why static methods break polymorphism and why you should avoid overdesigning with statics.

**Common mistake:** Assuming you can override a static method with `@override`. Dart will give a compile error — `@override` only applies to instance members.

---

**Q:** What is the difference between a class, an object, and an instance?

**A:**

```
┌───────────────────────────────────────────────────────────┐
│  CLASS = Blueprint / Template                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  fields, methods, constructors (defined once)       │  │
│  └─────────────────────────────────────────────────────┘  │
└───────────────────────┬───────────────────────────────────┘
                        │  instantiation
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
      object 1      object 2      object 3   ← INSTANCES (objects)
   name: "Alice"  name: "Bob"  name: "Carol"
```

- **Class** — The definition/blueprint. Exists at compile time. Describes what data and behaviour objects of that type will have.
- **Object** — A generic term for any entity created from a class. Often used interchangeably with "instance."
- **Instance** — A specific, concrete occurrence of a class in memory at runtime. Each instance has its own copy of instance fields.

**Example:**
```dart
// CLASS — the blueprint
class Car {
  String brand;
  int year;

  Car(this.brand, this.year);

  void describe() => print('$brand ($year)');
}

void main() {
  // INSTANCES (objects) — two separate allocations in memory
  final car1 = Car('Toyota', 2020); // instance 1
  final car2 = Car('Honda', 2022);  // instance 2

  car1.describe(); // Toyota (2020)
  car2.describe(); // Honda (2022)

  print(identical(car1, car2)); // false — different instances
}
```

**Why it matters:** This is a foundational question. A stumbled answer signals weak OOP fundamentals. The key distinction to emphasise: a class is a *definition*, an instance is a *living object in memory*.

**Common mistake:** Saying "object and instance are different things." In most practical contexts they mean the same thing. The distinction is that *object* is the broader term (all instances are objects; in Dart everything is an object, including `int`), while *instance* specifically refers to an object created from a class.

---

**Q:** What is coupling and cohesion? Why is low coupling and high cohesion the goal in software design?

**A:**

**Cohesion** — how *closely related* the responsibilities inside a single class/module are.  
**Coupling** — how *dependent* classes/modules are on each other.

```
HIGH COHESION (good)          LOW COHESION (bad)
┌──────────────────┐          ┌──────────────────────────┐
│   OrderService   │          │   GodClass               │
│  - placeOrder()  │          │  - saveUser()            │
│  - cancelOrder() │          │  - sendEmail()           │
│  - getStatus()   │          │  - processPayment()      │
│  (all: orders)   │          │  - renderUI()            │
└──────────────────┘          │  (everything in one!)    │
                              └──────────────────────────┘

LOW COUPLING (good)           HIGH COUPLING (bad)
┌──────────┐                  ┌──────────┐
│ ClassA   │──interface──▶│B│ │ ClassA   │──directly──▶ ClassB._field
└──────────┘                  └──────────┘  ──────────▶ ClassB._method
```

**Example:**
```dart
// ── High coupling — bad ────────────────────────────────────
class OrderService {
  // Directly creates its own database connection — tightly coupled
  final db = MySQLDatabase('localhost', 'orders_db');

  void placeOrder(String item) {
    db.execute('INSERT INTO orders VALUES ("$item")');
  }
}
// Changing the database means changing OrderService — ripple effect

// ── Low coupling + High cohesion — good ───────────────────
abstract class Database {
  void execute(String query);
}

class OrderService {
  final Database _db; // depends on abstraction, not concrete class

  OrderService(this._db); // injected from outside

  void placeOrder(String item) {
    _db.execute('INSERT INTO orders VALUES ("$item")');
  }

  void cancelOrder(String id) {
    _db.execute('DELETE FROM orders WHERE id = "$id"');
  }
}
// OrderService only knows about orders — high cohesion
// It depends on an interface — low coupling
// Swapping MySQL for SQLite requires zero changes here
```

**Why these matter:**

| Goal | Benefit |
|---|---|
| High cohesion | Easier to understand, maintain, test |
| Low coupling | Easier to change, replace, or reuse parts independently |

**Why it matters:** This is a design maturity question. Senior engineers talk naturally about cohesion and coupling. It's the conceptual foundation of SOLID principles.

**Common mistake:** Confusing them — "high cohesion means classes are closely connected to each other." No. Cohesion is about internal relatedness *within* a module. Coupling is about external dependencies *between* modules. High cohesion within, low coupling between.

---

**Q:** Explain the SOLID principles with a Dart example for each.

**A:**

```
S — Single Responsibility Principle
O — Open/Closed Principle
L — Liskov Substitution Principle
I — Interface Segregation Principle
D — Dependency Inversion Principle
```

---

### S — Single Responsibility Principle
*A class should have only one reason to change.*

```dart
// ❌ Violates SRP — UserService does too many things
class UserService {
  void createUser(String name) { /* DB logic */ }
  void sendWelcomeEmail(String email) { /* Email logic */ }
  void logUserCreation(String name) { /* Logging logic */ }
}

// ✅ Each class has one job
class UserRepository {
  void create(String name) => print('Saving $name to DB');
}

class EmailService {
  void sendWelcome(String email) => print('Sending email to $email');
}

class UserLogger {
  void logCreation(String name) => print('User created: $name');
}

class UserService {
  final UserRepository _repo;
  final EmailService _email;
  final UserLogger _logger;

  UserService(this._repo, this._email, this._logger);

  void createUser(String name, String email) {
    _repo.create(name);
    _email.sendWelcome(email);
    _logger.logCreation(name);
  }
}
```

---

### O — Open/Closed Principle
*Classes should be open for extension, closed for modification.*

```dart
// ❌ Violates OCP — adding a new payment type requires modifying this class
class PaymentProcessor {
  void process(String type, double amount) {
    if (type == 'credit') {
      print('Credit card: \$$amount');
    } else if (type == 'paypal') {
      print('PayPal: \$$amount');
    }
    // Adding crypto means editing this method — risky
  }
}

// ✅ OCP compliant — extend by adding new classes, not modifying existing ones
abstract class PaymentMethod {
  void process(double amount);
}

class CreditCardPayment implements PaymentMethod {
  @override
  void process(double amount) => print('Credit card: \$$amount');
}

class PayPalPayment implements PaymentMethod {
  @override
  void process(double amount) => print('PayPal: \$$amount');
}

class CryptoPayment implements PaymentMethod {
  @override
  void process(double amount) => print('Crypto: \$$amount');
  // No existing code changed ✓
}

class Checkout {
  void complete(PaymentMethod method, double amount) {
    method.process(amount);
  }
}
```

---

### L — Liskov Substitution Principle
*Subtypes must be substitutable for their base types without breaking the program.*

```dart
// ❌ Violates LSP — Square breaks the Rectangle contract
class Rectangle {
  double width;
  double height;
  Rectangle(this.width, this.height);
  double get area => width * height;
}

class Square extends Rectangle {
  Square(double side) : super(side, side);

  @override
  set width(double value) {
    super.width = value;
    super.height = value; // Forces height to match — breaks Rectangle logic
  }
}

void resize(Rectangle r) {
  r.width = 10;
  r.height = 5;
  // Caller expects area = 50; Square gives 25 — LSP violated
  print(r.area);
}

// ✅ LSP compliant — separate shapes, common abstraction
abstract class Shape {
  double get area;
}

class LSPRectangle implements Shape {
  final double width, height;
  LSPRectangle(this.width, this.height);
  @override
  double get area => width * height;
}

class LSPSquare implements Shape {
  final double side;
  LSPSquare(this.side);
  @override
  double get area => side * side;
}
```

---

### I — Interface Segregation Principle
*Clients should not be forced to depend on interfaces they don't use.*

```dart
// ❌ Violates ISP — one fat interface forces all implementors to implement everything
abstract class Worker {
  void work();
  void eat();
  void sleep();
}

class Robot implements Worker {
  @override void work() => print('Robot working');
  @override void eat() => throw UnimplementedError('Robots don\'t eat'); // ❌
  @override void sleep() => throw UnimplementedError('Robots don\'t sleep'); // ❌
}

// ✅ ISP compliant — split into focused interfaces
abstract class Workable {
  void work();
}

abstract class Eatable {
  void eat();
}

abstract class Sleepable {
  void sleep();
}

class Human implements Workable, Eatable, Sleepable {
  @override void work() => print('Human working');
  @override void eat() => print('Human eating');
  @override void sleep() => print('Human sleeping');
}

class ISPRobot implements Workable {
  @override void work() => print('Robot working'); // only what it needs ✓
}
```

---

### D — Dependency Inversion Principle
*High-level modules should not depend on low-level modules. Both should depend on abstractions.*

```dart
// ❌ Violates DIP — high-level class directly depends on low-level class
class MySQLDatabase {
  void save(String data) => print('Saving to MySQL: $data');
}

class UserServiceBad {
  final db = MySQLDatabase(); // tightly coupled to MySQL — can't swap
  void save(String name) => db.save(name);
}

// ✅ DIP compliant — both depend on an abstraction
abstract class DataStore {
  void save(String data);
}

class MySQLStore implements DataStore {
  @override
  void save(String data) => print('MySQL: $data');
}

class InMemoryStore implements DataStore {
  final _data = <String>[];
  @override
  void save(String data) => _data.add(data);
}

class UserServiceGood {
  final DataStore _store; // depends on abstraction ✓

  UserServiceGood(this._store); // injected from outside

  void save(String name) => _store.save(name);
}

void main() {
  // Production
  final prodService = UserServiceGood(MySQLStore());
  prodService.save('Alice');

  // Testing — swap with no code changes
  final testService = UserServiceGood(InMemoryStore());
  testService.save('Bob');
}
```

**Why it matters:** SOLID is the most common design principle topic in senior Flutter interviews. Knowing the names is not enough — you must show concrete code and explain *what problem each principle solves*.

**Common mistake:** Memorising acronyms but giving abstract definitions. Always anchor each principle to a concrete problem it fixes. Also: candidates often confuse ISP and SRP — SRP is about classes having one reason to change; ISP is about interfaces not having methods callers don't need.

---

**Q:** What is the DRY principle? Show a Dart example of a violation and how to fix it.

**A:**
**DRY — Don't Repeat Yourself.** Every piece of knowledge or logic should have a *single, authoritative representation* in the codebase. When logic is duplicated, a bug fix or change must be applied in multiple places — easy to forget one and create inconsistencies.

**Example:**
```dart
// ❌ DRY violation — discount logic duplicated in two places
class OnlineOrder {
  double subtotal;
  bool isPremiumMember;
  OnlineOrder(this.subtotal, this.isPremiumMember);

  double get total {
    double discount = 0;
    if (isPremiumMember) discount = subtotal * 0.1;
    if (subtotal > 100) discount += subtotal * 0.05;
    return subtotal - discount;
  }
}

class InStoreOrder {
  double subtotal;
  bool isPremiumMember;
  InStoreOrder(this.subtotal, this.isPremiumMember);

  double get total {
    // Exact same discount logic duplicated ❌
    double discount = 0;
    if (isPremiumMember) discount = subtotal * 0.1;
    if (subtotal > 100) discount += subtotal * 0.05;
    return subtotal - discount;
  }
}

// ✅ DRY fix — extract the shared logic into one place
double calculateDiscount(double subtotal, bool isPremiumMember) {
  double discount = 0;
  if (isPremiumMember) discount = subtotal * 0.1;
  if (subtotal > 100) discount += subtotal * 0.05;
  return discount;
}

class DryOnlineOrder {
  final double subtotal;
  final bool isPremiumMember;
  DryOnlineOrder(this.subtotal, this.isPremiumMember);

  double get total => subtotal - calculateDiscount(subtotal, isPremiumMember);
}

class DryInStoreOrder {
  final double subtotal;
  final bool isPremiumMember;
  DryInStoreOrder(this.subtotal, this.isPremiumMember);

  double get total => subtotal - calculateDiscount(subtotal, isPremiumMember);
}
// Now change the discount rule in ONE place — both order types benefit ✓
```

**Why it matters:** DRY is about *maintainability*. A codebase with lots of duplication is expensive to change correctly. Interviewers look for this in code review-style questions.

**Common mistake:** Over-applying DRY to produce premature abstractions. If two pieces of code *look* the same but represent *different business rules* that will evolve independently, duplicating them is intentional and correct. DRY is about *knowledge* duplication, not *syntactic* duplication.

---

**Q:** What is the KISS principle? Show a code example.

**A:**
**KISS — Keep It Simple, Stupid.** Prefer the simplest solution that correctly solves the problem. Complexity is a cost — it makes code harder to read, test, maintain, and debug.

**Example:**
```dart
// ❌ Over-engineered — unnecessary abstraction for a simple task
abstract class StringTransformer {
  String transform(String input);
}

class UpperCaseTransformerStrategy implements StringTransformer {
  @override
  String transform(String input) => input.toUpperCase();
}

class StringTransformerFactory {
  StringTransformer create(String type) {
    if (type == 'upper') return UpperCaseTransformerStrategy();
    throw Exception('Unknown transformer');
  }
}

void printUppercase(String text) {
  final factory = StringTransformerFactory();
  final transformer = factory.create('upper');
  print(transformer.transform(text));
}
// 20 lines for: text.toUpperCase()

// ✅ KISS — straightforward and clear
void printUppercaseKiss(String text) {
  print(text.toUpperCase());
}

// ── More realistic KISS example ─────────────────────────────
// ❌ Complex age validation
bool isAdultComplex(DateTime birthDate) {
  final now = DateTime.now();
  int age = now.year - birthDate.year;
  if (now.month < birthDate.month ||
      (now.month == birthDate.month && now.day < birthDate.day)) {
    age--;
  }
  return age >= 18; // there is a built-in way to do this
}

// ✅ Simple and readable
bool isAdult(DateTime birthDate) {
  final eighteenthBirthday = DateTime(
    birthDate.year + 18,
    birthDate.month,
    birthDate.day,
  );
  return DateTime.now().isAfter(eighteenthBirthday);
}
```

**Why it matters:** Senior developers are expected to *resist complexity*, not just implement it. KISS discipline is what separates maintainable codebases from those that become legacy nightmares.

**Common mistake:** Confusing KISS with "write less code." It means write the *least complex* code that works — sometimes that's more lines but cleaner logic. Also, KISS does not mean "don't use design patterns." It means don't add patterns you don't need yet.

---

**Q:** What is the YAGNI principle? Give a real-world example in the context of Flutter development.

**A:**
**YAGNI — You Aren't Gonna Need It.** Don't implement functionality until you actually need it. Building for imagined future requirements wastes time, adds complexity, and often the anticipated need never materialises.

**Example:**
```dart
// ❌ YAGNI violation — over-built "just in case"
class UserProfile {
  final String name;
  final String email;

  // "We might need social login someday"
  final String? googleId;
  final String? facebookId;
  final String? twitterId;
  final String? appleId;

  // "We might need multi-language someday"
  final String? preferredLanguage;
  final String? timezone;
  final String? currency;

  // "We might need analytics someday"
  final DateTime? lastActiveAt;
  final int? loginCount;
  final String? referralSource;

  UserProfile({
    required this.name,
    required this.email,
    this.googleId,
    this.facebookId,
    this.twitterId,
    this.appleId,
    this.preferredLanguage,
    this.timezone,
    this.currency,
    this.lastActiveAt,
    this.loginCount,
    this.referralSource,
  });
  // 90% of these fields are null — zero value, 100% cost
}

// ✅ YAGNI — build what the current requirements demand
class YagniUserProfile {
  final String name;
  final String email;

  YagniUserProfile({required this.name, required this.email});
}
// When social login is actually required → extend then.
// When analytics is actually required → add then.
```

**Real-world Flutter scenario:**

> You're building a simple note-taking app. You find yourself implementing:
> - Multi-user collaboration
> - Cloud sync with conflict resolution
> - Plugin architecture for "future integrations"
> - A full theming engine with 10 customisable tokens
>
> The current requirement is: *"A user can create and delete a note."*
>
> YAGNI says: implement exactly that. Add collaboration when the product team specifies it, with real requirements, not imagined ones.

**Why it matters:** YAGNI is especially relevant in startup and agile environments where requirements evolve rapidly. Over-engineering burns sprint time and produces dead code.

**Common mistake:** Confusing YAGNI with "never plan ahead." YAGNI is not anti-architecture — it means don't *implement* speculative features. Planning for extensibility (e.g., using abstractions and dependency injection) is still good practice; building unused features is not.

---
