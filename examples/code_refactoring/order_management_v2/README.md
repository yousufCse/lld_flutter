# Comprehensive Code Smells and Refactoring Techniques Guide

This document provides a complete reference for all major code smells found in `comprehensive_code_smells.dart` and the refactoring techniques that can be applied to fix them.

## 📚 Table of Contents

1. [Code Smells Overview](#code-smells-overview)
2. [Detailed Code Smells and Refactoring Techniques](#detailed-code-smells-and-refactoring-techniques)
3. [Refactoring Techniques Reference](#refactoring-techniques-reference)
4. [Practice Exercises](#practice-exercises)

## Code Smells Overview

The `comprehensive_code_smells.dart` file contains **22 major code smells** that commonly appear in real-world applications:

| # | Code Smell | Severity | Location in Code |
|---|------------|----------|------------------|
| 1 | Large Class | High | `ComprehensiveBusinessSystem` |
| 2 | Long Method | High | `processComprehensiveBusinessTransaction` |
| 3 | Long Parameter List | High | `processComprehensiveBusinessTransaction` |
| 4 | Duplicate Code | Medium | Validation logic, loops |
| 5 | Data Clumps | Medium | Customer data parameters |
| 6 | Primitive Obsession | Medium | Using Maps instead of objects |
| 7 | Switch Statements | Medium | Payment processing, shipping |
| 8 | Feature Envy | Medium | Product/Employee data access |
| 9 | Inappropriate Intimacy | Medium | CustomerManager/OrderManager |
| 10 | Message Chains | Low | `OrderService` methods |
| 11 | Middle Man | Low | `BusinessFacade` |
| 12 | Lazy Class | Low | `SimpleValidator` |
| 13 | Speculative Generality | Low | `processGenericBusinessEntity` |
| 14 | Temporary Field | Low | `tempCalculationResult` |
| 15 | Refused Bequest | Low | `Fish` class |
| 16 | Comments | Low | Excessive documentation |
| 17 | Divergent Change | High | `ComprehensiveBusinessSystem` |
| 18 | Shotgun Surgery | Medium | Payment processing changes |
| 19 | Parallel Inheritance | Medium | PaymentProcessor/PaymentValidator |
| 20 | Dead Code | Low | `oldReportingMethod` |
| 21 | Magic Numbers | Medium | Discount rates, limits |
| 22 | Complex Conditionals | Medium | Nested if statements |

## Detailed Code Smells and Refactoring Techniques

### 1. 🏢 Large Class
**Location:** `ComprehensiveBusinessSystem` class  
**Problem:** Class has too many responsibilities (customers, orders, products, employees, payments, reporting)

**Refactoring Techniques:**
- **Extract Class**: Create separate classes for `CustomerService`, `OrderService`, `ProductService`, `PaymentService`
- **Extract Subclass**: Create specialized business system classes
- **Extract Interface**: Define `IBusinessService` interface

**Example Refactoring:**
```dart
// Before: One large class
class ComprehensiveBusinessSystem { /* 500+ lines */ }

// After: Multiple focused classes
class CustomerService { /* Customer operations */ }
class OrderService { /* Order operations */ }
class PaymentService { /* Payment operations */ }
class BusinessSystemFacade { 
  CustomerService customers;
  OrderService orders;
  PaymentService payments;
}
```

### 2. 📏 Long Method
**Location:** `processComprehensiveBusinessTransaction` method  
**Problem:** Method is 150+ lines doing validation, calculation, order creation, payment processing

**Refactoring Techniques:**
- **Extract Method**: Break into smaller, focused methods
- **Replace Method with Method Object**: Create `OrderProcessor` class
- **Decompose Conditional**: Simplify complex conditionals

**Example Refactoring:**
```dart
// Before: One huge method
String processComprehensiveBusinessTransaction(20+ parameters) {
  // 150+ lines of code
}

// After: Multiple focused methods
String processOrder(OrderRequest request) {
  validateCustomer(request.customer);
  var items = calculateOrderItems(request.items);
  var shipping = calculateShipping(request.shipping);
  var payment = processPayment(request.payment);
  return createOrder(items, shipping, payment);
}
```

### 3. 📋 Long Parameter List
**Location:** `processComprehensiveBusinessTransaction` method  
**Problem:** Method takes 20+ individual parameters

**Refactoring Techniques:**
- **Introduce Parameter Object**: Create `OrderRequest` class
- **Preserve Whole Object**: Pass objects instead of primitive values
- **Replace Parameter with Method Call**: Calculate values inside method

**Example Refactoring:**
```dart
// Before: 20+ parameters
String processOrder(String firstName, String lastName, String email, 
                   String phone, String address, /* 15+ more params */) {

// After: Parameter object
class OrderRequest {
  Customer customer;
  List<OrderItem> items;
  ShippingInfo shipping;
  PaymentInfo payment;
}

String processOrder(OrderRequest request) {
```

### 4. 🔄 Duplicate Code
**Location:** Validation logic, statistical calculations  
**Problem:** Same validation and calculation logic repeated

**Refactoring Techniques:**
- **Extract Method**: Create reusable validation methods
- **Pull Up Method**: Move common code to superclass
- **Form Template Method**: Create template with hooks

**Example Refactoring:**
```dart
// Before: Duplicated validation
if (customer['firstName'] == null || customer['firstName'].isEmpty) { /* validation */ }
// Same validation repeated multiple times

// After: Extracted method
bool isValidName(String? name) => name != null && name.isNotEmpty;
bool isValidEmail(String? email) => email != null && email.contains('@');
```

### 5. 🗂️ Data Clumps
**Location:** Customer data parameters  
**Problem:** firstName, lastName, email, phone, address always used together

**Refactoring Techniques:**
- **Extract Class**: Create `Customer`, `Address` classes
- **Introduce Parameter Object**: Group related parameters
- **Preserve Whole Object**: Pass complete objects

**Example Refactoring:**
```dart
// Before: Data clumps
String processOrder(String firstName, String lastName, String email, 
                   String phone, String address, String city, String state);

// After: Extract class
class Customer {
  String firstName, lastName, email, phone;
  Address address;
}

class Address {
  String street, city, state, zip, country;
}
```

### 6. 🔤 Primitive Obsession
**Location:** Using `Map<String, dynamic>` for business objects  
**Problem:** Using primitives/maps instead of proper value objects

**Refactoring Techniques:**
- **Replace Data Value with Object**: Create proper classes
- **Replace Type Code with Class**: Use enums or classes for types
- **Replace Array with Object**: Use objects instead of arrays

**Example Refactoring:**
```dart
// Before: Primitive obsession
Map<String, dynamic> customer = {
  'firstName': 'John',
  'email': 'john@example.com',
  'type': 'premium' // String type code
};

// After: Proper objects
class Customer {
  String firstName;
  Email email;
  CustomerType type;
}

enum CustomerType { regular, premium, vip }
class Email { 
  String value;
  Email(this.value) { /* validation */ }
}
```

### 7. 🔀 Switch Statements
**Location:** Payment processing, shipping calculation  
**Problem:** Switch statements that should use polymorphism

**Refactoring Techniques:**
- **Replace Conditional with Polymorphism**: Use Strategy pattern
- **Replace Type Code with Subclasses**: Create payment processor classes
- **Replace Conditional with State/Strategy**: Use state machines

**Example Refactoring:**
```dart
// Before: Switch statement
switch (paymentMethod) {
  case 'credit_card': return processCreditCard();
  case 'paypal': return processPayPal();
  case 'crypto': return processCrypto();
}

// After: Polymorphism
abstract class PaymentProcessor {
  String process(double amount);
}

class CreditCardProcessor extends PaymentProcessor { 
  String process(double amount) => 'Credit card: $amount';
}

class PaymentService {
  Map<String, PaymentProcessor> processors = {
    'credit_card': CreditCardProcessor(),
    'paypal': PayPalProcessor(),
  };
}
```

### 8. 💘 Feature Envy
**Location:** Product/Employee data access methods  
**Problem:** Methods use other objects' data more than their own

**Refactoring Techniques:**
- **Move Method**: Move method to the class it uses most
- **Extract Method**: Create focused methods on appropriate classes
- **Move Field**: Move data closer to methods that use it

**Example Refactoring:**
```dart
// Before: Feature envy
class OrderService {
  String getProductInfo(String productId) {
    var product = productService.findById(productId);
    return '${product.name} - ${product.price}'; // Uses product data
  }
}

// After: Move method
class Product {
  String getDisplayInfo() => '$name - $price';
}

class OrderService {
  String getProductInfo(String productId) {
    return productService.findById(productId).getDisplayInfo();
  }
}
```

### 9. 🤝 Inappropriate Intimacy
**Location:** CustomerManager/OrderManager bidirectional dependency  
**Problem:** Classes know too much about each other's internal structure

**Refactoring Techniques:**
- **Move Method/Field**: Reduce coupling between classes
- **Change Bidirectional to Unidirectional**: Remove circular dependencies
- **Replace Inheritance with Delegation**: Use composition over inheritance

**Example Refactoring:**
```dart
// Before: Inappropriate intimacy
class CustomerManager {
  OrderManager orderManager; // Bidirectional
  void addCustomer(Customer customer) {
    customers.add(customer);
    orderManager.notifyNewCustomer(customer.email); // Knows internal details
  }
}

// After: Loose coupling
class CustomerManager {
  List<CustomerObserver> observers = [];
  void addCustomer(Customer customer) {
    customers.add(customer);
    notifyObservers(customer);
  }
}
```

### 10. ⛓️ Message Chains
**Location:** `OrderService.getFirstOrderCustomerEmail()`  
**Problem:** Long chains of method calls

**Refactoring Techniques:**
- **Hide Delegate**: Add methods to hide chain complexity
- **Extract Method**: Create intermediate methods
- **Move Method**: Move chain logic to appropriate class

**Example Refactoring:**
```dart
// Before: Message chain
String email = system.orders.first['customer']['email'];

// After: Hide delegate
class OrderService {
  String getFirstOrderCustomerEmail() {
    return getFirstOrder().getCustomerEmail();
  }
  
  Order getFirstOrder() => orders.first;
}

class Order {
  String getCustomerEmail() => customer.email;
}
```

## Refactoring Techniques Reference

### Composing Methods
- **Extract Method**: Break large methods into smaller ones
- **Inline Method**: Remove unnecessary method indirection
- **Replace Temp with Query**: Replace temporary variables with method calls
- **Replace Method with Method Object**: Turn method into separate class

### Moving Features Between Objects
- **Move Method**: Move method to the class that uses it most
- **Move Field**: Move field closer to methods that use it
- **Extract Class**: Create new class for related functionality
- **Inline Class**: Merge class functionality into another class

### Organizing Data
- **Replace Data Value with Object**: Turn simple data into proper objects
- **Change Value to Reference**: Use object references instead of values
- **Replace Array with Object**: Use objects instead of arrays
- **Replace Magic Number with Symbolic Constant**: Use named constants

### Simplifying Conditional Expressions
- **Decompose Conditional**: Break complex conditions into methods
- **Consolidate Conditional Expression**: Combine similar conditions
- **Replace Conditional with Polymorphism**: Use inheritance instead of conditionals
- **Remove Control Flag**: Eliminate flag variables in loops

### Simplifying Method Calls
- **Rename Method**: Give methods meaningful names
- **Add Parameter**: Add parameters when needed
- **Remove Parameter**: Remove unused parameters
- **Introduce Parameter Object**: Group related parameters into objects

### Dealing with Generalization
- **Pull Up Method**: Move common methods to superclass
- **Push Down Method**: Move specialized methods to subclass
- **Extract Subclass**: Create subclass for specialized behavior
- **Extract Interface**: Create interface for common behavior

## Practice Exercises

### Exercise 1: Extract Classes
Refactor `ComprehensiveBusinessSystem` into separate service classes:
1. `CustomerService`
2. `OrderService` 
3. `ProductService`
4. `PaymentService`
5. `ReportingService`

### Exercise 2: Create Value Objects
Replace primitive obsession by creating:
1. `Customer` class
2. `Address` class
3. `Email` class
4. `Money` class
5. `OrderItem` class

### Exercise 3: Implement Strategy Pattern
Replace switch statements with polymorphism:
1. Create `PaymentProcessor` hierarchy
2. Create `ShippingCalculator` hierarchy
3. Create `DiscountCalculator` hierarchy

### Exercise 4: Extract Methods
Break down the long `processComprehensiveBusinessTransaction` method:
1. `validateCustomerData()`
2. `calculateOrderTotal()`
3. `processPayment()`
4. `createOrder()`
5. `sendNotifications()`

### Exercise 5: Remove Code Smells
Fix remaining smells:
1. Remove dead code
2. Replace magic numbers with constants
3. Simplify complex conditionals
4. Remove duplicate code
5. Fix inappropriate intimacy

## Running the Code

To run the comprehensive code smells example:

```bash
# Run the main example
dart run examples/code_refactoring/comprehensive_code_smells.dart

# Run tests (after creating them)
flutter test examples/code_refactoring/
```

## Next Steps

1. **Analyze**: Study each code smell in the example
2. **Practice**: Try refactoring one smell at a time
3. **Test**: Write unit tests before and after refactoring
4. **Verify**: Ensure behavior doesn't change during refactoring
5. **Learn**: Understand why each refactoring improves the code

Remember: **Refactoring should be done in small, safe steps with comprehensive test coverage!**