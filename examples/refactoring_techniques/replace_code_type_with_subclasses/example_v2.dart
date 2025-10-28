// ignore_for_file: avoid_print

//* Applied
//? Encapsulate Field
//? Replace Code with Subclasses
//? Self Encapsulate Field
class Employee {
  final String _name;
  final String _type;

  Employee(this._name, this._type) {
    validateType(type);
  }

  validateType(String args) {
    if (!['engineer', 'salesman', 'manager'].contains(type)) {
      throw ArgumentError('Invalid employee type: $type');
    }
  }

  String get type => _type;

  @override
  String toString() {
    return 'Employee(name: $_name, type: $type)';
  }
}

void main(List<String> args) {
  var emp = Employee('Alice', 'manager');
  print('Employee: ..., Type: ${emp.type}');
}
