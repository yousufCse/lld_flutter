import '../validation_rule.dart';

/// Validates that a field has at least [min] characters (trimmed).
///
/// Skips validation if the value is null or empty — pair with
/// [RequiredRule] to enforce presence.
class MinLengthRule extends ValidationRule {
  MinLengthRule(this.min, [String? message])
    : message = message ?? 'Must be at least $min characters';

  final int min;
  final String message;

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.trim().length < min) return message;
    return null;
  }
}
