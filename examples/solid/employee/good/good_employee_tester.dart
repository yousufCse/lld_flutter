// Violations of DRY, OCP, and Single Responsibility Principle
// Problem: Employee Management System
//
// The system manages employees and calculates their salaries based on their roles.
// There are three roles: Developer, Manager, and Intern.
//
// The current implementation violates the DRY, OCP, and Single Responsibility Principle.
// Your task is to identify the issues and refactor the code to adhere to these principles.

// ignore_for_file: avoid_print

// Employee class
class Employee {
  String name;
  String role;
  double baseSalary;

  Employee(this.name, this.role, this.baseSalary);

  double calculateSalary() {
    if (role == 'Developer') {
      return baseSalary + (baseSalary * 0.20); // 20% bonus
    } else if (role == 'Manager') {
      return baseSalary + (baseSalary * 0.30); // 30% bonus
    } else if (role == 'Intern') {
      return baseSalary; // No bonus
    } else {
      throw Exception('Invalid role');
    }
  }

  void printDetails() {
    print('Name: $name, Role: $role, Salary: ${calculateSalary()}');
  }
}

// Main function to demonstrate the problem
void main() {
  List<Employee> employees = [
    Employee('Alice', 'Developer', 5000),
    Employee('Bob', 'Manager', 7000),
    Employee('Charlie', 'Intern', 2000),
  ];

  for (var employee in employees) {
    employee.printDetails();
  }
}

// Problem:
// 1. The `calculateSalary` method violates the Open-Closed Principle because adding a new role requires modifying this method.
// 2. The `calculateSalary` method and `printDetails` method violate the Single Responsibility Principle because they handle multiple responsibilities.
// 3. The bonus calculation logic is duplicated for each role, violating the DRY principle.
//
// Task: Refactor the code to adhere to DRY, OCP, and Single Responsibility Principle.
