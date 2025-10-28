class Employee {
  final String name;
  final String type; // 'full_time' or 'part_time'

  Employee(this.name, this.type);
}

class Engineer extends Employee {
  Engineer(String name) : super(name, 'engineer');
}

class Salesman extends Employee {
  Salesman(String name) : super(name, 'salesman');
}

class Manager extends Employee {
  Manager(String name) : super(name, 'manager');
}

Employee createEmployee(String name, String type) {
  return switch (type) {
    'engineer' => Engineer(name),
    'salesman' => Salesman(name),
    'manager' => Manager(name),
    _ => throw ArgumentError('Invalid employee type: $type'),
  };
}
