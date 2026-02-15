import 'package:niramoy_health_app/core/validation/rules/dob_rule.dart';

import 'field_validator.dart';
import 'rules/rules.dart';
import 'validation_messages.dart';

/// Pre-composed validators for common fields across the app.
///
/// Define once, reuse everywhere — in `TextFormField.validator`
/// and in Cubit logic with the same instance.
///
/// ```dart
/// // In UI
/// TextFormField(validator: AppValidators.firstName.call);
///
/// // In Cubit
/// final error = AppValidators.firstName('Jo');
/// ```
class AppValidators {
  const AppValidators._();

  static final firstName = FieldValidator([
    const RequiredRule(ValidationMessages.nameRequired),
    MinLengthRule(2, ValidationMessages.nameTooShort),
    PatternRule(_namePattern, ValidationMessages.nameInvalid),
  ]);

  static final lastName = FieldValidator([
    const RequiredRule(ValidationMessages.nameRequired),
    MinLengthRule(2, ValidationMessages.nameTooShort),
    PatternRule(_namePattern, ValidationMessages.nameInvalid),
  ]);

  static final phone = FieldValidator([
    const RequiredRule(ValidationMessages.phoneRequired),
    const PhoneRule(),
  ]);

  static final email = FieldValidator([
    const RequiredRule(ValidationMessages.emailRequired),
    const EmailRule(),
  ]);

  static final otp = FieldValidator([
    const RequiredRule(ValidationMessages.otpRequired),
    PatternRule(RegExp(r'^\d+$'), ValidationMessages.otpDigitsOnly),
    MinLengthRule(6, ValidationMessages.otpLength),
    MaxLengthRule(6, ValidationMessages.otpLength),
  ]);

  static final password = FieldValidator([
    const RequiredRule(ValidationMessages.passwordRequired),
    MinLengthRule(8, ValidationMessages.passwordTooShort),
  ]);

  static final dateOfBirth = FieldValidator([
    const RequiredRule(ValidationMessages.dobRequired),
    DobRule(),
  ]);

  static final gender = FieldValidator([
    const RequiredRule(ValidationMessages.genderRequired),
  ]);

  // Shared patterns
  static final _namePattern = RegExp(r"^[a-zA-Z\s.\-']+$");
}
