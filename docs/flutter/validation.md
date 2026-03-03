# Form Validation Guide

How form validation works in Niramoy, from atomic rules up to the UI. Read this before building any form.

---

## Table of Contents

1. [How It All Fits Together](#1-how-it-all-fits-together)
2. [Validation Rules](#2-validation-rules)
   - [Built-in Rules](#built-in-rules)
   - [The "Skip When Empty" Contract](#the-skip-when-empty-contract)
   - [CustomRule](#customrule)
   - [Writing a New Rule](#writing-a-new-rule)
3. [FieldValidator](#3-fieldvalidator)
   - [Rule Ordering](#rule-ordering)
   - [Using With TextFormField](#using-with-textformfield)
4. [AppValidators](#4-appvalidators)
   - [Required vs Optional Variants](#required-vs-optional-variants)
   - [Adding a New Validator](#adding-a-new-validator)
5. [ValidationMessages](#5-validationmessages)
6. [FormInput\<T\>](#6-forminputt)
   - [Constructors](#constructors)
   - [touch()](#touch)
   - [errorFrom()](#errorfrom)
   - [Why Not formz?](#why-not-formz)
7. [Cubit State](#7-cubit-state)
   - [Field Declarations](#field-declarations)
   - [Error Getters](#error-getters)
   - [isValid](#isvalid)
8. [Cubit Methods](#8-cubit-methods)
   - [onChange Handlers](#onchange-handlers)
   - [Pre-populating (initializeFormData)](#pre-populating-initializeformdata)
   - [Building Params for API](#building-params-for-api)
9. [UI Widgets](#9-ui-widgets)
   - [Field Widgets](#field-widgets)
   - [Submit Button](#submit-button)
10. [Progressive Validation UX](#10-progressive-validation-ux)
11. [Cookbook: Adding a New Form](#11-cookbook-adding-a-new-form)
12. [Common Mistakes](#12-common-mistakes)

---

## 1. How It All Fits Together

```
┌─────────────────────────────────────────────────────────────────┐
│  UI                                                             │
│  Field widgets read state.xyzError                              │
│  Submit button reads state.isValid                              │
└────────────────────────┬────────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────────┐
│  Cubit State (Freezed)                                          │
│                                                                  │
│  Error getters:  field.errorFrom(AppValidators.xyz.call)        │
│  isValid:        AppValidators.xyz(field.value) == null && ...  │
└────────────────────────┬────────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────────┐
│  FormInput<T>                                                    │
│  Wraps value + isDirty flag per field                            │
│  lib/core/forms/form_input.dart                                  │
└────────────────────────┬────────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────────┐
│  AppValidators                                                   │
│  Named, pre-composed FieldValidator instances                    │
│  lib/core/validation/app_validators.dart                         │
└────────────────────────┬────────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────────┐
│  FieldValidator                                                  │
│  Runs a list of ValidationRules, returns first error             │
│  lib/core/validation/field_validator.dart                         │
└────────────────────────┬────────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────────┐
│  ValidationRule (abstract)                                       │
│  One class per concern: RequiredRule, EmailRule, PhoneRule, ...   │
│  lib/core/validation/rules/                                      │
└──────────────────────────────────────────────────────────────────┘
```

Each layer has one job and depends only on the layer below it.

---

## 2. Validation Rules

**File:** `lib/core/validation/validation_rule.dart`

```dart
abstract class ValidationRule {
  const ValidationRule();
  String? validate(String? value);
}
```

A rule checks one thing. Returns an error string on failure, `null` on success. Rules are `const`-constructible and stateless.

### Built-in Rules

| Class | File | Checks | Skips empty? |
|---|---|---|---|
| `RequiredRule(msg)` | `required_rule.dart` | Not null, not blank | No |
| `MinLengthRule(n, msg)` | `min_length_rule.dart` | `trimmed.length >= n` | Yes |
| `MaxLengthRule(n, msg)` | `max_length_rule.dart` | `trimmed.length <= n` | Yes |
| `PatternRule(regex, msg)` | `pattern_rule.dart` | Regex match | Yes |
| `EmailRule(msg)` | `email_rule.dart` | Email format | Yes |
| `PhoneRule(msg)` | `phone_rule.dart` | BD phone `01XXXXXXXXX` | Yes |
| `DobRule()` | `dob_rule.dart` | Non-empty date string | No |
| `CustomRule(fn)` | `custom_rule.dart` | Inline lambda | Caller decides |

### The "Skip When Empty" Contract

Format rules (`EmailRule`, `PhoneRule`, `PatternRule`, `MinLengthRule`, `MaxLengthRule`) return `null` when the value is empty. They only validate non-empty values. This is what makes optional fields work:

- **Required field:** `RequiredRule` + format rules. `RequiredRule` catches empty, format rules catch bad format.
- **Optional field:** format rules only. Empty passes, non-empty must be valid.

### CustomRule

For one-off logic that doesn't justify a new class:

```dart
CustomRule((value) {
  if (value != null && value.contains('admin')) {
    return 'Username cannot contain "admin"';
  }
  return null;
});
```

If you use the same logic twice, promote it to a named rule class.

### Writing a New Rule

```dart
// lib/core/validation/rules/max_value_rule.dart

class MaxValueRule extends ValidationRule {
  const MaxValueRule(this.max, this.message);
  final int max;
  final String message;

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null; // skip when empty
    final parsed = int.tryParse(value);
    if (parsed == null || parsed > max) return message;
    return null;
  }
}
```

Then export it from `lib/core/validation/rules/rules.dart`.

---

## 3. FieldValidator

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

Runs rules in order, returns the **first** failure. The user sees one error at a time — the most fundamental one.

### Rule Ordering

Always declare rules in this order:

1. `RequiredRule` — is it present?
2. `MinLengthRule` / `MaxLengthRule` — is it the right length?
3. `PatternRule` / `EmailRule` / `PhoneRule` — is the format correct?
4. `CustomRule` — business logic

### Using With TextFormField

`FieldValidator` is callable, so it works directly as a `TextFormField.validator`:

```dart
TextFormField(validator: AppValidators.firstName.call)
```

---

## 4. AppValidators

**File:** `lib/core/validation/app_validators.dart`

Pre-composed validators shared across the entire app. Define once, reuse in every form.

```dart
class AppValidators {
  const AppValidators._();

  static final firstName = FieldValidator([
    const RequiredRule(ValidationMessages.nameRequired),
    MinLengthRule(2, ValidationMessages.nameTooShort),
    PatternRule(_namePattern, ValidationMessages.nameInvalid),
  ]);

  static final phone = const FieldValidator([
    RequiredRule(ValidationMessages.phoneRequired),
    PhoneRule(),
  ]);

  // Optional variants — no RequiredRule
  static const optionalEmail = FieldValidator([EmailRule()]);
  static const optionalPhone = FieldValidator([PhoneRule()]);
}
```

### Required vs Optional Variants

| Validator | Has RequiredRule? | Use case |
|---|---|---|
| `AppValidators.phone` | Yes | Registration — mobile is mandatory |
| `AppValidators.optionalPhone` | No | Profile — mobile is optional, but valid if provided |
| `AppValidators.email` | Yes | Sign-up |
| `AppValidators.optionalEmail` | No | Profile — email is optional |

The optional variant has no `RequiredRule`. Format rules skip empty values, so an empty optional field always passes.

### Adding a New Validator

```dart
// 1. Add message to ValidationMessages
static const String postalCodeRequired = 'Postal code is required';
static const String postalCodeInvalid = 'Enter a 4-digit postal code';

// 2. Add validator to AppValidators
static final postalCode = FieldValidator([
  const RequiredRule(ValidationMessages.postalCodeRequired),
  PatternRule(RegExp(r'^\d{4}$'), ValidationMessages.postalCodeInvalid),
]);
```

Never hardcode error strings in `AppValidators` — always reference `ValidationMessages`.

---

## 5. ValidationMessages

**File:** `lib/core/validation/validation_messages.dart`

All user-facing error strings in one place. Grouped by field type.

```dart
class ValidationMessages {
  const ValidationMessages._();

  static const String required         = 'This field is required';
  static const String nameRequired     = 'Name is required';
  static const String nameTooShort     = 'Name must be at least 2 characters';
  static const String nameInvalid      = 'Only letters, spaces, hyphens and dots are allowed';
  static const String phoneRequired    = 'Phone number is required';
  static const String phoneInvalid     = 'Enter a valid phone number';
  static const String emailRequired    = 'Email is required';
  static const String emailInvalid     = 'Enter a valid email address';
  static const String dobRequired      = 'Date of Birth is required';
  static const String genderRequired   = 'Gender is required';
  // ...
}
```

When adding a new message: add it here, reference it from the rule constructor. Never pass a raw string literal to a rule.

---

## 6. FormInput\<T\>

**File:** `lib/core/forms/form_input.dart`

```dart
class FormInput<T> extends Equatable {
  const FormInput.pure(this.value) : isDirty = false;
  const FormInput.dirty(this.value) : isDirty = true;

  final T value;
  final bool isDirty;

  FormInput<T> touch(T newValue) => FormInput.dirty(newValue);

  String? errorFrom(String? Function(T) validator) =>
      isDirty ? validator(value) : null;

  @override
  List<Object?> get props => [value, isDirty];
}
```

`FormInput<T>` bundles a field's **value** with its **dirty state**. It does not validate anything — it only tracks whether the user has interacted with the field.

### Constructors

| Constructor | isDirty | When to use |
|---|---|---|
| `FormInput.pure(value)` | `false` | Initial/default values, pre-populated data from server |
| `FormInput.dirty(value)` | `true` | After user interaction (usually via `touch()`) |

### touch()

Transitions a field to dirty with a new value. Used in cubit `onXxxChanged` methods:

```dart
void onFirstNameChanged(String value) =>
    emit(state.copyWith(firstName: state.firstName.touch(value)));
```

Always use `state.field.touch(value)` — it preserves the generic type parameter. This matters for `FormInput<DateTime?>` where `FormInput.dirty(dateTimeValue)` would infer `FormInput<DateTime>` (wrong) instead of `FormInput<DateTime?>` (correct).

### errorFrom()

Runs a validator only when the field is dirty. Returns `null` when pure (error suppressed).

```dart
// String fields — pass the validator's .call method
String? get firstNameError => firstName.errorFrom(AppValidators.firstName.call);
String? get emailError     => email.errorFrom(AppValidators.optionalEmail.call);

// Non-String fields — lambda to transform the value first
String? get dobError => dob.errorFrom(
    (v) => AppValidators.dateOfBirth(v?.toIso8601String()));
```

`errorFrom` eliminates the manual `isDirty ? validator(value) : null` pattern. You cannot forget the dirty check or the `.value` access — both are handled internally.

### Why Not formz?

The `formz` package requires **per field**: 1 error enum + 1 class extending `FormzInput` + 1 extension to map enum back to string. For 5 fields that is ~150 lines of boilerplate.

Our approach requires **0 extra classes per field**. The same `FormInput<T>` is reused everywhere, `AppValidators` provides validation through composable rules, and errors are strings from the start — no enum roundtrip.

| | formz | Our approach |
|---|---|---|
| Per new field type | ~30 lines (enum + class + extension) | 0 extra classes |
| Error type | Enum (mapped back to String for display) | String directly |
| Rule composition | Monolithic per-field class | Atomic rules, mix-and-match |
| Optional variant | Separate class | Same FormInput, different AppValidator |
| Touched/dirty | Built-in via `displayError` | Built-in via `errorFrom()` |
| External dependency | Yes | No |

---

## 7. Cubit State

The state is a Freezed class with `FormInput<T>` fields and computed getters.

### Field Declarations

```dart
@freezed
abstract class RegistrationFormState with _$RegistrationFormState {
  const RegistrationFormState._();

  const factory RegistrationFormState({
    @Default(FormInput.pure('')) FormInput<String> firstName,
    @Default(FormInput.pure('')) FormInput<String> lastName,
    @Default(FormInput.pure('')) FormInput<String> mobile,
    @Default(FormInput<DateTime?>.pure(null)) FormInput<DateTime?> dob,
    @Default(FormInput.pure('')) FormInput<String> gender,
    @Default(true) bool termsAccepted,
    @Default(RegisterInitiateIdle()) RegisterOperationState registerState,
  }) = _RegistrationFormState;

  factory RegistrationFormState.initial() => const RegistrationFormState();
```

- String fields default to `FormInput.pure('')`
- Nullable types need the explicit generic: `FormInput<DateTime?>.pure(null)`
- Non-form fields (`termsAccepted`, `registerState`, `userId`) stay as plain types

### Error Getters

One line per field using `errorFrom()`:

```dart
  String? get firstNameError => firstName.errorFrom(AppValidators.firstName.call);
  String? get lastNameError  => lastName.errorFrom(AppValidators.lastName.call);
  String? get mobileError    => mobile.errorFrom(AppValidators.phone.call);
  String? get genderError    => gender.errorFrom(AppValidators.gender.call);

  // Non-String fields use a lambda
  String? get dateOfBirthError =>
      dob.errorFrom((v) => AppValidators.dateOfBirth(v?.toIso8601String()));
```

For optional fields in profile:

```dart
  String? get emailError => email.errorFrom(AppValidators.optionalEmail.call);
  String? get phoneError => mobile.errorFrom(AppValidators.optionalPhone.call);
```

Fields with no validator (`bloodGroup`, `nationalId`, `address`) have no error getter.

### isValid

`isValid` is **touch-blind** — it ignores `isDirty` and checks the raw values:

```dart
  bool get isValid =>
      AppValidators.firstName(firstName.value) == null &&
      AppValidators.lastName(lastName.value) == null &&
      AppValidators.phone(mobile.value) == null &&
      AppValidators.dateOfBirth(dob.value?.toIso8601String()) == null &&
      AppValidators.gender(gender.value) == null;
```

Why two separate mechanisms:

| | Error getters | isValid |
|---|---|---|
| Question | Should I **show** an error? | Are all values **actually valid**? |
| Checks isDirty | Yes (via `errorFrom`) | No |
| Used by | Field widgets (`errorText`) | Submit button (`onPressed`) |

---

## 8. Cubit Methods

### onChange Handlers

Each handler calls `touch()` to mark the field dirty and set the new value:

```dart
void onFirstNameChanged(String value) =>
    emit(state.copyWith(firstName: state.firstName.touch(value)));

void onDobChanged(DateTime value) =>
    emit(state.copyWith(dob: state.dob.touch(value)));

void onGenderChanged(String? value) =>
    emit(state.copyWith(gender: state.gender.touch(value ?? '')));

void onBloodGroupChanged(String? value) => emit(
    state.copyWith(
      bloodGroup: state.bloodGroup.touch((value ?? '').toUpperCase()),
    ),
  );
```

### Pre-populating (initializeFormData)

When loading a form with server data, use `FormInput.pure()` for every field:

```dart
void initializeFormData(UserInfoEntity? user) {
  if (user == null) return;
  emit(ProfileFormState(
    userId: user.userId,
    firstName: FormInput.pure(user.firstName ?? ''),
    lastName: FormInput.pure(user.lastName ?? ''),
    dateOfBirth: FormInput.pure(_parseDateOfBirth(user.dateOfBirth)),
    gender: FormInput.pure(_toTitleCase(user.gender ?? '')),
    bloodGroup: FormInput.pure((user.bloodGroup ?? '').toUpperCase()),
    // ...
  ));
}
```

`FormInput.pure()` means:
- No errors shown (fields are not dirty)
- `isValid` returns `true` if the server data is valid (button enabled immediately)
- The first edit marks that single field dirty

### Building Params for API

Read `.value` from each `FormInput` field:

```dart
UpdateProfileParams? buildParams() {
  if (!state.isValid) return null;
  return UpdateProfileParams(
    userId: state.userId,
    firstName: state.firstName.value.trim(),
    lastName: state.lastName.value.trim(),
    dateOfBirth: _formatDateForApi(state.dateOfBirth.value),
    gender: state.gender.value.isNotEmpty
        ? state.gender.value.toUpperCase()
        : null,
    // ...
  );
}
```

---

## 9. UI Widgets

### Field Widgets

Each field widget is a `BlocBuilder` that reads **only its own error getter** via `buildWhen`:

```dart
class NameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegistrationFormCubit>();
    return BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
      buildWhen: (prev, curr) =>
          prev.firstNameError != curr.firstNameError ||
          prev.lastNameError != curr.lastNameError,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: AppTextField.name(
                labelText: RegistrationStrings.firstNameRequired,
                errorText: state.firstNameError,
                onChanged: cubit.onFirstNameChanged,
              ),
            ),
            Expanded(
              child: AppTextField.name(
                labelText: RegistrationStrings.lastNameRequired,
                errorText: state.lastNameError,
                onChanged: cubit.onLastNameChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}
```

For fields that display the current value (dropdowns, date pickers), read `.value`:

```dart
value: state.bloodGroup.value.isNotEmpty ? state.bloodGroup.value : null,
initialValue: state.dateOfBirth.value,
```

### Submit Button

The button depends on `isValid` (touch-blind) and loading state.

**Registration — single cubit:**

```dart
BlocBuilder<RegistrationFormCubit, RegistrationFormState>(
  buildWhen: (p, c) =>
      p.isValid != c.isValid || p.registerState != c.registerState,
  builder: (context, state) {
    final isLoading = state.registerState is RegisterInitiateLoading;
    return AppButton.filled(
      title: AppStrings.next,
      isLoading: isLoading,
      onPressed: isLoading || !state.isValid ? null : onRegisterPressed,
    );
  },
);
```

**Profile — two cubits (form validity + update operation):**

```dart
// Outer: form validity drives onPressed
BlocBuilder<ProfileFormCubit, ProfileFormState>(
  buildWhen: (prev, curr) => prev.isValid != curr.isValid,
  builder: (context, formState) {
    return UpdateButton(
      onPressed: formState.isValid ? _handleSubmit : null,
    );
  },
),

// Inner (UpdateButton): loading state overrides onPressed
BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
  builder: (context, state) {
    final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
    return AppButton.filled(
      isLoading: isLoading,
      onPressed: isLoading ? null : onPressed, // null from either source
    );
  },
);
```

`onPressed: null` makes Flutter render the button as disabled.

---

## 10. Progressive Validation UX

Three states the user experiences:

```
  FORM OPENS
  ──────────────────────────────────────────
  All fields: FormInput.pure → isDirty = false
  errorFrom() returns null for all fields
  isValid = false (empty values)

  UI: No errors. Button DISABLED.
                    │
                    │ user types "A" in first name
                    ▼
  PARTIAL INPUT
  ──────────────────────────────────────────
  firstName: dirty("A") → errorFrom returns "Name must be at least 2 characters"
  Other fields: still pure → errorFrom returns null
  isValid = false

  UI: Only first name error shown. Button DISABLED.
                    │
                    │ user fills all required fields correctly
                    ▼
  ALL VALID
  ──────────────────────────────────────────
  All required fields pass validation
  isValid = true

  UI: No errors on valid fields. Button ENABLED.
```

**Pre-populated form (profile):**

```
  FORM OPENS WITH SERVER DATA
  ──────────────────────────────────────────
  All fields: FormInput.pure(serverValue)
  isDirty = false → errorFrom returns null
  isValid = true (server data is valid)

  UI: Zero errors. Button ENABLED immediately.
                    │
                    │ user clears first name
                    ▼
  firstName: dirty("") → errorFrom returns "Name is required"
  isValid = false

  UI: First name error shown. Button DISABLED.
```

---

## 11. Cookbook: Adding a New Form

### Step 1 — Validators

If the form has field types not already in `AppValidators`, add them. Skip if existing validators cover your fields.

```dart
// ValidationMessages
static const String postalCodeRequired = 'Postal code is required';
static const String postalCodeInvalid = 'Enter a 4-digit postal code';

// AppValidators
static final postalCode = FieldValidator([
  const RequiredRule(ValidationMessages.postalCodeRequired),
  PatternRule(RegExp(r'^\d{4}$'), ValidationMessages.postalCodeInvalid),
]);
```

### Step 2 — State

```dart
@freezed
abstract class AddressFormState with _$AddressFormState {
  const AddressFormState._();

  const factory AddressFormState({
    @Default(FormInput.pure('')) FormInput<String> street,
    @Default(FormInput.pure('')) FormInput<String> postalCode,
    @Default(FormInput.pure('')) FormInput<String> city, // no validator
  }) = _AddressFormState;

  factory AddressFormState.initial() => const AddressFormState();

  // Error getters
  String? get streetError => street.errorFrom(AppValidators.required.call);
  String? get postalCodeError => postalCode.errorFrom(AppValidators.postalCode.call);
  // city has no validator — no getter

  // isValid
  bool get isValid =>
      AppValidators.required(street.value) == null &&
      AppValidators.postalCode(postalCode.value) == null;
}
```

### Step 3 — Cubit

```dart
@injectable
class AddressFormCubit extends Cubit<AddressFormState> {
  AddressFormCubit() : super(AddressFormState.initial());

  void onStreetChanged(String value) =>
      emit(state.copyWith(street: state.street.touch(value)));

  void onPostalCodeChanged(String value) =>
      emit(state.copyWith(postalCode: state.postalCode.touch(value)));

  void onCityChanged(String value) =>
      emit(state.copyWith(city: state.city.touch(value)));
}
```

### Step 4 — Field widget

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

### Step 5 — Submit button

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

### Step 6 — Codegen

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

---

## 12. Common Mistakes

### 1. Bypassing errorFrom with manual isDirty check

```dart
// WRONG — manual pattern, easy to forget isDirty or .value
String? get nameError =>
    name.isDirty ? AppValidators.name(name.value) : null;

// CORRECT — errorFrom handles both
String? get nameError => name.errorFrom(AppValidators.name.call);
```

### 2. Using FormInput.dirty() in initializeFormData

```dart
// WRONG — shows errors immediately on a pre-populated form
firstName: FormInput.dirty(user.firstName ?? ''),

// CORRECT — no errors shown, button enabled if data is valid
firstName: FormInput.pure(user.firstName ?? ''),
```

### 3. Reading FormInput instead of .value in widgets

```dart
// WRONG — passes FormInput<String> where String is expected
value: state.bloodGroup,

// CORRECT
value: state.bloodGroup.value,
```

### 4. Missing buildWhen on field widgets

```dart
// WRONG — rebuilds on every state change
BlocBuilder<FormCubit, FormState>(
  builder: (context, state) { ... },
);

// CORRECT — rebuilds only when this field's error changes
BlocBuilder<FormCubit, FormState>(
  buildWhen: (p, c) => p.streetError != c.streetError,
  builder: (context, state) { ... },
);
```

### 5. Enabling the button based on dirty state

```dart
// WRONG — enables just because user typed
onPressed: state.firstName.isDirty ? _submit : null,

// CORRECT — enables only when all values pass validation
onPressed: state.isValid ? _submit : null,
```

### 6. Putting validation logic in the widget

```dart
// WRONG — validation in the view layer
final error = state.firstName.value.length < 2 ? 'Too short' : null;

// CORRECT — read the pre-computed getter
errorText: state.firstNameError,
```

### 7. Hardcoding error messages

```dart
// WRONG
static final phone = FieldValidator([RequiredRule('Phone number is required')]);

// CORRECT
static final phone = const FieldValidator([RequiredRule(ValidationMessages.phoneRequired)]);
```

### 8. Using FormInput.dirty() instead of touch() in cubit methods

```dart
// WRONG — Dart infers FormInput<DateTime>, not FormInput<DateTime?>
emit(state.copyWith(dob: FormInput.dirty(value)));

// CORRECT — touch() preserves the generic type
emit(state.copyWith(dob: state.dob.touch(value)));
```

### 9. Forgetting to export a new rule

All rules must be exported from `lib/core/validation/rules/rules.dart`:

```dart
export 'custom_rule.dart';
export 'email_rule.dart';
export 'max_length_rule.dart';
// ... add your new rule here
```
