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

class InternSalaryCalculator implements SalaryCalculator {
  @override
  double calculate(double baseSalary) {
    return baseSalary; // Interns do not get bonuses
  }
}

class Developer extends Employee {
  Developer(super.salaryCalculator, super.name, super.baseSalary);
}

class Manager extends Employee {
  Manager(super.salaryCalculator, super.name, super.baseSalary);
}

class Intern extends Employee {
  Intern(super.salaryCalculator, super.name, super.baseSalary);
}

abstract class Employee {
  Employee(this.salaryCalculator, this.name, this.baseSalary);

  final SalaryCalculator salaryCalculator;
  final String name;
  final double baseSalary;

  double getTotalSalary() {
    return salaryCalculator.calculate(baseSalary);
  }

  void showDetails() {
    print('''
|${name.padRight(18)}| ${runtimeType.toString().padRight(12)} | ${baseSalary.toString().padLeft(13)} | ${getTotalSalary().toString().padLeft(12)}
|------------------|--------------|---------------|--------------|
''');
  }
}

void main() {
  final developerSalaryCalculator = DeveloperSalaryCalculator();
  final managerSalaryCalulator = ManagerSalaryCalculator();
  final internSalaryCalculator = InternSalaryCalculator();

  final List<Employee> employees = [
    Developer(developerSalaryCalculator, 'Yousuf', 5000),
    Manager(managerSalaryCalulator, 'Rana', 7000),
    Developer(developerSalaryCalculator, 'Md. Sohel', 2000),
    Developer(developerSalaryCalculator, 'Akash', 3000),
    Intern(internSalaryCalculator, 'Saif', 1000),
  ];

  print('''
|-----------------|---------------|---------------|--------------|
| Name            | Type          | Base Salary   | Total Salary |
|-----------------|---------------|---------------|--------------|
''');
  for (var employee in employees) {
    employee.showDetails();
  }
}
