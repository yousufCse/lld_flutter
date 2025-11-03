import 'package:flutter_test/flutter_test.dart';

import '../invoice_calculator_example.dart';

void main() {
  late InvoiceCalculator calculator;

  setUp(() {
    calculator = InvoiceCalculator();
  });

  test('calculateInvoiceTotal returns correct total with tax and discount', () {
    var itemPrices = [100.0, 50.0, 25.0];
    var taxRate = 0.08; // 8%
    var discountRate = 0.1; // 10%

    var total = calculator.calculateInvoiceTotal(
      itemPrices,
      taxRate,
      discountRate,
    );

    // Subtotal = 175.0
    // Discount = 17.5
    // Taxable amount = 157.5
    // Tax = 12.6
    // Total = 175.0 - 17.5 + 12.6 = 170.1
    expect(total, closeTo(170.1, 0.01));
  });
}
