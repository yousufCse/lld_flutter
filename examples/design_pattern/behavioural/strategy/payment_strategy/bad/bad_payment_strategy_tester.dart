// ignore_for_file: avoid_print

import 'bad_payment_processor.dart';

void main(List<String> args) {
  print("🚀 Starting Bad Payment Strategy Example");

  final processor = BadPaymentProcessor();
  processor.pay('y.com', 'credit_card', 100.0);
  processor.pay('y.com', 'paypal', 75.0);
  processor.pay('y.com', 'bank_transfer', 200.0);
  processor.pay('y.com', 'unsupported_method', 50.0);

  print("🚀 Bad Payment Strategy Example completed");
}
