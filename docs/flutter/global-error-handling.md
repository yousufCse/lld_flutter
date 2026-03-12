# Global Error Handling in Flutter with BLoC

A complete guide to showing error dialogs automatically for **every** API failure (401, 403, 500, network errors, etc.) from a single place — no copy-paste in every screen.

---

## Table of Contents

1. [The Problem](#the-problem)
2. [Why This Matters](#why-this-matters)
3. [Three Approaches Compared](#three-approaches-compared)
4. [Approach A: Global ErrorCubit (Recommended)](#approach-a-global-errorcubit-recommended)
5. [Step-by-Step Implementation](#step-by-step-implementation)
6. [How to Use It in a Feature Cubit](#how-to-use-it-in-a-feature-cubit)
7. [The Complete Error Flow](#the-complete-error-flow)
8. [Pros and Cons](#pros-and-cons)
9. [FAQ](#faq)

---

## The Problem

Imagine you have 20 screens. Each screen calls an API. Each API can fail with:

- **401** — session expired, user must log in again
- **403** — forbidden
- **500** — server crashed
- **No internet** — WiFi is off
- **Timeout** — server is too slow

Without a global system, every screen must do this manually:

```dart
// ❌ BAD: repeated in EVERY screen
BlocListener<SomeCubit, SomeState>(
  listener: (context, state) {
    state.maybeWhen(
      error: (failure) {
        if (failure is AuthFailure) {
          // show session expired dialog
          // navigate to login
          // clear tokens
        } else if (failure is NetworkFailure) {
          // show no internet dialog
        } else if (failure is ServerFailure) {
          // show server error dialog
        }
        // ... more ifs for every failure type
      },
      orElse: () {},
    );
  },
)
```

That is **20 screens × the same error handling code**. If you want to change the 401 dialog text, you change it in 20 places. If you forget one screen, that screen silently swallows errors.

---

## Why This Matters

| Without global handling | With global handling |
|---|---|
| Same error code in every screen | Write error dialog logic once |
| Forget one screen → silent failure | Every error is always shown |
| Change dialog text → edit 20 files | Change dialog text → edit 1 file |
| 401 session expiry handled differently per screen | 401 always navigates to login, guaranteed |
| New developer must learn the pattern per screen | New developer reads one file |

**Bottom line:** Global error handling is the difference between "it works" and "it works reliably and is easy to maintain."

---

## Three Approaches Compared

### Approach A: Global ErrorCubit + Top-Level BlocListener ⭐

**How it works:** Create a singleton `GlobalErrorCubit`. Any cubit in the app can push a `Failure` into it. A single `BlocListener` at the top of the widget tree listens and shows the right dialog.

```
Feature Cubit → pushes Failure → GlobalErrorCubit → BlocListener → Dialog
```

| Pros | Cons |
|---|---|
| One listener handles all error dialogs | Adds one global cubit to the app |
| Feature cubits stay clean (just forward errors) | Developer must remember to call `globalErrorCubit.showError()` |
| Fully testable with standard bloc_test | Need a convention: "local" errors (form validation) vs "global" errors (auth, server) |
| Works with any state management (Cubit, Bloc) | |
| Session expiry → force logout is automatic | |

**Best for:** Medium to large apps with Clean Architecture and flutter_bloc.

---

### Approach B: BlocObserver

**How it works:** Override Flutter BLoC's `BlocObserver.onChange()`. It fires every time any cubit in the app changes state. Inspect the new state — if it contains a `Failure`, show a dialog.

```dart
class AppBlocObserver extends BlocObserver {
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Inspect change.nextState for Failure
    // Use navigatorKey.currentContext to show dialog
  }
}
```

| Pros | Cons |
|---|---|
| Truly automatic — zero changes to any cubit | Catches ALL errors, including ones you want to handle locally (form validation) |
| Zero boilerplate per feature | `navigatorKey.currentContext` can be `null` during screen transitions |
| | Must use runtime type checking to extract `Failure` from arbitrary state types |
| | BlocObserver is designed for logging/analytics, not UI — this is an anti-pattern per the flutter_bloc maintainers |
| | Very hard to unit test |

**Best for:** Small apps or prototypes where speed matters more than correctness.

---

### Approach C: Per-Screen ErrorListener Widget

**How it works:** Create a reusable `ErrorListenerWrapper` widget. Every screen wraps its body with it. The widget contains the dialog logic.

```dart
// Every screen does this:
@override
Widget build(BuildContext context) {
  return ErrorListenerWrapper<MyCubit, MyState>(
    failureExtractor: (state) => state.maybeWhen(
      error: (f) => f,
      orElse: () => null,
    ),
    child: Scaffold(...),
  );
}
```

| Pros | Cons |
|---|---|
| Each screen explicitly opts in | Must wrap every single screen (boilerplate) |
| No global state | Easy to forget on new screens |
| Screen controls which errors to forward | 401 handling is duplicated or needs special coordination |
| | Not "global" — if you miss a screen, errors are swallowed |

**Best for:** Apps that want explicit per-screen control and don't mind the boilerplate.

---

### Verdict

| Criteria | A: GlobalErrorCubit | B: BlocObserver | C: Per-Screen Widget |
|---|---|---|---|
| Boilerplate per screen | Very low | None | Medium |
| Can distinguish local vs global errors | Yes | No | Yes |
| 401 force-logout reliability | Guaranteed | Fragile | Depends on developer |
| Testability | Easy | Hard | Easy |
| Follows flutter_bloc best practices | Yes | No | Yes |
| Scales to 50+ screens | Yes | Yes but risky | Yes but tedious |

**Approach A wins** for production apps. The rest of this document implements Approach A.

---

## Approach A: Global ErrorCubit (Recommended)

### Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                    app.dart                       │
│                                                   │
│  MultiBlocProvider                                │
│   ├─ AuthCubit (global, lazySingleton)           │
│   └─ GlobalErrorCubit (global, lazySingleton)    │
│                                                   │
│   GlobalErrorListener  ◄── listens to errors     │
│    └─ MaterialApp.router                         │
│        └─ ... screens ...                        │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│              Any Feature Cubit                    │
│                                                   │
│  result.fold(                                    │
│    (failure) {                                   │
│      // Option 1: Handle locally                 │
│      emit(MyState.error(failure));               │
│                                                   │
│      // Option 2: Forward to global dialog       │
│      globalErrorCubit.showError(failure);         │
│                                                   │
│      // Option 3: Both                           │
│    },                                            │
│    (data) => emit(MyState.success(data)),        │
│  );                                              │
└─────────────────────────────────────────────────┘
```

### What You Need

| File | Purpose |
|---|---|
| `global_error_cubit.dart` | Holds the current error. Any cubit can push a `Failure` into it. |
| `global_error_state.dart` | Freezed state: `initial` or `error(failure, id)`. |
| `failure_dialog_mapper.dart` | Maps each `Failure` type to the correct dialog style (error, warning, info). |
| `global_error_listener.dart` | Widget that listens to `GlobalErrorCubit` and shows the dialog. |
| `global_app_providers.dart` | Registers `GlobalErrorCubit` as a global `BlocProvider`. |
| `app.dart` | Wraps `MaterialApp` with `GlobalErrorListener`. |
| `auth_cubit.dart` | Has a `forceLogout()` method for session expiry. |

---

## Step-by-Step Implementation

### Prerequisites

Your app must already have:

- **flutter_bloc** for state management
- **freezed** for sealed union states
- **A `Failure` class hierarchy** — a base `Failure` class with subtypes like `AuthFailure`, `ServerFailure`, `NetworkFailure`, etc.
- **A dialog utility** — any way to show dialogs (e.g., `showDialog()`, a custom `AppDialog` class)
- **An `AuthCubit`** (or equivalent) that manages login/logout state

If you use **injectable/get_it** for DI, annotate with `@lazySingleton`. If not, create the cubit manually and pass it down.

---

### Step 1: Create `GlobalErrorState`

This is the state. It has only two variants:

- `initial` — no error, nothing to show
- `error` — has a `Failure` and a unique `id`

**Why the `id` field?** Freezed compares states by value. If the same `Failure` happens twice in a row (e.g., user taps a button twice and gets the same network error), Freezed would think "same state, don't emit." The `id` (a timestamp) makes each emission unique.

```dart
// file: lib/core/presentation/cubits/global_error/global_error_state.dart

part of 'global_error_cubit.dart';

@freezed
sealed class GlobalErrorState with _$GlobalErrorState {
  const factory GlobalErrorState.initial() = _Initial;

  const factory GlobalErrorState.error({
    required Failure failure,
    required int id,
  }) = _Error;
}
```

---

### Step 2: Create `GlobalErrorCubit`

This cubit has two methods:

- `showError(Failure)` — call this from any feature cubit to trigger a dialog
- `clearError()` — called after the dialog is dismissed, resets to `initial`

```dart
// file: lib/core/presentation/cubits/global_error/global_error_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart'; // remove if not using injectable

part 'global_error_state.dart';
part 'global_error_cubit.freezed.dart';

@lazySingleton // remove if not using injectable
class GlobalErrorCubit extends Cubit<GlobalErrorState> {
  GlobalErrorCubit() : super(const GlobalErrorState.initial());

  /// Push a Failure to trigger the global error dialog.
  void showError(Failure failure) {
    emit(
      GlobalErrorState.error(
        failure: failure,
        id: DateTime.now().microsecondsSinceEpoch,
      ),
    );
  }

  /// Reset after the dialog has been shown.
  void clearError() {
    emit(const GlobalErrorState.initial());
  }
}
```

After creating these two files, run code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

### Step 3: Create `FailureDialogMapper`

This is a **pure function** that takes a `Failure` and returns a dialog configuration. It decides:

- What **icon/color** to use (error, warning, info)
- What **title and message** to display
- What the **button text** says
- Whether this is a **session expiry** (needs force-logout)

```dart
// file: lib/core/presentation/utils/failure_dialog_mapper.dart

class FailureDialogConfig {
  final DialogVariant variant; // your dialog's enum: info, success, warning, error
  final String title;
  final String message;
  final String? confirmText;
  final bool isSessionExpiry;

  const FailureDialogConfig({
    required this.variant,
    required this.title,
    required this.message,
    this.confirmText,
    this.isSessionExpiry = false,
  });
}

class FailureDialogMapper {
  const FailureDialogMapper._();

  static FailureDialogConfig map(Failure failure) {
    return switch (failure) {
      AuthFailure() => FailureDialogConfig(
        variant: DialogVariant.error,
        title: failure.title,
        message: failure.details,
        confirmText: 'Go to Login',
        isSessionExpiry: true,
      ),
      ServerFailure() => FailureDialogConfig(
        variant: DialogVariant.error,
        title: failure.title,
        message: failure.details,
      ),
      NetworkFailure() => FailureDialogConfig(
        variant: DialogVariant.warning,
        title: failure.title,
        message: failure.details,
      ),
      ApiFailure() => FailureDialogConfig(
        variant: DialogVariant.error,
        title: failure.title,
        message: failure.details,
      ),
      CacheFailure() || ParsingFailure() => FailureDialogConfig(
        variant: DialogVariant.info,
        title: failure.title,
        message: failure.details,
      ),
      _ => FailureDialogConfig(
        variant: DialogVariant.info,
        title: failure.title,
        message: failure.details,
      ),
    };
  }
}
```

**To add a new failure type:** Add a new case to the `switch`. That is the only change needed.

---

### Step 4: Create `GlobalErrorListener`

This widget sits at the top of the widget tree. It listens to `GlobalErrorCubit`. When an error is emitted, it:

1. Maps the `Failure` to a dialog config
2. Shows the dialog
3. If it was a session expiry (401), calls `authCubit.forceLogout()`
4. Clears the error state

```dart
// file: lib/core/presentation/widgets/global_error_listener.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalErrorListener extends StatelessWidget {
  final Widget child;

  const GlobalErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalErrorCubit, GlobalErrorState>(
      listener: _onGlobalError,
      child: child,
    );
  }

  Future<void> _onGlobalError(
    BuildContext context,
    GlobalErrorState state,
  ) async {
    await state.whenOrNull(
      error: (failure, _) async {
        final config = FailureDialogMapper.map(failure);

        // Show the dialog and WAIT for the user to dismiss it
        await AppDialog.alert(
          context,
          title: config.title,
          message: config.message,
          confirmText: config.confirmText,
          variant: config.variant,
        );

        // Safety check: the widget might have been removed while dialog was open
        if (!context.mounted) return;

        // If session expired, force-logout → GoRouter redirect sends to login
        if (config.isSessionExpiry) {
          context.read<AuthCubit>().forceLogout();
        }

        // Reset the state so the next error can be shown
        context.read<GlobalErrorCubit>().clearError();
      },
    );
  }
}
```

---

### Step 5: Add `forceLogout()` to `AuthCubit`

This method does one thing: set the auth status to `unauthenticated`. If your router watches the auth status (e.g., GoRouter with `redirectListenable`), it will automatically navigate to the login screen.

```dart
// Inside your existing AuthCubit class, add this method:

/// Force-logout: clear state and redirect to login.
/// Called by GlobalErrorListener when a session-expiry error is shown.
/// GoRouter redirect automatically navigates to login.
void forceLogout() {
  emit(
    state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: null,
      user: null,
    ),
  );
}
```

If you also need to clear tokens from storage, call your token storage here:

```dart
void forceLogout() {
  _tokenStorage.clearTokens(); // if you have a reference to token storage
  emit(
    state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: null,
      user: null,
    ),
  );
}
```

---

### Step 6: Register `GlobalErrorCubit` as a Global Provider

Add it next to your `AuthCubit` in the global providers list:

```dart
// file: lib/core/app/global_app_providers.dart

final List<BlocProvider> blocProviders = [
  BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
  BlocProvider<GlobalErrorCubit>(
    create: (context) => getIt<GlobalErrorCubit>(),
  ),
];
```

If you don't use injectable/get_it, create the cubit directly:

```dart
BlocProvider<GlobalErrorCubit>(
  create: (context) => GlobalErrorCubit(),
),
```

---

### Step 7: Wrap Your App with `GlobalErrorListener`

In your main app widget, wrap `MaterialApp` (or `MaterialApp.router`) with the listener:

```dart
// file: lib/core/app/app.dart

@override
Widget build(BuildContext context) {
  return MultiBlocProvider(
    providers: blocProviders,
    child: GlobalErrorListener(        // ← add this wrapper
      child: MaterialApp.router(
        routerConfig: router,
        theme: theme,
        // ... other config
      ),
    ),
  );
}
```

**The order matters:** `MultiBlocProvider` must be above `GlobalErrorListener` because the listener needs access to both `GlobalErrorCubit` and `AuthCubit` from the context.

---

## How to Use It in a Feature Cubit

### Option 1: Forward ALL errors to global dialog

The cubit does not handle errors itself. It just forwards them.

```dart
@injectable
class GetPrescriptionsCubit extends Cubit<GetPrescriptionsState> {
  final GetPrescriptionsUseCase _usecase;
  final GlobalErrorCubit _globalErrorCubit;

  GetPrescriptionsCubit(this._usecase, this._globalErrorCubit)
      : super(const GetPrescriptionsState.initial());

  Future<void> fetch() async {
    emit(const GetPrescriptionsState.loading());

    final result = await _usecase(const NoParams());

    result.fold(
      (failure) {
        emit(const GetPrescriptionsState.initial()); // reset to initial
        _globalErrorCubit.showError(failure);         // global dialog
      },
      (data) => emit(GetPrescriptionsState.success(data)),
    );
  }
}
```

### Option 2: Handle locally AND forward specific errors

The cubit handles the error in its own state (e.g., shows an error view on screen), but also forwards critical errors (auth, server) to the global dialog.

```dart
result.fold(
  (failure) {
    // Always set local error state (screen shows error UI)
    emit(GetPrescriptionsState.error(failure));

    // Forward only critical errors to global dialog
    if (failure is AuthFailure || failure is ServerFailure) {
      _globalErrorCubit.showError(failure);
    }
  },
  (data) => emit(GetPrescriptionsState.success(data)),
);
```

### Option 3: Handle locally, never forward

For errors that are expected and handled in the UI (e.g., form validation errors), don't forward to global:

```dart
result.fold(
  (failure) {
    // Form screen shows inline field errors — no global dialog needed
    emit(RegistrationState.error(failure));
  },
  (data) => emit(RegistrationState.success(data)),
);
```

### Which option to pick?

| Error type | Handle locally? | Forward to global? |
|---|---|---|
| 401 session expired | No (can't recover on this screen) | **Yes** |
| 500 server error | Optional (show retry button) | **Yes** |
| No internet | Optional (show retry button) | **Yes** |
| Form validation error | **Yes** (show inline field errors) | No |
| "Item not found" API error | **Yes** (show empty state) | No |

---

## The Complete Error Flow

Here is the full journey of a 401 error, from the network layer to the login screen:

```
1. API returns HTTP 401
       │
2. RefreshTokenInterceptor catches 401
       │ tries to refresh the token
       │
3. Refresh fails (refresh token also expired)
       │
4. Interceptor rejects with DioException(badResponse, statusCode: 401)
       │
5. ApiClient catches DioException
       │ _handleResponseError() sees 401
       │ throws AuthException.unauthorized()
       │
6. BaseRepository.handleException() catches AuthException
       │ maps to AuthFailure(title: "Unauthorized", details: "...")
       │ returns Left(AuthFailure)
       │
7. Feature Cubit receives Left(AuthFailure)
       │ calls globalErrorCubit.showError(authFailure)
       │
8. GlobalErrorCubit emits GlobalErrorState.error(failure, id)
       │
9. GlobalErrorListener receives the state
       │ calls FailureDialogMapper.map(authFailure)
       │ gets: variant=error, title="Unauthorized", confirmText="Go to Login",
       │       isSessionExpiry=true
       │
10. Dialog appears: "Unauthorized Access — Go to Login"
       │ user taps "Go to Login"
       │
11. Listener calls authCubit.forceLogout()
       │ emits AuthState(status: unauthenticated)
       │
12. GoRouter detects auth status change
       │ redirects to /login
       │
13. User sees login screen.
```

For a **500 Server Error**, the flow is the same except:
- Step 9: `isSessionExpiry = false` → no force-logout
- Step 10: Dialog shows "Server Error" with a plain "OK" button
- Step 11-13: skipped (user just dismisses the dialog and stays on the current screen)

---

## Pros and Cons

### Pros

1. **Write once, works everywhere.** Error dialog logic lives in one file (`GlobalErrorListener`). Every screen benefits automatically.

2. **Impossible to forget.** Once a cubit forwards to `globalErrorCubit.showError()`, the dialog always appears. No screen can accidentally swallow errors.

3. **Easy to change.** Want to change the 401 dialog text from "Go to Login" to "Sign in again"? Change one line in `FailureDialogMapper`. Done.

4. **Easy to test.** Unit test `GlobalErrorCubit`: call `showError(AuthFailure())`, assert state is `error`. Unit test `FailureDialogMapper`: pass each `Failure` type, assert the config. No widget tests needed for the dialog logic.

5. **Clean Architecture friendly.** The domain layer (`Failure`) knows nothing about dialogs. The presentation layer maps failures to UI. No layer violations.

6. **Session expiry is bulletproof.** Every 401, from every API call, from every screen, always shows the session expired dialog and navigates to login. No exceptions.

7. **Feature cubits stay simple.** A feature cubit just calls `_globalErrorCubit.showError(failure)` in one line. No `if/else` chains for error types.

### Cons

1. **One extra global cubit.** The app has one more singleton. This is a very small cost.

2. **Developer must call `showError()` explicitly.** If a developer forgets to call `globalErrorCubit.showError(failure)` in a new cubit, errors will be silently ignored. This can be mitigated with code review or a base cubit mixin.

3. **Not suitable for local errors.** Form validation errors, "not found" states, etc. should still be handled per-screen. The developer must decide which errors are "global" vs "local."

4. **Dialog stacking.** If two API calls fail at the same time, two dialogs could appear (one after the other, since `clearError` resets after each). This is usually fine, but be aware.

---

## FAQ

### Can I use snackbars instead of dialogs for some errors?

Yes. Modify `GlobalErrorListener` to check the failure type:

```dart
if (failure is NetworkFailure) {
  context.showWarningSnackbar(failure.details); // snackbar for network
} else {
  await AppDialog.alert(...); // dialog for everything else
}
```

### Can I use this without injectable/get_it?

Yes. Create `GlobalErrorCubit()` directly in the `BlocProvider`:

```dart
BlocProvider<GlobalErrorCubit>(create: (_) => GlobalErrorCubit()),
```

And pass it to cubits manually or via `context.read<GlobalErrorCubit>()`.

### Can I use this without Freezed?

Yes. Replace the Freezed state with a simple class:

```dart
abstract class GlobalErrorState {}

class GlobalErrorInitial extends GlobalErrorState {}

class GlobalErrorOccurred extends GlobalErrorState {
  final Failure failure;
  final int id;
  GlobalErrorOccurred({required this.failure, required this.id});
}
```

And in the listener, use `if (state is GlobalErrorOccurred)` instead of `.whenOrNull()`.

### What if I don't use GoRouter?

The `forceLogout()` method just sets the auth state to `unauthenticated`. However your app handles navigation on auth-state change, that same mechanism will navigate to login. If you use manual `Navigator.pushReplacement`, call it after `forceLogout()` in the listener.

### How do I add a new error type?

1. Create a new `Failure` subclass (e.g., `RateLimitFailure`)
2. Add a case in `FailureDialogMapper.map()`:
   ```dart
   RateLimitFailure() => FailureDialogConfig(
     variant: DialogVariant.warning,
     title: 'Too Many Requests',
     message: 'Please wait and try again.',
   ),
   ```
3. That is it. The listener and cubit need no changes.

---

## File Structure Summary

```
lib/
├── core/
│   ├── app/
│   │   ├── app.dart                          ← wraps with GlobalErrorListener
│   │   └── global_app_providers.dart         ← registers GlobalErrorCubit
│   ├── errors/
│   │   └── failures/
│   │       ├── failures.dart                 ← base Failure class
│   │       ├── auth_failures.dart            ← AuthFailure
│   │       ├── network_failures.dart         ← NetworkFailure, ServerFailure
│   │       ├── api_failures.dart             ← ApiFailure
│   │       └── data_failures.dart            ← CacheFailure, ParsingFailure
│   └── presentation/
│       ├── cubits/
│       │   └── global_error/
│       │       ├── global_error_cubit.dart    ← the cubit (2 methods)
│       │       └── global_error_state.dart    ← Freezed state (2 variants)
│       ├── utils/
│       │   └── failure_dialog_mapper.dart     ← maps Failure → dialog config
│       └── widgets/
│           ├── app_dialog.dart                ← your dialog utility
│           └── global_error_listener.dart     ← the BlocListener widget
└── features/
    └── auth/
        └── presentation/
            └── cubits/
                └── auth/
                    └── auth_cubit.dart        ← has forceLogout() method
```
