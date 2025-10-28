// ignore_for_file: avoid_print

class Employee {
  final String name;
  final String type;

  Employee(this.name, this.type) {
    validateType(name);
  }

  validateType(String args) {
    if (!['engineer', 'salesman', 'manager'].contains(type)) {
      throw ArgumentError('Invalid employee type: $type');
    }
  }
}

void main(List<String> args) {
  var emp = Employee('Alice', 'manager');
  print('Employee: ${emp.name}, Type: ${emp.type}');
}
