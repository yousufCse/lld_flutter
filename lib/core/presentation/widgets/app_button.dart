import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';

/// App-wide button widget.
///
/// All styling (size, shape, colors, ripple) comes from [ThemeData].
/// The only behaviour this widget adds on top of theme is [isLoading]:
/// when true the button disables itself and shows a spinner.
///
/// Usage:
/// ```dart
/// AppButton.filled(title: 'Submit', onPressed: _submit);       // Primary CTA
/// AppButton.elevated(title: 'Secondary', onPressed: _action);  // Secondary
/// AppButton.outlined(title: 'Cancel', onPressed: _cancel);
/// AppButton.text(title: 'Skip', onPressed: _skip);
/// AppButton.filled(title: 'Login', onPressed: _login, isLoading: _loading);
/// ```

class AppButton extends StatelessWidget {
  const AppButton._({
    super.key,
    required _ButtonType type,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.width,
  }) : _type = type;

  final _ButtonType _type;
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;

  const AppButton.filled({
    Key? key,
    required String title,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
  }) : this._(
         key: key,
         type: _ButtonType.filled,
         title: title,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
       );

  const AppButton.elevated({
    Key? key,
    required String title,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
  }) : this._(
         key: key,
         type: _ButtonType.elevated,
         title: title,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
       );

  const AppButton.outlined({
    Key? key,
    required String title,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
  }) : this._(
         key: key,
         type: _ButtonType.outlined,
         title: title,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
       );

  const AppButton.text({
    Key? key,
    required String title,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
  }) : this._(
         key: key,
         type: _ButtonType.text,
         title: title,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
       );

  @override
  Widget build(BuildContext context) {
    final VoidCallback? effectiveCallback = isLoading ? null : onPressed;

    final Widget child = isLoading
        ? SizedBox(
            height: AppSizes.space20,
            width: AppSizes.space20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(title);

    final Widget button = switch (_type) {
      _ButtonType.filled => FilledButton(
        onPressed: effectiveCallback,
        child: child,
      ),
      _ButtonType.elevated => ElevatedButton(
        onPressed: effectiveCallback,
        child: child,
      ),
      _ButtonType.outlined => OutlinedButton(
        onPressed: effectiveCallback,
        child: child,
      ),
      _ButtonType.text => TextButton(
        onPressed: effectiveCallback,
        child: child,
      ),
    };

    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
  }
}

enum _ButtonType { filled, elevated, outlined, text }
