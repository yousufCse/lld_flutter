import '../validation_rule.dart';

/// Validates that a field matches the given [RegExp] pattern.
///
/// Skips validation if the value is null or empty — pair with
/// [RequiredRule] to enforce presence.
class PatternRule extends ValidationRule {
  const PatternRule(this.pattern, this.message);

  final RegExp pattern;
  final String message;

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!pattern.hasMatch(value)) return message;
    return null;
  }
}
