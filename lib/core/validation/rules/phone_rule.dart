import '../validation_messages.dart';
import '../validation_rule.dart';

/// Validates a Bangladeshi phone number format (01XXXXXXXXX).
///
/// Strips spaces, hyphens, and parentheses before matching.
/// Skips validation if the value is null or empty — pair with
/// [RequiredRule] to enforce presence.
class PhoneRule extends ValidationRule {
  const PhoneRule([this.message = ValidationMessages.phoneInvalid]);

  final String message;

  static final _pattern = RegExp(r'^(\+88)?01[3-9]\d{8}$');

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_pattern.hasMatch(cleaned)) return message;
    return null;
  }
}
