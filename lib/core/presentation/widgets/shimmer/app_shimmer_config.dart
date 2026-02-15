import 'package:flutter/material.dart';

/// Configuration class for customizing shimmer behavior and appearance.
///
/// All parameters are optional and have sensible defaults aligned with
/// Material 3 design principles.
///
/// Usage:
/// ```dart
/// AppShimmerConfig(
///   period: const Duration(milliseconds: 2000),
///   enabled: state.isLoading,
/// )
/// ```
class AppShimmerConfig {
  /// Optional custom base color for the shimmer effect.
  /// If null, uses theme-aware color from ColorScheme extension.
  final Color? baseColor;

  /// Optional custom highlight color for the shimmer effect.
  /// If null, uses theme-aware color from ColorScheme extension.
  final Color? highlightColor;

  /// Duration of one shimmer animation cycle.
  /// Default: 1500ms (Material 3 recommendation for skeleton screens).
  final Duration period;

  /// Whether the shimmer animation is enabled.
  /// When false, shows static skeleton without animation.
  /// Default: true.
  final bool enabled;

  const AppShimmerConfig({
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  /// Creates a copy with optional parameter overrides.
  ///
  /// Usage:
  /// ```dart
  /// final newConfig = config.copyWith(enabled: false);
  /// ```
  AppShimmerConfig copyWith({
    Color? baseColor,
    Color? highlightColor,
    Duration? period,
    bool? enabled,
  }) {
    return AppShimmerConfig(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      period: period ?? this.period,
      enabled: enabled ?? this.enabled,
    );
  }
}
