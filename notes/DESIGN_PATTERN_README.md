# Desing Patterns


## (1) Strategy Pattern

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


## (2) Factory Method

**Types**
- Factory Method: Subclasses decide what to create.
- Abstract Factory: Create families of related objects.

*The Factory Method Pattern*
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
- *Like ordering from a pizza store: you ask for a pizza, the store decides how to make it and hands you the finished product.
----------------------------------------------------------------------------------


## (3) Singleton

*The Singleton Pattern*
    ensures a class has only one instance, and provides a global point of accesst to it.

**Quick Hints**
- *One and only one!*
    Guarantees a signle instance for the lifetime of your app.
- *Private constructor!*
    Prevents others from creating new instances.
- *Static instance!*
    Holds the single instance in a static variable.
- *Global access!*
    Holds the single instace in a static variable.
- *Lazy or eager?*
    Create the instance when needed(lazy) or at startup(eager).
- *Thread safety matters!*
    Be carefull in muli-threaded environments.

**Mnemonic**
*There can be only one!*

**Analogy**
*Like the captain of a ship: there's only one captain and everyone knows how to reach them.*
-----------------------------------------------------------------------------------


## (4) State

*The State Pattern*
    allow an object to alter its behaviour when its internal
    state changes. The object will appear to change its class.

**Quick Hints**
- *Encapsulate state-specific behaviour!*
    Put state-dependent code in seperate state classes.
- *Context delegated to state!*
    The context object delegates behavior to the current state object.
- *Change the state, change the behavior!*
    Swap the state object to change how to context behaves.
- *No more giant if/else or switch!*
    Replace conditional logic with polymorphism.
- *State transitions are explicit!*
    State objects can change the context's state

**Mnemonic**
*I change my mind(behavior) when my state changes!*

**Analogy**
*Like a vending machine: its behavior changes depending on weather you've inserted money, selected a product, or it's out of stock*
-----------------------------------------------------------------------------------


## (5) Observer

*The Observer Pattern*
    defines a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically.

**Quick Hints**
- *One-to-many relationship!*
    When one object changes, all dependents are notified.
- *Loose coupling!*
    Observers and subjects are loosely coupled.
- *Push or pull updates!*
    The subject can push updates to observers or let them pull the data.
- *Dynamic subscription!*
    Observers can subscribe or unsubscribe at runtime.
- *Encapsulate the core!*
    The subject encapsulates the core logic, while observers handle dependent behavior.

**Mnemonic**
*"I’ll let you know when I change!"*

**Analogy**
*Like a news agency: when news is published (subject), all subscribers (observers) are notified and receive the update.*
-----------------------------------------------------------------------------------


## (6) Decorator

*The Decorator Pattern*
    attaches additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing for extending functionality.

**Quick Hints**
- *Wrap to extend!*  
    Add new behavior by wrapping objects with decorators.
- *Flexible combinations!*  
    Stack multiple decorators for different combinations of features.
- *Favors composition over inheritance!*  
    Use composition to add functionality, not inheritance.
- *Same interface!*  
    Decorators and components share the same interface.
- *Transparent to client!*  
    Client code can use decorated and undecorated objects interchangeably.

**Mnemonic**
*"I’ll dress you up with new features!"*

**Analogy**
*Like adding toppings to a pizza: each topping (decorator) adds new flavor (behavior) to the base pizza (component).*
-----------------------------------------------------------------------------------


## (7) Builder

*The Builder Pattern*
    separates the construction of a complex object from its representation, allowing the same construction process to create different representations.

**Quick Hints**
- *Step-by-step construction!*  
    Build objects piece by piece.
- *Different representations!*  
    Same process, different results.
- *Director controls the process!*  
    The director tells the builder what to do.
- *Encapsulate construction logic!*  
    Builder hides the details of how parts are assembled.

**Mnemonic**
*"I’ll build it your way!"*

**Analogy**
*Like ordering a custom sandwich: you choose the ingredients, the builder assembles it step by step.*
-----------------------------------------------------------------------------------


## (8) Memento

*The Memento Pattern*
    captures and externalizes an object’s internal state without violating encapsulation, so the object can be restored to this state later.

**Quick Hints**
- *Save and restore state!*  
    Take snapshots of an object’s state.
- *Encapsulation preserved!*  
    State is stored without exposing internals.
- *Caretaker manages mementos!*  
    Caretaker keeps track of saved states.
- *Undo/redo functionality!*  
    Useful for undo operations.

**Mnemonic**
*"I’ll remember so you can go back!"*

**Analogy**
*Like a save point in a video game: you can restore to a previous state if needed.*
-----------------------------------------------------------------------------------


## (9) Visitor

*The Visitor Pattern*
    lets you define a new operation without changing the classes of the elements on which it operates.

**Quick Hints**
- *Separate algorithm from object structure!*  
    Visitor adds new operations to existing objects.
- *Double dispatch!*  
    Visitor and element cooperate to select the right method.
- *Easy to add new operations!*  
    Add new functionality without modifying element classes.
- *Harder to add new element types!*  
    Must update visitor for new elements.

**Mnemonic**
*"I’ll visit and do something new!"*

**Analogy**
*Like a tax auditor visiting different businesses: each business lets the auditor perform a specific operation.*
-----------------------------------------------------------------------------------

## (10) Composite


*The Composite Pattern*
    lets you compose objects into tree structures to represent part-whole hierarchies. Composite lets clients treat individual objects and compositions uniformly.

**Quick Hints**
- *Tree structure!*  
    Organize objects in a hierarchy.
- *Uniform treatment!*  
    Treat leaves and composites the same way.
- *Recursive operations!*  
    Operations apply to both individual and composite objects.
- *Simplifies client code!*  
    Client doesn’t need to distinguish between single and grouped objects.

**Mnemonic**
*"I’m made of parts, but you can treat me as one!"*

**Analogy**
*Like a folder system: folders can contain files or other folders, and you can perform actions on both.*
-----------------------------------------------------------------------------------

## (11) Iterator


*The Iterator Pattern*
    provides a way to access the elements of an aggregate object sequentially without exposing its underlying representation.

**Quick Hints**
- *Traverse collections!*  
    Access elements one at a time.
- *No need to know structure!*  
    Client doesn’t care how the collection is built.
- *Multiple traversals!*  
    Can have multiple iterators for the same collection.

**Mnemonic**
*"I’ll show you one item at a time!"*

**Analogy**
*Like flipping through a playlist: you see each song in order.*
-----------------------------------------------------------------------------------


## (12) Proxy

*The Proxy Pattern*
    provides a surrogate or placeholder for another object to control access to it.

**Quick Hints**
- *Control access!*  
    Proxy stands in for the real object.
- *Add extra logic!*  
    Proxies can add security, caching, or logging.
- *Same interface!*  
    Proxy and real subject share the same interface.

**Mnemonic**
*"Talk to my representative!"*

**Analogy**
*Like a receptionist: you interact with them instead of directly with the boss.*
-----------------------------------------------------------------------------------


## (13) Facade

*The Facade Pattern*
    provides a unified interface to a set of interfaces in a subsystem, making it easier to use.

**Quick Hints**
- *Simplify complexity!*  
    Facade hides the subsystem’s complexity.
- *One-stop shop!*  
    Offers a simple interface for complex operations.
- *Decouples client from subsystem!*  
    Client interacts only with the facade.

**Mnemonic**
*"I’ll make it easy for you!"*

**Analogy**
*Like a universal remote: one remote controls many devices.*
-----------------------------------------------------------------------------------


## (14) Command

*The Command Pattern*
    encapsulates a request as an object, thereby letting you parameterize clients with queues, requests, and operations.

**Quick Hints**
- *Encapsulate requests!*  
    Turn actions into objects.
- *Undo/redo support!*  
    Store commands for undo/redo.
- *Queue and log requests!*  
    Commands can be queued or logged.
- *Decouples sender from receiver!*  
    The invoker doesn’t know the receiver’s details.

**Mnemonic**
*"I’ll take your order and deliver it later!"*

**Analogy**
*Like a remote control: each button is a command object.*
-----------------------------------------------------------------------------------


## (15) Template Method

*The Template Method Pattern*
    defines the skeleton of an algorithm in a method, deferring some steps to subclasses. Template Method lets subclasses redefine certain steps of an algorithm without changing its structure.

**Quick Hints**
- *Define the steps!*  
    The base class outlines the algorithm’s steps.
- *Let subclasses fill in the details!*  
    Subclasses override specific steps.
- *No code duplication!*  
    Common code stays in the base class.
- *Control the algorithm!*  
    The template method controls the sequence.

**Mnemonic**
*"I’ll set the recipe, you add the ingredients!"*

**Analogy**
*Like a coffee machine: the process is fixed, but you can choose the type of coffee.*
-----------------------------------------------------------------------------------


## (16) Compound

*The Compound Pattern*
    combines two or more patterns to solve a recurring or complex design problem. Often used in frameworks and libraries to leverage the strengths of multiple patterns together.

**Quick Hints**
- *Mix and match!*  
    Use several patterns together for robust solutions.
- *Frameworks love it!*  
    Common in UI toolkits and libraries.
- *Synergy of patterns!*  
    Patterns work together to solve bigger problems.

**Mnemonic**
*"Stronger together!"*

**Analogy**
*Like a Swiss Army knife: multiple tools in one package.*
-----------------------------------------------------------------------------------

## (17) Visitor

*The Visitor Pattern*
    lets you define a new operation without changing the classes of the elements on which it operates.

**Quick Hints**
- *Separate algorithm from object structure!*  
    Visitor adds new operations to existing objects.
- *Double dispatch!*  
    Visitor and element cooperate to select the right method.
- *Easy to add new operations!*  
    Add new functionality without modifying element classes.
- *Harder to add new element types!*  
    Must update visitor for new elements.

**Mnemonic**
*"I’ll visit and do something new!"*

**Analogy**
*Like a tax auditor visiting different businesses: each business lets the auditor perform a specific operation.*
-----------------------------------------------------------------------------------


## (18) Null Object

*The Null Object Pattern*
    provides an object as a surrogate for the lack of an object of a given type. The null object implements the expected interface but does nothing.

**Quick Hints**
- *Avoid null checks!*  
    Use a do-nothing object instead of null.
- *Same interface!*  
    Null object implements the same interface as real objects.
- *Safe defaults!*  
    Prevents null pointer exceptions.

**Mnemonic**
*"I’m here, but I do nothing!"*

**Analogy**
*Like a silent partner: present, but never participates.*
-----------------------------------------------------------------------------------


## (19) Chain of Responsibility

*The Chain of Responsibility Pattern*
    lets you pass requests along a chain of handlers. Each handler decides either to process the request or to pass it to the next handler in the chain.

**Quick Hints**
- *Decouple sender and receiver!*  
    Sender doesn’t know which handler will process the request.
- *Flexible chains!*  
    Handlers can be added, removed, or reordered.
- *Each handler gets a chance!*  
    Each handler can process or pass the request.

**Mnemonic**
*"Pass it along until someone handles it!"*

**Analogy**
*Like customer service escalation: your request moves up the chain until someone resolves it.*
-----------------------------------------------------------------------------------


## (20) Prototype


*The Prototype Pattern*
    specifies the kinds of objects to create using a prototypical instance, and creates new objects by copying this prototype.

**Quick Hints**
- *Clone, don’t build!*  
    Create new objects by copying (cloning) an existing object.
- *Avoids subclassing for new objects!*  
    No need to write code to create each new object from scratch.
- *Add or remove objects at runtime!*  
    New prototypes can be registered and cloned as needed.
- *Reduces the need for subclasses!*  
    Use prototypes instead of subclassing for slight variations.
- *Deep vs. shallow copy!*  
    Decide if you need a deep or shallow clone.

**Mnemonic**
*"Copy me!"*

**Analogy**
*Like making a key copy: you use an existing key (the prototype) to create a new one, rather than forging a new key from scratch.*
-----------------------------------------------------------------------------------


## (21) Bridge

*The Bridge Pattern*
    decouples an abstraction from its implementation so that the two can vary independently.

**Quick Hints**
- *Separate abstraction from implementation!*  
    Both can change without affecting each other.
- *Use composition, not inheritance!*  
    Abstraction holds a reference to the implementor.
- *Extend independently!*  
    Add new abstractions and implementations freely.

**Mnemonic**
*"I’ll connect you without tying you down!"*

**Analogy**
*Like a TV remote: the remote (abstraction) works with different brands of TVs (implementations) without changing the remote.*
-----------------------------------------------------------------------------------


## (22) Flyweight

*The Flyweight Pattern*
    uses sharing to support large numbers of fine-grained objects efficiently.

**Quick Hints**
- *Share common state!*  
    Store shared data externally to reduce memory usage.
- *Separate intrinsic and extrinsic state!*  
    Intrinsic is shared, extrinsic is unique per object.
- *Great for lots of similar objects!*  
    Useful in graphics, text editors, etc.

**Mnemonic**
*"I’m small and shared!"*

**Analogy**
*Like chess pieces: many pieces share the same type, only position is unique.*
-----------------------------------------------------------------------------------


## (23) Interpreter

*The Interpreter Pattern*
    defines a representation for a language’s grammar along with an interpreter that uses the representation to interpret sentences in the language.

**Quick Hints**
- *Grammar and interpretation!*  
    Represent grammar rules as classes.
- *Parse and evaluate!*  
    Interpreter parses and evaluates sentences.
- *Easy to extend!*  
    Add new grammar rules by adding new classes.

**Mnemonic**
*"I’ll translate your language!"*

**Analogy**
*Like a calculator: interprets and evaluates mathematical expressions.*
-----------------------------------------------------------------------------------


## (24) Mediator

*The Mediator Pattern*
    defines an object that encapsulates how a set of objects interact, promoting loose coupling by keeping objects from referring to each other explicitly.

**Quick Hints**
- *Centralize communication!*  
    Mediator handles interactions between objects.
- *Loose coupling!*  
    Objects communicate through the mediator, not directly.
- *Simplifies object relationships!*  
    Reduces dependencies between objects.

**Mnemonic**
*"I’ll coordinate everyone’s conversation!"*

**Analogy**
*Like an air traffic controller: coordinates planes so they don’t talk to each other directly.*
-----------------------------------------------------------------------------------


## (25) Adapter

*The Adapter Pattern*
    allows objects with incompatible interfaces to work together. Adapter wraps an existing class with a new interface.

**Quick Hints**
- *Convert the interface!*  
    Adapter makes one interface look like another.
- *Wrap and delegate!*  
    Adapter wraps the adaptee and delegates calls.
- *Client sees only the target interface!*  
    The client uses the adapter, not the adaptee directly.
- *Two main types:*  
    Object Adapter (uses composition), Class Adapter (uses inheritance).
- *Use when you can’t change the existing code!*  
    Adapter lets you reuse code without modifying it.

**Mnemonic**
*"I’ll translate for you!"*

**Analogy**
*Like a power plug adapter: lets your device (client) use a foreign socket (adaptee) by converting the interface.*



Singleton: Ensures a single instance of a class.
Factory: Provides an interface for object creation, letting subclasses decide the class to instantiate.
Builder: Separates complex object construction from its representation.
Abstract Factory: Creates families of related objects. 

Facade: Simplifies a complex system interface.
Decorator: Adds behaviors dynamically by wrapping an object.
Adapter: Allows incompatible interfaces to work together.
Proxy: Provides a substitute for another object to control access. 

Observer: Defines a one-to-many dependency for state change notifications.
Strategy: Defines interchangeable algorithms.
Command: Encapsulates a request as an object.
Iterator: Provides sequential traversal of collection elements.
State: Allows behavior change based on internal state. 
