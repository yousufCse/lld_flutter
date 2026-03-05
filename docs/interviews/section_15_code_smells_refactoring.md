# Section 15: Code Smells & Refactoring

---

## CODE SMELLS

---

**Q:** What is a code smell? How is it different from a bug?

**A:** A code smell is a surface-level indicator in the codebase that suggests a deeper structural problem. It is not a bug — the code still compiles and runs — but it signals that the design is fragile, hard to maintain, or likely to produce bugs in the future.

A **bug** causes incorrect behavior. A **code smell** causes maintenance pain.

```
Bug:                          Code Smell:
─────────────────────         ─────────────────────────────
Crashes the app          vs   Makes the app hard to change
Wrong output             vs   Makes the code hard to read
Breaks at runtime        vs   Slows down the team over time
```

**Example:**
```dart
// BUG — causes wrong behavior
double calculateDiscount(double price) {
  return price * 1.1; // Bug: should be 0.9 for a 10% discount
}

// CODE SMELL — works, but unclear and hard to maintain
double cd(double p, int t, bool f, String x) {
  // What is t? What is f? What is x?
  if (f) return p * 0.9;
  if (t > 30) return p * 0.85;
  return p;
}
```

**Why it matters:** The interviewer wants to know if you think beyond "does it work?" to "is it maintainable?" Senior engineers identify smells during code review before they accumulate into real problems.

**Common mistake:** Candidates say "a code smell is just bad style." Style is about formatting (spaces, naming conventions). Code smells are about **structural design problems** — they are a different and deeper category.

---

**Q:** What is a Long Method? How do you fix it using Extract Method?

**A:** A Long Method is a function that does too many things. There is no strict line count rule, but if you need to scroll to read it, or if you need comments to separate sections, it is too long. The fix is **Extract Method** — pulling logical chunks into smaller, well-named functions.

Long methods are hard to:
- Read (you cannot hold the whole thing in your head)
- Test (too many paths through one function)
- Reuse (logic is buried)
- Modify (changing one thing risks breaking another)

```
Long Method:
─────────────────────────────────────
│  validateInput()                  │
│  formatData()                     │  ← All crammed into one method
│  saveToDatabase()                 │
│  sendNotification()               │
─────────────────────────────────────

After Extract Method:
─────────────────────────────────────
│  processOrder()  ← orchestrator   │
│    │                              │
│    ├── _validateInput()           │
│    ├── _formatData()              │
│    ├── _saveToDatabase()          │
│    └── _sendNotification()        │
─────────────────────────────────────
```

**Example:**
```dart
// BEFORE — Long Method
Future<void> submitOrder(Order order) async {
  // Validate
  if (order.items.isEmpty) throw Exception('No items');
  if (order.userId.isEmpty) throw Exception('No user');
  if (order.total <= 0) throw Exception('Invalid total');

  // Format
  final payload = {
    'userId': order.userId,
    'items': order.items.map((i) => i.toJson()).toList(),
    'total': order.total.toStringAsFixed(2),
    'timestamp': DateTime.now().toIso8601String(),
  };

  // Save
  await database.collection('orders').add(payload);

  // Notify
  final message = 'Order placed for \$${order.total.toStringAsFixed(2)}';
  await notificationService.send(order.userId, message);
}

// AFTER — Extract Method applied
Future<void> submitOrder(Order order) async {
  _validateOrder(order);
  final payload = _formatOrderPayload(order);
  await _saveOrder(payload);
  await _notifyUser(order);
}

void _validateOrder(Order order) {
  if (order.items.isEmpty) throw Exception('No items');
  if (order.userId.isEmpty) throw Exception('No user');
  if (order.total <= 0) throw Exception('Invalid total');
}

Map<String, dynamic> _formatOrderPayload(Order order) {
  return {
    'userId': order.userId,
    'items': order.items.map((i) => i.toJson()).toList(),
    'total': order.total.toStringAsFixed(2),
    'timestamp': DateTime.now().toIso8601String(),
  };
}

Future<void> _saveOrder(Map<String, dynamic> payload) async {
  await database.collection('orders').add(payload);
}

Future<void> _notifyUser(Order order) async {
  final message = 'Order placed for \$${order.total.toStringAsFixed(2)}';
  await notificationService.send(order.userId, message);
}
```

**Why it matters:** Extract Method is the most frequently used refactoring technique. The interviewer is checking whether you write functions that have a **single, clear responsibility** — the "S" in SOLID.

**Common mistake:** Candidates extract methods but give them vague names like `doStep1()` or `handleStuff()`. The method name should reveal **what** it does and eliminate the need for a comment — if you still need a comment to explain the extracted method, rename it.

---

**Q:** What is a Large Class (God Object)? How do you fix it?

**A:** A Large Class (also called a God Object or God Class) is a class that knows too much or does too much. It accumulates responsibilities over time until it becomes the center of the universe — everything depends on it, and it depends on everything.

Signs of a God Class:
- Hundreds or thousands of lines
- Dozens of methods and fields
- Methods that have nothing to do with each other
- It is injected into almost every other class

The fix is **Extract Class** — pull cohesive groups of fields and methods into their own dedicated classes.

```
God Class (before):
───────────────────────────────────────
│  UserManager                        │
│  ─────────────────                  │
│  login()         ← auth logic       │
│  logout()        ← auth logic       │
│  saveProfile()   ← profile logic    │
│  uploadAvatar()  ← profile logic    │
│  fetchOrders()   ← order logic      │
│  cancelOrder()   ← order logic      │
│  sendEmail()     ← notification     │
│  formatDate()    ← utility          │
───────────────────────────────────────

After Extract Class:
──────────────────────────────────────────────────
│ AuthService    │ ProfileService │ OrderService │
│ ────────────   │ ─────────────  │ ───────────  │
│ login()        │ saveProfile()  │ fetchOrders()│
│ logout()       │ uploadAvatar() │ cancelOrder()│
──────────────────────────────────────────────────
```

**Example:**
```dart
// BEFORE — God Class
class UserManager {
  final _db = DatabaseService();
  final _emailService = EmailService();

  // Auth
  Future<User> login(String email, String password) async { ... }
  Future<void> logout(String userId) async { ... }

  // Profile
  Future<void> updateProfile(String userId, Map data) async { ... }
  Future<String> uploadAvatar(String userId, File image) async { ... }

  // Orders
  Future<List<Order>> getOrders(String userId) async { ... }
  Future<void> cancelOrder(String orderId) async { ... }

  // Notifications
  Future<void> sendWelcomeEmail(String email) async { ... }
}

// AFTER — Responsibilities extracted into focused classes
class AuthService {
  Future<User> login(String email, String password) async { ... }
  Future<void> logout(String userId) async { ... }
}

class ProfileService {
  Future<void> updateProfile(String userId, Map data) async { ... }
  Future<String> uploadAvatar(String userId, File image) async { ... }
}

class OrderService {
  Future<List<Order>> getOrders(String userId) async { ... }
  Future<void> cancelOrder(String orderId) async { ... }
}
```

**Why it matters:** God Objects are the #1 enemy of testability and team scalability. The interviewer wants to see that you recognize when a class has exceeded its mandate and that you know how to split it without breaking things.

**Common mistake:** Candidates say "just break it into smaller files." Splitting into files is not enough if each file still has the same tangled responsibilities. The split must follow **cohesion** — group things that change together and belong together.

---

**Q:** What is a Long Parameter List? How do you fix it using Introduce Parameter Object?

**A:** A Long Parameter List is when a method or constructor takes too many parameters (typically more than 3–4). It makes calls hard to read, easy to mix up argument order, and painful to extend.

The fix is **Introduce Parameter Object** — group related parameters into a single class or data object.

**Example:**
```dart
// BEFORE — Long Parameter List (6 parameters, easy to pass in wrong order)
Future<void> createBooking(
  String userId,
  String hotelId,
  DateTime checkIn,
  DateTime checkOut,
  int guests,
  String roomType,
) async { ... }

// Called like this — confusing and error-prone:
await createBooking('u123', 'h456', checkIn, checkOut, 2, 'deluxe');

// ─────────────────────────────────────────────────────────

// AFTER — Introduce Parameter Object
class BookingRequest {
  final String userId;
  final String hotelId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final String roomType;

  const BookingRequest({
    required this.userId,
    required this.hotelId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.roomType,
  });
}

Future<void> createBooking(BookingRequest request) async { ... }

// Called like this — clear, named, safe:
await createBooking(BookingRequest(
  userId: 'u123',
  hotelId: 'h456',
  checkIn: checkIn,
  checkOut: checkOut,
  guests: 2,
  roomType: 'deluxe',
));
```

**Why it matters:** Long parameter lists are a readability and correctness hazard. Dart's named parameters reduce the risk of swapping values, but they do not eliminate the problem of having too many. The interviewer checks whether you think about API design and discoverability.

**Common mistake:** Candidates fix this by just adding named parameters in Dart (e.g., `({required String userId, ...})`). That helps readability but does not address the deeper issue: the related parameters should be a **cohesive concept** (a `BookingRequest`) that can also carry validation logic, be passed around, and be extended independently.

---

**Q:** What is Duplicate Code? How do you identify and fix it (DRY principle)?

**A:** Duplicate Code is when the same logic or structure appears in more than one place. It violates DRY — Don't Repeat Yourself. Every piece of knowledge should have a single, unambiguous representation.

Duplication is dangerous because when logic changes, you have to remember to change it in every place it appears — and you will forget one.

Types of duplication:
- **Exact copy-paste** — identical blocks
- **Near-duplicate** — same logic, slightly different variables
- **Structural duplication** — same pattern, different data

Fix strategies:
- **Extract Method** — pull shared logic into one function
- **Extract Class** — if the duplication spans multiple classes
- **Inheritance or Mixins** — if subclasses repeat parent behavior
- **Generic functions** — if duplication differs only by type

**Example:**
```dart
// BEFORE — Duplicate validation logic in two places
class RegistrationForm {
  bool validateEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}

class LoginForm {
  bool validateEmail(String email) {
    return email.contains('@') && email.contains('.');  // exact copy
  }
}

// ─────────────────────────────────────────────────────────

// AFTER — Single source of truth
class EmailValidator {
  static bool isValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class RegistrationForm {
  bool validateEmail(String email) => EmailValidator.isValid(email);
}

class LoginForm {
  bool validateEmail(String email) => EmailValidator.isValid(email);
}

// ─────────────────────────────────────────────────────────

// Near-duplicate — same structure, different fields
// BEFORE
Widget buildNameField() {
  return TextField(
    decoration: InputDecoration(label: Text('Name')),
    validator: (v) => v!.isEmpty ? 'Required' : null,
  );
}

Widget buildEmailField() {
  return TextField(
    decoration: InputDecoration(label: Text('Email')),
    validator: (v) => v!.isEmpty ? 'Required' : null,
  );
}

// AFTER — parameterize the differences
Widget buildRequiredField(String label) {
  return TextField(
    decoration: InputDecoration(label: Text(label)),
    validator: (v) => v!.isEmpty ? 'Required' : null,
  );
}
```

**Why it matters:** DRY is fundamental. The interviewer wants to see that you identify duplication early (in code review) and fix it structurally — not just with copy-paste shortcuts.

**Common mistake:** Candidates over-apply DRY and merge code that looks similar but represents **different concepts**. If two things happen to look the same today but evolve for different reasons, merging them creates coupling that is worse than duplication. Always ask: "Is this the same concept, or just the same shape?"

---

**Q:** What are Magic Numbers and Magic Strings? How do you fix them?

**A:** Magic Numbers and Magic Strings are literal values used directly in code with no explanation of what they mean. They are "magic" because their meaning is not obvious without context. They make code hard to read and dangerous to change because the same value might appear in multiple places.

**Example:**
```dart
// BEFORE — Magic numbers and strings everywhere
void checkUserStatus(int status) {
  if (status == 2) {             // What is 2?
    showBanner('VIP');           // Why 'VIP'?
  } else if (status == 3) {      // What is 3?
    showBanner('SUSPENDED');
  }
}

Future<void> fetchData() async {
  await Future.delayed(Duration(milliseconds: 3000)); // Why 3000?
  final result = await api.get('/v2/users');          // Why '/v2/users'?
}

// ─────────────────────────────────────────────────────────

// AFTER — Named constants
class UserStatus {
  static const int active = 1;
  static const int vip = 2;
  static const int suspended = 3;
}

class AppConfig {
  static const Duration fetchTimeout = Duration(seconds: 3);
  static const String usersEndpoint = '/v2/users';
}

class UserLabels {
  static const String vip = 'VIP';
  static const String suspended = 'SUSPENDED';
}

void checkUserStatus(int status) {
  if (status == UserStatus.vip) {
    showBanner(UserLabels.vip);
  } else if (status == UserStatus.suspended) {
    showBanner(UserLabels.suspended);
  }
}

Future<void> fetchData() async {
  await Future.delayed(AppConfig.fetchTimeout);
  final result = await api.get(AppConfig.usersEndpoint);
}
```

**Why it matters:** Magic values scatter meaning across the codebase. When the API version changes from `/v2/` to `/v3/`, you want to change it in one place, not hunt through hundreds of files. The interviewer checks whether you think about maintainability from day one.

**Common mistake:** Candidates use `const` variables but name them poorly: `const int TWO = 2` or `const String S = 'SUSPENDED'`. The name must express **meaning**, not just wrap the value. A good constant name makes the `= value` part feel almost redundant.

---

**Q:** What is Dead Code? Why is it dangerous?

**A:** Dead Code is code that is never executed — unreachable methods, unused variables, commented-out blocks, or features that were removed but the implementation was left behind. It is dangerous not because it runs, but because it **does not run while still demanding attention**.

Dangers of dead code:
- **Mental overhead** — developers read it and wonder if it matters
- **False signal** — makes the codebase look larger and more complex
- **Accidental resurrection** — someone uncomments it thinking it is needed
- **Stale tests** — tests that test nothing real
- **Security risk** — old auth paths or deprecated endpoints left in

**Example:**
```dart
class PaymentService {
  // Dead method — never called anywhere
  Future<void> processLegacyPayment(String token) async {
    // Old Stripe v1 integration from 2019
    await oldStripeClient.charge(token);
  }

  // Dead parameter — 'currency' is passed in but never used
  Future<void> processPayment(double amount, String currency) async {
    await stripeClient.charge(amount); // currency ignored
  }

  // Dead code path — condition can never be true
  void validateAmount(double amount) {
    if (amount < 0) throw Exception('Negative');
    if (amount < 0) { // unreachable — already thrown above
      log('Warning: negative amount');
    }
  }

  // Commented-out code — dead, but tempting to keep "just in case"
  // void applyPromoCode(String code) {
  //   discount = promoTable[code] ?? 0;
  // }
}

// FIX: Delete dead code. Use version control (git) to recover it
// if it is ever needed again. That is what git is for.
class PaymentService {
  Future<void> processPayment(double amount) async {
    await stripeClient.charge(amount);
  }

  void validateAmount(double amount) {
    if (amount < 0) throw Exception('Negative amount');
  }
}
```

**Why it matters:** Dead code signals poor housekeeping and creates confusion for new team members. The interviewer is evaluating whether you treat your codebase as a living thing that requires pruning, not just a place to add code.

**Common mistake:** Candidates say "I'll comment it out in case we need it later." This is the most common mistake. Version control exists for exactly this purpose. Commented-out code should always be deleted — if it was worth keeping, it would not have been removed.

---

**Q:** What is Feature Envy? How do you identify it?

**A:** Feature Envy is when a method in one class is more interested in the data of another class than in its own. It keeps reaching into another object to access fields or call multiple methods. This is a signal that the method belongs in the class it is so interested in.

```
Feature Envy visualization:

ClassA                    ClassB
──────────────────        ──────────────────
│ methodX()      │        │ field1           │
│  ─ B.field1  ──┼───────>│ field2           │
│  ─ B.field2  ──┼───────>│ field3           │
│  ─ B.field3  ──┼───────>│                  │
└────────────────┘        └──────────────────┘
         ▲
         Feature Envy: methodX uses ClassB more than ClassA
         → Move methodX to ClassB
```

**Example:**
```dart
// BEFORE — Feature Envy
// OrderPrinter is obsessed with Order's internals
class OrderPrinter {
  String formatOrder(Order order) {
    // This method touches order's data constantly
    final subtotal = order.items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
    final tax = subtotal * order.taxRate;
    final discount = order.discountCode != null ? subtotal * order.discountRate : 0.0;
    final total = subtotal + tax - discount;

    return 'Order #${order.id}: \$$total';
  }
}

// AFTER — Move the method to the class it belongs in
class Order {
  final String id;
  final List<OrderItem> items;
  final double taxRate;
  final String? discountCode;
  final double discountRate;

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  double get tax => subtotal * taxRate;

  double get discount => discountCode != null ? subtotal * discountRate : 0.0;

  double get total => subtotal + tax - discount;

  String format() => 'Order #$id: \$$total';
}

class OrderPrinter {
  String formatOrder(Order order) => order.format(); // now just delegates
}
```

**Why it matters:** Feature Envy breaks encapsulation. If you have to reach into another object's internals to do your job, the logic belongs there. The interviewer is testing whether you understand that behavior should live close to the data it operates on.

**Common mistake:** Candidates confuse Feature Envy with normal delegation. It is fine to call methods on another object. Feature Envy is specifically when a method **accesses the fields or internal state** of another class repeatedly — it is doing the other class's work for it.

---

**Q:** What are Data Clumps? How do you fix them?

**A:** Data Clumps are groups of data items that always appear together — in method signatures, class fields, or at call sites — but are never formally grouped into their own object. If you always see `latitude` and `longitude` together, or `startDate` and `endDate`, those belong together as a concept.

The fix is to extract them into a dedicated class or value object, just like **Introduce Parameter Object**.

**Example:**
```dart
// BEFORE — Data Clumps (lat/lng always travel together)
class MapService {
  void moveTo(double latitude, double longitude) { ... }
  void drawCircle(double latitude, double longitude, double radius) { ... }
  double distanceBetween(
    double lat1, double lng1,
    double lat2, double lng2,
  ) { ... }
}

// BEFORE — Data Clumps (date range always travels together)
Future<List<Report>> fetchReports(DateTime startDate, DateTime endDate) async { ... }
Future<int> countEvents(DateTime startDate, DateTime endDate) async { ... }

// ─────────────────────────────────────────────────────────

// AFTER — Named value objects
class GeoPoint {
  final double latitude;
  final double longitude;
  const GeoPoint(this.latitude, this.longitude);
}

class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});

  bool contains(DateTime date) =>
      date.isAfter(start) && date.isBefore(end);

  Duration get duration => end.difference(start);
}

class MapService {
  void moveTo(GeoPoint point) { ... }
  void drawCircle(GeoPoint center, double radius) { ... }
  double distanceBetween(GeoPoint a, GeoPoint b) { ... }
}

Future<List<Report>> fetchReports(DateRange range) async { ... }
Future<int> countEvents(DateRange range) async { ... }
```

**Why it matters:** Data Clumps are missed opportunities for abstraction. Once you create the `GeoPoint` or `DateRange` class, you can add behavior to it (like `distanceTo()` or `contains()`) and share it across the whole codebase. The interviewer sees whether you recognize natural domain concepts.

**Common mistake:** Candidates treat this as just a "cleanliness" issue. It is actually a **domain modeling** issue. `DateRange` is a real concept in the business domain. Missing it means the code does not reflect the domain, which makes it harder for everyone.

---

**Q:** What is Primitive Obsession? How do you fix it with value objects?

**A:** Primitive Obsession is when code uses raw primitive types (`String`, `int`, `double`, `bool`) to represent domain concepts that deserve their own type. It leads to validation scattered everywhere, no encapsulation of rules, and easy mix-ups between values of the same type.

```
Primitive Obsession:
────────────────────────────────────
User(
  id: 'u-123',          ← plain String — no validation
  email: 'bad-email',   ← plain String — should validate format
  age: -5,              ← plain int — negative age makes no sense
  phone: '12345',       ← plain String — no format guarantee
)
────────────────────────────────────
```

**Example:**
```dart
// BEFORE — Primitive Obsession
class User {
  final String id;
  final String email;
  final int age;

  User(this.id, this.email, this.age);
}

// Problems: Can create User('', 'not-an-email', -5)
// Validation must be copy-pasted everywhere email is used

// ─────────────────────────────────────────────────────────

// AFTER — Value Objects
class UserId {
  final String value;

  UserId(String raw) : value = raw.trim() {
    if (value.isEmpty) throw ArgumentError('UserId cannot be empty');
  }

  @override
  bool operator ==(Object other) => other is UserId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class Email {
  final String value;

  Email(String raw) : value = raw.trim().toLowerCase() {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      throw ArgumentError('Invalid email: $raw');
    }
  }
}

class Age {
  final int value;

  Age(this.value) {
    if (value < 0 || value > 150) {
      throw ArgumentError('Invalid age: $value');
    }
  }
}

class User {
  final UserId id;
  final Email email;
  final Age age;

  User({required this.id, required this.email, required this.age});
}

// Usage — invalid data fails at construction, not deep in business logic:
// User(id: UserId(''), ...) → throws immediately
// User(email: Email('bad'), ...) → throws immediately
```

**Why it matters:** Primitive Obsession is extremely common in production Flutter apps — passing raw `String` user IDs, unvalidated email addresses, etc. The interviewer is checking whether you understand domain modeling and self-validating types.

**Common mistake:** Candidates say "Dart's type system already handles this." It does not — both a user ID and an order ID are `String` types, and Dart will happily let you pass a user ID where an order ID is expected. Value objects prevent this class of bug at compile time.

---

**Q:** What is Shotgun Surgery? How is it different from Divergent Change?

**A:** **Shotgun Surgery** is when a single logical change requires touching many different classes or files. It is the opposite of what you want — high coupling means a small change ripples everywhere.

**Divergent Change** is the inverse: one class that changes for many different reasons. It violates SRP — the class has too many responsibilities.

```
Shotgun Surgery:
One change → many files touched
─────────────────────────────────────────
Change: "Add tax calculation to orders"
  → Edit: order_model.dart
  → Edit: checkout_service.dart
  → Edit: receipt_printer.dart
  → Edit: report_generator.dart
  → Edit: order_summary_widget.dart
─────────────────────────────────────────

Divergent Change:
One class → changes for many reasons
─────────────────────────────────────────
UserService changes when:
  - Auth rules change
  - Profile validation changes
  - Email format changes
  - Order logic changes
─────────────────────────────────────────
```

**Example:**
```dart
// SHOTGUN SURGERY EXAMPLE
// Suppose order discount logic is duplicated across files:

// checkout_service.dart
double calcTotal(Order order) => order.subtotal * 0.9; // 10% discount

// receipt_widget.dart
String formatTotal(Order order) {
  final total = order.subtotal * 0.9; // same discount logic duplicated
  return '\$$total';
}

// report_service.dart
double getOrderRevenue(Order order) => order.subtotal * 0.9; // again

// Change discount to 15% → must edit 3+ files → Shotgun Surgery
// FIX: Centralize the discount logic
extension OrderPricing on Order {
  double get total => subtotal * 0.85; // one place, one change
}

// ─────────────────────────────────────────────────────────

// DIVERGENT CHANGE EXAMPLE
class UserService {
  // Changes when auth system changes
  Future<User> login(String email, String password) async { ... }

  // Changes when profile rules change
  Future<void> updateBio(String userId, String bio) async { ... }

  // Changes when notification system changes
  Future<void> sendWelcomeEmail(String email) async { ... }
}

// FIX: Extract into focused services
class AuthService { ... }    // changes with auth
class ProfileService { ... } // changes with profile rules
class EmailService { ... }   // changes with notification system
```

**Why it matters:** Both smells indicate **wrong boundaries**. Shotgun Surgery means logic is too scattered. Divergent Change means a class has too many masters. The interviewer is checking whether you understand cohesion and coupling at an architectural level.

**Common mistake:** Candidates mix up the two. Remember: **Shotgun Surgery** = one change, many files (too scattered). **Divergent Change** = one file, many reasons to change (too concentrated). They are opposites and often fix each other.

---

**Q:** When do comments become a code smell?

**A:** Comments are a code smell when they exist to explain **what** the code is doing, rather than **why** a non-obvious decision was made. If you need a comment to explain what a block of code does, that is a signal the code itself should be clearer — through better naming, extraction, or restructuring.

Good comments explain intent, trade-offs, or external constraints. Bad comments compensate for unclear code.

**Example:**
```dart
// SMELL — Comment explains WHAT (the code should explain this itself)

// Get the user and check if they are active
final user = await userRepo.findById(id);
if (user.status == 1) {
  // Show the dashboard
  navigator.push(DashboardRoute());
}

// ─────────────────────────────────────────────────────────

// BETTER — Code is self-explanatory, comment is gone
final user = await userRepo.findById(userId);
if (user.isActive) {
  _navigateToDashboard();
}

// ─────────────────────────────────────────────────────────

// GOOD COMMENT — Explains WHY (non-obvious business rule or constraint)

// Delay is intentional: the backend needs 500ms to propagate
// the status change before we re-fetch user data.
await Future.delayed(const Duration(milliseconds: 500));
final updatedUser = await userRepo.findById(userId);

// Using index 1, not 0, because the API returns a sentinel
// value at index 0 that represents "no selection"
final selected = options[selectedIndex + 1];
```

Common comment smells:
- **Redundant comments** — `// increment counter` above `counter++`
- **Commented-out code** — use git instead
- **TODO comments left for months** — create a ticket
- **Section dividers** — `// ===== AUTH =====` → extract class instead

**Why it matters:** This is a professional maturity question. Junior developers add comments to explain code. Senior developers write code that does not need comments. The interviewer is checking whether you write expressive code or rely on comments as a crutch.

**Common mistake:** Candidates say "comments are always good practice." This is wrong. Comments that describe **what** the code does go stale — the code changes but the comment does not. Misleading stale comments are worse than no comments at all.

---

## REFACTORING TECHNIQUES

---

**Q:** Extract Method — how and when to do it?

**A:** Extract Method takes a fragment of code from inside a method and turns it into its own method with a descriptive name. Apply it when:

- A method is too long
- A block of code needs a comment to explain what it does
- The same logic appears in multiple places
- You want to make a method easier to test

The process:
1. Identify the fragment with a clear purpose
2. Check what local variables it reads and modifies
3. Create a new method — passing read variables as parameters, returning modified ones
4. Replace the original fragment with a call to the new method
5. Run tests

**Example:**
```dart
// BEFORE
Future<void> processUserRegistration(String email, String password) async {
  // Validate inputs
  if (email.isEmpty || !email.contains('@')) {
    throw ValidationException('Invalid email');
  }
  if (password.length < 8) {
    throw ValidationException('Password too short');
  }
  if (!password.contains(RegExp(r'[A-Z]'))) {
    throw ValidationException('Password needs uppercase letter');
  }

  // Hash password
  final salt = generateSalt();
  final hash = sha256.convert(utf8.encode(password + salt)).toString();

  // Save user
  await userRepository.save(User(email: email, passwordHash: hash, salt: salt));

  // Send welcome email
  await emailService.send(
    to: email,
    subject: 'Welcome!',
    body: 'Thanks for registering.',
  );
}

// ─────────────────────────────────────────────────────────

// AFTER — Extract Method applied
Future<void> processUserRegistration(String email, String password) async {
  _validateCredentials(email, password);
  final hashed = _hashPassword(password);
  await _saveUser(email, hashed);
  await _sendWelcomeEmail(email);
}

void _validateCredentials(String email, String password) {
  if (email.isEmpty || !email.contains('@')) {
    throw ValidationException('Invalid email');
  }
  if (password.length < 8) {
    throw ValidationException('Password too short');
  }
  if (!password.contains(RegExp(r'[A-Z]'))) {
    throw ValidationException('Password needs uppercase letter');
  }
}

({String hash, String salt}) _hashPassword(String password) {
  final salt = generateSalt();
  final hash = sha256.convert(utf8.encode(password + salt)).toString();
  return (hash: hash, salt: salt);
}

Future<void> _saveUser(String email, ({String hash, String salt}) hashed) async {
  await userRepository.save(User(
    email: email,
    passwordHash: hashed.hash,
    salt: hashed.salt,
  ));
}

Future<void> _sendWelcomeEmail(String email) async {
  await emailService.send(
    to: email,
    subject: 'Welcome!',
    body: 'Thanks for registering.',
  );
}
```

**Why it matters:** Extract Method is the most fundamental refactoring. Everything else builds on it. The interviewer wants to see that you do this instinctively when writing code — not just when fixing old code.

**Common mistake:** Extracting with names like `_step1()`, `_doThing()`, or `_helper()`. The name must make the extracted method's purpose immediately clear. If naming it is hard, the extracted fragment may not have a single clear purpose yet.

---

**Q:** Extract Class — how and when to do it?

**A:** Extract Class takes a subset of fields and methods from a large class and moves them into a new, focused class. Apply it when a class has more than one reason to change, or when you can identify a cluster of fields and methods that go together logically.

Process:
1. Identify the cluster of related data and behavior
2. Create a new class with a meaningful name
3. Move the relevant fields to the new class
4. Move or redirect the relevant methods
5. Update the original class to hold a reference to the new class
6. Run tests

**Example:**
```dart
// BEFORE — UserAccount does too much
class UserAccount {
  String userId;
  String email;
  String passwordHash;
  DateTime lastLogin;

  // Address data crammed in
  String street;
  String city;
  String postalCode;
  String country;

  // Address methods
  String get formattedAddress => '$street, $city $postalCode, $country';
  bool isInCountry(String countryCode) => country == countryCode;
}

// ─────────────────────────────────────────────────────────

// AFTER — Extract Class: Address
class Address {
  final String street;
  final String city;
  final String postalCode;
  final String country;

  const Address({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  String get formatted => '$street, $city $postalCode, $country';
  bool isInCountry(String countryCode) => country == countryCode;
}

class UserAccount {
  final String userId;
  final String email;
  final String passwordHash;
  final DateTime lastLogin;
  final Address address; // composed, not flattened

  const UserAccount({
    required this.userId,
    required this.email,
    required this.passwordHash,
    required this.lastLogin,
    required this.address,
  });
}
```

**Why it matters:** Extract Class is how you achieve the Single Responsibility Principle at the class level. The interviewer is checking whether you can see the natural seams in a class where it should be split.

**Common mistake:** Candidates extract a class but leave the original class with a large number of one-liner delegating methods — just proxying everything to the new class. If that happens, ask yourself whether the original class still needs to exist or whether callers should use the extracted class directly.

---

**Q:** Rename (method, variable, class) — how to do it safely?

**A:** Rename is the most frequently performed refactoring. A bad name is a permanent comment debt — every future reader has to mentally translate the name to its meaning. Renaming must be done safely to avoid breaking the codebase.

Safe renaming process:
1. Use your IDE's **refactor → rename** (not find-and-replace)
2. The IDE will update all usages automatically
3. If it is a **public API** used by other packages or teams — add the new name first, deprecate the old one, then remove after migration

```
Rename safety levels:
─────────────────────────────────────────────────
Private (_method, _variable) → rename freely, IDE updates all usages
Public internal       → rename with IDE, check all call sites
Public API (library)  → deprecate old → release → remove in next version
─────────────────────────────────────────────────
```

**Example:**
```dart
// BEFORE — Poor names
class DataHandler {
  Future<dynamic> proc(String x, int y) async { ... }
  void upd(Map<String, dynamic> d) { ... }
  bool chk(int val) => val > 0;
}

// AFTER — Meaningful names
class UserRepository {
  Future<User> fetchUserById(String userId, int version) async { ... }
  void updateUserProfile(Map<String, dynamic> profileData) { ... }
  bool isValidAge(int age) => age > 0;
}

// ─────────────────────────────────────────────────────────

// Renaming a public API safely using @Deprecated
class ApiClient {
  /// Use [fetchUser] instead.
  @Deprecated('Use fetchUser() — removed in v3.0')
  Future<User> getUser(String id) => fetchUser(id);

  Future<User> fetchUser(String id) async { ... }
}
```

**Why it matters:** Rename is a discipline, not just a feature. The interviewer checks whether you treat naming as a first-class concern and whether you know how to rename safely in a shared codebase without breaking consumers.

**Common mistake:** Using find-and-replace instead of the IDE's refactoring tool. Find-and-replace will rename string literals, comments, and unrelated variables that happen to share the name — the IDE's rename is scope-aware.

---

**Q:** Introduce Parameter Object — when and how to use it?

**A:** Introduce Parameter Object groups a set of related parameters that travel together into a single object. Use it when you see the same group of parameters appearing in multiple method signatures, or when a method has more than 3–4 parameters.

This also opens the door to moving behavior (validation, computation) into the new object itself.

**Example:**
```dart
// BEFORE — Same parameter group appears repeatedly
Future<List<Transaction>> fetchTransactions(
  String accountId,
  DateTime from,
  DateTime to,
  String currency,
) async { ... }

double calculateInterest(
  double principal,
  DateTime from,
  DateTime to,
  double rate,
) { ... }

// AFTER — Parameter Object
class DateRange {
  final DateTime from;
  final DateTime to;

  const DateRange({required this.from, required this.to});

  Duration get duration => to.difference(from);

  bool isValid() => to.isAfter(from);
}

class TransactionQuery {
  final String accountId;
  final DateRange period;
  final String currency;

  const TransactionQuery({
    required this.accountId,
    required this.period,
    required this.currency,
  });
}

Future<List<Transaction>> fetchTransactions(TransactionQuery query) async { ... }

// Bonus: behavior can live on the object
double calculateInterest(double principal, DateRange period, double rate) {
  final days = period.duration.inDays;
  return principal * rate * days / 365;
}
```

**Why it matters:** This refactoring improves readability at call sites, prevents parameter ordering mistakes, and creates a place to add validation and domain behavior. The interviewer looks for your instinct to spot these opportunities.

**Common mistake:** Candidates use a generic `Map<String, dynamic>` as the "parameter object." Maps lose type safety, provide no IDE autocomplete, and carry no validation logic. A proper typed class is the right solution.

---

**Q:** Replace Conditional with Polymorphism — when and how?

**A:** When you have a chain of `if/else` or `switch` statements that check a type or category and do different things for each, you can replace it with a class hierarchy or interface where each subclass implements the behavior for its own case. This moves the branching from runtime conditionals to compile-time dispatch.

```
Before (Conditional):                After (Polymorphism):
─────────────────────────────        ──────────────────────────────
if type == 'pdf'  → renderPdf()      PdfRenderer.render()
if type == 'html' → renderHtml()     HtmlRenderer.render()
if type == 'txt'  → renderText()     TextRenderer.render()
─────────────────────────────        ──────────────────────────────
Adding new type = edit existing       Adding new type = new class
```

**Example:**
```dart
// BEFORE — Conditional branching on type
class NotificationService {
  void send(String type, String message, String recipient) {
    if (type == 'email') {
      emailClient.send(to: recipient, body: message);
    } else if (type == 'sms') {
      smsClient.send(phone: recipient, text: message);
    } else if (type == 'push') {
      pushClient.sendPush(deviceToken: recipient, payload: message);
    }
  }
}

// AFTER — Polymorphism
abstract class NotificationChannel {
  Future<void> send(String message, String recipient);
}

class EmailChannel implements NotificationChannel {
  @override
  Future<void> send(String message, String recipient) async {
    await emailClient.send(to: recipient, body: message);
  }
}

class SmsChannel implements NotificationChannel {
  @override
  Future<void> send(String message, String recipient) async {
    await smsClient.send(phone: recipient, text: message);
  }
}

class PushChannel implements NotificationChannel {
  @override
  Future<void> send(String message, String recipient) async {
    await pushClient.sendPush(deviceToken: recipient, payload: message);
  }
}

class NotificationService {
  final NotificationChannel channel;
  const NotificationService(this.channel);

  Future<void> send(String message, String recipient) =>
      channel.send(message, recipient);
}

// Adding a new channel = new class, zero changes to existing code (Open/Closed)
class InAppChannel implements NotificationChannel {
  @override
  Future<void> send(String message, String recipient) async { ... }
}
```

**Why it matters:** This is the Strategy Pattern in action. It applies the Open/Closed Principle — open for extension, closed for modification. The interviewer evaluates whether you reach for OOP design instead of growing a switch statement.

**Common mistake:** Candidates apply this to simple one-off conditionals. Not every `if` statement needs polymorphism. Use it when the same type-check appears in multiple methods, or when you anticipate new types being added regularly. Over-engineering a simple condition is worse than leaving it as an `if`.

---

**Q:** Replace Magic Number with Named Constant — how to do it correctly in Dart?

**A:** Identify the literal value, understand its meaning, create a well-named `const` or `static const` in an appropriate scope, and replace all usages of the raw literal with the constant.

**Example:**
```dart
// BEFORE
class SessionManager {
  bool isSessionValid(int sessionAgeSeconds) {
    return sessionAgeSeconds < 3600; // What is 3600?
  }

  void scheduleRefresh(Timer timer) {
    timer.run(every: 300); // What is 300?
  }
}

// ─────────────────────────────────────────────────────────

// AFTER — Scoped named constants
class SessionConfig {
  static const Duration sessionTimeout = Duration(hours: 1);
  static const Duration refreshInterval = Duration(minutes: 5);
}

class SessionManager {
  bool isSessionValid(Duration sessionAge) {
    return sessionAge < SessionConfig.sessionTimeout;
  }

  void scheduleRefresh(Timer timer) {
    timer.run(every: SessionConfig.refreshInterval);
  }
}

// ─────────────────────────────────────────────────────────

// For Flutter UI — avoid magic layout values
// BEFORE
SizedBox(height: 24); // Why 24?

// AFTER
class AppSpacing {
  static const double sectionGap = 24.0;
  static const double cardPadding = 16.0;
  static const double iconSize = 20.0;
}

SizedBox(height: AppSpacing.sectionGap);
```

**Why it matters:** Named constants make the business rule visible — `3600` tells you nothing, `sessionTimeout` tells you everything. They also make changes safe — update one constant, every usage updates.

**Common mistake:** Candidates name constants after their value rather than their meaning: `const int SIXTY = 60`. The name should describe purpose — `const int maxRetryAttempts = 60` would be correct if that is what 60 represents.

---

**Q:** Move Method — how and when to move a method to the class where it belongs?

**A:** Move Method relocates a method from one class to another when the method clearly uses more of another class's data and behavior than its own class. It reduces Feature Envy and improves cohesion.

Process:
1. Identify the method that is more interested in another class
2. Verify the method does not depend on fields from the current class (or accept them as a parameter if it does)
3. Copy the method to the target class
4. Update the original to delegate to the new location (or delete if unused)
5. Update all callers
6. Run tests

**Example:**
```dart
// BEFORE — discountedPrice lives in Cart but is really about Product
class Product {
  final double basePrice;
  final double vatRate;
  final bool isMemberExclusive;

  const Product({
    required this.basePrice,
    required this.vatRate,
    required this.isMemberExclusive,
  });
}

class Cart {
  // This method uses nothing from Cart — it only uses Product data
  double discountedPrice(Product product, bool isMember) {
    double price = product.basePrice * (1 + product.vatRate);
    if (product.isMemberExclusive && isMember) {
      price *= 0.85;
    }
    return price;
  }
}

// ─────────────────────────────────────────────────────────

// AFTER — Move Method to Product
class Product {
  final double basePrice;
  final double vatRate;
  final bool isMemberExclusive;

  const Product({
    required this.basePrice,
    required this.vatRate,
    required this.isMemberExclusive,
  });

  // Method now lives where its data lives
  double priceFor({required bool isMember}) {
    double price = basePrice * (1 + vatRate);
    if (isMemberExclusive && isMember) {
      price *= 0.85;
    }
    return price;
  }
}

class Cart {
  double totalFor(List<Product> items, bool isMember) {
    return items.fold(0, (sum, p) => sum + p.priceFor(isMember: isMember));
  }
}
```

**Why it matters:** Move Method is about placing behavior next to the data it transforms. This is the essence of object-oriented design: objects should own their behavior. The interviewer checks whether you actively maintain cohesion.

**Common mistake:** Candidates move the method but leave a delegating wrapper in the original class "for backward compatibility" — and then never remove it. This adds indirection without value. Clean up the delegation after confirming no callers depend on it.

---

**Q:** Inline Method — when is a method unnecessary indirection?

**A:** Inline Method is the reverse of Extract Method. Use it when a method's body is as clear as its name — the method is no longer adding meaning or hiding complexity. Over-extracted code creates navigation overhead and cognitive cost without benefit.

Apply Inline Method when:
- The method body is one line that says exactly what the name says
- The method is only called once and adds no clarity
- A series of tiny methods makes the flow hard to follow

**Example:**
```dart
// BEFORE — needless indirection
class OrderService {
  bool isEligibleForDiscount(Order order) {
    return _hasEnoughItems(order) && _isHighValue(order);
  }

  bool _hasEnoughItems(Order order) {
    return order.items.length >= 3; // Only one line, used nowhere else
  }

  bool _isHighValue(Order order) {
    return order.total > 100.0; // Only one line, used nowhere else
  }
}

// AFTER — Inline the trivial one-liners
class OrderService {
  bool isEligibleForDiscount(Order order) {
    return order.items.length >= 3 && order.total > 100.0;
  }
}

// ─────────────────────────────────────────────────────────

// But keep the extraction if the logic is non-trivial or reused:
class OrderService {
  bool isEligibleForDiscount(Order order) {
    return _meetsMinimumThreshold(order);
  }

  // Worth keeping — name communicates a business rule, not just math
  bool _meetsMinimumThreshold(Order order) {
    final itemCount = order.items.where((i) => !i.isGift).length;
    return itemCount >= 3 && order.subtotal > 100.0 && !order.hasAppliedCoupon;
  }
}
```

**Why it matters:** Good refactoring is not always about extracting. Knowing when **not** to extract — or when to inline back — shows mature judgment. The interviewer is checking whether you know the purpose of abstraction: to hide complexity, not to add hierarchy for its own sake.

**Common mistake:** Candidates think "more methods = better code." Abstraction must earn its keep. An extracted method that adds zero clarity and is never reused is pure overhead. The goal is **readable flow**, not the highest possible method count.

---

**Q:** How do you refactor safely? (tests first, small steps)

**A:** Refactoring is defined as changing the internal structure of code without changing its external behavior. The only way to guarantee external behavior is unchanged is to have automated tests verifying it before, during, and after each change.

Safe refactoring process:
```
Safe Refactoring Loop:
────────────────────────────────────────────────────────
1. Ensure tests exist and pass (GREEN state)
   ↓
2. Make one small change (rename, extract, move)
   ↓
3. Run tests immediately — stay in GREEN
   ↓
4. If RED → undo the last change, understand why
   ↓
5. Commit the working state
   ↓
6. Repeat for the next small change
────────────────────────────────────────────────────────
```

**Example:**
```dart
// STEP 1 — Write tests BEFORE refactoring
void main() {
  group('OrderService', () {
    test('applies discount when order qualifies', () {
      final order = Order(items: List.filled(3, item), total: 150.0);
      final service = OrderService();
      expect(service.calculateTotal(order), equals(135.0)); // 10% off
    });

    test('no discount when order is too small', () {
      final order = Order(items: [item], total: 50.0);
      final service = OrderService();
      expect(service.calculateTotal(order), equals(50.0));
    });
  });
}

// STEP 2 — Extract method (small change)
class OrderService {
  // BEFORE: inline logic
  double calculateTotal(Order order) {
    if (order.items.length >= 3 && order.total > 100.0) {
      return order.total * 0.9;
    }
    return order.total;
  }
}

// Run tests → GREEN ✓ → commit

// STEP 3 — Second small change: extract condition
class OrderService {
  double calculateTotal(Order order) {
    return _isEligibleForDiscount(order)
        ? order.total * 0.9
        : order.total;
  }

  bool _isEligibleForDiscount(Order order) {
    return order.items.length >= 3 && order.total > 100.0;
  }
}

// Run tests → GREEN ✓ → commit

// STEP 4 — Third change: name the discount rate
class OrderService {
  static const double _discountRate = 0.9;

  double calculateTotal(Order order) {
    return _isEligibleForDiscount(order)
        ? order.total * _discountRate
        : order.total;
  }

  bool _isEligibleForDiscount(Order order) {
    return order.items.length >= 3 && order.total > 100.0;
  }
}

// Run tests → GREEN ✓ → commit
```

Key rules:
- **Never refactor and add features at the same time** — keep them in separate commits
- **Never refactor without tests** — you will not know what you broke
- **Commit after every green step** — gives you a safe rollback point
- **Keep each step small** — large refactors compound risk

**Why it matters:** Refactoring without tests is just restructuring with hope. The interviewer wants to know you have a disciplined, methodical approach — not that you "eyeball" it and "seems fine."

**Common mistake:** Refactoring in big sessions without running tests between steps. When something breaks, you have no idea which of the 20 changes caused it. Small steps with frequent test runs make it trivially easy to pinpoint problems.

---

**Q:** How do you convince a team to refactor old code?

**A:** Convincing a team to refactor requires addressing both the technical case and the human/business case. Engineers, product managers, and tech leads all have different concerns. You need to speak all three languages.

**The Boy Scout Rule:** Always leave the code cleaner than you found it. Refactor incrementally as part of normal feature work — not as a big separate project.

**Strategies to convince your team:**

**1. Show the cost of not refactoring**
```
Technical debt is a loan with compound interest.
A 2-hour fix today costs 8 hours next quarter
because the code grew worse.
Make the cost visible with data:
  - Bug frequency in a module
  - Average time to implement features in an area
  - Number of files touched per change (shotgun surgery metric)
```

**2. Propose incremental refactoring, not a rewrite**
```dart
// WRONG pitch: "Let's spend 2 sprints refactoring UserService"
// → Delivers no business value, hard to approve

// RIGHT pitch: "As part of adding the new payment feature,
//               I'll clean up the PaymentService which we need to change anyway"
// → Business value (feature) + technical value (cleanup) combined
```

**3. The Strangler Fig pattern — for legacy systems**
```
Legacy System          New System
─────────────          ───────────
│ OldModule   │ ──→   │ NewModule  │ ← Build new alongside old
│ OldService  │       │ NewService │ ← Route traffic gradually
│ OldRepo     │       │ NewRepo    │ ← Retire old when confident
─────────────          ───────────
Never do a big-bang rewrite. Strangle the old system incrementally.
```

**4. Quantify the risk of the current state**
- Show test coverage gaps in legacy code
- Show how frequently bugs come from that area
- Propose adding tests first, which reduces risk for everyone

**5. Establish team norms**
```dart
// Suggest team practices:
// 1. Definition of Done includes: no new code smells introduced
// 2. Code review checklist includes smell detection
// 3. "Refactoring PR" is a recognized and budgeted PR type
// 4. Tech debt is tracked in the backlog alongside features
```

**Why it matters:** This is a leadership and communication question, not just a technical one. Senior engineers must convince stakeholders — including skeptical PMs and time-pressured teammates — that quality investment pays off. The interviewer is checking your maturity and influence skills.

**Common mistake:** Candidates make the case for refactoring on purely aesthetic or idealistic grounds: "the code is ugly" or "it's not SOLID." Business stakeholders do not respond to that. Translate it into **time, risk, and money**: "This module causes 40% of our production bugs and takes 3x longer to change than a healthy module."

---

## ADDITIONAL REFACTORING TECHNIQUES (Frequently Asked in Interviews)

---

**Q:** What is the Strangler Fig Pattern? When do you use it?

**A:** The Strangler Fig Pattern is a technique for incrementally replacing a legacy system or module. Instead of a risky "big bang" rewrite, you build the new system alongside the old one and gradually route traffic from old to new until the legacy code can be safely deleted.

The name comes from the strangler fig tree, which grows around an existing tree and eventually replaces it.

```
Phase 1: New system built alongside old
────────────────────────────────────────
Requests → OldPaymentService (100%)
           NewPaymentService (0%)  ← built but not used

Phase 2: Traffic shifted gradually
────────────────────────────────────────
Requests → OldPaymentService (50%)
           NewPaymentService (50%) ← canary or feature flag

Phase 3: Migration complete
────────────────────────────────────────
Requests → NewPaymentService (100%)
           OldPaymentService → DELETED
```

**Example:**
```dart
// Feature flag controls which implementation is active
class PaymentServiceFactory {
  static PaymentService create(FeatureFlags flags) {
    if (flags.isEnabled('new_payment_service')) {
      return NewStripePaymentService();
    }
    return LegacyPaymentService();
  }
}

// Both implement the same interface — easy to swap
abstract class PaymentService {
  Future<PaymentResult> processPayment(PaymentRequest request);
}

class LegacyPaymentService implements PaymentService {
  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    // Old implementation
  }
}

class NewStripePaymentService implements PaymentService {
  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    // New implementation
  }
}
```

**Why it matters:** Rewrites are the most dangerous projects in software. The Strangler Fig Pattern is the professional, risk-managed alternative. Interviewers ask this to check whether you know how to deal with real-world legacy systems without gambling the product.

**Common mistake:** Candidates skip the parallel-run phase. Running both implementations simultaneously (with comparison logging) is the most valuable phase — it proves the new system is behaviorally equivalent before you commit to it.

---

**Q:** What is the Decompose Conditional refactoring?

**A:** Decompose Conditional extracts complex conditional expressions and the code in their branches into clearly named methods. This is a specific form of Extract Method focused on `if/else` or `switch` statements that have non-obvious logic in their conditions or branches.

**Example:**
```dart
// BEFORE — Complex conditional, hard to understand
double calculateShipping(Order order, DateTime orderDate) {
  if (!order.isPremium &&
      orderDate.weekday != DateTime.saturday &&
      orderDate.weekday != DateTime.sunday &&
      order.totalWeight < 5.0) {
    return order.totalWeight * 2.5;
  } else if (order.isPremium) {
    return 0.0;
  } else {
    return order.totalWeight * 4.0 + 10.0;
  }
}

// ─────────────────────────────────────────────────────────

// AFTER — Decompose Conditional
double calculateShipping(Order order, DateTime orderDate) {
  if (order.isPremium) return _freeShipping();
  if (_isStandardEligible(order, orderDate)) return _standardRate(order);
  return _expressRate(order);
}

bool _isStandardEligible(Order order, DateTime orderDate) {
  return !order.isPremium &&
      !_isWeekend(orderDate) &&
      order.totalWeight < 5.0;
}

bool _isWeekend(DateTime date) {
  return date.weekday == DateTime.saturday ||
      date.weekday == DateTime.sunday;
}

double _freeShipping() => 0.0;
double _standardRate(Order order) => order.totalWeight * 2.5;
double _expressRate(Order order) => order.totalWeight * 4.0 + 10.0;
```

**Why it matters:** Complex conditions are where bugs hide. By naming the condition and its branches, you make the intent explicit and make each part independently testable. The interviewer uses this to check your instinct for readable control flow.

**Common mistake:** Only extracting the condition but leaving the branches as anonymous inline blocks. Both the condition and the branches should be named if they are non-trivial.

---

**Q:** What is Consolidate Conditional Expression? When do you use it?

**A:** Consolidate Conditional Expression combines multiple conditional checks that lead to the same result into a single, clearly named condition. The goal is to eliminate repetition and signal that these checks represent one unified business rule.

**Example:**
```dart
// BEFORE — Multiple separate checks, same result, no obvious connection
double getDiscount(Employee employee) {
  if (employee.isPartTime) return 0;
  if (employee.onProbation) return 0;
  if (employee.performanceScore < 3) return 0;
  return employee.salary * 0.1;
}

// These three checks all mean "not eligible for bonus"
// — they are one concept, not three independent conditions

// ─────────────────────────────────────────────────────────

// AFTER — Consolidate into a named condition
double getDiscount(Employee employee) {
  if (_isNotEligibleForBonus(employee)) return 0;
  return employee.salary * 0.1;
}

bool _isNotEligibleForBonus(Employee employee) {
  return employee.isPartTime ||
      employee.onProbation ||
      employee.performanceScore < 3;
}
```

**Why it matters:** Each `if` statement looks like a separate policy when reading the code. Consolidating them reveals they form a single concept — eligibility — and gives that concept a name. Interviewers check whether you think in terms of business rules, not just code branches.

**Common mistake:** Consolidating conditions that are actually independent rules. If the three checks above came from three different business policies that could change independently, merging them into one method hides that independence. Only consolidate when the conditions truly represent one concept.

---

**Q:** What is Replace Temp with Query?

**A:** Replace Temp with Query removes a temporary variable used to hold the result of an expression and replaces it with a method or getter that computes the result on demand. This reduces the scope of variables and makes computations reusable.

**Example:**
```dart
// BEFORE — Temp variable holds computed value
double calculateOrderTotal(Order order) {
  final basePrice = order.items.fold(0.0, (sum, i) => sum + i.price * i.quantity);
  final taxAmount = basePrice * order.taxRate;
  final discount = order.hasPromoCode ? basePrice * 0.1 : 0.0;
  return basePrice + taxAmount - discount;
}

// AFTER — Replace Temp with Query (getters on Order)
class Order {
  final List<OrderItem> items;
  final double taxRate;
  final bool hasPromoCode;

  double get basePrice =>
      items.fold(0.0, (sum, i) => sum + i.price * i.quantity);

  double get taxAmount => basePrice * taxRate;

  double get discountAmount => hasPromoCode ? basePrice * 0.1 : 0.0;

  double get total => basePrice + taxAmount - discountAmount;
}

// calculateOrderTotal is now just:
double calculateOrderTotal(Order order) => order.total;
```

**Why it matters:** Temp variables have limited scope and cannot be reused. Queries (methods/getters) can be called from anywhere and make the object richer. This is especially clean in Dart because getters are zero-argument and read exactly like fields.

**Common mistake:** Over-applying this to performance-critical code. If `basePrice` is computed many times and the list is large, a getter that recomputes on each access can hurt performance. In that case, caching (or keeping the temp variable) is correct. Profile before refactoring away a temp in a hot path.

---

*End of Section 15: Code Smells & Refactoring*
