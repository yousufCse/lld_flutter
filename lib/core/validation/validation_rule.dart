/// Base contract for all validation rules (Strategy Pattern).
///
/// Each rule encapsulates a single validation concern and returns
/// an error message if the value is invalid, or `null` if valid.
///
/// Rules are designed to be composed via [FieldValidator].
abstract class ValidationRule {
  const ValidationRule();

  /// Returns an error message if [value] is invalid, `null` otherwise.
  String? validate(String? value);
}
