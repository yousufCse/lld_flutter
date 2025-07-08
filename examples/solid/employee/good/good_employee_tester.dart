// ignore_for_file: avoid_print

abstract class SalaryCalculator {
  double calculate(double baseSalary);
}

class DeveloperSalaryCalculator implements SalaryCalculator {
  @override
  double calculate(double baseSalary) {
    return baseSalary + (baseSalary * 0.20); // 20% bonus
  }
}

class ManagerSalaryCalculator implements SalaryCalculator {
  @override
  double calculate(double baseSalary) {
    return baseSalary + (baseSalary * 0.30); // 30% bonus
  }
}

class Developer extends Employee {
  Developer(super.name, super.baseSalary, this.salaryCalculator);

  final SalaryCalculator salaryCalculator;

  @override
  double getTotalSalary() {
    return salaryCalculator.calculate(baseSalary);
  }

  @override
  void showDetails() {
    print('Name: $name, Role: $runtimeType, Salary: ${getTotalSalary()}');
  }
}

class Manager extends Employee {
  Manager(super.name, super.baseSalary, this.salaryCalculator);

  final SalaryCalculator salaryCalculator;

  @override
  double getTotalSalary() {
    return salaryCalculator.calculate(baseSalary);
  }

  @override
  void showDetails() {
    print('Name: $name, Role: $runtimeType, Salary: ${getTotalSalary()}');
  }
}

abstract class Employee {
  Employee(this.name, this.baseSalary);

  final String name;
  final double baseSalary;

  double getTotalSalary();
  void showDetails();
}

void main() {
  final developerSalaryCalculator = DeveloperSalaryCalculator();
  final managerSalaryCalulator = ManagerSalaryCalculator();

  final List<Employee> employees = [
    Developer('Alice', 5000, developerSalaryCalculator),
    Manager('Bob', 7000, managerSalaryCalulator),
    Developer('Charlie', 2000, developerSalaryCalculator),
  ];

  for (var employee in employees) {
    employee.showDetails();
  }
}
