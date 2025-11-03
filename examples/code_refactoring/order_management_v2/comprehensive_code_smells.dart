// ignore_for_file: avoid_print, dangling_library_doc_comments

/// Comprehensive Code Smells Example for Refactoring Practice
///
/// This file contains ALL major code smells that can be found in real-world applications.
/// Each code smell is marked with comments and can be refactored using specific techniques.
///
/// CODE SMELLS INCLUDED:
/// 1. Long Method - Methods that are too long and do too much
/// 2. Large Class - Classes with too many responsibilities
/// 3. Long Parameter List - Methods with too many parameters
/// 4. Duplicate Code - Same code repeated in multiple places
/// 5. Data Clumps - Groups of data that always appear together
/// 6. Primitive Obsession - Using primitives instead of value objects
/// 7. Switch Statements - Should use polymorphism instead
/// 8. Feature Envy - Method uses another class's data more than its own
/// 9. Inappropriate Intimacy - Classes know too much about each other
/// 10. Message Chains - Long chains of method calls
/// 11. Middle Man - Class that delegates most of its work
/// 12. Lazy Class - Class that doesn't do enough to justify existence
/// 13. Speculative Generality - Unused generality/flexibility
/// 14. Temporary Field - Fields that are only used sometimes
/// 15. Refused Bequest - Subclass doesn't use inherited functionality
/// 16. Comments - Excessive or unnecessary comments
/// 17. Divergent Change - Class changes for multiple reasons
/// 18. Shotgun Surgery - Small change requires many class modifications
/// 19. Parallel Inheritance Hierarchies - Related hierarchies that must evolve together
/// 20. Dead Code - Code that is never executed
/// 21. Magic Numbers - Unexplained numeric literals
/// 22. Complex Conditionals - Hard to understand conditional logic

import 'dart:math';

// CODE SMELL: Large Class - Too many responsibilities
// REFACTORING TECHNIQUES: Extract Class, Extract Subclass, Extract Interface
class ComprehensiveBusinessSystem {
  // CODE SMELL: Primitive Obsession - Using primitives instead of value objects
  // REFACTORING: Replace Data Value with Object, Replace Type Code with Class
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> invoices = [];
  List<Map<String, dynamic>> payments = [];

  // CODE SMELL: Temporary Field - Only used in some methods
  // REFACTORING: Extract Class, Replace Method with Method Object
  String? tempCalculationResult;
  double? tempDiscount;

  // CODE SMELL: Magic Numbers throughout
  // REFACTORING: Replace Magic Number with Named Constant
  static const double TAX_RATE = 0.08;
  static const double PREMIUM_DISCOUNT = 0.15;
  static const double REGULAR_DISCOUNT = 0.05;

  // CODE SMELL: Long Method - Does too many things
  // CODE SMELL: Long Parameter List - Too many parameters
  // CODE SMELL: Complex Conditionals - Nested if statements
  // REFACTORING: Extract Method, Introduce Parameter Object, Decompose Conditional
  String processComprehensiveBusinessTransaction(
    String customerFirstName,
    String customerLastName,
    String customerEmail,
    String customerPhone,
    String customerAddress,
    String customerCity,
    String customerState,
    String customerZip,
    String customerCountry,
    List<String> productIds,
    List<int> quantities,
    List<double> prices,
    String paymentMethod,
    String shippingMethod,
    bool isExpress,
    bool isPriority,
    String couponCode,
    bool isFirstTimeCustomer,
    String employeeId,
    String departmentCode,
  ) {
    // CODE SMELL: Duplicate Code - This validation appears multiple times
    // REFACTORING: Extract Method
    if (customerFirstName.isEmpty ||
        customerLastName.isEmpty ||
        customerEmail.isEmpty ||
        !customerEmail.contains('@')) {
      return 'Invalid customer data';
    }

    // CODE SMELL: Data Clumps - Customer data always used together
    // REFACTORING: Extract Class (Customer)
    Map<String, dynamic> customer = {
      'firstName': customerFirstName,
      'lastName': customerLastName,
      'email': customerEmail,
      'phone': customerPhone,
      'address': customerAddress,
      'city': customerCity,
      'state': customerState,
      'zip': customerZip,
      'country': customerCountry,
    };

    double totalAmount = 0;
    List<Map<String, dynamic>> orderItems = [];

    // CODE SMELL: Long Loop with multiple responsibilities
    // REFACTORING: Extract Method
    for (int i = 0; i < productIds.length; i++) {
      String productId = productIds[i];
      int quantity = quantities[i];
      double price = prices[i];

      // CODE SMELL: Feature Envy - Uses product data more than own data
      // REFACTORING: Move Method to Product class
      Map<String, dynamic>? product = findProductById(productId);
      if (product != null) {
        // CODE SMELL: Complex Conditional Logic
        // REFACTORING: Replace Conditional with Polymorphism
        if (product['category'] == 'electronics' && quantity > 5) {
          price = price * 0.95; // 5% bulk discount
        } else if (product['category'] == 'clothing' && quantity > 10) {
          price = price * 0.90; // 10% bulk discount
        } else if (product['category'] == 'books' && quantity > 20) {
          price = price * 0.85; // 15% bulk discount
        }

        double itemTotal = quantity * price;
        totalAmount += itemTotal;

        orderItems.add({
          'productId': productId,
          'productName': product['name'],
          'quantity': quantity,
          'unitPrice': price,
          'total': itemTotal,
        });
      }
    }

    // CODE SMELL: Switch Statement - Should use polymorphism
    // REFACTORING: Replace Conditional with Polymorphism
    double shippingCost = 0;
    switch (shippingMethod) {
      case 'standard':
        shippingCost = 5.99;
        if (isExpress) shippingCost *= 2;
        if (isPriority) shippingCost *= 1.5;
        break;
      case 'expedited':
        shippingCost = 12.99;
        if (isExpress) shippingCost *= 2;
        if (isPriority) shippingCost *= 1.5;
        break;
      case 'overnight':
        shippingCost = 25.99;
        if (isExpress) shippingCost *= 2;
        if (isPriority) shippingCost *= 1.5;
        break;
      case 'international':
        shippingCost = 45.99;
        if (isExpress) shippingCost *= 2;
        if (isPriority) shippingCost *= 1.5;
        break;
      default:
        shippingCost = 5.99;
    }

    // CODE SMELL: Duplicate Code - Discount calculation repeated
    // REFACTORING: Extract Method
    double discount = 0;
    if (isFirstTimeCustomer) {
      discount = totalAmount * 0.10; // 10% first time discount
    } else if (totalAmount > 500) {
      discount = totalAmount * 0.15; // 15% large order discount
    } else if (totalAmount > 200) {
      discount = totalAmount * 0.10; // 10% medium order discount
    } else if (totalAmount > 100) {
      discount = totalAmount * 0.05; // 5% small order discount
    }

    // CODE SMELL: Magic Numbers and complex calculation
    // REFACTORING: Extract Method, Replace Magic Number with Named Constant
    if (couponCode == 'SAVE20') {
      discount += totalAmount * 0.20;
    } else if (couponCode == 'SAVE10') {
      discount += totalAmount * 0.10;
    } else if (couponCode == 'FIRSTTIME') {
      discount += 25.0; // Fixed $25 discount
    }

    double subtotal = totalAmount - discount + shippingCost;
    double tax = subtotal * TAX_RATE;
    double finalTotal = subtotal + tax;

    // CODE SMELL: Long Method continues - Order creation
    // REFACTORING: Extract Method
    Map<String, dynamic> order = {
      'orderId': generateOrderId(),
      'customer': customer,
      'items': orderItems,
      'subtotal': totalAmount,
      'discount': discount,
      'shippingCost': shippingCost,
      'tax': tax,
      'total': finalTotal,
      'paymentMethod': paymentMethod,
      'shippingMethod': shippingMethod,
      'isExpress': isExpress,
      'isPriority': isPriority,
      'employeeId': employeeId,
      'departmentCode': departmentCode,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    };

    orders.add(order);

    // CODE SMELL: Switch Statement for payment processing
    // REFACTORING: Replace Conditional with Polymorphism (Strategy Pattern)
    String paymentResult = '';
    switch (paymentMethod) {
      case 'credit_card':
        paymentResult = processCreditCardPayment(finalTotal, customer);
        break;
      case 'debit_card':
        paymentResult = processDebitCardPayment(finalTotal, customer);
        break;
      case 'paypal':
        paymentResult = processPayPalPayment(finalTotal, customer);
        break;
      case 'bank_transfer':
        paymentResult = processBankTransferPayment(finalTotal, customer);
        break;
      case 'cryptocurrency':
        paymentResult = processCryptocurrencyPayment(finalTotal, customer);
        break;
      default:
        paymentResult = 'Invalid payment method';
    }

    // CODE SMELL: Feature Envy - Uses employee data extensively
    // REFACTORING: Move Method to Employee class
    Map<String, dynamic>? employee = findEmployeeById(employeeId);
    if (employee != null) {
      updateEmployeeSalesStats(employee, finalTotal);
      updateDepartmentStats(departmentCode, finalTotal);
    }

    // CODE SMELL: Long Method continues - Notification and logging
    // REFACTORING: Extract Method
    sendOrderConfirmationEmail(customer['email'], order);
    logOrderTransaction(order);
    updateInventoryLevels(orderItems);

    return 'Order processed successfully: ${order['orderId']}';
  }

  // CODE SMELL: Duplicate Code - Same validation as above
  // REFACTORING: Extract Method
  bool validateCustomerData(Map<String, dynamic> customer) {
    final firstName = customer['firstName'] as String?;
    final lastName = customer['lastName'] as String?;
    final email = customer['email'] as String?;

    if (firstName == null ||
        firstName.isEmpty ||
        lastName == null ||
        lastName.isEmpty ||
        email == null ||
        email.isEmpty ||
        !email.contains('@')) {
      return false;
    }
    return true;
  }

  // CODE SMELL: Feature Envy - Manipulates product data more than own data
  // REFACTORING: Move Method to Product class
  Map<String, dynamic>? findProductById(String productId) {
    for (var product in products) {
      if (product['id'] == productId) {
        return product;
      }
    }
    return null;
  }

  // CODE SMELL: Feature Envy - Manipulates employee data
  // REFACTORING: Move Method to Employee class
  Map<String, dynamic>? findEmployeeById(String employeeId) {
    for (var employee in employees) {
      if (employee['id'] == employeeId) {
        return employee;
      }
    }
    return null;
  }

  // CODE SMELL: Switch Statement repeated pattern
  // REFACTORING: Replace Conditional with Polymorphism
  String processCreditCardPayment(
    double amount,
    Map<String, dynamic> customer,
  ) {
    // Simulate credit card processing
    if (amount > 10000) {
      return 'Credit card payment declined - amount too high';
    }
    return 'Credit card payment processed: \$${amount.toStringAsFixed(2)}';
  }

  String processDebitCardPayment(double amount, Map<String, dynamic> customer) {
    // Simulate debit card processing
    if (amount > 5000) {
      return 'Debit card payment declined - amount too high';
    }
    return 'Debit card payment processed: \$${amount.toStringAsFixed(2)}';
  }

  String processPayPalPayment(double amount, Map<String, dynamic> customer) {
    // Simulate PayPal processing
    return 'PayPal payment processed: \$${amount.toStringAsFixed(2)}';
  }

  String processBankTransferPayment(
    double amount,
    Map<String, dynamic> customer,
  ) {
    // Simulate bank transfer processing
    return 'Bank transfer initiated: \$${amount.toStringAsFixed(2)}';
  }

  String processCryptocurrencyPayment(
    double amount,
    Map<String, dynamic> customer,
  ) {
    // Simulate cryptocurrency processing
    return 'Cryptocurrency payment processed: \$${amount.toStringAsFixed(2)}';
  }

  // CODE SMELL: Long Method with multiple responsibilities
  // REFACTORING: Extract Method, Extract Class
  void updateEmployeeSalesStats(Map<String, dynamic> employee, double amount) {
    if (employee['salesStats'] == null) {
      employee['salesStats'] = <String, dynamic>{
        'totalSales': 0.0,
        'orderCount': 0,
        'averageOrderValue': 0.0,
        'bestMonth': '',
        'worstMonth': '',
      };
    }

    final stats = employee['salesStats'] as Map<String, dynamic>;
    stats['totalSales'] = (stats['totalSales'] as double) + amount;
    stats['orderCount'] = (stats['orderCount'] as int) + 1;
    stats['averageOrderValue'] =
        (stats['totalSales'] as double) / (stats['orderCount'] as int);

    // CODE SMELL: Magic Numbers and complex date logic
    // REFACTORING: Extract Method, Replace Magic Number with Named Constant
    String currentMonth = DateTime.now().month.toString();
    if ((stats['bestMonth'] as String).isEmpty) {
      stats['bestMonth'] = currentMonth;
    }
  }

  void updateDepartmentStats(String departmentCode, double amount) {
    // CODE SMELL: Duplicate Code - Similar pattern to employee stats
    // REFACTORING: Extract Method or Extract Class
    print('Updating department $departmentCode with amount: $amount');
  }

  // CODE SMELL: Long Method - Email generation with lots of string concatenation
  // REFACTORING: Extract Method, Replace Method with Method Object
  void sendOrderConfirmationEmail(String email, Map<String, dynamic> order) {
    String subject = 'Order Confirmation - ${order['orderId']}';
    String body =
        'Dear ${order['customer']['firstName']} ${order['customer']['lastName']},\n\n';
    body += 'Thank you for your order! Here are the details:\n\n';
    body += 'Order ID: ${order['orderId']}\n';
    body += 'Order Date: ${order['createdAt']}\n';
    body += 'Total Amount: \$${order['total'].toStringAsFixed(2)}\n\n';
    body += 'Items:\n';

    for (var item in order['items']) {
      body +=
          '- ${item['productName']} x ${item['quantity']} = \$${item['total'].toStringAsFixed(2)}\n';
    }

    body += '\nSubtotal: \$${order['subtotal'].toStringAsFixed(2)}\n';
    body += 'Discount: -\$${order['discount'].toStringAsFixed(2)}\n';
    body += 'Shipping: \$${order['shippingCost'].toStringAsFixed(2)}\n';
    body += 'Tax: \$${order['tax'].toStringAsFixed(2)}\n';
    body += 'Total: \$${order['total'].toStringAsFixed(2)}\n\n';
    body += 'Thank you for your business!\n';

    print('Sending email to $email');
    print('Subject: $subject');
    print('Body: $body');
  }

  void logOrderTransaction(Map<String, dynamic> order) {
    // CODE SMELL: Primitive Obsession - Should use proper logging object
    // REFACTORING: Replace Data Value with Object
    print('LOG: Order ${order['orderId']} processed for ${order['total']}');
  }

  void updateInventoryLevels(List<Map<String, dynamic>> items) {
    // CODE SMELL: Feature Envy - Manipulates product inventory
    // REFACTORING: Move Method to Inventory class
    for (var item in items) {
      print(
        'Updating inventory for ${item['productId']} - ${item['quantity']}',
      );
    }
  }

  // CODE SMELL: Magic Numbers in ID generation
  // REFACTORING: Extract Method, Replace Magic Number with Named Constant
  String generateOrderId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random = Random().nextInt(9999);
    return 'ORD-$timestamp-$random';
  }

  // CODE SMELL: Long Method with complex reporting logic
  // REFACTORING: Extract Method, Extract Class (ReportGenerator)
  String generateComprehensiveBusinessReport() {
    String report = '';
    report += '=== COMPREHENSIVE BUSINESS REPORT ===\n\n';

    // CODE SMELL: Duplicate Code - Similar loops for different entities
    // REFACTORING: Extract Method
    report += 'CUSTOMER SUMMARY:\n';
    report += 'Total Customers: ${customers.length}\n';
    int activeCustomers = 0;
    double totalCustomerValue = 0;

    for (var customer in customers) {
      bool hasOrders = false;
      double customerTotal = 0;

      for (var order in orders) {
        if (order['customer']['email'] == customer['email']) {
          hasOrders = true;
          customerTotal += order['total'];
        }
      }

      if (hasOrders) {
        activeCustomers++;
        totalCustomerValue += customerTotal;
      }
    }

    report += 'Active Customers: $activeCustomers\n';
    report +=
        'Total Customer Value: \$${totalCustomerValue.toStringAsFixed(2)}\n\n';

    // CODE SMELL: Duplicate Code - Similar pattern as customer loop
    // REFACTORING: Extract Method
    report += 'ORDER SUMMARY:\n';
    report += 'Total Orders: ${orders.length}\n';
    double totalRevenue = 0;
    int pendingOrders = 0;
    int completedOrders = 0;

    for (var order in orders) {
      totalRevenue += order['total'];
      if (order['status'] == 'pending') {
        pendingOrders++;
      } else if (order['status'] == 'completed') {
        completedOrders++;
      }
    }

    report += 'Total Revenue: \$${totalRevenue.toStringAsFixed(2)}\n';
    report += 'Pending Orders: $pendingOrders\n';
    report += 'Completed Orders: $completedOrders\n\n';

    // CODE SMELL: Complex Conditional Logic for product categories
    // REFACTORING: Replace Conditional with Polymorphism
    report += 'PRODUCT CATEGORY ANALYSIS:\n';
    Map<String, int> categoryCount = {};
    Map<String, double> categoryRevenue = {};

    for (var order in orders) {
      for (var item in order['items']) {
        String productId = item['productId'];
        Map<String, dynamic>? product = findProductById(productId);

        if (product != null) {
          String category = product['category'] ?? 'unknown';
          categoryCount[category] =
              (categoryCount[category] ?? 0) + (item['quantity'] as int);
          categoryRevenue[category] =
              (categoryRevenue[category] ?? 0) + item['total'];
        }
      }
    }

    categoryCount.forEach((category, count) {
      double revenue = categoryRevenue[category] ?? 0;
      report +=
          '$category: $count units, \$${revenue.toStringAsFixed(2)} revenue\n';
    });

    return report;
  }

  // CODE SMELL: Dead Code - This method is never called
  // REFACTORING: Remove Dead Code
  void oldReportingMethod() {
    print('This method is obsolete and never used');
  }

  // CODE SMELL: Speculative Generality - Overly generic method not used
  // REFACTORING: Remove Speculative Generality
  T processGenericBusinessEntity<T>(T entity, Function processor) {
    return processor(entity);
  }
}

// CODE SMELL: Lazy Class - Doesn't do enough to justify existence
// REFACTORING: Collapse Hierarchy or Inline Class
class SimpleValidator {
  bool isValid(String? value) {
    return value != null && value.isNotEmpty;
  }
}

// CODE SMELL: Middle Man - Just delegates to other classes
// REFACTORING: Remove Middle Man
class BusinessFacade {
  ComprehensiveBusinessSystem _system = ComprehensiveBusinessSystem();

  String processOrder(Map<String, dynamic> orderData) {
    return _system.processComprehensiveBusinessTransaction(
      orderData['customerFirstName'],
      orderData['customerLastName'],
      orderData['customerEmail'],
      orderData['customerPhone'],
      orderData['customerAddress'],
      orderData['customerCity'],
      orderData['customerState'],
      orderData['customerZip'],
      orderData['customerCountry'],
      orderData['productIds'],
      orderData['quantities'],
      orderData['prices'],
      orderData['paymentMethod'],
      orderData['shippingMethod'],
      orderData['isExpress'],
      orderData['isPriority'],
      orderData['couponCode'],
      orderData['isFirstTimeCustomer'],
      orderData['employeeId'],
      orderData['departmentCode'],
    );
  }
}

// CODE SMELL: Parallel Inheritance Hierarchies
// REFACTORING: Move Method, Move Field to eliminate parallel hierarchies
abstract class PaymentProcessor {
  void process(double amount);
}

class CreditCardProcessor extends PaymentProcessor {
  @override
  void process(double amount) {
    print('Processing credit card: $amount');
  }
}

class PayPalProcessor extends PaymentProcessor {
  @override
  void process(double amount) {
    print('Processing PayPal: $amount');
  }
}

// Parallel hierarchy that mirrors payment processors
abstract class PaymentValidator {
  bool validate(Map<String, dynamic> data);
}

class CreditCardValidator extends PaymentValidator {
  @override
  bool validate(Map<String, dynamic> data) {
    return data['cardNumber'] != null;
  }
}

class PayPalValidator extends PaymentValidator {
  @override
  bool validate(Map<String, dynamic> data) {
    return data['email'] != null;
  }
}

// CODE SMELL: Refused Bequest - Subclass doesn't use parent functionality
// REFACTORING: Replace Inheritance with Delegation
class Animal {
  void walk() => print('Walking');
  void eat() => print('Eating');
  void sleep() => print('Sleeping');
}

class Fish extends Animal {
  void swim() => print('Swimming');

  // Fish refuses the walk behavior from Animal
  @override
  void walk() {
    throw UnsupportedError('Fish cannot walk');
  }
}

// CODE SMELL: Message Chains - Long chains of method calls
// REFACTORING: Hide Delegate
class OrderService {
  ComprehensiveBusinessSystem system = ComprehensiveBusinessSystem();

  String getFirstOrderCustomerEmail() {
    // CODE SMELL: Message Chain
    return system.orders.first['customer']['email'];
  }

  double getFirstOrderFirstItemPrice() {
    // CODE SMELL: Message Chain
    return system.orders.first['items'].first['unitPrice'];
  }
}

// CODE SMELL: Inappropriate Intimacy - Classes know too much about each other
// REFACTORING: Move Method, Move Field, Change Bidirectional Association to Unidirectional
class CustomerManager {
  List<Map<String, dynamic>> customers = [];
  OrderManager orderManager = OrderManager(); // Tight coupling

  void addCustomer(Map<String, dynamic> customer) {
    customers.add(customer);
    // Directly accessing internal structure of OrderManager
    orderManager.notifyNewCustomer(customer['email']);
  }
}

class OrderManager {
  List<Map<String, dynamic>> orders = [];
  CustomerManager? customerManager; // Bidirectional dependency

  void notifyNewCustomer(String email) {
    print('New customer notification: $email');
    // Accessing customer manager's internal data
    if (customerManager != null) {
      print('Total customers: ${customerManager!.customers.length}');
    }
  }
}

// Main function demonstrating usage with all code smells
void main() {
  print('========================================');
  print('| COMPREHENSIVE CODE SMELLS EXAMPLE   |');
  print('| All Major Smells for Refactoring    |');
  print('========================================\n');

  var system = ComprehensiveBusinessSystem();

  // CODE SMELL: Long Parameter List in action
  String result = system.processComprehensiveBusinessTransaction(
    'John',
    'Doe',
    'john.doe@example.com',
    '555-1234',
    '123 Main St',
    'Anytown',
    'CA',
    '12345',
    'USA',
    ['PROD-001', 'PROD-002'],
    [2, 1],
    [99.99, 149.99],
    'credit_card',
    'expedited',
    true,
    false,
    'SAVE10',
    true,
    'EMP-001',
    'SALES',
  );

  print('Transaction Result: $result\n');

  // Generate comprehensive report
  print(system.generateComprehensiveBusinessReport());

  // Demonstrate other code smells
  var facade = BusinessFacade();
  var validator = SimpleValidator();
  var orderService = OrderService();

  print('Validator result: ${validator.isValid('test')}');

  // Demonstrate inappropriate intimacy
  var customerManager = CustomerManager();
  var orderManager = OrderManager();
  customerManager.orderManager = orderManager;
  orderManager.customerManager = customerManager;

  customerManager.addCustomer({
    'firstName': 'Jane',
    'lastName': 'Smith',
    'email': 'jane@example.com',
  });
}
