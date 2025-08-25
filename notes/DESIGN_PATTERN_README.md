# Desing Patterns


## Strategy Pattern

*The Strategy Pattern*
    defines a family of algorithms, encapsulates each one,
    and makes them interchangeable.
    Strategy lets the algorithm vary independently from clients that use it.


**Quick Hints**
- *Encapsulate what varies!*
    Put changing algorithms is their own classes.
- *Swap the strategy, change the behavior!*
    Change algorithms at runtime by swapping strategy objets.
- *No more giant if/else or switch!*
    Replace conditional logic with polymorphism.
- *Program to an nterface, not an implementation*
    Use a common interface for all strategies.
- *Favors composition over inheritance!*
    The context HAS-A stragety the need!
- *Clients pick the strategy they need!*
    The context delegates work to the strategy bject.

**Mnemonic**
*I'll use whatever plan(strategy) you give me!*

**Analogy**
*Like a duck that can change how it flies or quacks by swapping out its flying or quacking behvior object.*

- Identify the aspects of your application that vary and seperate them from what staty the same.
- Take what varies and *'encapsulate'* it so it won't affect the rest of your code.
- Separating what changes frm what statys the same.
- Program to an interface, not an implementation.
- Favors composition over inheritance
    - Strategy used composition to change behaviour at runtime,
    rather that inheritance which is static.


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
- *Make, don't take!*
    Don't instantiate object directly- let a factory do it.
- *Encapsulate object creation*
    Hide the new keywords is on place.
- *Let subclasses decide*
    Subclasses of factories choose which class to instantiate.
- *Program to an interface, not an implementation*
    Use interfaces or abstract classes for return types.
- *Factories = Decoupling*
    Client code doesn't need to know concreate classes.
- *If you see lots of new scattered, think Factory!*

**Mnemonic**
*Don't call us, we'll call you (with the right object)!*

**Analogy**
- Like ordering from a pizza store: you ask for a pizza, the store decides how to make it and hands you the finished product.

----------------------------------------------------------------------------------