// PROBLEM: E-commerce Notification System (BAD IMPLEMENTATION)
//
// This is a poorly designed notification system for an e-commerce platform.
// The code violates SOLID principles and lacks proper design patterns.
//
// YOUR CHALLENGE: Refactor this code using appropriate design patterns to make it:
// 1. Follow SOLID principles
// 2. Be easily extensible for new notification types
// 3. Support different delivery channels (email, SMS, push, etc.)
// 4. Handle different notification formats
// 5. Be testable and maintainable

// ignore_for_file: avoid_print

import 'dart:math';

// BAD: Violates Single Responsibility and Open/Closed Principle
class NotificationManager {
  void sendOrderConfirmation(
    String customerEmail,
    String customerPhone,
    String orderId,
    double amount,
    List<String> items,
  ) {
    // Email notification logic mixed with business logic
    if (customerEmail.isNotEmpty) {
      print("Sending email to: $customerEmail");
      print("Subject: Order Confirmation #$orderId");
      print("Dear Customer,");
      print("Your order #$orderId has been confirmed.");
      print("Total Amount: \$${amount.toStringAsFixed(2)}");
      print("Items: ${items.join(', ')}");
      print("Thank you for your purchase!");
      print("---EMAIL SENT---\n");
    }

    // SMS notification logic mixed in
    if (customerPhone.isNotEmpty) {
      String smsText =
          "Order #$orderId confirmed. Amount: \$${amount.toStringAsFixed(2)}. Items: ${items.take(2).join(', ')}${items.length > 2 ? '...' : ''}";
      if (smsText.length > 160) {
        smsText = smsText.substring(0, 157) + "...";
      }
      print("Sending SMS to: $customerPhone");
      print("Message: $smsText");
      print("---SMS SENT---\n");
    }
  }

  void sendShippingNotification(
    String customerEmail,
    String customerPhone,
    String orderId,
    String trackingNumber,
    String estimatedDelivery,
  ) {
    // Duplicate email logic
    if (customerEmail.isNotEmpty) {
      print("Sending email to: $customerEmail");
      print("Subject: Your Order #$orderId Has Shipped!");
      print("Dear Customer,");
      print("Great news! Your order #$orderId has been shipped.");
      print("Tracking Number: $trackingNumber");
      print("Estimated Delivery: $estimatedDelivery");
      print(
        "You can track your package at: https://tracking.example.com/$trackingNumber",
      );
      print("---EMAIL SENT---\n");
    }

    // Duplicate SMS logic
    if (customerPhone.isNotEmpty) {
      String smsText =
          "Order #$orderId shipped! Tracking: $trackingNumber. Est. delivery: $estimatedDelivery";
      if (smsText.length > 160) {
        smsText = smsText.substring(0, 157) + "...";
      }
      print("Sending SMS to: $customerPhone");
      print("Message: $smsText");
      print("---SMS SENT---\n");
    }
  }

  void sendPaymentFailedNotification(
    String customerEmail,
    String customerPhone,
    String orderId,
    String reason,
  ) {
    // More duplicate code
    if (customerEmail.isNotEmpty) {
      print("Sending email to: $customerEmail");
      print("Subject: Payment Failed for Order #$orderId");
      print("Dear Customer,");
      print("We were unable to process your payment for order #$orderId.");
      print("Reason: $reason");
      print("Please update your payment method and try again.");
      print("---EMAIL SENT---\n");
    }

    if (customerPhone.isNotEmpty) {
      String smsText =
          "Payment failed for order #$orderId. Reason: $reason. Please update payment method.";
      if (smsText.length > 160) {
        smsText = smsText.substring(0, 157) + "...";
      }
      print("Sending SMS to: $customerPhone");
      print("Message: $smsText");
      print("---SMS SENT---\n");
    }
  }

  // BAD: What if we want to add push notifications? We'd have to modify every method!
  // BAD: What if we want different templates? More if-else conditions!
  // BAD: Hard to test individual notification types
  // BAD: No way to easily add new notification types without modifying existing code
}

// BAD: Tightly coupled data structures
class Order {
  final String id;
  final String customerEmail;
  final String customerPhone;
  final double amount;
  final List<String> items;
  final String status;

  Order({
    required this.id,
    required this.customerEmail,
    required this.customerPhone,
    required this.amount,
    required this.items,
    required this.status,
  });
}

class Shipping {
  final String orderId;
  final String trackingNumber;
  final String estimatedDelivery;

  Shipping({
    required this.orderId,
    required this.trackingNumber,
    required this.estimatedDelivery,
  });
}

// Example usage of the BAD implementation
void main() {
  print("=== BAD IMPLEMENTATION DEMO ===\n");

  final notificationManager = NotificationManager();

  final order = Order(
    id: "ORD-${Random().nextInt(10000)}",
    customerEmail: "customer@example.com",
    customerPhone: "+1234567890",
    amount: 99.99,
    items: ["Wireless Headphones", "Phone Case", "Screen Protector"],
    status: "confirmed",
  );

  // Send order confirmation
  notificationManager.sendOrderConfirmation(
    order.customerEmail,
    order.customerPhone,
    order.id,
    order.amount,
    order.items,
  );

  // Send shipping notification
  final shipping = Shipping(
    orderId: order.id,
    trackingNumber: "TRK${Random().nextInt(1000000)}",
    estimatedDelivery: "June 30, 2025",
  );

  notificationManager.sendShippingNotification(
    order.customerEmail,
    order.customerPhone,
    shipping.orderId,
    shipping.trackingNumber,
    shipping.estimatedDelivery,
  );

  // Send payment failed notification
  notificationManager.sendPaymentFailedNotification(
    order.customerEmail,
    order.customerPhone,
    order.id,
    "Insufficient funds",
  );

  print("\n=== PROBLEMS WITH THIS CODE ===");
  print("1. Violates Single Responsibility Principle");
  print("2. Violates Open/Closed Principle");
  print("3. Code duplication everywhere");
  print("4. Hard to add new notification channels");
  print("5. Hard to add new notification types");
  print("6. Difficult to test");
  print("7. Tightly coupled components");
  print("8. No separation of concerns");

  print("\n=== YOUR MISSION ===");
  print("Refactor this code using design patterns such as:");
  print("- Strategy Pattern (for different delivery channels)");
  print("- Template Method Pattern (for notification structure)");
  print("- Factory Pattern (for creating notifications)");
  print("- Observer Pattern (for event-driven notifications)");
  print("- Builder Pattern (for complex notification construction)");
  print("- Command Pattern (for notification actions)");
  print("And make sure it follows SOLID principles!");
}

/*
HINTS FOR SOLVING:

1. Identify what varies and encapsulate it
2. Think about the different dimensions of variation:
   - Notification types (order confirmation, shipping, payment failed, etc.)
   - Delivery channels (email, SMS, push notifications, etc.)
   - Message formats (HTML, plain text, etc.)
   
3. Consider these design patterns:
   - Strategy: For different delivery mechanisms
   - Template Method: For notification structure
   - Factory: For creating appropriate notifications
   - Observer: For event-driven architecture
   - Builder: For constructing complex notifications

4. Apply SOLID principles:
   - Single Responsibility: Each class should have one reason to change
   - Open/Closed: Open for extension, closed for modification
   - Liskov Substitution: Subtypes should be substitutable
   - Interface Segregation: Clients shouldn't depend on unused interfaces
   - Dependency Inversion: Depend on abstractions, not concretions
*/
