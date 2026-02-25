# Model Conversion Pattern — Architecture Decision

> **Date:** 2026-02-25
> **Status:** Adopted (replaces `plans/generic-mapper-pattern.md`)
> **Scope:** All features — data ↔ domain layer conversion

---

## Table of Contents

1. [Decision](#1-decision)
2. [The Pattern](#2-the-pattern)
3. [Why This Approach](#3-why-this-approach)
4. [Comparison With All Alternatives](#4-comparison-with-all-alternatives)
5. [Real Examples From This Codebase](#5-real-examples-from-this-codebase)
6. [Handling Complex Conversions](#6-handling-complex-conversions)
7. [The One Rule That Makes This Safe](#7-the-one-rule-that-makes-this-safe)
8. [When To Escalate](#8-when-to-escalate)
9. [Conventions & Checklist](#9-conventions--checklist)
10. [References](#10-references)

---

## 1. Decision

**Use `ResponseModel.toEntity` and `RequestModel.fromParams(Params)` for all data ↔ domain conversions.**

This is the standard approach used by the Flutter community, taught in every major Clean Architecture tutorial, and already in place in this codebase (`auth`, `registration`). The separate `Mapper<I, O>` class experiment (branch `refactor/mapper-abstraction`) is being reverted in favor of this simpler, industry-standard pattern.

---

## 2. The Pattern

### Response Model → Entity (`toEntity`)

The response model provides a `toEntity` getter that converts itself into a domain entity:

```dart
@JsonSerializable(createToJson: false)
class RegisterResponseModel {
  final String registrationId;
  final String otpReference;
  final String expiresAt;
  final String maskedPhone;

  RegisterResponseModel({
    required this.registrationId,
    required this.otpReference,
    required this.expiresAt,
    required this.maskedPhone,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  // Conversion: data → domain
  RegisterEntity get toEntity => RegisterEntity(
    registrationId: registrationId,
    otpReference: otpReference,
    expiresAt: expiresAt,
    maskedPhone: maskedPhone,
  );
}
```

### Params → Request Model (`fromParams`)

The request model provides a factory constructor that builds itself from domain params:

```dart
@JsonSerializable()
class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String mobile;
  final String? dateOfBirth;
  final String gender;
  final bool termsAccepted;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.dateOfBirth,
    required this.gender,
    required this.termsAccepted,
  });

  // Conversion: domain → data
  factory RegisterRequestModel.fromParams(RegisterParams params) =>
      RegisterRequestModel(
        firstName: params.firstName,
        lastName: params.lastName,
        mobile: params.mobile,
        gender: params.gender.toUpperCase(),
        dateOfBirth: params.dateOfBirth,
        termsAccepted: params.termsAccepted,
      );

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
```

### Repository usage

```dart
@override
Result<RegisterEntity> registerInitiate(RegisterParams params) async {
  return handleException(() async {
    final result = await remote.registerInitiate(
      RegisterRequestModel.fromParams(params),
    );
    return result.data.toEntity;
  }, operationName: 'Register Initiate');
}
```

---

## 3. Why This Approach

### 3.1 It is the Flutter community standard

The `toEntity`/`fromParams` pattern is used in:

- **Reso Coder's Clean Architecture Course** — the most-cited Flutter architecture reference. Originally used model-extends-entity, later updated to `toEntity()` method.
- **Rubem Vasconcelos's DEV Community tutorial** — uses `toEntity()` on response models and `fromDomain()` on request models.
- **Enes Akbal's Flutter-Clean-Architecture-Example** (200+ GitHub stars) — `toEntity()` on all response models.
- **Nearly every flutter-clean-architecture repo** on GitHub Topics.

No major Flutter tutorial or production reference project uses separate mapper classes as the default.

### 3.2 Zero extra files, zero extra classes

| Feature endpoints | Extra files with Mapper classes | Extra files with toEntity |
|---|---|---|
| 1 endpoint | 1 mapper file, 2 mapper classes | 0 |
| 5 endpoints | 5 mapper files, 10 mapper classes | 0 |
| 20 features × 3 endpoints | 60 mapper files, 120 mapper classes | 0 |

The mapper approach scales linearly in boilerplate. The `toEntity` approach scales at zero.

### 3.3 Discoverability

A new developer sees `RegisterResponseModel`, hits `.` in the IDE → `toEntity` appears immediately in autocomplete. With mappers, they must know a `RegisterEntityMapper` exists in the same directory — findable, but not obvious.

### 3.4 The repository reads like prose

```dart
// With toEntity — reads naturally
return result.data.toEntity;

// With mapper — requires scrolling up to see what _toEntity is
return _toEntity(result.data);
```

### 3.5 Compile safety is identical

Both approaches construct the entity with the same constructor call. If entity constructor params are `required`, a missing field is caught at compile time in both cases. There is no safety advantage to separate mapper classes.

### 3.6 Performance is identical

`toEntity` is a getter/method on an already-allocated object — zero extra allocation. Mapper classes use `static const` — also zero allocation. Neither approach has a performance advantage.

---

## 4. Comparison With All Alternatives

### Approach A: `toEntity` / `fromParams` (ADOPTED)

```dart
class UserResponseModel {
  factory UserResponseModel.fromJson(Map<String, dynamic> json) => ...;
  UserEntity get toEntity => UserEntity(id: id, name: name);
}

class CreateUserRequestModel {
  factory CreateUserRequestModel.fromParams(CreateUserParams p) => ...;
  Map<String, dynamic> toJson() => ...;
}
```

```
✅ Community standard
✅ Zero extra files/classes
✅ Excellent discoverability (IDE autocomplete)
✅ Clean repository code
✅ Same compile safety as all other approaches
⚠️  Model has 2 jobs (JSON + conversion) — minor SRP concern
⚠️  Complex conversions (20+ lines) can clutter the model file
```

**Best for:** 80-90% of features where mapping is straightforward.

---

### Approach B: Extension methods

```dart
// Model is pure DTO
class UserResponseModel {
  factory UserResponseModel.fromJson(Map<String, dynamic> json) => ...;
}

// Conversion in an extension
extension UserResponseModelX on UserResponseModel {
  UserEntity toEntity() => UserEntity(id: id, name: name);
}
```

```
✅ Model is a pure DTO (strict SRP compliance)
✅ No extra classes — just an extension
✅ Same IDE autocomplete as toEntity on the model
✅ Can live in the same file or a separate file
⚠️  Extension must be imported at call site
⚠️  Static factory (fromParams) is awkward as an extension
⚠️  Not widely adopted — most Flutter devs don't expect it
```

**Best for:** Teams that want strict SRP without mapper class overhead. However, the `fromParams` direction doesn't map cleanly to extensions since you can't add factory constructors via extensions.

---

### Approach C: Separate Mapper classes

```dart
abstract class Mapper<Input, Output> {
  const Mapper();
  Output call(Input input);
}

class UserEntityMapper extends Mapper<UserResponseModel, UserEntity> {
  const UserEntityMapper();
  @override
  UserEntity call(UserResponseModel model) => UserEntity(id: model.id, name: model.name);
}
```

```
✅ Strict SRP — model is pure DTO, mapper is pure conversion
✅ Easy to unit test in isolation
✅ Composition with static const for nested models
⚠️  2 extra classes per endpoint (request mapper + entity mapper)
⚠️  1 extra file per model subdirectory
⚠️  Barrel file updates required
⚠️  Repository needs static const declarations for every mapper
⚠️  Not the Flutter community standard
⚠️  Imported from Java/Spring ecosystem (MapStruct) — not idiomatic Dart
```

**Best for:** Enterprise teams with strict architectural audits, or projects migrating from Android/Java.

---

### Approach D: Model extends Entity (Reso Coder original)

```dart
class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({required String text, required int number})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) => ...;
  Map<String, dynamic> toJson() => ...;
}
```

```
✅ Zero conversion code — model IS the entity
✅ Simplest possible approach
❌ Cannot transform fields (e.g., milliseconds → DateTime)
❌ Entity inherits model's JSON annotations
❌ Tight coupling — entity shape is locked to API shape
❌ Reso Coder himself moved away from this approach
```

**Best for:** Prototypes or apps where API and domain shapes are always identical. Not recommended for production.

---

### Approach E: `auto_mappr` code generation

```dart
@AutoMappr([MapType<UserResponseModel, UserEntity>()])
class Mappr extends $Mappr {}
```

```
✅ Zero manual mapping code
✅ Catches missing fields at build time
⚠️  Another code-gen dependency (slower builds)
⚠️  Hard to debug generated code
⚠️  Low community adoption
⚠️  Overkill when toEntity is 3-8 lines
```

**Best for:** Very large projects (100+ models) where build time is already high and one more generator doesn't matter.

---

### Side-by-side summary

| Concern | A: toEntity | B: Extension | C: Mapper class | D: Extends | E: auto_mappr |
|---|---|---|---|---|---|
| Community adoption | ★★★★★ | ★★☆☆☆ | ★★☆☆☆ | ★★★☆☆ (outdated) | ★☆☆☆☆ |
| Extra files/classes | 0 | 0 | 2 per endpoint | 0 | 1 config class |
| SRP compliance | Soft violation | Clean | Clean | Violated | Clean |
| Discoverability | Excellent | Good | Fair | Excellent | Poor |
| IDE autocomplete | ✓ | ✓ | ✗ | ✓ | ✗ |
| Compile safety | Same | Same | Same | Same | Same + build-time |
| Complex mapping | Gets messy | Clean | Clean | Cannot handle | Clean |
| Performance | Zero overhead | Zero overhead | Zero overhead | Zero overhead | Zero overhead |
| Learning curve | None | Low | Medium | None | High |
| Onboarding | Instant | Easy | Needs docs | Instant | Needs docs |

---

## 5. Real Examples From This Codebase

### Simple 1:1 mapping (RegisterResponseModel)

```dart
// lib/features/registration/data/models/register_initiate/register_response_model.dart

RegisterEntity get toEntity => RegisterEntity(
  registrationId: registrationId,
  otpReference: otpReference,
  expiresAt: expiresAt,
  maskedPhone: maskedPhone,
);
```

4 lines. No transformation. Mapper class would add a file, a class declaration, a constructor, an `@override`, and a `static const` in the repository — all to do the same 4-line field copy.

### Nested model conversion (LoginResponseModel)

```dart
// lib/features/auth/data/models/login_response/login_response_model.dart

// Parent model delegates to child model's toEntity
LoginEntity get toEntity => LoginEntity(
  success: success,
  data: data.toEntity,        // DataModel.toEntity
  message: message,
  links: links.toEntity,      // LinksModel.toEntity
);

// Child model (same file)
LoginDataEntity get toEntity => LoginDataEntity(
  user: user.toEntity,        // UserModel.toEntity
  tokens: tokens.toEntity,    // TokensModel.toEntity
  session: session.toEntity,  // SessionModel.toEntity
  passwordChangeRequired: passwordChangeRequired,
);
```

Each nested model handles its own conversion. The chain reads naturally: `result.data.toEntity` → calls `data.toEntity` → calls `user.toEntity`, `tokens.toEntity`, etc. No mapper composition, no `static const` chains.

### Complex mapping with enum + list (AccountVerificationResponseModel)

```dart
// lib/features/registration/data/models/otp_verify/otp_verify_response_model.dart

AccountVerificationEntity get toEntity => AccountVerificationEntity(
  action: _mapAction(action),                            // String → enum
  existingAccounts: existingAccounts.map((e) => e.toEntity).toList(), // List<Model> → List<Entity>
  completion: completion?.toEntity,                       // Nullable nested model
  message: message,
);

VerificationAction _mapAction(String action) {
  switch (action.toUpperCase()) {
    case 'CHOOSE':
      return VerificationAction.choose;
    case 'COMPLETED':
      return VerificationAction.completed;
    default:
      throw Exception('Unknown verification action: $action');
  }
}
```

This is the most complex conversion in the codebase — string-to-enum, list mapping, nullable nested model. Still readable. Still contained in the model file. A mapper class would not make this simpler.

### Request model with fromParams (proposed)

```dart
// Current: inline construction in repository
RegisterRequestModel(
  firstName: params.firstName,
  lastName: params.lastName,
  mobile: params.mobile,
  gender: params.gender.toUpperCase(),
  dateOfBirth: params.dateOfBirth,
  termsAccepted: params.termsAccepted,
)

// Proposed: factory on the model
factory RegisterRequestModel.fromParams(RegisterParams params) =>
    RegisterRequestModel(
      firstName: params.firstName,
      lastName: params.lastName,
      mobile: params.mobile,
      gender: params.gender.toUpperCase(),
      dateOfBirth: params.dateOfBirth,
      termsAccepted: params.termsAccepted,
    );

// Repository becomes:
RegisterRequestModel.fromParams(params)
```

The `fromParams` factory moves the conversion out of the repository into the model, making the repository method a clean two-liner.

---

## 6. Handling Complex Conversions

### Rule of thumb

| toEntity complexity | Approach |
|---|---|
| 1-8 lines, 1:1 field copy | `toEntity` getter on model |
| 8-20 lines, enums/lists/nullables | `toEntity` getter + private helper methods |
| 20+ lines, multiple output entities | Consider extracting to an extension method in a separate file |

### Private helper pattern for enum/list conversions

```dart
class SomeResponseModel {
  // ... fields, fromJson ...

  SomeEntity get toEntity => SomeEntity(
    status: _mapStatus(statusString),
    items: items.map(_mapItem).toList(),
  );

  // Private helpers — colocated, easy to find
  SomeStatus _mapStatus(String s) => switch (s) {
    'ACTIVE'   => SomeStatus.active,
    'INACTIVE' => SomeStatus.inactive,
    _          => throw Exception('Unknown status: $s'),
  };

  SomeItemEntity _mapItem(SomeItemModel m) => SomeItemEntity(
    id: m.id,
    name: m.name,
  );
}
```

### Escalation: extension method for very complex cases

If `toEntity` plus helpers exceeds ~20 lines and the model file becomes hard to read:

```dart
// some_response_model.dart — pure DTO
@JsonSerializable(createToJson: false)
class SomeResponseModel {
  // fields + fromJson only
}

// some_response_model_x.dart — conversion extension
extension SomeResponseModelX on SomeResponseModel {
  SomeEntity toEntity() => SomeEntity(
    // complex 20+ line conversion here
  );
}
```

Export both from the barrel file. The repository code stays the same: `result.data.toEntity`.

---

## 7. The One Rule That Makes This Safe

**All entity constructor parameters MUST be `required`.**

```dart
// ✅ CORRECT — compiler catches missing fields
class RegisterEntity {
  final String registrationId;
  final String otpReference;
  final String expiresAt;
  final String maskedPhone;

  const RegisterEntity({
    required this.registrationId,   // ← required
    required this.otpReference,     // ← required
    required this.expiresAt,        // ← required
    required this.maskedPhone,      // ← required
  });
}
```

```dart
// ❌ DANGEROUS — missing field compiles silently
class RegisterEntity {
  final String registrationId;
  final String otpReference;
  final String expiresAt;
  final String maskedPhone;

  const RegisterEntity({
    required this.registrationId,
    this.otpReference = '',        // ← default value: silent bug risk
    required this.expiresAt,
    this.maskedPhone = '',         // ← default value: silent bug risk
  });
}
```

### Why this matters

When a new field is added to the entity, the compiler forces every `toEntity` that constructs it to provide the new field. This is true regardless of whether you use `toEntity`, mappers, extensions, or any other approach. `required` parameters are the universal safety net.

**Exception:** Only use optional/nullable params when the domain genuinely allows null (e.g., `String? lastVisit` where a patient may not have visited).

---

## 8. When To Escalate

The `toEntity`/`fromParams` pattern handles 90% of cases. For the remaining 10%:

| Scenario | Solution |
|---|---|
| toEntity > 20 lines | Extract to extension method in separate file |
| One model → multiple entities | Multiple toEntity variants: `toSummaryEntity`, `toDetailEntity` |
| One model used across features | Keep toEntity for primary use, extension for secondary |
| Conversion requires injected dependency | Use a mapper class (rare — avoid if possible) |

---

## 9. Conventions & Checklist

### Naming

| Direction | Convention | Example |
|---|---|---|
| Response → Entity | `get toEntity` (getter) | `model.toEntity` |
| Params → Request | `factory fromParams(Params)` | `RequestModel.fromParams(params)` |

### Response model structure

```dart
@JsonSerializable(createToJson: false)  // Response-only: no toJson needed
class XResponseModel {
  // fields...

  XResponseModel({required this.fieldA, ...});

  factory XResponseModel.fromJson(Map<String, dynamic> json) =>
      _$XResponseModelFromJson(json);

  XEntity get toEntity => XEntity(
    fieldA: fieldA,
    // ...
  );
}
```

### Request model structure

```dart
@JsonSerializable()
class XRequestModel {
  // fields...

  XRequestModel({required this.fieldA, ...});

  factory XRequestModel.fromParams(XParams params) =>
      XRequestModel(
        fieldA: params.fieldA,
        // ...
      );

  factory XRequestModel.fromJson(Map<String, dynamic> json) =>
      _$XRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$XRequestModelToJson(this);
}
```

### Repository structure

```dart
@override
Result<XEntity> doSomething(XParams params) async {
  return handleException(() async {
    final result = await remote.doSomething(
      XRequestModel.fromParams(params),
    );
    return result.data.toEntity;
  });
}
```

### Checklist for new features

- [ ] Response model has `toEntity` getter returning the domain entity
- [ ] Request model has `factory fromParams(Params)` constructor
- [ ] All entity constructor params are `required` (unless genuinely nullable)
- [ ] Entity has zero imports from the data layer
- [ ] Model imports entity (data depends on domain — correct direction)
- [ ] Repository uses `RequestModel.fromParams(params)` and `result.data.toEntity`
- [ ] No inline field-by-field construction in the repository
- [ ] Nested models each have their own `toEntity`
- [ ] Private helper methods for enum/list conversions live on the model
- [ ] `fvm flutter analyze` passes

---

## 10. References

### Primary (used in this decision)

| Source | Pattern | Link |
|---|---|---|
| Reso Coder — Flutter TDD Clean Architecture | Model extends Entity → updated to `toEntity()` | [resocoder.com](https://resocoder.com/2019/09/09/flutter-tdd-clean-architecture-course-4-data-layer-overview-models/) |
| Rubem Vasconcelos — Clean Architecture with Flutter | `toEntity()` + `fromDomain()` | [dev.to](https://dev.to/rubemfsv/clean-architecture-applying-with-flutter-487b) |
| Enes Akbal — Flutter-Clean-Architecture-Example | `toEntity()` on all models | [github.com](https://github.com/enesakbal/Flutter-Clean-Architecture-Example) |
| Flutter Clean Architecture topic (GitHub) | Majority use `toEntity()` | [github.com/topics](https://github.com/topics/flutter-clean-architecture) |

### Supplementary

| Source | Link |
|---|---|
| Models vs Entities in Flutter (DEV Community) | [dev.to](https://dev.to/yusufhnf/understanding-clean-architecture-models-vs-entities-in-flutter-applications-1pm5) |
| Flutter Clean Architecture Guide (Gist) | [gist.github.com](https://gist.github.com/ahmedyehya92/0257809d6fbd3047e408869f3d747a2c) |
| Flutter Clean Architecture — hadiuzzaman524 | [github.com](https://github.com/hadiuzzaman524/flutter-clean-architecture) |
| Flutter Clean Architecture Example — guilherme-v | [github.com](https://github.com/guilherme-v/flutter-clean-architecture-example) |

---

## Appendix: Why We Tried Mapper Classes (And Why We Reverted)

The `refactor/mapper-abstraction` branch introduced a generic `Mapper<Input, Output>` base class modeled after the project's `Usecase<T, P>` pattern. It was architecturally clean — strict SRP, composable, testable in isolation.

**Why it was reverted:**

1. **Not the Flutter community standard.** Every major reference uses `toEntity`. A new developer joining this project would need to learn a custom pattern.
2. **120 extra classes for 60 endpoints.** The project already has models, entities, params, usecases, repositories, data sources, and cubits per feature. Adding 2 mapper classes per endpoint doubled the data layer's file count for no measurable benefit.
3. **Identical compile safety.** The mapper's `Mapper<Input, Output>` type signature does not check field completeness. The safety comes from `required` entity constructor params — which work identically with `toEntity`.
4. **Identical performance.** Both `static const` mappers and `get toEntity` getters have zero runtime overhead.
5. **The pattern originated in Java/Spring** (MapStruct), where reflection and code generation make mapper classes nearly free. In Dart, every mapper is hand-written boilerplate.

The mapper base class remains available in the codebase for the rare case where a conversion genuinely needs its own class (e.g., conversion requiring injected dependencies). But it is not the default.
