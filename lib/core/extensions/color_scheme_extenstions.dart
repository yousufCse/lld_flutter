import 'package:flutter/material.dart';

/// Extension for shimmer-specific colors with automatic dark mode support.
///
/// Provides theme-aware shimmer colors that adapt to light/dark mode:
/// - Light mode: Subtle shimmer effect with lighter opacity
/// - Dark mode: More visible shimmer with higher opacity
extension ShimmerColors on ColorScheme {
  /// Base color for shimmer effect (background).
  Color get shimmerBase => brightness == Brightness.light
      ? onSurface.withValues(alpha: 0.08)
      : onSurface.withValues(alpha: 0.12);

  /// Highlight color for shimmer effect (animated overlay).
  Color get shimmerHighlight => brightness == Brightness.light
      ? onSurface.withValues(alpha: 0.04)
      : onSurface.withValues(alpha: 0.08);
}
