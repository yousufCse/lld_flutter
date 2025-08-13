// ignore_for_file: avoid_print

import 'dart:math';

class UserProcessor {
  dynamic processUserData(var d, var opts, bool isVIP) {
    // Initialize variables
    var tot = 0.0;
    var dis = 0.0;
    var res = "";
    var user_products = [];
    var user_name = d["name"];

    // Calculate total price of all products
    for (var i = 0; i < d["products"].length; i++) {
      var p = d["products"][i];
      tot = tot + p["price"] * p["quantity"];
      user_products.add(p["name"]);
    }

    // Apply different discount based on user type
    if (isVIP == true) {
      if (tot > 1000) {
        dis = tot * 0.15;
      } else if (tot > 500) {
        dis = tot * 0.1;
      } else {
        dis = tot * 0.05;
      }
    } else {
      if (tot > 1000) {
        dis = tot * 0.1;
      } else if (tot > 500) {
        dis = tot * 0.05;
      } else {
        dis = 0;
      }
    }

    // Apply special discount if specified in options
    if (opts != null && opts["specialDiscount"] == true) {
      dis = dis + 50;
    }

    // Make sure discount doesn't exceed total
    if (dis > tot) {
      dis = tot;
    }

    // Generate report
    res = "User: " + user_name + "\n";
    res = res + "Products: " + user_products.join(", ") + "\n";
    res = res + "Subtotal: " + tot.toStringAsFixed(2) + "\n";
    res = res + "Discount: " + dis.toStringAsFixed(2) + "\n";
    res = res + "Total: " + (tot - dis).toStringAsFixed(2);

    // Generate random order ID
    var order_id = "ORD" + (Random().nextInt(9000) + 1000).toString();

    // Return final data
    var finalData = {
      "report": res,
      "order_id": order_id,
      "total": tot,
      "discount": dis,
      "final_amount": tot - dis,
      "processed_on": DateTime.now().toString(),
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
