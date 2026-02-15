import 'package:flutter/material.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';

/// App-wide time picker styled identically to [AppTextField].
///
/// Tap the field or the clock icon to open Flutter's standard time picker.
/// Supports pre-selected times, custom formatting, and [Form] validation.
///
/// ```dart
/// AppTimePicker(
///   labelText: 'Appointment Time',
///   initialValue: const TimeOfDay(hour: 10, minute: 30),
///   onChanged: (time) => bloc.add(TimeChanged(time)),
/// );
/// ```
class AppTimePicker extends StatefulWidget {
  const AppTimePicker({
    super.key,
    required this.labelText,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.timeFormat,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.errorText,
  });

  final String labelText;
  final String? hintText;

  /// Pre-selected time. When the parent changes this value the picker updates.
  final TimeOfDay? initialValue;

  /// Called when the user picks a new time.
  final void Function(TimeOfDay)? onChanged;

  /// Custom time-to-string formatter. Default: HH:mm (24-hour).
  /// For locale-aware 12/24 h switching pass: (time) => time.format(context)
  final String Function(TimeOfDay)? timeFormat;

  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? errorText;

  @override
  State<AppTimePicker> createState() => _AppTimePickerState();
}

class _AppTimePickerState extends State<AppTimePicker> {
  TimeOfDay? _selectedTime;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialValue;
    if (_selectedTime != null) {
      _controller.text = _formatTime(_selectedTime!);
    }
  }

  @override
  void didUpdateWidget(covariant AppTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedTime = widget.initialValue;
        _controller.text = _selectedTime != null
            ? _formatTime(_selectedTime!)
            : '';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) {
    if (widget.timeFormat != null) return widget.timeFormat!(time);
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openPicker() async {
    if (!widget.enabled) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (!mounted || picked == null) return;

    setState(() {
      _selectedTime = picked;
      _controller.text = _formatTime(picked);
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
                icon: const Icon(Icons.access_time),
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
