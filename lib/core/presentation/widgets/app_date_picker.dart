import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';

// ─── Date Picker ─────────────────────────────────────────────────────────────

/// App-wide date picker styled identically to [AppTextField].
///
/// Tap the field or the calendar icon to open Flutter's standard date picker.
/// Supports pre-selected dates, custom formatting, and [Form] validation.
///
/// ```dart
/// AppDatePicker(
///   labelText: 'Date of Birth',
///   initialValue: DateTime(1990, 5, 15),
///   onChanged: (date) => bloc.add(DobChanged(date)),
///   lastDate: DateTime.now(),
/// );
/// ```
class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    super.key,
    required this.labelText,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.errorText,
  });

  final String labelText;
  final String? hintText;

  /// Pre-selected date. When the parent changes this value the picker updates.
  final DateTime? initialValue;

  /// Called when the user picks a new date.
  final void Function(DateTime)? onChanged;

  /// Earliest selectable date. Defaults to 1 Jan 1900.
  final DateTime? firstDate;

  /// Latest selectable date. Defaults to 31 Dec 2100.
  final DateTime? lastDate;

  /// Custom date-to-string formatter. Default: dd/MM/yyyy.
  final String Function(DateTime)? dateFormat;

  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? errorText;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime? _selectedDate;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialValue;
    if (_selectedDate != null) {
      _controller.text = _formatDate(_selectedDate!);
    }
  }

  @override
  void didUpdateWidget(covariant AppDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedDate = widget.initialValue;
        _controller.text = _selectedDate != null
            ? _formatDate(_selectedDate!)
            : '';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    if (widget.dateFormat != null) return widget.dateFormat!(date);
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _openPicker() async {
    if (!widget.enabled) return;

    final firstDate = widget.firstDate ?? DateTime(1900, 1, 1);
    final lastDate = widget.lastDate ?? DateTime(2100, 12, 31);
    var initialDate = _selectedDate ?? DateTime.now();

    // Clamp initialDate within valid range
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (!mounted || picked == null) return;

    setState(() {
      _selectedDate = picked;
      _controller.text = _formatDate(picked);
    });
    widget.onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSizes.textFieldHeight,
          child: TextFormField(
            controller: _controller,
            readOnly: true,
            onTap: _openPicker,
            enabled: widget.enabled,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              errorText: widget.errorText,
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.space12,
                vertical: AppSizes.space4,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _openPicker,
              ),
            ),
            validator: widget.validator,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.space12,
            top: AppSizes.space4,
          ),
          child: Text(
            widget.errorText ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: widget.errorText != null ? errorColor : Colors.transparent,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
