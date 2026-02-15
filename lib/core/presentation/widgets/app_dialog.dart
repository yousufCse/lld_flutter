import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';
import 'package:niramoy_health_app/core/resources/strings/app_strings.dart';

/// Semantic variant for [AppDialog.alert].
///
/// Each variant auto-selects an icon and accent color from the current
/// [ColorScheme], keeping dialogs visually consistent across the app.
enum DialogVariant { info, success, warning, error }

/// Centralized, theme-aware dialog system.
///
/// All styling (shape, elevation, colors) is inherited from [DialogTheme]
/// and [ColorScheme] — no hard-coded values.
///
/// Three dialog types are supported:
///
/// ```dart
/// // 1. Alert — single "OK" button
/// await AppDialog.alert(context, title: 'Done', message: 'Saved.');
///
/// // 2. Confirm — cancel + confirm, returns bool
/// final ok = await AppDialog.confirm(context, title: 'Delete?', message: '...');
///
/// // 3. Loading — non-dismissible spinner, closed via Navigator.pop
/// AppDialog.loading(context, message: 'Please wait...');
/// ```
class AppDialog {
  const AppDialog._();

  // ─── Alert ───────────────────────────────────────────────────────

  /// Shows an informational dialog with a single dismiss button.
  ///
  /// [variant] controls the icon and accent color:
  /// - [DialogVariant.info] (default) — primary color, info icon
  /// - [DialogVariant.success] — green, check-circle icon
  /// - [DialogVariant.warning] — orange, warning icon
  /// - [DialogVariant.error] — error color, error icon
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    DialogVariant variant = DialogVariant.info,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final (icon, color) = _variantConfig(variant, colors);

        return AlertDialog(
          icon: Icon(icon, color: color, size: AppSizes.space48),
          title: Text(
            title,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(confirmText ?? AppStrings.ok),
            ),
          ],
        );
      },
    );
  }

  // ─── Confirm ─────────────────────────────────────────────────────

  /// Shows a confirmation dialog with cancel and confirm buttons.
  ///
  /// Returns `true` if the user tapped confirm, `false` otherwise
  /// (including barrier dismiss).
  ///
  /// Set [isDestructive] to `true` to render the confirm button in
  /// [ColorScheme.error] (e.g. for delete / logout actions).
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return AlertDialog(
          title: Text(title, style: theme.textTheme.titleLarge),
          content: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText ?? AppStrings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: isDestructive
                  ? TextButton.styleFrom(foregroundColor: colors.error)
                  : null,
              child: Text(confirmText ?? AppStrings.confirm),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ─── Loading ─────────────────────────────────────────────────────

  /// Shows a non-dismissible loading dialog.
  ///
  /// The caller is responsible for closing it via `Navigator.pop(context)`.
  static void loading(BuildContext context, {String? message}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(color: colors.primary),
                SizedBox(width: AppSizes.space24),
                Expanded(
                  child: Text(
                    message ?? AppStrings.loading,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Variant helpers ─────────────────────────────────────────────

  static (IconData, Color) _variantConfig(
    DialogVariant variant,
    ColorScheme colors,
  ) {
    return switch (variant) {
      DialogVariant.info => (Icons.info_outline, colors.primary),
      DialogVariant.success => (Icons.check_circle_outline, Colors.green),
      DialogVariant.warning => (Icons.warning_amber_rounded, Colors.orange),
      DialogVariant.error => (Icons.error_outline, colors.error),
    };
  }
}

// ─── Context Extensions ──────────────────────────────────────────

extension DialogExtension on BuildContext {
  Future<void> showAlert({
    required String title,
    required String message,
    String? confirmText,
    DialogVariant variant = DialogVariant.info,
  }) {
    return AppDialog.alert(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      variant: variant,
    );
  }

  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
  }) {
    return AppDialog.confirm(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
    );
  }

  void showLoadingDialog({String? message}) {
    AppDialog.loading(this, message: message);
  }
}
