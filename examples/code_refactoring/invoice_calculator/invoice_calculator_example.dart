// BAD CODE EXAMPLE: Composing Methods Code Smells
// This file intentionally contains code that should be refactored using:
// - Extract Method
// - Inline Method
// - Replace Temp with Query
// - Replace Method with Method Object

// ignore_for_file: avoid_print

class InvoiceCalculator {
  // Long method, duplicated code, temporary variables
  double calculateInvoiceTotal(
    List<double> itemPrices,
    double taxRate,
    double discountRate,
  ) {
    double subtotal = 0;
    for (var price in itemPrices) {
      subtotal += price;
    }
    // Duplicated code: subtotal calculation
    double subtotalAgain = 0;
    for (var price in itemPrices) {
      subtotalAgain += price;
    }
    // Temporary variable for discount
    double discount = subtotal * discountRate;
    // Temporary variable for tax
    double tax = (subtotal - discount) * taxRate;
    // More duplicated code: tax calculation
    // ignore: unused_local_variable
    double taxAgain = (subtotalAgain - discount) * taxRate;
    // Unnecessary inline method
    double getFinalTotal() {
      return subtotal - discount + tax;
    }

    return getFinalTotal();
  }

  // Poorly composed method: does too much
  String generateInvoiceReport(
    List<double> itemPrices,
    double taxRate,
    double discountRate,
  ) {
    double subtotal = 0;
    for (var price in itemPrices) {
      subtotal += price;
    }
    double discount = subtotal * discountRate;
    double tax = (subtotal - discount) * taxRate;
    double total = subtotal - discount + tax;
    String report = 'Invoice Report\n';
    report += 'Subtotal: \$${subtotal.toStringAsFixed(2)}\n';
    report += 'Discount: \$${discount.toStringAsFixed(2)}\n';
    report += 'Tax: \$${tax.toStringAsFixed(2)}\n';
    report += 'Total: \$${total.toStringAsFixed(2)}\n';
    return report;
  }
}

void main() {
  var calc = InvoiceCalculator();
  var prices = [100.0, 50.0, 25.0];
  print(calc.calculateInvoiceTotal(prices, 0.08, 0.1));
  print(calc.generateInvoiceReport(prices, 0.08, 0.1));
}
