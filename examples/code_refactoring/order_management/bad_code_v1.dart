// ignore_for_file: avoid_print, dangling_library_doc_comments

/// This file contains intentional code smells for refactoring practice
/// Code Smells Present:
/// 1. Long Method
/// 2. Long Parameter List
/// 3. Duplicated Code
/// 4. Large Class
/// 5. Data Clumps
/// 6. Primitive Obsession
/// 7. Switch Statements
/// 8. Feature Envy
/// 9. Magic Numbers
/// 10. Dead Code
/// 11. Comments (excessive)
/// 12. Complex Conditional

// CODE SMELL: Large Class with too many responsibilities
class OrderManager {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> customers = [];

  // CODE SMELL: Long Method with multiple responsibilities
  // CODE SMELL: Long Parameter List
  // CODE SMELL: Magic Numbers
  // CODE SMELL: Primitive Obsession (using primitives instead of objects)
  void processOrder(
    String customerName,
    String customerEmail,
    String customerPhone,
    String customerAddress,
    String productName,
    int quantity,
    double price,
    String shippingMethod,
    bool isExpress,
    String paymentMethod,
  ) {
    // CODE SMELL: Complex Conditional
    if (customerName.isNotEmpty &&
        customerEmail.isNotEmpty &&
        customerPhone.length == 10) {
      // CODE SMELL: Duplicated Code (this validation appears multiple times)
      if (quantity > 0 && quantity < 1000) {
        double total = quantity * price;

        // CODE SMELL: Magic Numbers
        if (total > 100) {
          total = total * 0.9; // 10% discount
        }

        // CODE SMELL: Switch Statement (should use polymorphism)
        double shippingCost = 0;
        switch (shippingMethod) {
          case 'standard':
            shippingCost = 5.0;
            break;
          case 'express':
            shippingCost = 15.0;
            break;
          case 'overnight':
            shippingCost = 25.0;
            break;
          default:
            shippingCost = 5.0;
        }

        if (isExpress) {
          shippingCost = shippingCost * 2;
        }

        total = total + shippingCost;

        // CODE SMELL: Data Clumps (customer data always used together)
        Map<String, dynamic> customer = {
          'name': customerName,
          'email': customerEmail,
          'phone': customerPhone,
          'address': customerAddress,
        };

        Map<String, dynamic> order = {
          'customer': customer,
          'product': productName,
          'quantity': quantity,
          'price': price,
          'total': total,
          'shipping': shippingMethod,
          'payment': paymentMethod,
          'status': 'pending',
        };

        orders.add(order);

        // CODE SMELL: Feature Envy (using customer data from map)
        print('Order created for ${customer['name']}');
        print('Email: ${customer['email']}');
        print('Total: \$${total.toStringAsFixed(2)}');
      }
    }
  }

  // CODE SMELL: Duplicated Code (similar to processOrder validation)
  void updateOrder(
    String orderId,
    String customerName,
    String customerEmail,
    String productName,
    int quantity,
    double price,
  ) {
    // Same validation as above - DUPLICATED
    if (customerName.isNotEmpty && customerEmail.isNotEmpty) {
      if (quantity > 0 && quantity < 1000) {
        double total = quantity * price;

        // CODE SMELL: Magic Numbers (repeated)
        if (total > 100) {
          total = total * 0.9;
        }

        print('Order updated for $customerName');
        print('New total: \$${total.toStringAsFixed(2)}');
      }
    }
  }

  // CODE SMELL: Long Method
  // CODE SMELL: Complex Conditional
  String generateOrderReport() {
    String report = '';

    // CODE SMELL: Long Loop with multiple responsibilities
    for (var order in orders) {
      // CODE SMELL: Temporary Field
      String customerInfo = '';

      // CODE SMELL: Nested Conditionals
      if (order['customer'] != null) {
        if (order['customer']['name'] != null) {
          customerInfo += 'Customer: ${order['customer']['name']}\n';

          if (order['customer']['email'] != null) {
            customerInfo += 'Email: ${order['customer']['email']}\n';

            if (order['customer']['phone'] != null) {
              customerInfo += 'Phone: ${order['customer']['phone']}\n';
            }
          }
        }
      }

      report += customerInfo;
      report += 'Product: ${order['product']}\n';
      report += 'Quantity: ${order['quantity']}\n';
      report += 'Total: \$${order['total']}\n';
      report += '---\n';
    }

    return report;
  }

  // CODE SMELL: Dead Code (never called)
  void oldProcessingMethod() {
    print('This method is no longer used');
  }

  // CODE SMELL: Magic Numbers everywhere
  double calculateDiscount(double amount, String customerType) {
    // CODE SMELL: Switch Statement
    switch (customerType) {
      case 'regular':
        if (amount > 100) return amount * 0.05;
        return 0;
      case 'premium':
        if (amount > 100) return amount * 0.10;
        if (amount > 50) return amount * 0.05;
        return 0;
      case 'vip':
        if (amount > 100) return amount * 0.20;
        if (amount > 50) return amount * 0.15;
        if (amount > 25) return amount * 0.10;
        return 0;
      default:
        return 0;
    }
  }

  // CODE SMELL: Feature Envy (manipulates order data more than own data)
  void printOrderDetails(Map<String, dynamic> order) {
    print('Customer: ${order['customer']['name']}');
    print('Email: ${order['customer']['email']}');
    print('Phone: ${order['customer']['phone']}');
    print('Product: ${order['product']}');
    print('Quantity: ${order['quantity']}');
    print('Price: \$${order['price']}');
    print('Total: \$${order['total']}');
    print('Shipping: ${order['shipping']}');
    print('Payment: ${order['payment']}');
    print('Status: ${order['status']}');
  }

  // CODE SMELL: Inappropriate Intimacy
  // Accessing internal structure of other objects too much
  double getTotalRevenue() {
    double total = 0;
    for (var order in orders) {
      if (order['status'] == 'completed') {
        total += order['total'];
      }
    }
    return total;
  }
}

// CODE SMELL: Speculative Generality (unused flexibility)
abstract class PaymentProcessor {
  void process();
}

class CreditCardProcessor extends PaymentProcessor {
  @override
  void process() {
    // Not implemented
  }
}

// CODE SMELL: Lazy Class (does almost nothing)
class OrderValidator {
  bool validate(Map<String, dynamic> order) {
    return order.isNotEmpty;
  }
}

void main() {
  print('-------------------------------');
  print('| Bad Code Example            |');
  print('| Practice Refactoring!       |');
  print('-------------------------------\n');

  var manager = OrderManager();

  // CODE SMELL: Long Parameter List in action
  manager.processOrder(
    'John Doe',
    'john@example.com',
    '1234567890',
    '123 Main St',
    'Laptop',
    2,
    999.99,
    'express',
    true,
    'credit_card',
  );

  print('\n${manager.generateOrderReport()}');

  // CODE SMELL: Magic Number usage
  print(
    'Discount for \$150: \$${manager.calculateDiscount(150, 'premium').toStringAsFixed(2)}',
  );
}
