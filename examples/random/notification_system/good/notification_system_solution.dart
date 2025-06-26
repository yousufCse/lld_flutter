// SOLUTION: E-commerce Notification System (GOOD IMPLEMENTATION)
//
// This is a well-designed notification system that follows SOLID principles
// and uses multiple design patterns for a clean, extensible architecture.

// ignore_for_file: avoid_print

import 'dart:math';

// Domain Models (Clean, focused data structures)
class Customer {
  final String id;
  final String email;
  final String phone;
  final String name;
  final List<String> preferences; // notification preferences

  Customer({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    this.preferences = const [],
  });
}

class Order {
  final String id;
  final String customerId;
  final double amount;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.items,
    required this.status,
    required this.createdAt,
  });
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({required this.name, required this.price, required this.quantity});
}

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class ShippingInfo {
  final String orderId;
  final String trackingNumber;
  final DateTime estimatedDelivery;
  final String carrier;

  ShippingInfo({
    required this.orderId,
    required this.trackingNumber,
    required this.estimatedDelivery,
    required this.carrier,
  });
}

// Strategy Pattern: Different notification delivery channels
abstract class NotificationChannel {
  Future<bool> send(NotificationMessage message, Customer customer);
  String get channelName;
}

class EmailChannel implements NotificationChannel {
  @override
  String get channelName => 'Email';

  @override
  Future<bool> send(NotificationMessage message, Customer customer) async {
    // Simulate email sending
    print("📧 Sending email to: ${customer.email}");
    print("Subject: ${message.subject}");
    print("Body: ${message.body}");
    print("---EMAIL SENT---\n");
    return true;
  }
}

class SmsChannel implements NotificationChannel {
  @override
  String get channelName => 'SMS';

  @override
  Future<bool> send(NotificationMessage message, Customer customer) async {
    // Simulate SMS sending with length limit
    String smsBody = message.body;
    if (smsBody.length > 160) {
      smsBody = smsBody.substring(0, 157) + "...";
    }

    print("📱 Sending SMS to: ${customer.phone}");
    print("Message: $smsBody");
    print("---SMS SENT---\n");
    return true;
  }
}

class PushNotificationChannel implements NotificationChannel {
  @override
  String get channelName => 'Push Notification';

  @override
  Future<bool> send(NotificationMessage message, Customer customer) async {
    print("🔔 Sending push notification to: ${customer.id}");
    print("Title: ${message.subject}");
    print("Body: ${message.body}");
    print("---PUSH NOTIFICATION SENT---\n");
    return true;
  }
}

// Message structure
class NotificationMessage {
  final String subject;
  final String body;
  final Map<String, dynamic> metadata;

  NotificationMessage({
    required this.subject,
    required this.body,
    this.metadata = const {},
  });
}

// Template Method Pattern: Base class for notification templates
abstract class NotificationTemplate {
  // Template method - defines the algorithm structure
  NotificationMessage createMessage(Map<String, dynamic> data) {
    final subject = createSubject(data);
    final body = createBody(data);
    final metadata = createMetadata(data);

    return NotificationMessage(
      subject: subject,
      body: body,
      metadata: metadata,
    );
  }

  // Abstract methods to be implemented by concrete templates
  String createSubject(Map<String, dynamic> data);
  String createBody(Map<String, dynamic> data);

  // Hook method with default implementation
  Map<String, dynamic> createMetadata(Map<String, dynamic> data) {
    return {'timestamp': DateTime.now().toIso8601String()};
  }
}

// Concrete templates for different notification types
class OrderConfirmationTemplate extends NotificationTemplate {
  @override
  String createSubject(Map<String, dynamic> data) {
    return "Order Confirmation #${data['orderId']}";
  }

  @override
  String createBody(Map<String, dynamic> data) {
    final order = data['order'] as Order;
    final customer = data['customer'] as Customer;

    return """
Dear ${customer.name},

Your order #${order.id} has been confirmed!

Order Details:
- Total Amount: \$${order.amount.toStringAsFixed(2)}
- Items: ${order.items.map((item) => '${item.name} (x${item.quantity})').join(', ')}
- Order Date: ${order.createdAt.toLocal().toString().split('.')[0]}

Thank you for your purchase!

Best regards,
The E-commerce Team
"""
        .trim();
  }
}

class ShippingNotificationTemplate extends NotificationTemplate {
  @override
  String createSubject(Map<String, dynamic> data) {
    return "Your Order #${data['orderId']} Has Shipped! 📦";
  }

  @override
  String createBody(Map<String, dynamic> data) {
    final shipping = data['shipping'] as ShippingInfo;
    final customer = data['customer'] as Customer;

    return """
Dear ${customer.name},

Great news! Your order #${shipping.orderId} has been shipped.

Shipping Details:
- Tracking Number: ${shipping.trackingNumber}
- Carrier: ${shipping.carrier}
- Estimated Delivery: ${shipping.estimatedDelivery.toLocal().toString().split(' ')[0]}

Track your package: https://tracking.example.com/${shipping.trackingNumber}

Best regards,
The E-commerce Team
"""
        .trim();
  }
}

class PaymentFailedTemplate extends NotificationTemplate {
  @override
  String createSubject(Map<String, dynamic> data) {
    return "Payment Issue with Order #${data['orderId']} ⚠️";
  }

  @override
  String createBody(Map<String, dynamic> data) {
    final customer = data['customer'] as Customer;
    final reason = data['reason'] as String;

    return """
Dear ${customer.name},

We were unable to process your payment for order #${data['orderId']}.

Issue: $reason

Please update your payment method and try again at:
https://checkout.example.com/retry/${data['orderId']}

If you need assistance, please contact our support team.

Best regards,
The E-commerce Team
"""
        .trim();
  }
}

// Factory Pattern: Creates appropriate notification templates
class NotificationTemplateFactory {
  static final Map<String, NotificationTemplate> _templates = {
    'order_confirmation': OrderConfirmationTemplate(),
    'shipping_notification': ShippingNotificationTemplate(),
    'payment_failed': PaymentFailedTemplate(),
  };

  static NotificationTemplate? getTemplate(String type) {
    return _templates[type];
  }

  static void registerTemplate(String type, NotificationTemplate template) {
    _templates[type] = template;
  }
}

// Command Pattern: Encapsulates notification sending as commands
abstract class NotificationCommand {
  Future<void> execute();
}

class SendNotificationCommand implements NotificationCommand {
  final NotificationChannel channel;
  final NotificationMessage message;
  final Customer customer;

  SendNotificationCommand({
    required this.channel,
    required this.message,
    required this.customer,
  });

  @override
  Future<void> execute() async {
    try {
      await channel.send(message, customer);
    } catch (e) {
      print("❌ Failed to send notification via ${channel.channelName}: $e");
    }
  }
}

// Observer Pattern: Event-driven notification system
abstract class NotificationEvent {
  final DateTime timestamp;
  final Map<String, dynamic> data;

  NotificationEvent(this.data) : timestamp = DateTime.now();
}

class OrderConfirmedEvent extends NotificationEvent {
  OrderConfirmedEvent(Order order, Customer customer)
    : super({'order': order, 'customer': customer});
}

class OrderShippedEvent extends NotificationEvent {
  OrderShippedEvent(ShippingInfo shipping, Customer customer)
    : super({'shipping': shipping, 'customer': customer});
}

class PaymentFailedEvent extends NotificationEvent {
  PaymentFailedEvent(String orderId, String reason, Customer customer)
    : super({'orderId': orderId, 'reason': reason, 'customer': customer});
}

abstract class EventListener {
  void handle(NotificationEvent event);
}

// Main Notification Service (follows Single Responsibility)
class NotificationService implements EventListener {
  final List<NotificationChannel> _channels;
  final Map<String, String> _eventTemplateMapping = {
    'OrderConfirmedEvent': 'order_confirmation',
    'OrderShippedEvent': 'shipping_notification',
    'PaymentFailedEvent': 'payment_failed',
  };

  NotificationService(this._channels);

  @override
  void handle(NotificationEvent event) {
    final eventType = event.runtimeType.toString();
    final templateType = _eventTemplateMapping[eventType];

    if (templateType == null) {
      print("⚠️ No template mapping found for event: $eventType");
      return;
    }

    final template = NotificationTemplateFactory.getTemplate(templateType);
    if (template == null) {
      print("⚠️ No template found for type: $templateType");
      return;
    }

    final message = template.createMessage(event.data);
    final customer = event.data['customer'] as Customer;

    // Send via all available channels (could be filtered by customer preferences)
    for (final channel in _channels) {
      final command = SendNotificationCommand(
        channel: channel,
        message: message,
        customer: customer,
      );
      command.execute();
    }
  }
}

// Event Bus (Simple implementation of Observer pattern)
class EventBus {
  final List<EventListener> _listeners = [];

  void subscribe(EventListener listener) {
    _listeners.add(listener);
  }

  void unsubscribe(EventListener listener) {
    _listeners.remove(listener);
  }

  void publish(NotificationEvent event) {
    for (final listener in _listeners) {
      listener.handle(event);
    }
  }
}

// Usage example demonstrating the clean architecture
void main() {
  print("=== GOOD IMPLEMENTATION DEMO ===\n");

  // Setup notification channels
  final channels = [EmailChannel(), SmsChannel(), PushNotificationChannel()];

  // Setup notification service
  final notificationService = NotificationService(channels);

  // Setup event bus
  final eventBus = EventBus();
  eventBus.subscribe(notificationService);

  // Create test data
  final customer = Customer(
    id: "CUST-001",
    email: "customer@example.com",
    phone: "+1234567890",
    name: "John Doe",
    preferences: ["email", "sms"],
  );

  final order = Order(
    id: "ORD-${Random().nextInt(10000)}",
    customerId: customer.id,
    amount: 199.99,
    items: [
      OrderItem(name: "Wireless Headphones", price: 149.99, quantity: 1),
      OrderItem(name: "Phone Case", price: 29.99, quantity: 1),
      OrderItem(name: "Screen Protector", price: 19.99, quantity: 1),
    ],
    status: OrderStatus.confirmed,
    createdAt: DateTime.now(),
  );

  // Trigger events (this would normally come from your business logic)
  print("🎯 Publishing Order Confirmed Event...\n");
  eventBus.publish(OrderConfirmedEvent(order, customer));

  // Simulate shipping
  final shipping = ShippingInfo(
    orderId: order.id,
    trackingNumber: "TRK${Random().nextInt(1000000)}",
    estimatedDelivery: DateTime.now().add(Duration(days: 3)),
    carrier: "FastShip Express",
  );

  print("🎯 Publishing Order Shipped Event...\n");
  eventBus.publish(OrderShippedEvent(shipping, customer));

  print("🎯 Publishing Payment Failed Event...\n");
  eventBus.publish(
    PaymentFailedEvent(order.id, "Insufficient funds", customer),
  );

  print("\n=== BENEFITS OF THIS DESIGN ===");
  print("✅ Follows Single Responsibility Principle");
  print("✅ Follows Open/Closed Principle");
  print("✅ Easy to add new notification channels");
  print("✅ Easy to add new notification types");
  print("✅ Event-driven architecture");
  print("✅ Highly testable");
  print("✅ Loosely coupled components");
  print("✅ Clear separation of concerns");
  print("✅ Uses multiple design patterns effectively");

  print("\n=== DESIGN PATTERNS USED ===");
  print("🔧 Strategy Pattern: NotificationChannel implementations");
  print("🔧 Template Method: NotificationTemplate base class");
  print("🔧 Factory Pattern: NotificationTemplateFactory");
  print("🔧 Command Pattern: NotificationCommand");
  print("🔧 Observer Pattern: EventBus and EventListener");
}

/*
DESIGN PATTERNS EXPLANATION:

1. STRATEGY PATTERN:
   - NotificationChannel interface with different implementations
   - Allows runtime selection of delivery method
   - Easy to add new channels without modifying existing code

2. TEMPLATE METHOD PATTERN:
   - NotificationTemplate defines the structure of message creation
   - Subclasses implement specific parts (subject, body)
   - Ensures consistent message structure across types

3. FACTORY PATTERN:
   - NotificationTemplateFactory creates appropriate templates
   - Centralizes template creation logic
   - Easy to register new template types

4. COMMAND PATTERN:
   - SendNotificationCommand encapsulates sending action
   - Allows queuing, logging, and retry mechanisms
   - Decouples sender from receiver

5. OBSERVER PATTERN:
   - EventBus manages event publishing and subscription
   - Loose coupling between event producers and consumers
   - Easy to add new event handlers

SOLID PRINCIPLES:

1. Single Responsibility:
   - Each class has one reason to change
   - NotificationService only handles notifications
   - Templates only handle message creation

2. Open/Closed:
   - Open for extension (new channels, templates)
   - Closed for modification (existing code doesn't change)

3. Liskov Substitution:
   - All NotificationChannel implementations are interchangeable
   - All NotificationTemplate implementations work the same way

4. Interface Segregation:
   - Small, focused interfaces
   - Clients only depend on what they use

5. Dependency Inversion:
   - Depends on abstractions (interfaces)
   - Not on concrete implementations
*/
