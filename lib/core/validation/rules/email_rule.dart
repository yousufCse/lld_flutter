import '../validation_messages.dart';
import '../validation_rule.dart';

/// Validates a standard email format.
///
/// Skips validation if the value is null or empty — pair with
/// [RequiredRule] to enforce presence.
class EmailRule extends ValidationRule {
  const EmailRule([this.message = ValidationMessages.emailInvalid]);

  final String message;

  static final _pattern = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_pattern.hasMatch(value)) return message;
    return null;
  }
}
