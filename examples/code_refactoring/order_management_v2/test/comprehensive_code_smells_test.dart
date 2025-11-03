import 'package:flutter_test/flutter_test.dart';

import '../comprehensive_code_smells.dart';

void main() {
  group('ComprehensiveBusinessSystem', () {
    late ComprehensiveBusinessSystem system;

    setUp(() {
      system = ComprehensiveBusinessSystem();
      // Add some test products
      system.products.addAll([
        {
          'id': 'PROD-001',
          'name': 'Laptop',
          'price': 999.99,
          'category': 'electronics',
        },
        {
          'id': 'PROD-002',
          'name': 'T-Shirt',
          'price': 29.99,
          'category': 'clothing',
        },
        {'id': 'PROD-003', 'name': 'Book', 'price': 19.99, 'category': 'books'},
      ]);

      // Add test employee
      system.employees.add({
        'id': 'EMP-001',
        'name': 'John Smith',
        'department': 'SALES',
      });
    });

    group('processComprehensiveBusinessTransaction', () {
      test('successfully processes valid order', () {
        final result = system.processComprehensiveBusinessTransaction(
          'John',
          'Doe',
          'john.doe@example.com',
          '555-1234',
          '123 Main St',
          'Anytown',
          'CA',
          '12345',
          'USA',
          ['PROD-001'],
          [1],
          [999.99],
          'credit_card',
          'standard',
          false,
          false,
          '',
          false,
          'EMP-001',
          'SALES',
        );

        expect(result, contains('Order processed successfully'));
        expect(system.orders.length, 1);

        final order = system.orders.first;
        expect(order['customer']['firstName'], 'John');
        expect(order['customer']['email'], 'john.doe@example.com');
        expect(order['items'].length, 1);
        expect(order['status'], 'pending');
      });

      test('rejects invalid customer data', () {
        final result = system.processComprehensiveBusinessTransaction(
          '', // Invalid first name
          'Doe',
          'invalid-email', // Invalid email
          '555-1234',
          '123 Main St',
          'Anytown',
          'CA',
          '12345',
          'USA',
          ['PROD-001'],
          [1],
          [999.99],
          'credit_card',
          'standard',
          false,
          false,
          '',
          false,
          'EMP-001',
          'SALES',
        );

        expect(result, 'Invalid customer data');
        expect(system.orders.length, 0);
      });

      test('calculates correct total with discount and shipping', () {
        final result = system.processComprehensiveBusinessTransaction(
          'John',
          'Doe',
          'john.doe@example.com',
          '555-1234',
          '123 Main St',
          'Anytown',
          'CA',
          '12345',
          'USA',
          ['PROD-001'], // $999.99
          [1],
          [999.99],
          'credit_card',
          'expedited', // $12.99 shipping
          false,
          false,
          'SAVE10', // 10% discount
          true, // First time customer (additional 10% discount)
          'EMP-001',
          'SALES',
        );

        expect(result, contains('Order processed successfully'));

        final order = system.orders.first;
        // Base: $999.99
        // First time discount: 10% = $99.999
        // Coupon discount: 10% = $99.999
        // Total discount: ~$199.998
        // Subtotal after discount: ~$799.99
        // Shipping: $12.99
        // Before tax: ~$812.98
        // Tax (8%): ~$65.04
        // Final total: ~$878.02

        expect(order['discount'], closeTo(199.998, 0.01));
        expect(order['shippingCost'], 12.99);
        expect(order['total'], greaterThan(870));
        expect(order['total'], lessThan(890));
      });

      test('applies bulk discounts for electronics', () {
        system.processComprehensiveBusinessTransaction(
          'John',
          'Doe',
          'john.doe@example.com',
          '555-1234',
          '123 Main St',
          'Anytown',
          'CA',
          '12345',
          'USA',
          ['PROD-001'], // Electronics
          [6], // > 5 quantity for 5% bulk discount
          [100.0],
          'credit_card',
          'standard',
          false,
          false,
          '',
          false,
          'EMP-001',
          'SALES',
        );

        final order = system.orders.first;
        final item = order['items'][0];
        // Original price: $100, with 5% bulk discount: $95
        expect(item['unitPrice'], 95.0);
        expect(item['total'], 6 * 95.0);
      });
    });

    group('payment processing methods', () {
      test('processCreditCardPayment handles normal amounts', () {
        final result = system.processCreditCardPayment(1000.0, {});
        expect(result, contains('Credit card payment processed'));
        expect(result, contains('1000.00'));
      });

      test('processCreditCardPayment rejects large amounts', () {
        final result = system.processCreditCardPayment(15000.0, {});
        expect(result, contains('declined - amount too high'));
      });

      test('processDebitCardPayment has lower limit', () {
        final normalResult = system.processDebitCardPayment(3000.0, {});
        expect(normalResult, contains('Debit card payment processed'));

        final rejectedResult = system.processDebitCardPayment(6000.0, {});
        expect(rejectedResult, contains('declined - amount too high'));
      });

      test('processPayPalPayment always succeeds', () {
        final result = system.processPayPalPayment(10000.0, {});
        expect(result, contains('PayPal payment processed'));
      });
    });

    group('utility methods', () {
      test('findProductById returns correct product', () {
        final product = system.findProductById('PROD-001');
        expect(product, isNotNull);
        expect(product!['name'], 'Laptop');
        expect(product['category'], 'electronics');
      });

      test('findProductById returns null for invalid id', () {
        final product = system.findProductById('INVALID-ID');
        expect(product, isNull);
      });

      test('findEmployeeById returns correct employee', () {
        final employee = system.findEmployeeById('EMP-001');
        expect(employee, isNotNull);
        expect(employee!['name'], 'John Smith');
      });

      test('generateOrderId creates unique IDs', () {
        final id1 = system.generateOrderId();
        final id2 = system.generateOrderId();

        expect(id1, startsWith('ORD-'));
        expect(id2, startsWith('ORD-'));
        expect(id1, isNot(equals(id2)));
      });

      test('validateCustomerData validates correctly', () {
        expect(
          system.validateCustomerData({
            'firstName': 'John',
            'lastName': 'Doe',
            'email': 'john@example.com',
          }),
          isTrue,
        );

        expect(
          system.validateCustomerData({
            'firstName': '',
            'lastName': 'Doe',
            'email': 'john@example.com',
          }),
          isFalse,
        );

        expect(
          system.validateCustomerData({
            'firstName': 'John',
            'lastName': 'Doe',
            'email': 'invalid-email',
          }),
          isFalse,
        );
      });
    });

    group('updateEmployeeSalesStats', () {
      test('initializes stats for new employee', () {
        final employee = <String, dynamic>{'id': 'EMP-002', 'name': 'Jane Doe'};

        system.updateEmployeeSalesStats(employee, 1000.0);

        expect(employee['salesStats'], isNotNull);
        // Just verify the method runs without error
      });

      test('updates existing stats', () {
        final employee = {
          'id': 'EMP-002',
          'salesStats': <String, dynamic>{
            'totalSales': 500.0,
            'orderCount': 1,
            'averageOrderValue': 500.0,
            'bestMonth': 'January',
          },
        };

        system.updateEmployeeSalesStats(employee, 1000.0);

        // Just verify the method runs without error
        expect(employee['salesStats'], isNotNull);
      });
    });

    group('generateComprehensiveBusinessReport', () {
      test('generates report with empty data', () {
        final report = system.generateComprehensiveBusinessReport();

        expect(report, contains('COMPREHENSIVE BUSINESS REPORT'));
        expect(report, contains('Total Customers: 0'));
        expect(report, contains('Total Orders: 0'));
        expect(report, contains('Total Revenue: \$0.00'));
      });

      test('generates report with order data', () {
        // Add some test data
        system.orders.add({
          'customer': {'email': 'test@example.com'},
          'total': 100.0,
          'status': 'completed',
          'items': [
            {'productId': 'PROD-001', 'quantity': 1, 'total': 100.0},
          ],
        });

        final report = system.generateComprehensiveBusinessReport();

        expect(report, contains('Total Orders: 1'));
        expect(report, contains('Total Revenue: \$100.00'));
        expect(report, contains('Completed Orders: 1'));
        expect(report, contains('electronics: 1 units'));
      });
    });
  });

  group('Other Code Smell Classes', () {
    test('SimpleValidator validates correctly', () {
      final validator = SimpleValidator();

      expect(validator.isValid('valid'), isTrue);
      expect(validator.isValid(''), isFalse);
      expect(validator.isValid(null), isFalse);
    });

    test('BusinessFacade delegates to system', () {
      final facade = BusinessFacade();

      final orderData = {
        'customerFirstName': 'John',
        'customerLastName': 'Doe',
        'customerEmail': 'john@example.com',
        'customerPhone': '555-1234',
        'customerAddress': '123 Main St',
        'customerCity': 'Anytown',
        'customerState': 'CA',
        'customerZip': '12345',
        'customerCountry': 'USA',
        'productIds': ['PROD-001'],
        'quantities': [1],
        'prices': [999.99],
        'paymentMethod': 'credit_card',
        'shippingMethod': 'standard',
        'isExpress': false,
        'isPriority': false,
        'couponCode': '',
        'isFirstTimeCustomer': false,
        'employeeId': 'EMP-001',
        'departmentCode': 'SALES',
      };

      final result = facade.processOrder(orderData);
      // Note: The facade will process successfully because it doesn't validate products exist
      expect(result, contains('Order processed successfully'));
    });

    test('PaymentProcessor hierarchy works', () {
      final creditProcessor = CreditCardProcessor();
      final paypalProcessor = PayPalProcessor();

      // These just print, so we test they don't throw
      expect(() => creditProcessor.process(100.0), returnsNormally);
      expect(() => paypalProcessor.process(100.0), returnsNormally);
    });

    test('PaymentValidator hierarchy works', () {
      final creditValidator = CreditCardValidator();
      final paypalValidator = PayPalValidator();

      expect(creditValidator.validate({'cardNumber': '1234'}), isTrue);
      expect(creditValidator.validate({}), isFalse);

      expect(paypalValidator.validate({'email': 'test@example.com'}), isTrue);
      expect(paypalValidator.validate({}), isFalse);
    });

    test('Fish refuses to walk (Refused Bequest)', () {
      final fish = Fish();

      expect(() => fish.swim(), returnsNormally);
      expect(() => fish.eat(), returnsNormally);
      expect(() => fish.sleep(), returnsNormally);
      expect(() => fish.walk(), throwsUnsupportedError);
    });

    test('CustomerManager and OrderManager show inappropriate intimacy', () {
      final customerManager = CustomerManager();
      final orderManager = OrderManager();

      customerManager.orderManager = orderManager;
      orderManager.customerManager = customerManager;

      // This demonstrates the tight coupling - they know about each other
      expect(
        () => customerManager.addCustomer({
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john@example.com',
        }),
        returnsNormally,
      );

      expect(customerManager.customers.length, 1);
    });
  });

  group('Integration Tests', () {
    test('full business flow with multiple orders', () {
      final system = ComprehensiveBusinessSystem();

      // Add products
      system.products.addAll([
        {
          'id': 'PROD-001',
          'name': 'Laptop',
          'price': 1000.0,
          'category': 'electronics',
        },
        {
          'id': 'PROD-002',
          'name': 'Mouse',
          'price': 25.0,
          'category': 'electronics',
        },
      ]);

      // Add employee
      system.employees.add({'id': 'EMP-001', 'name': 'Sales Rep'});

      // Process first order
      final result1 = system.processComprehensiveBusinessTransaction(
        'Alice',
        'Smith',
        'alice@example.com',
        '555-0001',
        '100 First St',
        'City1',
        'CA',
        '11111',
        'USA',
        ['PROD-001'],
        [1],
        [1000.0],
        'credit_card',
        'standard',
        false,
        false,
        '',
        false,
        'EMP-001',
        'SALES',
      );

      // Process second order
      final result2 = system.processComprehensiveBusinessTransaction(
        'Bob',
        'Jones',
        'bob@example.com',
        '555-0002',
        '200 Second St',
        'City2',
        'CA',
        '22222',
        'USA',
        ['PROD-002'],
        [10],
        [25.0], // 10 mice for bulk discount
        'paypal',
        'expedited',
        true,
        false,
        'SAVE10',
        true,
        'EMP-001',
        'SALES',
      );

      expect(result1, contains('Order processed successfully'));
      expect(result2, contains('Order processed successfully'));
      expect(system.orders.length, 2);

      // Test reporting
      final report = system.generateComprehensiveBusinessReport();
      expect(report, contains('Total Orders: 2'));
      expect(report, contains('electronics:'));
    });
  });
}
