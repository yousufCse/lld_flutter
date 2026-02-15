import '../validation_rule.dart';

/// Escape hatch for one-off validations without creating a new rule class.
///
/// ```dart
/// CustomRule((value) {
///   if (value != null && value.contains('admin')) {
///     return 'Username cannot contain "admin"';
///   }
///   return null;
/// });
/// ```
class CustomRule extends ValidationRule {
  const CustomRule(this._validate);

  final String? Function(String? value) _validate;

  @override
  String? validate(String? value) => _validate(value);
}
