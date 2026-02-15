import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../extensions/index.dart';
import 'shimmer/app_shimmer_config.dart';
import 'shimmer/shimmer_skeletons.dart';

/// App-wide shimmer loading component for skeleton screens.
///
/// Provides shimmer/skeleton loading states for lists, cards, and other content
/// to improve perceived performance and user experience.
///
/// **Features:**
/// - Factory constructors for common use cases (list tiles, cards, avatars, etc.)
/// - Theme-aware colors with automatic dark mode support
/// - Configurable animation period and behavior
/// - Follows existing app patterns (AppButton, AppSnackbar)
///
/// **Usage:**
/// ```dart
/// // List tile shimmer
/// AppShimmer.listTile();
///
/// // Card shimmer
/// AppShimmer.card();
///
/// // Avatar shimmer
/// AppShimmer.avatar();
///
/// // Custom configuration
/// AppShimmer.listTile(
///   config: AppShimmerConfig(
///     period: Duration(milliseconds: 2000),
///     enabled: state.isLoading,
///   ),
/// );
///
/// // ListView integration
/// ListView.builder(
///   itemCount: isLoading ? 5 : patients.length,
///   itemBuilder: (context, index) {
///     if (isLoading) return AppShimmer.listTile();
///     return PatientListTile(patient: patients[index]);
///   },
/// )
/// ```
class AppShimmer extends StatelessWidget {
  const AppShimmer._({super.key, required this.child, this.config});

  /// The skeleton widget to display with shimmer effect.
  final Widget child;

  /// Optional configuration for customizing shimmer behavior.
  final AppShimmerConfig? config;

  /// Creates a shimmer effect for list tile items.
  ///
  /// Use for: patient lists, appointment lists, medical record lists.
  ///
  /// Layout includes:
  /// - Circle avatar (48x48)
  /// - Title line
  /// - Two subtitle lines
  const AppShimmer.listTile({Key? key, AppShimmerConfig? config})
    : this._(key: key, child: const ListTileSkeleton(), config: config);

  /// Creates a shimmer effect for card widgets.
  ///
  /// Use for: appointment cards, medical record cards, info cards.
  ///
  /// Layout includes:
  /// - Header with avatar and text
  /// - Content area with multiple text lines
  const AppShimmer.card({Key? key, AppShimmerConfig? config})
    : this._(key: key, child: const CardSkeleton(), config: config);

  /// Creates a shimmer effect for avatar placeholders.
  ///
  /// Use for: patient avatars, doctor avatars, profile pictures.
  ///
  /// [size] - Diameter of the circular avatar (default: 48px)
  AppShimmer.avatar({Key? key, AppShimmerConfig? config, double size = 48.0})
    : this._(
        key: key,
        child: AvatarSkeleton(size: size),
        config: config,
      );

  /// Creates a shimmer effect for single text lines.
  ///
  /// Use for: loading individual text elements, labels, headings.
  ///
  /// [width] - Optional width constraint (defaults to 70% of screen width)
  /// [height] - Line height (default: 16px)
  AppShimmer.textLine({
    Key? key,
    AppShimmerConfig? config,
    double? width,
    double height = 16,
  }) : this._(
         key: key,
         child: TextLineSkeleton(width: width, height: height),
         config: config,
       );

  /// Creates a shimmer effect for button loading states.
  ///
  /// Use for: loading states of primary actions, form submissions.
  ///
  /// Matches AppButton dimensions (48px height, 8px border radius).
  const AppShimmer.button({Key? key, AppShimmerConfig? config})
    : this._(key: key, child: const ButtonSkeleton(), config: config);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const AppShimmerConfig();

    // If shimmer is disabled, show static skeleton
    if (!effectiveConfig.enabled) {
      return child;
    }

    final colorScheme = Theme.of(context).colorScheme;

    // Get theme-aware shimmer colors using extension
    final baseColor = effectiveConfig.baseColor ?? colorScheme.shimmerBase;
    final highlightColor =
        effectiveConfig.highlightColor ?? colorScheme.shimmerHighlight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: effectiveConfig.period,
      child: child,
    );
  }
}
