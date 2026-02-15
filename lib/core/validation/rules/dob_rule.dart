import 'package:niramoy_health_app/core/validation/validation_messages.dart';
import 'package:niramoy_health_app/core/validation/validation_rule.dart';

class DobRule extends ValidationRule {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.dobRequired;
    }
    // Additional validation for date format and logical checks (e.g., not in the future) can be added here.
    return null;
  }
}
