import '../validation_rule.dart';

/// Validates that a field has at most [max] characters (trimmed).
///
/// Skips validation if the value is null or empty.
class MaxLengthRule extends ValidationRule {
  MaxLengthRule(this.max, [String? message])
    : message = message ?? 'Must be no more than $max characters';

  final int max;
  final String message;

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.trim().length > max) return message;
    return null;
  }
}
