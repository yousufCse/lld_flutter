import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';

/// App-wide dropdown field for generic selections.
///
/// Matches [AppTextField] styling for the outer container.
///
/// ```dart
/// AppDropdown<String>(
///   labelText: 'Gender',
///   items: ['Male', 'Female', 'Other'],
///   value: 'Male',
///   onChanged: (value) => setState(() => _gender = value),
///   prefixIcon: Icon(Icons.person_outline),
/// );
///
/// AppDropdown<String>(
///   labelText: 'Blood Group',
///   items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
///   value: 'A+',
///   onChanged: (value) => setState(() => _bloodGroup = value),
///   prefixIcon: Icon(Icons.bloodtype),
/// );
/// ```
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
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

  /// Custom builder for dropdown items. If null, uses `toString()`.
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
          child: DropdownButtonFormField<T>(
            initialValue: value,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(_itemToString(item)),
                  ),
                )
                .toList(),
            onChanged: enabled ? onChanged : null,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: prefixIcon,
              errorText: errorText,
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.space12,
                vertical: AppSizes.space4,
              ),
            ),
            validator: validator,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
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
}
