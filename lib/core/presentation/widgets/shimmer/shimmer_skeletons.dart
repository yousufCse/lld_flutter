import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';

/// Utility widget for creating rectangular shimmer placeholders.
///
/// This is a building block used by all preset skeletons to create
/// consistent placeholder boxes with rounded corners.
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Skeleton for list tile items (patient list, appointment list, medical records).
///
/// Layout:
/// - Circle avatar (48x48)
/// - Title line (full width, 16px height)
/// - Subtitle lines (2 lines, 12px height each)
class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.space16,
        vertical: AppSizes.space12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          const ShimmerBox(
            width: AppSizes.space48,
            height: AppSizes.space48,
            borderRadius: AppSizes.space48 / 2, // Circular
          ),
          const SizedBox(width: AppSizes.space12),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const ShimmerBox(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: AppSizes.space8),

                // Subtitle line 1
                ShimmerBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 12,
                  borderRadius: 4,
                ),
                const SizedBox(height: AppSizes.space4),

                // Subtitle line 2
                ShimmerBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 12,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for card widgets (appointment cards, medical record cards, info cards).
///
/// Layout:
/// - Header with circle avatar + title line
/// - Content area with 3 text lines of varying widths
/// - Proper card padding
class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const ShimmerBox(
                width: 40,
                height: 40,
                borderRadius: 20, // Circular
              ),
              const SizedBox(width: AppSizes.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(
                      width: double.infinity,
                      height: 16,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: AppSizes.space4),
                    ShimmerBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 12,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.space16),

          // Content lines
          const ShimmerBox(width: double.infinity, height: 12, borderRadius: 4),
          const SizedBox(height: AppSizes.space8),
          ShimmerBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 12,
            borderRadius: 4,
          ),
          const SizedBox(height: AppSizes.space8),
          ShimmerBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 12,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}

/// Skeleton for avatar placeholders (patient avatar, doctor avatar).
///
/// Creates a circular shimmer placeholder with customizable size.
class AvatarSkeleton extends StatelessWidget {
  final double size;

  const AvatarSkeleton({super.key, this.size = AppSizes.space48});

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: size,
      height: size,
      borderRadius: size / 2, // Circular
    );
  }
}

/// Skeleton for single line text placeholders.
///
/// Useful for loading states of individual text elements.
class TextLineSkeleton extends StatelessWidget {
  final double? width;
  final double height;

  const TextLineSkeleton({super.key, this.width, this.height = 16});

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width ?? MediaQuery.of(context).size.width * 0.7,
      height: height,
      borderRadius: 4,
    );
  }
}

/// Skeleton for button loading state.
///
/// Matches AppButton dimensions with proper border radius.
class ButtonSkeleton extends StatelessWidget {
  const ButtonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      borderRadius: AppSizes.buttonRadius,
    );
  }
}
