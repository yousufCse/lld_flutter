import 'validation_rule.dart';

/// Composes multiple [ValidationRule]s for a single field.
///
/// Runs rules in declaration order and returns the **first** error found.
/// Returns `null` when all rules pass.
///
/// ```dart
/// const validator = FieldValidator([
///   RequiredRule('Name is required'),
///   MinLengthRule(2),
/// ]);
///
/// // Use in TextFormField
/// TextFormField(validator: validator.call);
///
/// // Use in Cubit
/// final error = validator('');
/// ```
class FieldValidator {
  const FieldValidator(this._rules);

  final List<ValidationRule> _rules;

  /// Validates [value] against all rules in order.
  ///
  /// Can be passed directly as a `TextFormField.validator` callback.
  String? call(String? value) {
    for (final rule in _rules) {
      final error = rule.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}
