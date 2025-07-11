import 'package:lld_flutter/core/utils/validators/validator_strategy.dart';

class PasswordValidator extends ValidatorsStrategy {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}
