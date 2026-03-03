# Validation Guide

A complete reference for the Niramoy validation system — from low-level rules to the UX behavior visible to the user.

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Layer 1 — ValidationRule (Strategy)](#2-layer-1--validationrule-strategy)
   - [Built-in Rules](#built-in-rules)
   - [CustomRule — one-off validations](#customrule--one-off-validations)
   - [Writing a New Rule](#writing-a-new-rule)
3. [Layer 2 — FieldValidator (Compositor)](#3-layer-2--fieldvalidator-compositor)
4. [Layer 3 — AppValidators (App-level Registry)](#4-layer-3--appvalidators-app-level-registry)
   - [Required vs Optional Variants](#required-vs-optional-variants)
   - [Adding a New Named Validator](#adding-a-new-named-validator)
5. [Layer 4 — FormInput\<T\> (Touched/Dirty State)](#5-layer-4--forminputt-toucheddirty-state)
   - [Why FormInput?](#why-forminput)
   - [API Reference](#api-reference)
6. [Layer 5 — Cubit State (Error Getters + isValid)](#6-layer-5--cubit-state-error-getters--isvalid)
   - [Error Getters](#error-getters)
   - [isValid](#isvalid)
7. [Layer 6 — UI Widgets (Consuming Errors)](#7-layer-6--ui-widgets-consuming-errors)
   - [Field Widgets](#field-widgets)
   - [Submit Button](#submit-button)
8. [Progressive Validation UX](#8-progressive-validation-ux)
9. [Building a New Form — Step-by-Step](#9-building-a-new-form--step-by-step)
10. [Validation Messages](#10-validation-messages)
11. [Common Mistakes](#11-common-mistakes)

---

## 1. Architecture Overview

The system has six layers. Each layer has one job and knows nothing about the layers above it.

```
┌─────────────────────────────────────────────────────────────┐
│  UI Layer (Field widgets + Submit button)                   │
│  Reads: state.xyzError, state.isValid                       │
└────────────────────┬────────────────────────────────────────┘
                     │ reads
┌────────────────────▼────────────────────────────────────────┐
│  Cubit State  (error getters, isValid computed property)    │
│  FormInput fields with .isDirty gate                        │
└────────────────────┬────────────────────────────────────────┘
                     │ uses
┌────────────────────▼────────────────────────────────────────┐
│  FormInput<T>  (value + dirty flag per field)               │
│  lib/core/forms/form_input.dart                             │
└────────────────────┬────────────────────────────────────────┘
                     │ calls
┌────────────────────▼────────────────────────────────────────┐
│  AppValidators  (named, pre-composed validators)            │
│  lib/core/validation/app_validators.dart                    │
└────────────────────┬────────────────────────────────────────┘
                     │ composes
┌────────────────────▼────────────────────────────────────────┐
│  FieldValidator  (runs rules in order, returns first error) │
│  lib/core/validation/field_validator.dart                   │
└────────────────────┬────────────────────────────────────────┘
                     │ implements
┌────────────────────▼────────────────────────────────────────┐
│  ValidationRule  (single-concern Strategy)                  │
│  lib/core/validation/validation_rule.dart                   │
│  lib/core/validation/rules/                                 │
└─────────────────────────────────────────────────────────────┘
```

Data flows **downward** for definition (rules → validator → named validator) and **upward** for consumption (state reads validators → UI reads state).

---

## 2. Layer 1 — ValidationRule (Strategy)

**File:** `lib/core/validation/validation_rule.dart`

```dart
abstract class ValidationRule {
  const ValidationRule();
  String? validate(String? value);
}
```

Each rule encapsulates **one** validation concern. It returns an error string if the value is invalid, or `null` if it passes. Rules are stateless and `const`-constructible.

### Built-in Rules

| Class | File | What it checks | Skip when empty? |
|---|---|---|---|
| `RequiredRule` | `required_rule.dart` | Non-null, non-blank | No — this is the presence check |
| `MinLengthRule(n)` | `min_length_rule.dart` | `length >= n` (trimmed) | Yes |
| `MaxLengthRule(n)` | `max_length_rule.dart` | `length <= n` (trimmed) | Yes |
| `PatternRule(regex, msg)` | `pattern_rule.dart` | Regex match | Yes |
| `EmailRule` | `email_rule.dart` | Standard email format | Yes |
| `PhoneRule` | `phone_rule.dart` | BD phone `01XXXXXXXXX` (strips spaces/hyphens) | Yes |
| `DobRule` | `dob_rule.dart` | Non-empty ISO8601 date string | No — delegates to RequiredRule behavior |
| `CustomRule(fn)` | `custom_rule.dart` | Inline lambda — one-off logic | Caller decides |

**The "skip when empty" contract:** format rules (Email, Phone, Pattern, MinLength, MaxLength) skip validation when the value is empty. This means you can use them without `RequiredRule` to make a field **optional-but-valid-if-provided**. Always put `RequiredRule` first if the field is mandatory.

### CustomRule — one-off validations

Use `CustomRule` when you need a one-time validation that does not justify its own class:

```dart
CustomRule((value) {
  if (value != null && value.trim() == context.read<AuthCubit>().state.username) {
    return 'New username must differ from current';
  }
  return null;
});
```

Do **not** use `CustomRule` for logic that appears in more than one place — create a named rule class instead.

### Writing a New Rule

```dart
// lib/core/validation/rules/max_value_rule.dart
import 'package:niramoy_health_app/core/validation/validation_rule.dart';

class MaxValueRule extends ValidationRule {
  const MaxValueRule(this.max, this.message);

  final int max;
  final String message;

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null; // skip if empty
    final parsed = int.tryParse(value);
    if (parsed == null || parsed > max) return message;
    return null;
  }
}
```

Rules for writing rules:
- Extend `ValidationRule`, add `const` constructor.
- Skip validation for null/empty if the rule is a format rule (not a presence check).
- Return a **non-null string** on failure, `null` on success.
- Export it from `lib/core/validation/rules/rules.dart`.

---

## 3. Layer 2 — FieldValidator (Compositor)

**File:** `lib/core/validation/field_validator.dart`

```dart
class FieldValidator {
  const FieldValidator(this._rules);
  final List<ValidationRule> _rules;

  String? call(String? value) {
    for (final rule in _rules) {
      final error = rule.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}
```

`FieldValidator` is a callable class. It runs rules **in the order they are declared** and returns the **first failure**. A user sees one error at a time — the most fundamental one first (required → length → format).

Rule ordering convention:
1. `RequiredRule` — presence
2. `MinLengthRule` / `MaxLengthRule` — length
3. `PatternRule` / `EmailRule` / `PhoneRule` — format
4. `CustomRule` — business logic

`FieldValidator` works as a `TextFormField.validator` callback directly:

```dart
TextFormField(validator: AppValidators.firstName.call)
```

It also works as a plain function call:

```dart
final error = AppValidators.firstName('Jo'); // returns 'Name must be at least 2 characters'
```

---

## 4. Layer 3 — AppValidators (App-level Registry)

**File:** `lib/core/validation/app_validators.dart`

`AppValidators` is a collection of pre-composed, named `FieldValidator` instances shared across the app. Define once, reuse everywhere — in state error getters and in UI if needed.

```dart
class AppValidators {
  const AppValidators._(); // no instances

  static final firstName = FieldValidator([
    const RequiredRule(ValidationMessages.nameRequired),
    MinLengthRule(2, ValidationMessages.nameTooShort),
    PatternRule(_namePattern, ValidationMessages.nameInvalid),
  ]);

  static final phone = const FieldValidator([
    RequiredRule(ValidationMessages.phoneRequired),
    PhoneRule(),
  ]);

  static const optionalEmail = FieldValidator([EmailRule()]);
  static const optionalPhone = FieldValidator([PhoneRule()]);

  // ...
}
```

### Required vs Optional Variants

Some fields are required in one form and optional in another. The pattern:

| Validator | Has `RequiredRule`? | Use case |
|---|---|---|
| `AppValidators.phone` | Yes | Registration — mobile is required |
| `AppValidators.optionalPhone` | No | Profile update — mobile is optional, but must be valid if provided |
| `AppValidators.email` | Yes | Sign-up flows |
| `AppValidators.optionalEmail` | No | Profile update — email is optional |

The optional variant has **no `RequiredRule`** — the format rule skips empty values, so an empty optional field always passes.

### Adding a New Named Validator

1. Add the static field to `AppValidators`.
2. Use `ValidationMessages` for the error string — never hardcode a message in `AppValidators`.
3. Add the message constant to `ValidationMessages` if it does not exist.

```dart
// In AppValidators
static final postalCode = FieldValidator([
  const RequiredRule(ValidationMessages.postalCodeRequired),
  PatternRule(RegExp(r'^\d{4}$'), ValidationMessages.postalCodeInvalid),
]);

// In ValidationMessages
static const String postalCodeRequired = 'Postal code is required';
static const String postalCodeInvalid = 'Enter a 4-digit postal code';
```

---

## 5. Layer 4 — FormInput\<T\> (Touched/Dirty State)

**File:** `lib/core/forms/form_input.dart`

```dart
class FormInput<T> extends Equatable {
  const FormInput.pure(this.value) : isDirty = false;
  const FormInput.dirty(this.value) : isDirty = true;

  final T value;
  final bool isDirty;

  FormInput<T> touch(T newValue) => FormInput.dirty(newValue);

  @override
  List<Object?> get props => [value, isDirty];
}
```

`FormInput<T>` is a small immutable wrapper that bundles **the field's value** with **whether the user has interacted with it**. It does not validate anything — it only tracks state.

### Why FormInput?

Without `FormInput`, all fields start with errors visible (empty required field → error). That is a bad UX: the user hasn't done anything wrong yet.

With `FormInput`:

| State | `isDirty` | Error getter returns |
|---|---|---|
| Field never touched | `false` | `null` — no error shown |
| User typed something | `true` | result of `AppValidators.xyz(value)` |

### API Reference

| Constructor / Method | When to use |
|---|---|
| `FormInput.pure(value)` | Initial field value — not touched. Use in `RegistrationFormState()` defaults and in `ProfileFormCubit.initializeFormData()`. |
| `FormInput.dirty(value)` | Field has been interacted with. You rarely call this directly. |
| `.touch(newValue)` | Call from cubit `onXxxChanged` — marks dirty and sets the new value. |
| `.value` | Read the current value (in `buildParams()`, `isValid`, etc.). |
| `.isDirty` | True if the user has touched this field. Used in error getters. |

**Key insight — `initializeFormData` uses `pure`:**
When the profile form is pre-populated from the server, every field is initialized with `FormInput.pure(serverValue)`. This means:
- The form is valid immediately (button is enabled) — because the server data is valid.
- Zero error messages are shown — because no field is dirty yet.
- The first edit the user makes marks that field dirty and shows its error if invalid.

---

## 6. Layer 5 — Cubit State (Error Getters + isValid)

The cubit state is a Freezed class with computed getters on top of `FormInput<T>` fields.

### Error Getters

Error getters are **touch-gated**: they return `null` until the field is dirty.

```dart
String? get firstNameError =>
    firstName.isDirty ? AppValidators.firstName(firstName.value) : null;
```

The getter calls `AppValidators.firstName` with `.value` (not the raw `FormInput`), and suppresses the result when `isDirty` is false.

Pattern used for all fields:

```dart
String? get xyzError =>
    xyz.isDirty ? AppValidators.xyz(xyz.value) : null;
```

For fields with no validator (e.g. `address`), there is no error getter. The field is still a `FormInput<String>` for consistency with `copyWith` behavior.

### isValid

`isValid` is **touch-blind** — it ignores `isDirty` completely. It evaluates every required field's validator against the current value:

```dart
bool get isValid =>
    AppValidators.firstName(firstName.value) == null &&
    AppValidators.lastName(lastName.value) == null &&
    // ...all required fields
```

This is intentional:
- `isValid == true` → submit button is enabled.
- `isValid == false` → submit button is disabled, regardless of which fields are dirty.

The button state never depends on whether the user has touched any field — only on whether the **actual values** are all valid.

---

## 7. Layer 6 — UI Widgets (Consuming Errors)

### Field Widgets

Field widgets are `BlocBuilder` wrappers that read **only the error getter(s) they care about** via `buildWhen`. They pass the error directly to `AppTextField`'s `errorText` parameter.

```dart
BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
  buildWhen: (prev, curr) => prev.firstNameError != curr.firstNameError,
  builder: (context, state) {
    return AppTextField.name(
      labelText: RegistrationStrings.firstName,
      errorText: state.firstNameError, // null = no error shown
      onChanged: cubit.onFirstNameChanged,
    );
  },
);
```

`buildWhen` ensures the field widget only rebuilds when its own error changes — not on every keystroke in any field.

`onChanged` calls the cubit method:

```dart
void onFirstNameChanged(String value) =>
    emit(state.copyWith(firstName: state.firstName.touch(value)));
```

The `.touch(value)` call marks the field dirty and sets the new value in a single operation.

### Submit Button

The submit button uses a separate `BlocBuilder` that rebuilds only when `isValid` or `registerState` changes:

**Registration:**
```dart
BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
  buildWhen: (p, c) =>
      p.isValid != c.isValid || p.registerState != c.registerState,
  builder: (context, state) {
    final isLoading = state.registerState is RegisterInitiateLoading;
    return AppButton.filled(
      isLoading: isLoading,
      onPressed: isLoading || !state.isValid ? null : onRegisterPressed,
    );
  },
);
```

**Profile update:** the `ProfileFormCubit` state drives the outer `BlocBuilder` that decides `onPressed`, and the inner `UpdateButton` handles the loading state from `UpdateProfileCubit`:

```dart
// profile_update_form.dart
BlocBuilder<ProfileFormCubit, ProfileFormState>(
  buildWhen: (p, c) => p.isValid != c.isValid,
  builder: (context, formState) {
    return UpdateButton(
      onPressed: formState.isValid ? _handleSubmit : null,
    );
  },
),

// update_button.dart
BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
  builder: (context, state) {
    final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
    return AppButton.filled(
      isLoading: isLoading,
      onPressed: isLoading ? null : onPressed, // null when loading OR when form invalid
    );
  },
);
```

`onPressed: null` is how Flutter's `ElevatedButton` / `FilledButton` renders as disabled. No extra `enabled` flag is needed.

---

## 8. Progressive Validation UX

The three UX states and what drives them:

```
┌──────────────────────────────────────────────────────────────────┐
│  STATE 1: Form opens (all fields are pure)                      │
│                                                                  │
│  firstName.isDirty = false  →  firstNameError = null            │
│  lastName.isDirty  = false  →  lastNameError  = null            │
│  isValid = false (values are empty)                              │
│                                                                  │
│  UI: No error text shown. Submit button DISABLED.               │
└──────────────────────────────────────────────────────────────────┘
                              │ user types "A" in first name
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│  STATE 2: One field touched, still invalid                      │
│                                                                  │
│  firstName.isDirty = true   →  firstNameError = "Name must be   │
│  firstName.value   = "A"         at least 2 characters"         │
│  isValid = false                                                 │
│                                                                  │
│  UI: First name error shown. Other fields silent. Button DISABLED│
└──────────────────────────────────────────────────────────────────┘
                              │ user fills all fields validly
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│  STATE 3: All fields valid                                      │
│                                                                  │
│  all isDirty = true (or mixed, doesn't matter for isValid)       │
│  all AppValidators.xyz(value) == null                            │
│  isValid = true                                                  │
│                                                                  │
│  UI: Only errors on actually-invalid dirty fields. Button ENABLED│
└──────────────────────────────────────────────────────────────────┘
```

**Profile-specific case — pre-populated form:**

```
┌──────────────────────────────────────────────────────────────────┐
│  Form opens with server data (all fields pure, values valid)    │
│                                                                  │
│  firstName = FormInput.pure("Rafiq")  →  isDirty = false        │
│  AppValidators.firstName("Rafiq") == null                        │
│  isValid = true                                                  │
│                                                                  │
│  UI: Zero errors shown. Submit button ENABLED immediately.       │
└──────────────────────────────────────────────────────────────────┘
```

---

## 9. Building a New Form — Step-by-Step

### Step 1 — Add validators (if new fields)

Add to `AppValidators` and `ValidationMessages` if the field type doesn't exist yet.

### Step 2 — Write the state

```dart
// lib/features/address/presentation/cubits/address_form_state.dart

@freezed
abstract class AddressFormState with _$AddressFormState {
  const AddressFormState._();

  const factory AddressFormState({
    @Default(FormInput.pure('')) FormInput<String> street,
    @Default(FormInput.pure('')) FormInput<String> postalCode,
  }) = _AddressFormState;

  factory AddressFormState.initial() => const AddressFormState();

  // Touch-gated error getters
  String? get streetError =>
      street.isDirty ? AppValidators.required(street.value) : null;

  String? get postalCodeError =>
      postalCode.isDirty ? AppValidators.postalCode(postalCode.value) : null;

  // Touch-blind — drives button
  bool get isValid =>
      AppValidators.required(street.value) == null &&
      AppValidators.postalCode(postalCode.value) == null;
}
```

### Step 3 — Write the cubit

```dart
@injectable
class AddressFormCubit extends Cubit<AddressFormState> {
  AddressFormCubit() : super(AddressFormState.initial());

  void onStreetChanged(String value) =>
      emit(state.copyWith(street: state.street.touch(value)));

  void onPostalCodeChanged(String value) =>
      emit(state.copyWith(postalCode: state.postalCode.touch(value)));

  bool validate() => state.isValid; // safety net before submit
}
```

### Step 4 — Write field widgets

```dart
BlocBuilder<AddressFormCubit, AddressFormState>(
  buildWhen: (p, c) => p.streetError != c.streetError,
  builder: (context, state) {
    return AppTextField(
      labelText: 'Street',
      errorText: state.streetError,
      onChanged: context.read<AddressFormCubit>().onStreetChanged,
    );
  },
);
```

### Step 5 — Wire the submit button

```dart
BlocBuilder<AddressFormCubit, AddressFormState>(
  buildWhen: (p, c) => p.isValid != c.isValid,
  builder: (context, state) {
    return AppButton.filled(
      title: 'Save',
      onPressed: state.isValid ? _handleSubmit : null,
    );
  },
);
```

### Step 6 — Run codegen

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

---

## 10. Validation Messages

**File:** `lib/core/validation/validation_messages.dart`

All user-facing error strings live here. Never hardcode a validation message anywhere else.

```dart
class ValidationMessages {
  const ValidationMessages._();

  // General
  static const String required = 'This field is required';

  // Name
  static const String nameRequired = 'Name is required';
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String nameInvalid = 'Only letters, spaces, hyphens and dots are allowed';

  // Phone
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid  = 'Enter a valid phone number';

  // Email
  static const String emailRequired = 'Email is required';
  static const String emailInvalid  = 'Enter a valid email address';

  // OTP
  static const String otpRequired   = 'OTP is required';
  static const String otpDigitsOnly = 'OTP must contain digits only';
  static const String otpLength     = 'OTP must be 6 digits';

  // Password
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 8 characters';

  // Date of Birth
  static const String dobRequired = 'Date of Birth is required';
  static const String dobInvalid  = 'Enter a valid date of birth';

  // Gender
  static const String genderRequired = 'Gender is required';
}
```

When adding a new message: add the constant here, reference it from the rule or `AppValidators`. Never pass a raw string literal to a rule constructor in `AppValidators`.

---

## 11. Common Mistakes

### Mistake 1 — Showing errors on an untouched field

```dart
// WRONG — always runs validation, shows error on form open
String? get firstNameError => AppValidators.firstName(firstName);

// CORRECT — suppresses error until dirty
String? get firstNameError =>
    firstName.isDirty ? AppValidators.firstName(firstName.value) : null;
```

### Mistake 2 — Reading `.value` in isValid but forgetting `.value` in error getters

`isValid` and error getters both receive `firstName.value` (a `String`), not `firstName` (a `FormInput<String>`). `AppValidators.firstName` expects `String?`, not `FormInput<String>`.

```dart
// WRONG
String? get firstNameError => AppValidators.firstName(firstName); // type error

// CORRECT
String? get firstNameError =>
    firstName.isDirty ? AppValidators.firstName(firstName.value) : null;
```

### Mistake 3 — Using FormInput.dirty() in initializeFormData

```dart
// WRONG — shows errors immediately when profile loads
emit(ProfileFormState(
  firstName: FormInput.dirty(user.firstName ?? ''),
));

// CORRECT — no errors shown, button enabled if data is valid
emit(ProfileFormState(
  firstName: FormInput.pure(user.firstName ?? ''),
));
```

### Mistake 4 — Forgetting buildWhen on field widgets

Without `buildWhen`, the field widget rebuilds on every state change in the cubit — including keystrokes in other fields. Always narrow the rebuild:

```dart
// WRONG — rebuilds on every state change
BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
  builder: (context, state) { ... },
);

// CORRECT — rebuilds only when this field's error changes
BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
  buildWhen: (prev, curr) => prev.firstNameError != curr.firstNameError,
  builder: (context, state) { ... },
);
```

### Mistake 5 — Putting validation logic in the widget

```dart
// WRONG — validation logic leaks into the view
builder: (context, state) {
  final error = state.firstName.value.length < 2 ? 'Too short' : null;
  return AppTextField(errorText: error);
}

// CORRECT — widget reads a pre-computed getter from state
builder: (context, state) {
  return AppTextField(errorText: state.firstNameError);
}
```

### Mistake 6 — Enabling the button based on dirty state instead of validity

The button should be enabled when the **values are valid**, not when fields have been touched.

```dart
// WRONG — button enables just because the user typed something
onPressed: state.firstName.isDirty ? _submit : null,

// CORRECT — button enables only when all required fields pass validation
onPressed: state.isValid ? _submit : null,
```

### Mistake 7 — Adding a new rule but forgetting to export it

All rules must be exported from `lib/core/validation/rules/rules.dart`:

```dart
// rules.dart
export 'custom_rule.dart';
export 'dob_rule.dart';
export 'email_rule.dart';
export 'max_length_rule.dart';
export 'min_length_rule.dart';
export 'pattern_rule.dart';
export 'phone_rule.dart';
export 'required_rule.dart';
export 'max_value_rule.dart'; // add your new rule here
```
