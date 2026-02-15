import 'package:flutter/material.dart';

import '../presentation/widgets/index.dart';

/// Extension on [BuildContext] for programmatic keyboard dismissal.
///
/// Usage:
/// ```dart
/// context.dismissKeyboard();
/// ```
extension KeyboardDismissExtension on BuildContext {
  /// Dismisses the keyboard by removing focus from the current node.
  ///
  /// This is the recommended approach over `FocusScope.of(context).unfocus()`
  /// because it avoids issues with nested focus scopes and is more reliable
  /// across different Flutter versions.
  void dismissKeyboard() {
    final currentFocus = FocusManager.instance.primaryFocus;
    if (currentFocus != null && currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
  }
}

/// Extension on [BuildContext] for convenient snackbar display.
///
/// This provides a cleaner, more idiomatic API for showing snackbars.
///
/// Usage:
/// ```dart
/// context.showSuccessSnackbar('Profile updated');
/// context.showErrorSnackbar('Failed to save', config: AppSnackbarConfig(...));
/// ```
extension SnackbarExtension on BuildContext {
  /// Shows a success snackbar.
  ///
  /// Shorthand for [AppSnackbar.showSuccess].
  void showSuccessSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar.showSuccess(this, message, config: config);
  }

  /// Shows an error snackbar.
  ///
  /// Shorthand for [AppSnackbar.showError].
  void showErrorSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar.showError(this, message, config: config);
  }

  /// Shows a warning snackbar.
  ///
  /// Shorthand for [AppSnackbar.showWarning].
  void showWarningSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar.showWarning(this, message, config: config);
  }

  /// Shows an info snackbar.
  ///
  /// Shorthand for [AppSnackbar.showInfo].
  void showInfoSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar.showInfo(this, message, config: config);
  }
}
