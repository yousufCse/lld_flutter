// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';

import '../user_processor.dart';

void main() {
  var userData = {
    "name": "John Smith",
    "products": [
      {"name": "Laptop", "price": 1200, "quantity": 1},
      {"name": "Mouse", "price": 25, "quantity": 2},
      {"name": "Keyboard", "price": 50, "quantity": 1},
    ],
  };

  var options = {"specialDiscount": true};

  var processor = UserProcessor();
  var result = processor.processUserData(userData, options, true);
  print(result["report"]);
  final report = result["report"];

  test('Function statement generates correct output for given info', () {
    expect(report, contains('User: John Smith'));
    expect(report, contains('Products: Laptop, Mouse, Keyboard'));
    expect(report, contains('Subtotal: 1300.00'));
    expect(report, contains('Discount: 245.00'));
    expect(report, contains('Total: 1055.00'));
    expect(result["orderId"], isNotNull);
    expect(result["total"], 1300.00);
    expect(result["discount"], 245.00);
    expect(result["finalAmount"], 1055.00);
    expect(result["processedOn"], isNotNull);
  });
}
