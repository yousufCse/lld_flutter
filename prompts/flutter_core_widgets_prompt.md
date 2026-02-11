# Flutter Core Widgets Setup — Material 3 Components

Create production-ready, reusable core widgets for a Flutter app following Material 3 design, Clean Architecture, and enterprise best practices. All widgets must be consistent, type-safe, accessible, and performant.

## Design Principles

1. **Material 3 Compliance**: Use `ColorScheme` from theme, support light/dark modes automatically
2. **Consistency**: Use `AppSizes` for dimensions, `AppStrings` for labels, `AppErrors` for messages
3. **Type Safety**: Enum-based variants, no magic strings/numbers
4. **Accessibility**: Semantic labels, proper contrast (WCAG AA), keyboard navigation
5. **Performance**: `const` constructors, minimal rebuilds, efficient widget trees
6. **Naming**: `App{Component}` pattern (e.g., `AppButton`, `AppTextField`)

## Required Widgets

### 1. AppSnackbar — Toast Notifications

**Location:** `lib/core/presentation/widgets/app_snackbar.dart`

**Features:**
- 4 types: success, error, warning, info
- Auto-dismissible (except errors by default)
- Action button support
- Queue management (clears previous)
- Floating behavior with proper margins
- Icon support with type-specific defaults

**Architecture:**
```dart
enum SnackbarType { success, error, warning, info }

class AppSnackbarConfig {
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;             // Default: 4 seconds
  final bool? dismissible;             // Default: true (false for errors)
  final EdgeInsets? margin;            // Default: 16px all sides
  final Color? backgroundColor;        // Default: type-specific from colorScheme
  final Color? textColor;              // Default: type-specific contrasting color
  final double? elevation;             // Default: 6.0
  final IconData? icon;                // Default: type-specific icon
  final bool showIcon;                 // Default: true
  final SnackBarBehavior? behavior;    // Default: floating
  final double? maxWidth;              // Default: null (responsive)
  final VoidCallback? onVisible;

  const AppSnackbarConfig({...});
}

class AppSnackbar {
  const AppSnackbar._();  // Private constructor

  static void showSuccess(BuildContext context, String message, {AppSnackbarConfig? config});
  static void showError(BuildContext context, String message, {AppSnackbarConfig? config});
  static void showWarning(BuildContext context, String message, {AppSnackbarConfig? config});
  static void showInfo(BuildContext context, String message, {AppSnackbarConfig? config});

  static void _show(BuildContext context, {
    required String message,
    required SnackbarType type,
    AppSnackbarConfig? config,
  }) {
    // 1. Clear existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // 2. Get theme colors
    final colorScheme = Theme.of(context).colorScheme;

    // 3. Map type to colors and icon
    // Success: primary/onPrimary, check_circle_outline_rounded
    // Error: error/onError, error_outline_rounded
    // Warning: tertiary/onTertiary, warning_amber_rounded
    // Info: secondary/onSecondary, info_outline_rounded

    // 4. Build SnackBar with proper styling
    // 5. Show via ScaffoldMessenger
  }
}
```

**Context Extension** (in `lib/core/extensions/context_extensions.dart`):
```dart
extension SnackbarExtension on BuildContext {
  void showSuccessSnackbar(String message, {AppSnackbarConfig? config});
  void showErrorSnackbar(String message, {AppSnackbarConfig? config});
  void showWarningSnackbar(String message, {AppSnackbarConfig? config});
  void showInfoSnackbar(String message, {AppSnackbarConfig? config});
}
```

**Usage:**
```dart
// Simple
context.showSuccessSnackbar('Profile updated successfully');

// With action
context.showErrorSnackbar(
  'Failed to send OTP',
  config: AppSnackbarConfig(
    actionLabel: 'Retry',
    onAction: () => resendOtp(),
  ),
);

// In BlocListener
BlocListener<MyCubit, MyState>(
  listener: (context, state) {
    if (state.operationState is OperationSuccess) {
      context.showSuccessSnackbar('Operation completed');
    } else if (state.operationState is OperationFailure) {
      context.showErrorSnackbar((state.operationState as OperationFailure).message);
    }
  },
  child: MyContent(),
)
```

**Rules:**
- Never call multiple snackbar methods in sequence (second clears first instantly)
- Requires `Scaffold` ancestor in widget tree
- Error snackbars NOT dismissible by default (require explicit action or timeout)
- Keep messages clear, concise, actionable (no technical jargon)
- Duration: 2-3s for quick feedback, 4-6s for normal messages, 5-8s for important messages

---

### 2. AppDialog — Modal Dialogs

**Location:** `lib/core/presentation/widgets/app_dialog.dart`

**Features:**
- 5 variants: success, error, warning, info, confirm
- Alert dialogs (single button)
- Confirm dialogs (two buttons, returns bool?)
- Action button callbacks
- Barrier dismissible control
- Custom icons and colors

**Architecture:**
```dart
enum DialogVariant { success, error, warning, info, confirm }

class AppDialogConfig {
  final String? primaryActionLabel;      // Default: "OK" for alert, "Confirm" for confirm
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;    // Default: "Cancel" for confirm
  final VoidCallback? onSecondaryAction;
  final bool barrierDismissible;         // Default: true for info/success, false for error/confirm
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const AppDialogConfig({...});
}

class AppDialog {
  const AppDialog._();

  // Alert dialog (single button, returns when dismissed)
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    DialogVariant variant = DialogVariant.info,
    AppDialogConfig? config,
  });

  // Confirm dialog (two buttons, returns bool?)
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    AppDialogConfig? config,
  }); // Returns: true (confirm), false (cancel), null (barrier dismiss)
}
```

**Usage:**
```dart
// Alert
await AppDialog.alert(
  context,
  title: 'Success',
  message: 'Profile updated successfully',
  variant: DialogVariant.success,
);

// Confirm
final result = await AppDialog.confirm(
  context,
  title: 'Delete Account',
  message: 'Are you sure? This cannot be undone.',
  config: AppDialogConfig(
    primaryActionLabel: 'Delete',
    secondaryActionLabel: 'Cancel',
  ),
);
if (result == true) {
  // User confirmed, proceed with deletion
}

// In BlocListener (for errors)
if (state.operationState is OperationFailure) {
  final failure = state.operationState as OperationFailure;
  AppDialog.alert(
    context,
    title: failure.code ?? 'Error',
    message: failure.message,
    variant: DialogVariant.error,
  );
}
```

**Rules:**
- All methods return `Future` - use `await` or `.then()`
- Use clear action verbs ("Delete", "Retry", "Cancel") not "OK", "Yes", "No"
- Titles: Short (1-3 words), describes action or result
- Messages: Clear, specific, tells user what happened and what to do
- Confirm dialogs ALWAYS have two buttons
- Alert dialogs have single button

---

### 3. AppButton — Standard Buttons

**Location:** `lib/core/presentation/widgets/app_button.dart`

**Features:**
- 3 variants: filled, outlined, text
- Loading state support
- Disabled state support (onPressed = null)
- Optional icon support
- Full width by default

**Architecture:**
```dart
class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  // Private constructor
  const AppButton._({
    required this.title,
    required this.onPressed,
    required this.isLoading,
    this.icon,
  });

  // Factory constructors
  factory AppButton.filled({
    required String title,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  });

  factory AppButton.outlined({
    required String title,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  });

  factory AppButton.text({
    required String title,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  });

  @override
  Widget build(BuildContext context) {
    // Show CircularProgressIndicator if isLoading
    // Disable button if isLoading or onPressed == null
    // Use theme button styles (FilledButton, OutlinedButton, TextButton)
  }
}
```

**Usage:**
```dart
AppButton.filled(
  title: 'Submit',
  onPressed: state.isValid ? () => cubit.submit() : null,
  isLoading: state.operationState is OperationLoading,
);

AppButton.outlined(
  title: 'Cancel',
  onPressed: () => Navigator.pop(context),
);

AppButton.text(
  title: 'Skip for now',
  onPressed: () => skipStep(),
);

// With icon
AppButton.filled(
  title: 'Save',
  icon: Icons.save,
  onPressed: () => save(),
);
```

---

### 4. AppTextField — Text Input with Validation

**Location:** `lib/core/presentation/widgets/app_text_field.dart`

**Features:**
- Integration with validation system
- Factory constructors for common types (name, email, phone, password)
- Error text display
- Prefix/suffix icons
- Custom input formatters
- Read-only mode
- Tap callback (for pickers)

**Architecture:**
```dart
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  // Private constructor
  const AppTextField._({...});

  // Factory constructors
  factory AppTextField.name({
    TextEditingController? controller,
    String? errorText,
    ValueChanged<String>? onChanged,
  }); // labelText: 'Name', keyboardType: TextInputType.name, capitalization: words

  factory AppTextField.email({
    TextEditingController? controller,
    String? errorText,
    ValueChanged<String>? onChanged,
  }); // labelText: 'Email', keyboardType: TextInputType.emailAddress

  factory AppTextField.phone({
    TextEditingController? controller,
    String? errorText,
    ValueChanged<String>? onChanged,
  }); // labelText: 'Phone', keyboardType: TextInputType.phone

  factory AppTextField.password({
    TextEditingController? controller,
    String? errorText,
    ValueChanged<String>? onChanged,
  }); // labelText: 'Password', obscureText: true, with toggle visibility icon

  factory AppTextField.custom({...}); // For other cases
}
```

**Usage:**
```dart
AppTextField.name(
  controller: nameController,
  errorText: state.nameError,
  onChanged: (value) => cubit.onNameChanged(value),
);

AppTextField.email(
  controller: emailController,
  errorText: state.emailError,
  onChanged: (value) => cubit.onEmailChanged(value),
);

AppTextField.password(
  controller: passwordController,
  errorText: state.passwordError,
  onChanged: (value) => cubit.onPasswordChanged(value),
);

// Custom (for date picker, etc.)
AppTextField.custom(
  controller: dateController,
  labelText: 'Date of Birth',
  errorText: state.dobError,
  readOnly: true,
  onTap: () async {
    final date = await AppDatePicker.show(context, ...);
    if (date != null) cubit.onDobChanged(date);
  },
  suffixIcon: Icon(Icons.calendar_today),
);
```

---

### 5. AppBottomSheet — Modal Bottom Sheets

**Location:** `lib/core/presentation/widgets/bottom_sheet_helper.dart`

**Features:**
- Modal bottom sheets with drag handle
- Scroll controlled support
- Dismissible control
- Proper constraints for tablets
- Keyboard handling

**Architecture:**
```dart
class BottomSheetHelper {
  const BottomSheetHelper._();

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    Color? backgroundColor,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      builder: (context) => child,
    );
  }
}
```

**Usage:**
```dart
final result = await BottomSheetHelper.show(
  context,
  child: SelectionBottomSheet(),
);

// In selection bottom sheet widget
void _onItemSelected(BuildContext context, String value) {
  Navigator.pop(context, value);
}
```

---

### 6. AppDatePicker — Date Selection

**Location:** `lib/core/presentation/widgets/app_date_picker.dart`

**Architecture:**
```dart
class AppDatePicker {
  const AppDatePicker._();

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String? helpText,
  }) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
    );
  }
}
```

**Usage:**
```dart
final selectedDate = await AppDatePicker.show(
  context,
  initialDate: DateTime.now(),
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  helpText: 'Select your date of birth',
);
if (selectedDate != null) {
  cubit.onDateChanged(selectedDate);
}
```

---

### 7. AppTimePicker — Time Selection

**Location:** `lib/core/presentation/widgets/app_time_picker.dart`

**Architecture:**
```dart
class AppTimePicker {
  const AppTimePicker._();

  static Future<TimeOfDay?> show(
    BuildContext context, {
    required TimeOfDay initialTime,
    String? helpText,
  }) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: helpText,
    );
  }
}
```

---

### 8. AppDropdown — Dropdown Selection

**Location:** `lib/core/presentation/widgets/app_dropdown.dart`

**Architecture:**
```dart
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool enabled;

  const AppDropdown({
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.errorText,
    this.enabled = true,
  });
}
```

**Usage:**
```dart
AppDropdown<String>(
  value: state.gender,
  labelText: 'Gender',
  items: [
    DropdownMenuItem(value: 'M', child: Text('Male')),
    DropdownMenuItem(value: 'F', child: Text('Female')),
    DropdownMenuItem(value: 'O', child: Text('Other')),
  ],
  onChanged: (value) => cubit.onGenderChanged(value),
  errorText: state.genderError,
);
```

---

### 9. KeyboardDismissible — Dismiss Keyboard Wrapper

**Location:** `lib/core/presentation/widgets/keyboard_dismissible.dart`

**Architecture:**
```dart
class KeyboardDismissible extends StatelessWidget {
  final Widget child;
  const KeyboardDismissible({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusManager.instance.primaryFocus;
        if (currentFocus != null && currentFocus.hasFocus) {
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
```

**Context Extension** (in `lib/core/extensions/context_extensions.dart`):
```dart
extension KeyboardDismissExtension on BuildContext {
  void dismissKeyboard() {
    final currentFocus = FocusManager.instance.primaryFocus;
    if (currentFocus != null && currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
  }
}
```

**Usage:**
```dart
KeyboardDismissible(
  child: YourFormContent(),
);

// Or use context extension
onTap: () => context.dismissKeyboard();
```

---

### 10. Gap — Consistent Spacing

**Location:** `lib/core/presentation/widgets/gap.dart`

**Architecture:**
```dart
class Gap extends StatelessWidget {
  final double size;
  final Axis axis;

  const Gap._(this.size, this.axis);

  factory Gap.vertical(double size) => Gap._(size, Axis.vertical);
  factory Gap.horizontal(double size) => Gap._(size, Axis.horizontal);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: axis == Axis.horizontal ? size : 0,
      height: axis == Axis.vertical ? size : 0,
    );
  }
}
```

**Usage:**
```dart
Column(
  children: [
    Text('Title'),
    Gap.vertical(AppSizes.space16),
    Text('Body'),
    Gap.vertical(AppSizes.space24),
    AppButton.filled(title: 'Submit', onPressed: () {}),
  ],
);

Row(
  children: [
    Icon(Icons.person),
    Gap.horizontal(AppSizes.space8),
    Text('Profile'),
  ],
);
```

---

## Widget Integration Patterns

### Pattern 1: Form with Validation

```dart
KeyboardDismissible(
  child: SingleChildScrollView(
    padding: EdgeInsets.all(AppSizes.screenPadding),
    child: Column(
      children: [
        AppTextField.name(
          controller: nameController,
          errorText: state.nameError,
          onChanged: (value) => cubit.onNameChanged(value),
        ),
        Gap.vertical(AppSizes.space16),
        AppTextField.email(
          controller: emailController,
          errorText: state.emailError,
          onChanged: (value) => cubit.onEmailChanged(value),
        ),
        Gap.vertical(AppSizes.space16),
        AppDropdown<String>(
          value: state.gender,
          labelText: 'Gender',
          items: [...],
          onChanged: (value) => cubit.onGenderChanged(value),
          errorText: state.genderError,
        ),
        Gap.vertical(AppSizes.space24),
        AppButton.filled(
          title: 'Submit',
          onPressed: state.isValid ? () => cubit.submit() : null,
          isLoading: state.operationState is OperationLoading,
        ),
      ],
    ),
  ),
)
```

### Pattern 2: Snackbar in BlocListener

```dart
BlocListener<RegisterCubit, RegisterState>(
  listener: (context, state) {
    if (state.registerState is RegisterInitiateSuccess) {
      context.showSuccessSnackbar('OTP sent successfully');
    } else if (state.registerState is RegisterInitiateFailure) {
      final failure = state.registerState as RegisterInitiateFailure;
      context.showErrorSnackbar(
        failure.message,
        config: AppSnackbarConfig(
          actionLabel: 'Retry',
          onAction: () => context.read<RegisterCubit>().retry(),
        ),
      );
    }
  },
  child: RegistrationContent(),
)
```

### Pattern 3: Dialog in BlocListener

```dart
BlocListener<MyCubit, MyState>(
  listener: (context, state) {
    if (state.operationState is OperationFailure) {
      final failure = state.operationState as OperationFailure;
      AppDialog.alert(
        context,
        title: failure.code ?? 'Error',
        message: failure.message,
        variant: DialogVariant.error,
      );
    }
  },
  child: MyContent(),
)
```

### Pattern 4: Bottom Sheet Selection

```dart
Future<void> _showGenderSelection(BuildContext context) async {
  final selected = await BottomSheetHelper.show<String>(
    context,
    child: GenderSelectionSheet(
      currentValue: state.gender,
    ),
  );
  if (selected != null) {
    cubit.onGenderChanged(selected);
  }
}
```

---

## AppSizes Constants

All widgets must use `AppSizes` constants for dimensions.

```dart
// lib/core/resources/app_sizes.dart
class AppSizes {
  const AppSizes._();

  // Spacing
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  // Component dimensions
  static const double buttonHeight = 48.0;
  static const double textFieldHeight = 56.0;
  static const double buttonRadius = 8.0;
  static const double cardRadius = 12.0;
  static const double dialogRadius = 28.0;
  static const double bottomSheetRadius = 20.0;

  // Screen / layout
  static const double screenPadding = 24.0;
  static const double contentPadding = 20.0;
}
```

---

## Barrel Export

All widgets must be exported in `lib/core/presentation/widgets/index.dart`:

```dart
export 'app_snackbar.dart';
export 'app_dialog.dart';
export 'app_button.dart';
export 'app_text_field.dart';
export 'app_date_picker.dart';
export 'app_time_picker.dart';
export 'app_dropdown.dart';
export 'bottom_sheet_helper.dart';
export 'keyboard_dismissible.dart';
export 'gap.dart';
export 'app_scaffold.dart';
```

---

## Rules

1. **Material 3**: Use `ColorScheme` from theme, NEVER hardcode colors
2. **Constants**: Use `AppSizes`, `AppStrings`, `AppErrors` constants
3. **Naming**: Follow `App{Component}` pattern
4. **Const**: Use `const` constructors wherever possible
5. **Factory**: Use factory constructors for variants (e.g., `AppButton.filled()`)
6. **Private**: Use private constructors with underscore (e.g., `const AppDialog._()`)
7. **Type Safety**: Use enums for variants, no magic strings/numbers
8. **Documentation**: Add dartdoc comments with usage examples
9. **Accessibility**: Semantic labels, proper contrast, keyboard support
10. **Performance**: Minimal rebuilds, efficient widget trees
11. **Barrel Export**: Export all widgets in `widgets/index.dart`
12. **Context Extensions**: Add convenience extensions in `context_extensions.dart`

---

## Validation Integration

Widgets integrate with the validation system:

```dart
// In Cubit
void onNameChanged(String value) {
  emit(state.copyWith(
    name: value,
    nameError: () => state.submitted ? AppValidators.name(value) : null,
  ));
}

bool validate() {
  emit(state.copyWith(
    submitted: true,
    nameError: () => AppValidators.name(state.name),
    emailError: () => AppValidators.email(state.email),
  ));
  return state.isValid;
}

// In UI
AppTextField.name(
  errorText: state.nameError,  // Shows error only after submit attempt
  onChanged: (value) => cubit.onNameChanged(value),
);
```

---

## What to Generate

Generate ALL core widgets listed above with:
- Full implementations following the architectures specified
- Dartdoc comments with usage examples
- Material 3 compliance (use `ColorScheme`, not hardcoded colors)
- `AppSizes` constants for all dimensions
- Factory constructors for variants
- `const` constructors wherever possible
- Type-safe enums for variants
- Context extensions for convenience (Snackbar, Keyboard)
- Barrel export in `widgets/index.dart`

After generation:
- All widgets should compile without errors (`flutter analyze`)
- All widgets should work in both light and dark modes
- All widgets should be consistent in style and behavior
- All widgets should follow Material 3 design guidelines
