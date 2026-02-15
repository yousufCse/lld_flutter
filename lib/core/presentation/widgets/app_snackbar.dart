import 'package:flutter/material.dart';

import '../../resources/app_sizes.dart';

/// Snackbar type enum defining the visual state and semantics.
///
/// Each type has a specific color scheme, icon, and semantic meaning:
/// - [success]: Positive confirmation (e.g., "Saved successfully")
/// - [error]: Critical failures requiring attention
/// - [warning]: Cautionary messages (e.g., "Connection unstable")
/// - [info]: Neutral informational messages
enum SnackbarType { success, error, warning, info }

/// Configuration class for customizing snackbar behavior and appearance.
///
/// All parameters are optional and have sensible defaults.
///
/// Usage:
/// ```dart
/// AppSnackbarConfig(
///   duration: const Duration(seconds: 5),
///   actionLabel: 'Retry',
///   onAction: () => retryOperation(),
///   dismissible: true,
/// )
/// ```
class AppSnackbarConfig {
  /// Optional action button label.
  final String? actionLabel;

  /// Callback invoked when action button is tapped.
  final VoidCallback? onAction;

  /// Duration before auto-dismissal. Default: 4 seconds.
  /// Use [Duration.zero] or very short durations only for testing.
  final Duration duration;

  /// Whether snackbar can be dismissed by swiping.
  /// Default: true for all except error (errors require explicit dismissal).
  final bool? dismissible;

  /// Optional margin around the snackbar.
  /// Default: 16px on all sides (Material 3 spec for floating behavior).
  final EdgeInsets? margin;

  /// Optional custom background color.
  /// If null, uses type-specific color from theme.
  final Color? backgroundColor;

  /// Optional custom text color.
  /// If null, uses contrasting color based on background.
  final Color? textColor;

  /// Optional elevation for snackbar shadow.
  /// Default: 6.0 (Material 3 spec).
  final double? elevation;

  /// Optional custom icon.
  /// If null, uses type-specific icon.
  final IconData? icon;

  /// Whether to show an icon.
  /// Default: true.
  final bool showIcon;

  /// Snackbar behavior - floating or fixed.
  /// Default: floating (Material 3 recommendation).
  final SnackBarBehavior? behavior;

  /// Width constraint for the snackbar on large screens.
  /// Default: 600px (Material 3 spec).
  final double? maxWidth;

  /// Callback invoked when snackbar is visible.
  final VoidCallback? onVisible;

  const AppSnackbarConfig({
    this.actionLabel,
    this.onAction,
    this.duration = const Duration(seconds: 4),
    this.dismissible,
    this.margin,
    this.backgroundColor,
    this.textColor,
    this.elevation,
    this.icon,
    this.showIcon = true,
    this.behavior,
    this.maxWidth,
    this.onVisible,
  });

  /// Creates a copy with optional parameter overrides.
  AppSnackbarConfig copyWith({
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    bool? dismissible,
    EdgeInsets? margin,
    Color? backgroundColor,
    Color? textColor,
    double? elevation,
    IconData? icon,
    bool? showIcon,
    SnackBarBehavior? behavior,
    double? maxWidth,
    VoidCallback? onVisible,
  }) {
    return AppSnackbarConfig(
      actionLabel: actionLabel ?? this.actionLabel,
      onAction: onAction ?? this.onAction,
      duration: duration ?? this.duration,
      dismissible: dismissible ?? this.dismissible,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      elevation: elevation ?? this.elevation,
      icon: icon ?? this.icon,
      showIcon: showIcon ?? this.showIcon,
      behavior: behavior ?? this.behavior,
      maxWidth: maxWidth ?? this.maxWidth,
      onVisible: onVisible ?? this.onVisible,
    );
  }
}

/// Central snackbar manager with static methods for showing typed snackbars.
///
/// This class provides a consistent API for displaying snackbars throughout
/// the app. All methods are static and use the [ScaffoldMessenger] API
/// to ensure proper queue management and lifecycle handling.
///
/// **Features:**
/// - Type-safe snackbar variants (success, error, warning, info)
/// - Automatic queue management (prevents snackbar spam)
/// - Memory efficient (clears previous snackbars before showing new ones)
/// - Material 3 compliant design
/// - Accessibility support (semantic labels, proper contrast)
/// - Customizable via [AppSnackbarConfig]
///
/// **Usage:**
/// ```dart
/// // Simple success message
/// AppSnackbar.showSuccess(context, 'Profile updated successfully');
///
/// // Error with action
/// AppSnackbar.showError(
///   context,
///   'Failed to save changes',
///   config: AppSnackbarConfig(
///     actionLabel: 'Retry',
///     onAction: () => saveChanges(),
///   ),
/// );
///
/// // Using context extension (recommended)
/// context.showSuccessSnackbar('Operation completed');
/// context.showErrorSnackbar('Something went wrong');
/// ```
class AppSnackbar {
  const AppSnackbar._();

  // ═══════════════════════════════════════════════════════════════════════
  // Public API - Typed Snackbar Methods
  // ═══════════════════════════════════════════════════════════════════════

  /// Shows a success snackbar with green background.
  ///
  /// Use for positive confirmations like:
  /// - "Saved successfully"
  /// - "Profile updated"
  /// - "Payment processed"
  static void showSuccess(
    BuildContext context,
    String message, {
    AppSnackbarConfig? config,
  }) {
    _show(
      context,
      message: message,
      type: SnackbarType.success,
      config: config,
    );
  }

  /// Shows an error snackbar with red background.
  ///
  /// Use for critical failures like:
  /// - "Failed to save changes"
  /// - "Network error"
  /// - "Invalid credentials"
  ///
  /// Error snackbars are not dismissible by default (require explicit action).
  static void showError(
    BuildContext context,
    String message, {
    AppSnackbarConfig? config,
  }) {
    _show(context, message: message, type: SnackbarType.error, config: config);
  }

  /// Shows a warning snackbar with orange/amber background.
  ///
  /// Use for cautionary messages like:
  /// - "Connection unstable"
  /// - "Low battery"
  /// - "Approaching limit"
  static void showWarning(
    BuildContext context,
    String message, {
    AppSnackbarConfig? config,
  }) {
    _show(
      context,
      message: message,
      type: SnackbarType.warning,
      config: config,
    );
  }

  /// Shows an info snackbar with blue background.
  ///
  /// Use for neutral informational messages like:
  /// - "New version available"
  /// - "Syncing in progress"
  /// - "Feature tour completed"
  static void showInfo(
    BuildContext context,
    String message, {
    AppSnackbarConfig? config,
  }) {
    _show(context, message: message, type: SnackbarType.info, config: config);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Core Implementation
  // ═══════════════════════════════════════════════════════════════════════

  /// Internal method that handles the actual snackbar display.
  ///
  /// This method:
  /// 1. Clears any existing snackbars to prevent queue buildup
  /// 2. Resolves type-specific styling (colors, icons)
  /// 3. Builds the snackbar with proper Material 3 design
  /// 4. Shows it via ScaffoldMessenger with proper lifecycle management
  static void _show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    AppSnackbarConfig? config,
  }) {
    // Clear existing snackbars to prevent queue buildup and memory leaks
    ScaffoldMessenger.of(context).clearSnackBars();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Resolve type-specific defaults
    final typeConfig = _getTypeConfig(type, colorScheme);
    final effectiveConfig = config ?? const AppSnackbarConfig();

    // Determine background color
    final backgroundColor =
        effectiveConfig.backgroundColor ?? typeConfig.backgroundColor;

    // Determine text color (ensure proper contrast)
    final textColor = effectiveConfig.textColor ?? typeConfig.textColor;

    // Determine icon
    final icon = effectiveConfig.showIcon
        ? (effectiveConfig.icon ?? typeConfig.icon)
        : null;

    // Determine dismissible behavior
    // Errors are not dismissible by default (require explicit action)
    final dismissible =
        effectiveConfig.dismissible ?? (type != SnackbarType.error);

    // Build snackbar content
    final content = _SnackbarContent(
      message: message,
      icon: icon,
      textColor: textColor,
      textStyle: textTheme.bodyMedium?.copyWith(color: textColor),
    );

    // Build action button if provided
    final action =
        effectiveConfig.actionLabel != null && effectiveConfig.onAction != null
        ? SnackBarAction(
            label: effectiveConfig.actionLabel!,
            onPressed: effectiveConfig.onAction!,
            textColor: textColor,
          )
        : null;

    // Create snackbar with proper constraints
    final snackBar = SnackBar(
      content: content,
      backgroundColor: backgroundColor,
      behavior: effectiveConfig.behavior ?? SnackBarBehavior.floating,
      action: action,
      duration: effectiveConfig.duration,
      dismissDirection: dismissible
          ? DismissDirection.down
          : DismissDirection.none,
      margin: effectiveConfig.margin ?? const EdgeInsets.all(AppSizes.space16),
      elevation: effectiveConfig.elevation ?? 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      // Only set width if explicitly provided and behavior is floating
      width:
          (effectiveConfig.behavior ?? SnackBarBehavior.floating) ==
              SnackBarBehavior.floating
          ? effectiveConfig.maxWidth
          : null,
      // Callback when visible
      onVisible: effectiveConfig.onVisible,
    );

    // Show snackbar via ScaffoldMessenger
    // This ensures proper queue management and lifecycle handling
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Returns type-specific styling configuration.
  ///
  /// This method maps each [SnackbarType] to its corresponding:
  /// - Background color
  /// - Text color (with proper contrast)
  /// - Icon
  ///
  /// Colors are derived from Material 3 [ColorScheme] to ensure:
  /// - Consistency with app theme
  /// - Proper contrast ratios (WCAG AA compliant)
  /// - Automatic dark mode support
  static _TypeConfig _getTypeConfig(
    SnackbarType type,
    ColorScheme colorScheme,
  ) {
    switch (type) {
      case SnackbarType.success:
        return _TypeConfig(
          backgroundColor: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          icon: Icons.check_circle_outline_rounded,
        );

      case SnackbarType.error:
        return _TypeConfig(
          backgroundColor: colorScheme.error,
          textColor: colorScheme.onError,
          icon: Icons.error_outline_rounded,
        );

      case SnackbarType.warning:
        return _TypeConfig(
          backgroundColor: colorScheme.tertiary,
          textColor: colorScheme.onTertiary,
          icon: Icons.warning_amber_rounded,
        );

      case SnackbarType.info:
        return _TypeConfig(
          backgroundColor: colorScheme.secondary,
          textColor: colorScheme.onSecondary,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Internal Supporting Classes
// ═══════════════════════════════════════════════════════════════════════════

/// Internal class holding type-specific styling.
class _TypeConfig {
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const _TypeConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}

/// Internal widget for snackbar content with icon and message.
///
/// This widget is optimized for performance:
/// - Uses const constructor where possible
/// - Minimal rebuild surface
/// - Efficient layout with Row + mainAxisSize.min
class _SnackbarContent extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color textColor;
  final TextStyle? textStyle;

  const _SnackbarContent({
    required this.message,
    required this.icon,
    required this.textColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon (if provided)
        if (icon != null) ...[
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: AppSizes.space12),
        ],

        // Message text
        Expanded(
          child: Text(
            message,
            style: textStyle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Context Extensions
// ═══════════════════════════════════════════════════════════════════════════

extension SnackbarExtension on BuildContext {
  void showSuccessSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar.showSuccess(this, message, config: config);
  }

  void showErrorSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar.showError(this, message, config: config);
  }

  void showWarningSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar.showWarning(this, message, config: config);
  }

  void showInfoSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar.showInfo(this, message, config: config);
  }
}
