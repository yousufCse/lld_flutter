import 'dart:async';

import 'package:flutter/material.dart';

import 'package:niramoy_health_app/core/resources/app_sizes.dart';

/// Snackbar type enum defining the visual state and semantics.
enum SnackbarType { success, error, warning, info }

/// Configuration class for customizing snackbar behavior and appearance.
class AppSnackbarConfig {
  /// Optional custom title. If null, uses the type-specific default title.
  final String? title;

  /// Optional action label shown as tappable text below the message.
  final String? actionLabel;

  /// Callback invoked when action text is tapped.
  final VoidCallback? onAction;

  /// Duration before auto-dismissal. Default: 4 seconds.
  final Duration duration;

  /// Whether snackbar can be dismissed by swiping up.
  final bool? dismissible;

  /// Optional margin around the snackbar. Default: 16px horizontal.
  final EdgeInsets? margin;

  /// Optional custom background color override.
  final Color? backgroundColor;

  /// Optional custom text color override.
  final Color? textColor;

  /// Optional custom icon override.
  final IconData? icon;

  /// Whether to show an icon. Default: true.
  final bool showIcon;

  const AppSnackbarConfig({
    this.title,
    this.actionLabel,
    this.onAction,
    this.duration = const Duration(seconds: 4),
    this.dismissible,
    this.margin,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.showIcon = true,
  });

  AppSnackbarConfig copyWith({
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    bool? dismissible,
    EdgeInsets? margin,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    bool? showIcon,
  }) {
    return AppSnackbarConfig(
      title: title ?? this.title,
      actionLabel: actionLabel ?? this.actionLabel,
      onAction: onAction ?? this.onAction,
      duration: duration ?? this.duration,
      dismissible: dismissible ?? this.dismissible,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      icon: icon ?? this.icon,
      showIcon: showIcon ?? this.showIcon,
    );
  }
}

/// Central snackbar manager that displays snackbars at the top of the screen.
///
/// Uses an [Overlay] entry with a slide-from-top animation instead of
/// [ScaffoldMessenger], which only supports bottom positioning.
///
/// **Usage:**
/// ```dart
/// AppSnackbar.showSuccess(context, 'Profile updated successfully');
///
/// AppSnackbar.showError(
///   context,
///   'Failed to save changes',
///   config: AppSnackbarConfig(
///     title: 'Upload failed',
///     actionLabel: 'Retry',
///     onAction: () => saveChanges(),
///   ),
/// );
///
/// // Using context extension (recommended)
/// context.showSuccessSnackbar('Operation completed');
/// ```
class AppSnackbar2 {
  const AppSnackbar2._();

  static OverlayEntry? _currentEntry;

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

  static void showError(
    BuildContext context,
    String message, {
    AppSnackbarConfig? config,
  }) {
    _show(context, message: message, type: SnackbarType.error, config: config);
  }

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

  static void showInfo(
    BuildContext context,
    String message, {
    AppSnackbarConfig? config,
  }) {
    _show(context, message: message, type: SnackbarType.info, config: config);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    AppSnackbarConfig? config,
  }) {
    // Remove any existing snackbar before showing a new one
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);
    final theme = Theme.of(context);
    final typeConfig = _getTypeConfig(type);
    final effectiveConfig = config ?? const AppSnackbarConfig();

    final backgroundColor =
        effectiveConfig.backgroundColor ?? typeConfig.backgroundColor;
    final textColor = effectiveConfig.textColor ?? typeConfig.textColor;
    final icon = effectiveConfig.showIcon
        ? (effectiveConfig.icon ?? typeConfig.icon)
        : null;
    final title = effectiveConfig.title ?? typeConfig.defaultTitle;

    final titleStyle = theme.textTheme.titleSmall?.copyWith(
      color: textColor,
      fontWeight: FontWeight.bold,
    );
    final messageStyle = theme.textTheme.bodySmall?.copyWith(color: textColor);

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (_) => _TopSnackbar(
        title: title,
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        borderColor: typeConfig.borderColor,
        iconBackgroundColor: typeConfig.iconBackgroundColor,
        iconColor: typeConfig.iconColor,
        textColor: textColor,
        titleStyle: titleStyle,
        messageStyle: messageStyle,
        dismissible: effectiveConfig.dismissible ?? true,
        actionLabel: effectiveConfig.actionLabel,
        onAction: effectiveConfig.onAction,
        duration: effectiveConfig.duration,
        margin: effectiveConfig.margin,
        onDismiss: () {
          entry?.remove();
          _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static _TypeConfig _getTypeConfig(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const _TypeConfig(
          backgroundColor: Color(0xFFEDF7ED),
          borderColor: Color(0xFF81C784),
          iconBackgroundColor: Color(0xFF4CAF50),
          iconColor: Colors.white,
          textColor: Color(0xFF1C1C1C),
          icon: Icons.check_rounded,
          defaultTitle: 'Congratulations!',
        );
      case SnackbarType.error:
        return const _TypeConfig(
          backgroundColor: Color(0xFFFFEBEE),
          borderColor: Color(0xFFEF9A9A),
          iconBackgroundColor: Color(0xFFF44336),
          iconColor: Colors.white,
          textColor: Color(0xFF1C1C1C),
          icon: Icons.close_rounded,
          defaultTitle: 'Something went wrong!',
        );
      case SnackbarType.warning:
        return const _TypeConfig(
          backgroundColor: Color(0xFFFFF8E1),
          borderColor: Color(0xFFFFCC80),
          iconBackgroundColor: Color(0xFFFF9800),
          iconColor: Colors.white,
          textColor: Color(0xFF1C1C1C),
          icon: Icons.priority_high_rounded,
          defaultTitle: 'Warning!',
        );
      case SnackbarType.info:
        return const _TypeConfig(
          backgroundColor: Color(0xFFE3F2FD),
          borderColor: Color(0xFF90CAF9),
          iconBackgroundColor: Color(0xFF2196F3),
          iconColor: Colors.white,
          textColor: Color(0xFF1C1C1C),
          icon: Icons.question_mark_rounded,
          defaultTitle: 'Did you know?',
        );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Internal Supporting Classes
// ═══════════════════════════════════════════════════════════════════════════

class _TypeConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;
  final String defaultTitle;

  const _TypeConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
    required this.defaultTitle,
  });
}

/// Overlay widget that slides in from the top with animation.
class _TopSnackbar extends StatefulWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final EdgeInsets? margin;
  final bool dismissible;
  final VoidCallback onDismiss;

  const _TopSnackbar({
    required this.title,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.titleStyle,
    required this.messageStyle,
    required this.duration,
    required this.dismissible,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.margin,
  });

  @override
  State<_TopSnackbar> createState() => _TopSnackbarState();
}

class _TopSnackbarState extends State<_TopSnackbar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _timer?.cancel();
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final newOffset = _dragOffset + details.delta.dy;
    if (newOffset < 0) {
      setState(() => _dragOffset = newOffset.clamp(-200.0, 0.0));
    }
  }

  void _onDragEnd(DragEndDetails details) {
    const velocityThreshold = -300.0;
    const distanceThreshold = -60.0;

    if (details.velocity.pixelsPerSecond.dy < velocityThreshold ||
        _dragOffset < distanceThreshold) {
      _dismiss();
    } else {
      setState(() => _dragOffset = 0.0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final margin =
        widget.margin ??
        const EdgeInsets.symmetric(horizontal: AppSizes.space16);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: margin.copyWith(top: AppSizes.space8),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.translate(
                offset: Offset(0, _dragOffset),
                child: GestureDetector(
                  onVerticalDragUpdate: widget.dismissible
                      ? _onDragUpdate
                      : null,
                  onVerticalDragEnd: widget.dismissible ? _onDragEnd : null,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(
                          AppSizes.cardRadius,
                        ),
                        border: Border.all(color: widget.borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _SnackbarContent(
                        title: widget.title,
                        message: widget.message,
                        icon: widget.icon,
                        iconBackgroundColor: widget.iconBackgroundColor,
                        iconColor: widget.iconColor,
                        textColor: widget.textColor,
                        titleStyle: widget.titleStyle,
                        messageStyle: widget.messageStyle,
                        actionLabel: widget.actionLabel,
                        onAction: widget.onAction,
                        onDismiss: _dismiss,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SnackbarContent extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;

  const _SnackbarContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.titleStyle,
    required this.messageStyle,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular icon
          if (icon != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
          const SizedBox(width: AppSizes.space12),

          // Title + message body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: titleStyle),
                const SizedBox(height: AppSizes.space4),
                Text(
                  message,
                  style: messageStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: AppSizes.space4),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: messageStyle?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSizes.space8),

          // Dismiss button
          GestureDetector(
            onTap: onDismiss,
            child: Icon(
              Icons.close,
              color: textColor.withValues(alpha: 0.5),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Context Extensions
// ═══════════════════════════════════════════════════════════════════════════

extension SnackbarExtension on BuildContext {
  void showSuccessSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar2.showSuccess(this, message, config: config);
  }

  void showErrorSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar2.showError(this, message, config: config);
  }

  void showWarningSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar2.showWarning(this, message, config: config);
  }

  void showInfoSnackbar(String message, {AppSnackbarConfig? config}) {
    AppSnackbar2.showInfo(this, message, config: config);
  }
}
