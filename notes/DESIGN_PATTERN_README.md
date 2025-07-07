# Desing Patterns

## Strategy Pattern

*The Strategy Pattern* defines a family of algorithms, encapsulates each one, and makes them interchangeable. Strategy lets the algorithm vary independently from clients that use it.

1. Identify the aspects of your application that vary and seperate them from what staty the same.
2. Take what varies and *'encapsulate'* it so it won't affect the rest of your code.
3. Separating what changes frm what statys the same.
4. Program to an interface, not an implementation.

**HAS-A can be better than IS-A**
* When you put classe like HAS-A, this is composition. It gives you more flexiblity and can be changed behavior at runtime.
** Favor composition over inheritance.
