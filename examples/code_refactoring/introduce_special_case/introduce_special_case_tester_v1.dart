// ignore_for_file: avoid_print

class Customer {
  final String name;
  final String email;

  Customer(this.name, this.email);

  double calculateVat(double amount) {
    return amount * 0.05;
  }
}

class NoCustomer extends Customer {
  NoCustomer() : super('Guest', 'N/A');

  @override
  double calculateVat(double amount) {
    return amount * 0;
  }

  void displayCustomerInf(Customer? customer) {
    if (customer == null) {
      print('No customer information available.');
    } else {
      print('Customer Name: ${customer.name}');
      print('Customer Email: ${customer.email}');
    }
  }

  double calculateBill(Customer? customer, double amount) {
    if (customer == null) {
      print('Calculating bill for guest customer.');
      return amount * 0; // 10% tax for guest
    } else {
      print('Calculating bill for ${customer.name}.');
      return amount * 1.05; // 5% tax for registered customer
    }
  }
}

void main(List<String> args) {
  print('----- Introduce Special Case Tester V1 -----');

  final registeredCustomer = Customer('Alice', 'saa@g.com');
  print(
    '${registeredCustomer.name} Customer VAT on 100: ${registeredCustomer.calculateVat(100)}',
  );

  final noCustomer = NoCustomer();
  print('${noCustomer.name} VAT on 100: ${noCustomer.calculateVat(100)}');
}
