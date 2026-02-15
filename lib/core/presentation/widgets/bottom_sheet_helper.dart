import 'package:flutter/material.dart';

import '../../resources/app_sizes.dart';

/// Utility class for showing bottom sheets with consistent styling.
///
/// All bottom sheets automatically use the theme's [BottomSheetThemeData].
///
/// Usage examples:
/// ```dart
/// // Simple content bottom sheet
/// BottomSheetHelper.showContent(
///   context: context,
///   title: 'Confirmation',
///   child: Text('Are you sure you want to proceed?'),
/// );
///
/// // Scrollable list bottom sheet
/// BottomSheetHelper.showScrollable(
///   context: context,
///   title: 'Select an option',
///   builder: (context, scrollController) => ListView(
///     controller: scrollController,
///     children: [...],
///   ),
/// );
///
/// // Action sheet with buttons
/// BottomSheetHelper.showActions(
///   context: context,
///   title: 'Choose Action',
///   actions: [
///     BottomSheetAction(title: 'Edit', onTap: () => {}),
///     BottomSheetAction(title: 'Delete', onTap: () => {}, isDestructive: true),
///   ],
/// );
/// ```

class BottomSheetHelper {
  const BottomSheetHelper._();

  /// Shows a simple bottom sheet with a title and child widget.
  static Future<T?> showContent<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      // Theme automatically applied
      builder: (context) => _BottomSheetLayout(title: title, child: child),
    );
  }

  /// Shows a scrollable bottom sheet.
  ///
  /// The [builder] receives a [ScrollController] that must be passed
  /// to the scrollable widget (ListView, GridView, CustomScrollView, etc.)
  static Future<T?> showScrollable<T>({
    required BuildContext context,
    String? title,
    required Widget Function(BuildContext, ScrollController) builder,
    bool isDismissible = true,
    bool enableDrag = true,
    double initialChildSize = 0.6,
    double minChildSize = 0.3,
    double maxChildSize = 0.95,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) => _BottomSheetLayout(
          title: title,
          child: builder(context, scrollController),
        ),
      ),
    );
  }

  /// Shows an action sheet with a list of actions.
  static Future<T?> showActions<T>({
    required BuildContext context,
    String? title,
    required List<BottomSheetAction<T>> actions,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => _BottomSheetLayout(
        title: title,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: actions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return ListTile(
              leading: action.icon != null
                  ? Icon(
                      action.icon,
                      color: action.isDestructive
                          ? Theme.of(context).colorScheme.error
                          : null,
                    )
                  : null,
              title: Text(
                action.title,
                style: action.isDestructive
                    ? TextStyle(color: Theme.of(context).colorScheme.error)
                    : null,
              ),
              onTap: () {
                Navigator.pop(context, action.value);
                action.onTap?.call();
              },
            );
          },
        ),
      ),
    );
  }
}

/// Action item for use in [BottomSheetHelper.showActions].
class BottomSheetAction<T> {
  const BottomSheetAction({
    required this.title,
    this.icon,
    this.onTap,
    this.value,
    this.isDestructive = false,
  });

  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final T? value;
  final bool isDestructive;
}

/// Internal layout widget for consistent bottom sheet structure.
class _BottomSheetLayout extends StatelessWidget {
  const _BottomSheetLayout({this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.space24,
              AppSizes.space16,
              AppSizes.space24,
              AppSizes.space12,
            ),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ],
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.space24),
            child: child,
          ),
        ),
      ],
    );
  }
}
