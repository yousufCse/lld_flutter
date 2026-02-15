import '../validation_messages.dart';
import '../validation_rule.dart';

/// Validates that a field is not null, empty, or whitespace-only.
class RequiredRule extends ValidationRule {
  const RequiredRule([this.message = ValidationMessages.required]);

  final String message;

  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }
}
