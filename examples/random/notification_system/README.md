# Design Pattern Challenge: E-commerce Notification System

## 🎯 The Challenge

You are presented with a poorly designed e-commerce notification system that violates multiple SOLID principles and lacks proper design patterns. Your mission is to refactor this code into a clean, maintainable, and extensible solution.

## 📁 Files

- **`notification_system_problem.dart`** - The problematic code you need to refactor
- **`notification_system_solution.dart`** - The clean solution (don't peek! 😉)

## 🚨 Problems in the Current Code

The bad implementation suffers from several issues:

1. **Violates Single Responsibility Principle** - One class does everything
2. **Violates Open/Closed Principle** - Adding new features requires modifying existing code
3. **Massive code duplication** - Same logic repeated everywhere
4. **Tight coupling** - Components are heavily dependent on each other
5. **Hard to test** - No separation of concerns
6. **Poor extensibility** - Adding new notification types or channels is painful
7. **No error handling** - Fragile implementation
8. **Mixed concerns** - Business logic mixed with delivery logic

## 🎯 Your Mission

Refactor the problematic code using appropriate design patterns to achieve:

### Requirements:
- ✅ Follow all SOLID principles
- ✅ Support multiple notification types (order confirmation, shipping, payment failed, etc.)
- ✅ Support multiple delivery channels (email, SMS, push notifications)
- ✅ Easy to add new notification types without modifying existing code
- ✅ Easy to add new delivery channels without modifying existing code
- ✅ Proper separation of concerns
- ✅ Testable architecture
- ✅ Event-driven notifications

### Suggested Design Patterns:

1. **Strategy Pattern** - For different delivery channels (email, SMS, push)
2. **Template Method Pattern** - For notification message structure
3. **Factory Pattern** - For creating appropriate notification templates
4. **Observer Pattern** - For event-driven notification system
5. **Command Pattern** - For encapsulating notification actions
6. **Builder Pattern** - For constructing complex notifications (optional)

## 🚀 Getting Started

1. Run the problematic code first:
   ```bash
   dart examples/random/notification_system_problem.dart
   ```

2. Analyze the issues and plan your refactoring approach

3. Start refactoring by identifying:
   - What varies and should be encapsulated?
   - What responsibilities should be separated?
   - What abstractions are needed?

4. Implement your solution step by step

5. Test your solution and compare with the provided solution

## 🧠 Thinking Process

### Step 1: Identify the Variations
- **Notification Types**: Order confirmation, shipping, payment failed, etc.
- **Delivery Channels**: Email, SMS, push notifications, etc.
- **Message Formats**: Plain text, HTML, rich content, etc.

### Step 2: Apply SOLID Principles
- **Single Responsibility**: Each class should have one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subtypes should be substitutable for their base types
- **Interface Segregation**: Many specific interfaces are better than one general-purpose interface
- **Dependency Inversion**: Depend on abstractions, not concretions

### Step 3: Choose Design Patterns
Think about which patterns solve which problems:
- How to handle different delivery mechanisms? → **Strategy Pattern**
- How to ensure consistent message structure? → **Template Method Pattern**
- How to create appropriate message templates? → **Factory Pattern**
- How to decouple event generation from handling? → **Observer Pattern**
- How to encapsulate notification actions? → **Command Pattern**

## 🏆 Success Criteria

Your refactored solution should:

1. **Extensibility**: Adding a new notification type should require:
   - Creating a new template class
   - Registering it in the factory
   - Publishing the appropriate event

2. **Channel Independence**: Adding a new delivery channel should require:
   - Implementing the channel interface
   - Adding it to the service configuration

3. **Testability**: Each component should be testable in isolation

4. **Maintainability**: Code should be easy to understand and modify

5. **Reusability**: Components should be reusable across different contexts

## 💡 Pro Tips

- Start small - refactor one aspect at a time
- Think about the dependencies between components
- Consider what needs to be configurable vs. hardcoded
- Don't over-engineer - use patterns that solve real problems
- Write tests to verify your refactoring doesn't break functionality

## 🔍 Bonus Challenges

Once you've completed the basic refactoring, try these advanced challenges:

1. **Add retry mechanisms** for failed notifications
2. **Implement notification preferences** (customer chooses channels)
3. **Add notification scheduling** (send at specific times)
4. **Implement notification batching** (group multiple notifications)
5. **Add notification analytics** (track delivery success rates)
6. **Support notification templates with variables** (more dynamic content)

Good luck! Remember, the goal is not just to make it work, but to make it clean, maintainable, and extensible. Think like a software architect! 🏗️
