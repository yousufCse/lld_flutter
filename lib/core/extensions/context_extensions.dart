import 'package:flutter/material.dart';

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
