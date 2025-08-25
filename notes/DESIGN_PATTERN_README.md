# Desing Patterns


## Strategy Pattern

*The Strategy Pattern*
    defines a family of algorithms, encapsulates each one,
    and makes them interchangeable. Strategy lets the algorithm vary independently from clients that use it.

1. Identify the aspects of your application that vary and seperate them from what staty the same.
2. Take what varies and *'encapsulate'* it so it won't affect the rest of your code.
3. Separating what changes frm what statys the same.
4. Program to an interface, not an implementation.

**HAS-A can be better than IS-A**
* When you put classe like HAS-A, this is composition. It gives you more flexiblity and can be changed behavior at runtime.
** Favor composition over inheritance.


------------------------------------------------------------------------------
## Factory Pattern

**Types**
- Factory Method: Subclasses decide what to create.
- Abstract Factory: Create families of related objects.

*The Factory Pattern*
    defines an interface for creating an object, but lets subclasses decide
    which class to instantiate.
    Factory Method lets a class defer instantiation to sbclasses.

**Quick Hints**
* *Make, don't take!*
    Don't instantiate object directly- let a factory do it.
* *Encapsulate object creation*
    Hide the new keywords is on place.
* *Let subclasses decide*
    Subclasses of factories choose which class to instantiate.
* *Program to an interface, not an implementation*
    Use interfaces or abstract classes for return types.
* *Factories = Decoupling*
    Client code doesn't need to know concreate classes.
* *If you see lots of new scattered, think Factory!*

**Mnemonic**
*Don't call us, we'll call you (with the right object)!*

**Analogy**
- Like ordering from a pizza store: you ask for a pizza, the store decides how to make it and hands you the finished product.

----------------------------------------------------------------------------------