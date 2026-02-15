import 'package:flutter/material.dart';

import '../../resources/app_sizes.dart';

/// App-wide bottom sheet for generic selections.
///
/// Matches [AppTextField] styling for the trigger field. Displays items
/// in a modal bottom sheet with a scrollable list.
///
/// ```dart
/// AppBottomSheet<String>(
///   labelText: 'Select Country',
///   items: ['USA', 'UK', 'Canada', 'Australia', ...],
///   value: 'USA',
///   onChanged: (value) => setState(() => _country = value),
///   prefixIcon: Icon(Icons.flag),
///   errorText: state.countryError,  // Cubit-driven validation
/// );
/// ```
class AppBottomSheet<T> extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.itemBuilder,
    this.errorText,
  });

  final String labelText;
  final String? hintText;
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;
  final String? errorText;

  /// Custom builder for bottom sheet items. If null, uses `toString()`.
  final String Function(T)? itemBuilder;

  String _itemToString(T item) => itemBuilder?.call(item) ?? item.toString();

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSizes.textFieldHeight,
          child: InkWell(
            onTap: enabled ? () => _showBottomSheet(context) : null,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                prefixIcon: prefixIcon,
                suffixIcon: const Icon(Icons.arrow_drop_down),
                enabled: enabled,
                errorText: errorText,
                errorStyle: const TextStyle(fontSize: 0, height: 0),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.space12,
                  vertical: AppSizes.space4,
                ),
              ),
              child: Text(
                value != null ? _itemToString(value as T) : hintText ?? '',
                style: value == null
                    ? Theme.of(context).inputDecorationTheme.hintStyle
                    : null,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.space12,
            top: AppSizes.space4,
          ),
          child: Text(
            errorText ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: errorText != null ? errorColor : Colors.transparent,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      // Theme automatically applied via bottomSheetTheme
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Title bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    labelText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            // Items list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == value;
                  return ListTile(
                    title: Text(_itemToString(item)),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    selected: isSelected,
                    onTap: () => Navigator.pop(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      onChanged(selected);
    }
  }
}
