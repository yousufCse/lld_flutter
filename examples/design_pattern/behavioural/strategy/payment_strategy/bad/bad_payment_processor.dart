// ignore_for_file: avoid_print

class BadPaymentProcessor {
  void pay(String email, String method, double amount) {
    if (method == 'credit_card') {
      _processCreditCardPayment(email, amount);
    } else if (method == 'paypal') {
      _processPayPalPayment(email, amount);
    } else if (method == 'bank_transfer') {
      _processBankTransfer(email, amount);
    } else {
      print("❌ Unsupported payment method: $method");
    }
  }

  void _processCreditCardPayment(String email, double amount) {
    print(
      "💳 Processing Credit Card Payment for $email: \$${amount.toStringAsFixed(2)}",
    );
    // Simulate credit card processing logic
    if (email.isEmpty) {
      print("❌ Invalid credit card details");
    } else {
      print("✅ Credit Card Payment Successful");
    }
  }

  void _processPayPalPayment(String email, double amount) {
    print(
      "📧 Processing PayPal Payment for $email: \$${amount.toStringAsFixed(2)}",
    );
    // Simulate PayPal processing logic
    if (!email.contains('@')) {
      print("❌ Invalid PayPal email");
    } else {
      print("✅ PayPal Payment Successful");
    }
  }

  void _processBankTransfer(String email, double amount) {
    print(
      "🏦 Processing Bank Transfer for $email: \$${amount.toStringAsFixed(2)}",
    );
    // Simulate bank transfer logic
    if (email.isEmpty) {
      print("❌ Invalid bank transfer details");
    } else {
      print("✅ Bank Transfer Successful");
    }
  }
}
