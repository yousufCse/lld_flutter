// ignore_for_file: avoid_print

import 'dart:math';

class UserProcessor {
  dynamic processUserData(
    Map<String, dynamic> data,
    Map<String, dynamic> options,
    bool isVip,
  ) {
    // Initialize variables
    double total = 0.0;
    double discount = 0.0;
    String result = "";
    List<String> products = [];
    final userName = data["name"] as String;

    // Calculate total price of all products
    for (int i = 0; i < data["products"].length; i++) {
      final product = data["products"][i];
      total = total + product["price"] * product["quantity"];
      products.add(product["name"]);
    }

    // Apply different discount based on user type
    if (isVip == true) {
      if (total > 1000) {
        discount = total * 0.15;
      } else if (total > 500) {
        discount = total * 0.1;
      } else {
        discount = total * 0.05;
      }
    } else {
      if (total > 1000) {
        discount = total * 0.1;
      } else if (total > 500) {
        discount = total * 0.05;
      } else {
        discount = 0;
      }
    }

    // Apply special discount if specified in options
    if (options["specialDiscount"] == true) {
      discount = discount + 50;
    }

    // Make sure discount doesn't exceed total
    if (discount > total) {
      discount = total;
    }

    // Generate report
    result = "User: " + userName + "\n";
    result = result + "Products: " + products.join(", ") + "\n";
    result = result + "Subtotal: " + total.toStringAsFixed(2) + "\n";
    result = result + "Discount: " + discount.toStringAsFixed(2) + "\n";
    result = result + "Total: " + (total - discount).toStringAsFixed(2);

    // Generate random order ID
    final orderId = "ORD" + (Random().nextInt(9000) + 1000).toString();

    // Return final data
    final finalData = {
      "report": result,
      "orderId": orderId,
      "total": total,
      "discount": discount,
      "finalAmount": total - discount,
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
