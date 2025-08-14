// ignore_for_file: avoid_print

import 'dart:math';

class UserProcessor {
  double calculateTotalPrice(Map<String, dynamic> data) {
    return data["products"]
        .map(
          (product) =>
              product['price'].toDouble() * product['quantity'].toDouble(),
        )
        .reduce((value, element) => value + element);
  }

  List<String> productNames(Map<String, dynamic> data) {
    return (data['products'] as List)
        .map((product) => product['name'] as String)
        .toList();
  }

  double calculateDiscountForGeneral(final Map<String, dynamic> data) {
    double result = 0.0;
    if (calculateTotalPrice(data) > 1000) {
      result = calculateTotalPrice(data) * 0.1;
    } else if (calculateTotalPrice(data) > 500) {
      result = calculateTotalPrice(data) * 0.05;
    } else {
      result = 0;
    }

    return result;
  }

  double calculateDiscountForVip(final Map<String, dynamic> data) {
    double result = 0.0;
    if (calculateTotalPrice(data) > 1000) {
      result = calculateTotalPrice(data) * 0.15;
    } else if (calculateTotalPrice(data) > 500) {
      result = calculateTotalPrice(data) * 0.1;
    } else {
      result = calculateTotalPrice(data) * 0.05;
    }
    return result;
  }

  Map<String, dynamic> processUserData(
    Map<String, dynamic> data,
    Map<String, dynamic> options,
    bool isVip,
  ) {
    // Initialize variables
    String result = "";
    final userName = data["name"] as String;

    double discount = 0.0;
    if (isVip == true) {
      discount = calculateDiscountForVip(data);
    } else {
      discount = calculateDiscountForGeneral(data);
    }

    // Apply special discount if specified in options
    if (options["specialDiscount"] == true) {
      discount = discount + 50;
    }

    // Make sure discount doesn't exceed total
    if (discount > calculateTotalPrice(data)) {
      discount = calculateTotalPrice(data);
    }

    // Generate report
    result = "User: $userName\n";
    result = "${result}Products: ${productNames(data).join(", ")}\n";
    result =
        "${result}Subtotal: ${calculateTotalPrice(data).toStringAsFixed(2)}\n";
    result = "${result}Discount: ${discount.toStringAsFixed(2)}\n";
    result =
        "${result}Total: ${(calculateTotalPrice(data) - discount).toStringAsFixed(2)}";

    // Generate random order ID
    final orderId = "ORD${Random().nextInt(9000) + 1000}";

    // Return final data
    final finalData = {
      "report": result,
      "orderId": orderId,
      "total": calculateTotalPrice(data),
      "discount": discount,
      "finalAmount": calculateTotalPrice(data) - discount,
      "processedOn": DateTime.now().toString(),
    };

    return finalData;
  }
}

// Example usage:
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
}
