import 'package:lld_flutter/core/utils/validators/validator_strategy.dart';

class EmailValidator extends ValidatorsStrategy {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
