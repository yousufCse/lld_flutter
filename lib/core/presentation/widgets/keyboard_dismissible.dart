import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/extensions/context_extensions.dart';

/// A widget that dismisses the keyboard when the user taps outside
/// of any focused input field.
///
/// Wrap your [Scaffold] or screen body with this widget:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return KeyboardDismissible(
///     child: Scaffold(
///       body: ...,
///     ),
///   );
/// }
/// ```
class KeyboardDismissible extends StatelessWidget {
  const KeyboardDismissible({
    required this.child,
    this.excludeFromSemantics = true,
    super.key,
  });

  final Widget child;

  /// Whether to exclude the tap gesture from the semantics tree.
  /// Defaults to `true` since this is a UX convenience, not a semantic action.
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      excludeFromSemantics: excludeFromSemantics,
      behavior: HitTestBehavior.translucent,
      onTap: () => context.dismissKeyboard(),
      child: child,
    );
  }
}
