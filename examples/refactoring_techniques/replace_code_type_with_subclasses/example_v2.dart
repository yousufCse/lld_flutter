// ignore_for_file: avoid_print

//* Applied
//? Encapsulate Field
//? Replace Code with Subclasses
//? Self Encapsulate Field
//? Replace Constructor with Factory Function
class Employee {
  final String _name;

  Employee(this._name);

  String get name => _name;

  @override
  String toString() {
    return 'Employee(name: $_name)';
  }
}

class Engineer extends Employee {
  Engineer(super.name);
}

class Salesman extends Employee {
  Salesman(super.name);
}

class Manager extends Employee {
  Manager(super.name);
}

//? Replace Constructor with Factory Function
Employee createEmployee(String name, String type) {
  switch (type) {
    case 'engineer':
      return Engineer(name);
    case 'salesman':
      return Salesman(name);
    case 'manager':
      return Manager(name);
  }
  throw ArgumentError('Invalid employee type: $type');
}

void main(List<String> args) {
  var emp = createEmployee('AAA', 'salesman');
  print('Employee: ${emp.name}}');
}
