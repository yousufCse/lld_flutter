import 'package:lld_flutter/core/utils/validators/validator_strategy.dart';

class ValidatorContext {
  ValidatorsStrategy _validatorStrategy;

  ValidatorContext(this._validatorStrategy);

  String? validate(String? value) {
    return _validatorStrategy.validate(value);
  }

  set validatorStrategy(ValidatorsStrategy strategy) {
    _validatorStrategy = strategy;
  }
}
