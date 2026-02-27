# Software Engineering Body of Knowledge

A comprehensive reference of named disciplines, patterns, principles, and techniques used in professional software development.

---

## Table of Contents

1. [Code Smells](#1-code-smells)
2. [Refactoring Techniques](#2-refactoring-techniques)
3. [Design Patterns (Gang of Four)](#3-design-patterns-gang-of-four)
4. [SOLID Principles](#4-solid-principles)
5. [GRASP Principles](#5-grasp-principles)
6. [Clean Code](#6-clean-code)
7. [Clean Architecture](#7-clean-architecture)
8. [Domain-Driven Design (DDD)](#8-domain-driven-design-ddd)
9. [Enterprise Application Patterns (PoEAA)](#9-enterprise-application-patterns-poeaa)
10. [Enterprise Integration Patterns (EIP)](#10-enterprise-integration-patterns-eip)
11. [Concurrency Patterns](#11-concurrency-patterns)
12. [Distributed Systems Patterns](#12-distributed-systems-patterns)
13. [Stability & Resilience Patterns](#13-stability--resilience-patterns)
14. [Microservices Patterns](#14-microservices-patterns)
15. [Test-Driven Development (TDD)](#15-test-driven-development-tdd)
16. [Test Doubles & Mocking](#16-test-doubles--mocking)
17. [Legacy Code Techniques](#17-legacy-code-techniques)
18. [Object-Oriented Analysis and Design (OOAD)](#18-object-oriented-analysis-and-design-ooad)
19. [UML (Unified Modeling Language)](#19-uml-unified-modeling-language)
20. [Pragmatic Practices](#20-pragmatic-practices)
21. [Simple Design (Kent Beck's Four Rules)](#21-simple-design-kent-becks-four-rules)
22. [Continuous Delivery / DevOps](#22-continuous-delivery--devops)
23. [Anti-Patterns](#23-anti-patterns)
24. [Design by Contract (DbC)](#24-design-by-contract-dbc)
25. [Functional Programming Patterns](#25-functional-programming-patterns)
26. [Data Structures & Algorithms](#26-data-structures--algorithms)
27. [System Design](#27-system-design)
28. [API Design](#28-api-design)
29. [Database Design & Normalization](#29-database-design--normalization)
30. [The Twelve-Factor App](#30-the-twelve-factor-app)
31. [Cloud Design Patterns](#31-cloud-design-patterns)
32. [Reactive Programming](#32-reactive-programming)
33. [Site Reliability Engineering (SRE)](#33-site-reliability-engineering-sre)
34. [Behavior-Driven Development (BDD)](#34-behavior-driven-development-bdd)
35. [Event Storming](#35-event-storming)
36. [Specification by Example](#36-specification-by-example)
37. [Software Craftsmanship](#37-software-craftsmanship)
38. [Security Patterns & Practices (OWASP)](#38-security-patterns--practices-owasp)
39. [Performance Engineering](#39-performance-engineering)
40. [Agile Methodologies](#40-agile-methodologies)
41. [Modeling & Diagramming Beyond UML](#41-modeling--diagramming-beyond-uml)

---

## How They All Connect

```
                    Problem Understanding
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
           OOAD          DDD         UML
        (analyze)    (model the    (visualize)
                      domain)
              │            │            │
              └────────────┼────────────┘
                           ▼
                   Design Decisions
                           │
         ┌─────────┬───────┼───────┬──────────┐
         ▼         ▼       ▼       ▼          ▼
      SOLID     GRASP    Clean   Design    Functional
   (principles)(assign  Code   Patterns   Patterns
               roles)  (write)  (solve)   (compose)
         │         │       │       │          │
         └─────────┴───────┼───────┴──────────┘
                           ▼
                  Architecture Choices
                           │
       ┌──────────┬────────┼────────┬──────────┐
       ▼          ▼        ▼        ▼          ▼
    Clean     PoEAA     EIP    Microservice  Stability
    Arch    (enterprise)(msg)  Patterns     Patterns
              │        │        │
              └────────┼────────┘
                       ▼
                  Maintenance
                       │
         ┌─────────────┼─────────────┐
         ▼             ▼             ▼
    Refactoring    Legacy Code    Anti-Patterns
    Techniques     Techniques     (recognize
    (improve)      (rescue)        & avoid)
         │             │             │
         └─────────────┼─────────────┘
                       ▼
                  Verification
                       │
              ┌────────┼────────┐
              ▼        ▼        ▼
            TDD    Test       Simple
                  Doubles    Design
                       │
                       ▼
                   Delivery
                       │
                  CI/CD & DevOps
```

### By Software Lifecycle Phase

| Phase | Disciplines |
|---|---|
| **Understand the problem** | OOAD, DDD, Event Storming, Specification by Example, UML, C4 Model |
| **Design the solution** | SOLID, GRASP, Design Patterns, Clean Architecture, PoEAA, API Design, Database Design |
| **Write the code** | Clean Code, Refactoring, Functional Patterns, Pragmatic Practices, Simple Design |
| **Verify correctness** | TDD, BDD, Test Doubles, Performance Engineering |
| **Recognize problems** | Code Smells, Anti-Patterns |
| **Rescue existing code** | Refactoring Techniques, Legacy Code Techniques |
| **Build for scale** | System Design, Cloud Patterns, Microservices Patterns, Reactive Programming, 12-Factor App |
| **Run in production** | SRE, Stability Patterns, Security Patterns, CI/CD & DevOps |
| **Work as a team** | Agile (Scrum/Kanban/XP), Software Craftsmanship, Mob Programming |
| **Analyze complexity** | Data Structures & Algorithms |

---

## 1. Code Smells

> Named catalog of symptoms that indicate deeper structural problems in code.
>
> **Canonical source:** Martin Fowler — *Refactoring* (Chapter 3)

| Name | Description |
|---|---|
| **Long Method** | A method that has grown too many lines, doing too much — hard to read, test, and reuse. |
| **Large Class (God Class)** | A single class that knows too much or does too much, violating Single Responsibility. |
| **Feature Envy** | A method that uses data from another class more than its own — it belongs in the other class. |
| **Data Clumps** | Groups of variables that always travel together (e.g., `x`, `y`, `z`) but aren't wrapped in their own object. |
| **Primitive Obsession** | Using raw primitives (`String`, `int`) instead of small domain objects (e.g., `Email`, `Money`, `PhoneNumber`). |
| **Shotgun Surgery** | A single change requires editing many different classes scattered across the codebase. |
| **Divergent Change** | One class is modified for many different reasons — it has multiple axes of change and should be split. |
| **Parallel Inheritance Hierarchies** | Every time you add a subclass in one hierarchy, you must add a matching one in another. |
| **Speculative Generality** | Code written for "future needs" that don't exist yet — abstract classes, hooks, or parameters nobody uses. |
| **Middle Man** | A class that delegates almost everything to another class and does nothing itself. |
| **Inappropriate Intimacy** | Two classes that know too much about each other's internals, breaking encapsulation. |
| **Message Chains** | Long chains like `a.getB().getC().getD()` — caller knows the entire object graph structure. |
| **Refused Bequest** | A subclass inherits methods or data it doesn't need or want from its parent. |
| **Comments (Deodorant)** | Excessive comments that exist to explain unclear code — the code itself should be clear. |
| **Dead Code** | Code that is never executed — unreachable branches, unused variables, or abandoned methods. |
| **Lazy Class** | A class that doesn't do enough to justify its existence — merge it into another. |
| **Temporary Field** | A field that is only set and used in certain circumstances, making the object confusing. |
| **Switch Statements** | Repeated `switch`/`if-else` on the same type field — usually should be polymorphism instead. |
| **Data Class** | A class with only fields and getters/setters but no behavior — move behavior into it. |
| **Duplicated Code** | The same or nearly identical code structure appears in multiple places. |

---

## 2. Refactoring Techniques

> Named catalog of safe, behavior-preserving code transformations.
>
> **Canonical source:** Martin Fowler — *Refactoring: Improving the Design of Existing Code* (2nd ed. 2018)
> **Extended:** Joshua Kerievsky — *Refactoring to Patterns*

### Composing Methods

| Name | Description |
|---|---|
| **Extract Method** | Pull a block of code out of a long method into its own named method. |
| **Inline Method** | A method body is just as clear as the method name — collapse it back into the caller. |
| **Extract Variable** | Give a name to a complex expression by assigning it to a local variable. |
| **Inline Variable** | A variable just holds an obvious expression — remove it and use the expression directly. |
| **Replace Temp with Query** | Turn a local variable assignment into a method call, so other methods can reuse it. |

### Moving Features

| Name | Description |
|---|---|
| **Move Method** | A method uses another class's data more than its own — move it to where the data lives. |
| **Move Field** | A field is accessed more by another class — move it there. |
| **Extract Class** | A class is doing two distinct jobs — split it into two focused classes. |
| **Inline Class** | A class is too small to justify its existence — fold it into its user. |
| **Hide Delegate** | Stop exposing a chain of objects — provide a direct method instead. |
| **Remove Middle Man** | A class just delegates everything — let callers talk directly to the delegate. |

### Organizing Data

| Name | Description |
|---|---|
| **Encapsulate Field** | Make a public field private and add getter/setter methods to control access. |
| **Replace Primitive with Object** | Wrap a raw `String` or `int` in a meaningful domain class (e.g., `Money`, `Email`). |
| **Introduce Parameter Object** | Several parameters always travel together — bundle them into a single object. |
| **Preserve Whole Object** | Pass the whole object instead of extracting several values from it. |
| **Replace Magic Number with Constant** | Give a named constant to a literal value so its meaning is clear. |

### Simplifying Conditionals

| Name | Description |
|---|---|
| **Decompose Conditional** | Extract the condition and each branch into named methods that explain the intent. |
| **Consolidate Conditional Expression** | Multiple conditions return the same result — combine them into one and extract. |
| **Replace Nested Conditional with Guard Clauses** | Use early returns for edge cases instead of deeply nested `if-else`. |
| **Replace Conditional with Polymorphism** | Replace `switch`/`if` on a type with subclasses that override behavior. |
| **Introduce Null Object** | Replace `null` checks with a special object that provides safe default behavior. |
| **Introduce Special Case** | Generalization of Null Object for any value that requires special handling. |

### Dealing with Generalization

| Name | Description |
|---|---|
| **Extract Superclass** | Two classes share common code — pull the shared parts into a new parent class. |
| **Extract Interface** | Pull a set of method signatures into an interface so others can depend on the abstraction. |
| **Pull Up Method** | A method is identical in all subclasses — move it to the parent. |
| **Push Down Method** | A method in the parent is only used by one subclass — move it down. |
| **Collapse Hierarchy** | A superclass and subclass are nearly identical — merge them into one. |
| **Replace Inheritance with Delegation** | A subclass only uses part of its parent — hold an instance instead of extending. |

### Refactoring to Patterns (Kerievsky)

| Name | Description |
|---|---|
| **Replace Constructor with Factory Method** | Complex creation logic hides behind a descriptive factory method name. |
| **Replace Conditional Logic with Strategy** | Different algorithms are selected by `if/switch` — extract each into a Strategy object. |
| **Replace State-Altering Conditionals with State** | An object behaves differently based on internal state — use the State pattern. |
| **Replace Implicit Tree with Composite** | Nested structures are manually managed — formalize them with the Composite pattern. |
| **Unify Interfaces with Adapter** | Two classes do similar things with different interfaces — wrap one with an Adapter. |

---

## 3. Design Patterns (Gang of Four)

> Named catalog of 23 reusable solutions to recurring OO design problems.
>
> **Canonical source:** Gamma, Helm, Johnson, Vlissides — *Design Patterns: Elements of Reusable Object-Oriented Software* (1994)
> **Accessible version:** *Head First Design Patterns*

### Creational

| Name | Description |
|---|---|
| **Singleton** | Ensures only one instance of a class exists and provides global access to it. |
| **Factory Method** | Defines an interface for creating objects, but lets subclasses decide which class to instantiate. |
| **Abstract Factory** | Creates families of related objects without specifying their concrete classes. |
| **Builder** | Constructs a complex object step by step, separating construction from representation. |
| **Prototype** | Creates new objects by cloning an existing instance rather than calling a constructor. |

### Structural

| Name | Description |
|---|---|
| **Adapter** | Converts one class's interface into another interface that clients expect — makes incompatible classes work together. |
| **Bridge** | Separates an abstraction from its implementation so they can vary independently. |
| **Composite** | Composes objects into tree structures and lets clients treat individual objects and compositions uniformly. |
| **Decorator** | Wraps an object to add new behavior dynamically without changing its interface. |
| **Facade** | Provides a simplified interface to a complex subsystem of classes. |
| **Flyweight** | Shares common state between many objects to save memory when you have thousands of similar instances. |
| **Proxy** | Provides a surrogate or placeholder that controls access to another object (lazy loading, caching, access control). |

### Behavioral

| Name | Description |
|---|---|
| **Chain of Responsibility** | Passes a request along a chain of handlers — each handler can process it or pass it on. |
| **Command** | Encapsulates a request as an object, enabling undo, queuing, and logging of operations. |
| **Iterator** | Provides a way to traverse a collection's elements without exposing its internal structure. |
| **Mediator** | Centralizes complex communication between objects so they don't reference each other directly. |
| **Memento** | Captures an object's internal state so it can be restored later without violating encapsulation (undo). |
| **Observer** | When one object changes state, all its dependents are notified and updated automatically. |
| **State** | An object changes its behavior when its internal state changes — appears to change its class. |
| **Strategy** | Defines a family of algorithms, encapsulates each one, and makes them interchangeable at runtime. |
| **Template Method** | Defines the skeleton of an algorithm in a base class, letting subclasses override specific steps. |
| **Visitor** | Lets you add new operations to existing class hierarchies without modifying those classes. |
| **Interpreter** | Defines a grammar for a language and an interpreter that processes sentences in that grammar. |

---

## 4. SOLID Principles

> Five principles for maintainable object-oriented design.
>
> **Canonical source:** Robert C. Martin — *Agile Software Development: Principles, Patterns, and Practices* (2002)

| Name | Description |
|---|---|
| **Single Responsibility (SRP)** | A class should have only one reason to change — one job, one owner, one axis of change. |
| **Open/Closed (OCP)** | Classes should be open for extension but closed for modification — add behavior without editing existing code. |
| **Liskov Substitution (LSP)** | A subclass must be usable anywhere its parent is used without breaking correctness. |
| **Interface Segregation (ISP)** | Don't force clients to depend on methods they don't use — split large interfaces into smaller ones. |
| **Dependency Inversion (DIP)** | High-level modules should depend on abstractions, not concrete implementations. |

---

## 5. GRASP Principles

> Nine principles for assigning responsibilities to classes.
>
> **Canonical source:** Craig Larman — *Applying UML and Patterns* (3rd ed. 2004)

| Name | Description |
|---|---|
| **Information Expert** | Assign responsibility to the class that has the data needed to fulfill it. |
| **Creator** | Assign object creation to the class that aggregates, contains, or closely uses the created object. |
| **Controller** | Assign system event handling to a non-UI class that represents the overall system or a use case. |
| **Low Coupling** | Minimize dependencies between classes so changes in one don't ripple through others. |
| **High Cohesion** | Keep related responsibilities together in one class — a focused class is easier to understand and maintain. |
| **Polymorphism** | Use polymorphic method calls instead of conditionals that check object type. |
| **Pure Fabrication** | Invent a helper class that doesn't represent a domain concept to achieve low coupling or high cohesion. |
| **Indirection** | Introduce an intermediate object to decouple two components that shouldn't know about each other. |
| **Protected Variations** | Wrap the parts of your system most likely to change behind a stable interface. |

---

## 6. Clean Code

> Named rules and heuristics for writing readable, maintainable code.
>
> **Canonical source:** Robert C. Martin — *Clean Code: A Handbook of Agile Software Craftsmanship* (2008)

| Name | Description |
|---|---|
| **Meaningful Names** | Names should reveal intent — `elapsedTimeInDays` not `d`, `isEligible` not `flag`. |
| **Small Functions** | Functions should do one thing, do it well, and do it only — ideally under 20 lines. |
| **One Level of Abstraction** | Every line in a function should be at the same level of abstraction — don't mix high-level intent with low-level details. |
| **Command-Query Separation** | A method either does something (command) or returns something (query), never both. |
| **Don't Repeat Yourself (DRY)** | Every piece of knowledge should have a single, unambiguous, authoritative representation. |
| **Boy Scout Rule** | Always leave the code cleaner than you found it — make one small improvement each time. |
| **Newspaper Metaphor** | A source file should read like a newspaper — headline (class name) at top, details increase as you go down. |
| **Error Handling is One Thing** | A function that handles errors should do nothing else — separate happy path from error path. |
| **No Side Effects** | A function named `checkPassword` shouldn't also initialize a session — do what the name says, nothing more. |
| **Avoid Output Arguments** | Don't pass an object into a function just to have the function modify it — return a result instead. |

---

## 7. Clean Architecture

> Principles for structuring systems so business rules are independent of frameworks, databases, and UI.
>
> **Canonical source:** Robert C. Martin — *Clean Architecture* (2017)

| Name | Description |
|---|---|
| **Dependency Rule** | Source code dependencies must point inward only — inner layers never know about outer layers. |
| **Entities** | Enterprise-wide business rules and objects — the most stable, innermost layer. |
| **Use Cases** | Application-specific business rules — orchestrate data flow to and from entities. |
| **Interface Adapters** | Convert data between use case format and external format (controllers, presenters, gateways). |
| **Frameworks & Drivers** | The outermost layer — database, web framework, UI — all details that the core doesn't know about. |
| **Screaming Architecture** | Your project folder structure should scream the business domain, not the framework name. |
| **Humble Object** | Push testable logic out of hard-to-test boundaries (UI, DB) into simple objects that are easy to test. |

---

## 8. Domain-Driven Design (DDD)

> An approach to modeling complex software around the business domain.
>
> **Canonical source:** Eric Evans — *Domain-Driven Design: Tackling Complexity in the Heart of Software* (2003)
> **Accessible version:** Vaughn Vernon — *Domain-Driven Design Distilled* (2016)

### Tactical Patterns

| Name | Description |
|---|---|
| **Entity** | An object defined by its identity (ID), not its attributes — two users with the same name are still different. |
| **Value Object** | An object defined by its attributes, not identity — two `Money(10, "USD")` are equal and interchangeable. |
| **Aggregate** | A cluster of entities and value objects treated as a single unit for data changes, with one root entity. |
| **Aggregate Root** | The single entry point to an aggregate — all external access goes through it to enforce invariants. |
| **Repository** | An abstraction that provides collection-like access to aggregates, hiding persistence details. |
| **Factory** | Encapsulates complex object creation logic, especially when building an aggregate requires many steps. |
| **Domain Event** | Something meaningful that happened in the domain — "OrderPlaced", "PaymentReceived" — that other parts react to. |
| **Domain Service** | A stateless operation that doesn't naturally belong to any entity or value object. |
| **Specification** | Encapsulates a business rule as a reusable, composable boolean predicate object. |
| **Module** | A named grouping of related domain concepts — the packaging itself communicates design intent. |

### Strategic Patterns

| Name | Description |
|---|---|
| **Bounded Context** | An explicit boundary within which a particular domain model is defined and consistent. |
| **Ubiquitous Language** | A shared vocabulary between developers and domain experts — the same terms used in code and conversation. |
| **Context Map** | A visual overview of how different bounded contexts relate to and integrate with each other. |
| **Shared Kernel** | Two bounded contexts share a small, explicitly agreed-upon subset of the model. |
| **Anti-Corruption Layer** | A translation layer that protects your model from being polluted by an external system's model. |
| **Customer/Supplier** | One team (supplier) provides a service to another (customer) — the customer's needs drive the interface. |
| **Conformist** | A downstream team conforms entirely to the upstream model because they have no power to negotiate changes. |
| **Open Host Service** | A system exposes a well-defined protocol/API that any other system can consume. |
| **Published Language** | A well-documented shared language (e.g., JSON schema, XML standard) for inter-context communication. |

---

## 9. Enterprise Application Patterns (PoEAA)

> Named catalog of patterns for building enterprise/business applications.
>
> **Canonical source:** Martin Fowler — *Patterns of Enterprise Application Architecture* (2002)

### Domain Logic

| Name | Description |
|---|---|
| **Transaction Script** | Organizes business logic as a single procedure per operation — simple but doesn't scale with complexity. |
| **Domain Model** | An object-oriented model of the business domain with both data and behavior on the same objects. |
| **Table Module** | One class per database table handling all business logic for rows of that table. |
| **Service Layer** | A thin layer that defines the application's boundary and coordinates transactions and security. |

### Data Source

| Name | Description |
|---|---|
| **Data Mapper** | A layer of mappers that moves data between objects and the database while keeping them independent. |
| **Active Record** | An object wraps a database row, adds domain logic, and knows how to save/load itself. |
| **Table Gateway** | An object that acts as a gateway to a single database table — one instance handles all rows. |
| **Row Gateway** | An object that acts as a gateway to a single row — one instance per row, with save/load methods. |
| **Repository** | Mediates between domain and data mapping layers using a collection-like interface for accessing aggregates. |

### Object-Relational

| Name | Description |
|---|---|
| **Unit of Work** | Tracks all changes to objects during a business transaction and coordinates writing them out in one batch. |
| **Identity Map** | Ensures each object is loaded only once per transaction by keeping a map of already-loaded objects. |
| **Lazy Load** | An object doesn't load its related data until that data is actually accessed for the first time. |
| **Eager Load** | Load related objects upfront in one query to avoid the N+1 problem. |
| **Data Transfer Object (DTO)** | A simple object that carries data between processes/layers to reduce the number of method calls. |
| **Embedded Value** | Maps a value object into the columns of the parent's database table rather than a separate table. |

### Presentation

| Name | Description |
|---|---|
| **Model-View-Controller (MVC)** | Splits UI into Model (data), View (display), and Controller (input handling). |
| **Front Controller** | A single handler object that receives all requests and dispatches them to appropriate handlers. |
| **Page Controller** | Each page/screen has its own controller that handles the request for that specific page. |
| **Template View** | Generates HTML by embedding markers in a static HTML template that get replaced with dynamic data. |
| **Remote Facade** | Provides a coarse-grained interface over a network boundary to minimize round trips. |

---

## 10. Enterprise Integration Patterns (EIP)

> Named catalog of 65 patterns for messaging-based system integration.
>
> **Canonical source:** Gregor Hohpe & Bobby Woolf — *Enterprise Integration Patterns* (2003)

### Messaging

| Name | Description |
|---|---|
| **Message Channel** | A virtual pipe that connects a sender to a receiver — the fundamental building block of messaging. |
| **Message** | A discrete packet of data sent through a channel — has a header (metadata) and body (payload). |
| **Pipes and Filters** | Decomposes a processing task into a sequence of independent, composable filter steps connected by pipes. |
| **Message Router** | A component that decides which channel a message should be sent to based on conditions. |
| **Message Translator** | Converts a message from one format to another so different systems can communicate. |
| **Message Endpoint** | The code that connects an application to a messaging channel — the bridge between app and messaging system. |

### Routing

| Name | Description |
|---|---|
| **Content-Based Router** | Reads message content and routes it to the correct destination channel based on that content. |
| **Message Filter** | Drops messages that don't match certain criteria — only passes through what you want. |
| **Splitter** | Breaks a single composite message into multiple individual messages for separate processing. |
| **Aggregator** | Collects and combines multiple related messages back into a single message. |
| **Resequencer** | Puts out-of-order messages back into the correct sequence before processing. |
| **Scatter-Gather** | Broadcasts a request to multiple recipients, then aggregates their responses into one. |

### Transformation

| Name | Description |
|---|---|
| **Envelope Wrapper** | Wraps a message inside another message for system-level concerns (security, routing) without changing the payload. |
| **Content Enricher** | Adds missing data to a message by looking up additional information from an external source. |
| **Content Filter** | Removes unneeded fields from a message so only the relevant data continues downstream. |
| **Normalizer** | Routes different message formats through translators so they all emerge in a single canonical format. |

### Management

| Name | Description |
|---|---|
| **Dead Letter Channel** | A special channel where undeliverable or unprocessable messages are sent for investigation. |
| **Correlation Identifier** | A unique ID embedded in a request so the reply can be matched back to the original request. |
| **Publish-Subscribe** | A message is broadcast to all interested subscribers rather than sent to a single receiver. |
| **Competing Consumers** | Multiple consumers listen on the same channel — each message is processed by exactly one consumer for parallelism. |
| **Idempotent Receiver** | A receiver that can safely process the same message multiple times without duplicate side effects. |

---

## 11. Concurrency Patterns

> Named solutions for multi-threaded and parallel programming problems.
>
> **Canonical source:** Doug Lea — *Concurrent Programming in Java* (1999); Brian Goetz — *Java Concurrency in Practice* (2006)

| Name | Description |
|---|---|
| **Producer-Consumer** | One or more producers put items into a shared buffer; one or more consumers take them out — decouples production rate from consumption rate. |
| **Reader-Writer Lock** | Multiple readers can access a resource simultaneously, but a writer requires exclusive access. |
| **Thread Pool** | A fixed set of pre-created threads that pull tasks from a queue, avoiding the cost of creating a new thread per task. |
| **Monitor** | An object that combines a mutex with a condition variable — only one thread can execute any of its methods at a time. |
| **Active Object** | Decouples method invocation from execution — requests are queued and executed asynchronously by a private thread. |
| **Future / Promise** | A placeholder for a value that will be available later — lets you continue working and retrieve the result when needed. |
| **Barrier** | Forces multiple threads to wait until all of them have reached a certain point before any can proceed. |
| **Double-Checked Locking** | Reduces locking overhead for lazy initialization by first checking without a lock, then locking only if needed. |
| **Immutable Object** | An object whose state cannot change after creation — inherently thread-safe without any synchronization. |
| **Semaphore** | A counter that controls access to a resource — allows up to N threads in concurrently, blocking the rest. |
| **Fork-Join** | Recursively splits a task into subtasks, processes them in parallel, then joins (combines) the results. |

---

## 12. Distributed Systems Patterns

> Named patterns for building reliable distributed systems.
>
> **Canonical source:** Unmesh Joshi — *Patterns of Distributed Systems* (2023); Martin Kleppmann — *Designing Data-Intensive Applications* (2017)

| Name | Description |
|---|---|
| **Leader Election** | Multiple nodes agree on one "leader" that coordinates work — if the leader dies, a new one is elected. |
| **Write-Ahead Log (WAL)** | Write every change to an append-only log before applying it — guarantees durability even if the system crashes mid-operation. |
| **Replicated Log** | All nodes maintain identical logs by replicating every entry — the foundation of consensus algorithms. |
| **Heartbeat** | Nodes periodically send "I'm alive" signals so others can detect failures quickly. |
| **Generation Clock (Epoch)** | A monotonically increasing number that marks a new "era" after a leader change — detects stale messages from old leaders. |
| **Consistent Core** | A small cluster of nodes uses strong consensus (Raft/Paxos), while the rest of the system uses it as a coordination service. |
| **Gossip Protocol** | Nodes share state by randomly telling a few neighbors, who tell their neighbors — information spreads like a rumor. |
| **Two-Phase Commit (2PC)** | A coordinator asks all participants to prepare, then tells all to commit — ensures all-or-nothing across multiple nodes. |
| **Saga** | A sequence of local transactions where each step has a compensating action — if step 4 fails, steps 3, 2, 1 are undone. |
| **Quorum** | Requires a majority (e.g., 3 of 5) of nodes to agree before a read or write is considered successful. |
| **Phi Accrual Failure Detector** | Instead of binary alive/dead, calculates a continuous suspicion level based on heartbeat arrival intervals. |
| **State Machine Replication** | Every node runs the same deterministic state machine with the same inputs, guaranteeing identical state. |
| **Consistent Hashing** | Maps data to nodes using a hash ring — when a node is added/removed, only a small fraction of data moves. |

---

## 13. Stability & Resilience Patterns

> Named patterns for building production systems that survive real-world failures.
>
> **Canonical source:** Michael Nygard — *Release It! Design and Deploy Production-Ready Software* (2nd ed. 2018)

### Stability Patterns

| Name | Description |
|---|---|
| **Circuit Breaker** | Stops calling a failing service after repeated failures — "opens" the circuit to fail fast instead of waiting. |
| **Bulkhead** | Isolates different parts of the system so a failure in one doesn't take down the others (like compartments in a ship). |
| **Timeout** | Sets a maximum time to wait for a response — prevents threads from blocking forever on a slow service. |
| **Retry** | Automatically retries a failed operation with a delay, optionally using exponential backoff. |
| **Steady State** | Systems should not accumulate resources over time (logs, temp files, connections) — clean up automatically. |
| **Fail Fast** | If a system knows it will fail, fail immediately rather than wasting resources on a doomed operation. |
| **Handshaking** | A server signals its ability to accept work so clients don't send requests to an overloaded server. |
| **Shed Load** | Actively refuse excess requests under heavy load to protect the system from total collapse. |

### Stability Anti-Patterns

| Name | Description |
|---|---|
| **Integration Points** | Every connection to an external system is a potential failure source — they are the #1 killer of production systems. |
| **Chain Reactions** | One node's failure increases load on others, causing them to fail in sequence like dominoes. |
| **Cascading Failures** | A failure in one layer triggers failures in the calling layer, which triggers failures in the next, and so on. |
| **Blocked Threads** | Threads waiting indefinitely on a resource that will never respond — the system looks "alive" but does nothing. |
| **Unbalanced Capacities** | A fast upstream system overwhelms a slower downstream system because their throughput isn't matched. |

---

## 14. Microservices Patterns

> Named patterns for decomposing, communicating, and managing microservice architectures.
>
> **Canonical source:** Chris Richardson — *Microservices Patterns* (2018)

### Decomposition

| Name | Description |
|---|---|
| **Decompose by Business Capability** | Split services along what the business does — Orders, Payments, Inventory — not technical layers. |
| **Decompose by Subdomain** | Use DDD bounded contexts to determine service boundaries. |
| **Strangler Fig** | Gradually replace parts of a monolith by routing specific requests to the new service — like a vine slowly replacing a tree. |

### Communication

| Name | Description |
|---|---|
| **API Gateway** | A single entry point that routes external requests to the correct internal microservice and handles cross-cutting concerns. |
| **Backend for Frontend (BFF)** | A separate API gateway tailored for each client type (mobile, web, third-party). |
| **Service Discovery** | Services register themselves so others can find their network location dynamically instead of hardcoding URLs. |
| **Service Mesh** | A dedicated infrastructure layer (sidecar proxies) that handles service-to-service communication, retries, and observability. |

### Data Management

| Name | Description |
|---|---|
| **Database per Service** | Each microservice owns its private database — no shared tables — enforcing loose coupling at the data level. |
| **Saga (Orchestration)** | A central orchestrator tells each service what step to execute and what to compensate on failure. |
| **Saga (Choreography)** | Each service listens for events and decides what to do next — no central coordinator. |
| **CQRS** | Separate the read model from the write model — optimized independently for their different workloads. |
| **Event Sourcing** | Store every state change as an immutable event rather than the current state — rebuild state by replaying events. |

### Infrastructure

| Name | Description |
|---|---|
| **Sidecar** | A helper container deployed alongside the main service container to handle logging, proxying, or configuration. |
| **Ambassador** | A proxy sidecar specifically for outbound connections — handles retries, circuit-breaking, and routing on behalf of the service. |
| **Externalized Configuration** | Configuration lives outside the deployable artifact (env vars, config service) — change config without redeploying. |

---

## 15. Test-Driven Development (TDD)

> A discipline where you write a failing test before writing production code.
>
> **Canonical source:** Kent Beck — *Test-Driven Development: By Example* (2002)

| Name | Description |
|---|---|
| **Red** | Write a failing test first — it defines what the code should do before you write any production code. |
| **Green** | Write the minimum production code needed to make the failing test pass — nothing more. |
| **Refactor** | Clean up the code (and the test) while keeping all tests green — improve design without changing behavior. |
| **Triangulation** | Write a second test with different data to force a more general implementation instead of a hardcoded return. |
| **Fake It Till You Make It** | Return a hardcoded value to pass the test, then gradually replace it with real logic as more tests are added. |
| **Obvious Implementation** | When the solution is trivial and obvious, just write it directly instead of faking it. |
| **Arrange-Act-Assert (AAA)** | Structure each test in three blocks: set up the inputs, execute the action, verify the result. |
| **Given-When-Then** | BDD-style equivalent of AAA — given some precondition, when an action occurs, then expect an outcome. |

---

## 16. Test Doubles & Mocking

> Named catalog of fake objects used in testing.
>
> **Canonical source:** Gerard Meszaros — *xUnit Test Patterns: Refactoring Test Code* (2007)

| Name | Description |
|---|---|
| **Dummy** | An object passed to satisfy a parameter list but never actually used — just fills a slot. |
| **Stub** | Returns hardcoded/predetermined answers to method calls — provides canned data for the test. |
| **Spy** | A stub that also records how it was called (which methods, how many times, with what arguments). |
| **Mock** | A pre-programmed object with expectations — the test fails if the expected interactions don't happen. |
| **Fake** | A working but simplified implementation (e.g., in-memory database) — functional but not suitable for production. |
| **Characterization Test** | A test written against existing code to capture its current behavior, not to verify correctness. |
| **Object Mother** | A helper that creates fully-formed test objects with sensible defaults — reduces setup duplication across tests. |
| **Test Data Builder** | A builder pattern specifically for constructing test data — fluent API like `aUser().withName("Ali").build()`. |

---

## 17. Legacy Code Techniques

> Named catalog of 24 dependency-breaking techniques for safely changing code that has no tests.
>
> **Key definition:** "Legacy code = code without tests"
>
> **Canonical source:** Michael Feathers — *Working Effectively with Legacy Code* (2004)

| Name | Description |
|---|---|
| **Seam** | A place where you can alter behavior without editing the code itself — the key concept for testing legacy code. |
| **Sprout Method** | Write new behavior in a brand-new method, call it from the legacy code — keeps new code testable. |
| **Sprout Class** | Same idea as Sprout Method but at the class level — create a new class for new behavior and instantiate it from the legacy code. |
| **Wrap Method** | Rename the old method and create a new method with the old name that calls both old and new behavior. |
| **Wrap Class** | Use the Decorator pattern to add behavior around an existing class without modifying it. |
| **Extract and Override** | Extract a method, then in a test subclass override it to control its behavior during testing. |
| **Characterization Test** | Write tests that document what the code currently does (even bugs) — gives you a safety net before changing it. |
| **Scratch Refactoring** | Aggressively refactor just to understand the code — then throw away the changes and start over with knowledge. |
| **Sensing Variable** | Add a temporary variable to expose hidden behavior during testing — remove it after you have proper tests. |
| **Legacy Code Change Algorithm** | The 5-step process: identify change points, find test points, break dependencies, write tests, make changes. |

---

## 18. Object-Oriented Analysis and Design (OOAD)

> Systematic approach to analyzing a problem domain and designing a solution using objects.
>
> **Canonical source:** Craig Larman — *Applying UML and Patterns*; Grady Booch — *Object-Oriented Analysis and Design with Applications*

| Name | Description |
|---|---|
| **CRC Cards** | Index cards listing a class's Name, Responsibilities, and Collaborators — a lightweight design technique done at a whiteboard. |
| **Use Case Analysis** | Identifies what actors (users/systems) do with the system — each use case describes one goal the actor achieves. |
| **Responsibility-Driven Design** | Design by asking "who should be responsible for this?" rather than "what data does this class hold?" |
| **Class Diagram** | Shows classes, their attributes, methods, and relationships (inheritance, association, dependency). |
| **Sequence Diagram** | Shows how objects interact over time by sending messages to each other in sequence. |
| **Collaboration Diagram** | Shows the same interactions as a sequence diagram but organized spatially around the objects. |
| **Noun-Verb Analysis** | Extract nouns from requirements as candidate classes and verbs as candidate methods — a simple starting heuristic. |
| **Iterative Refinement** | OOAD is not done in one pass — you analyze, design, code, learn, then go back and refine the model. |

---

## 19. UML (Unified Modeling Language)

> Standardized visual notation for modeling software systems.
>
> **Canonical source:** Martin Fowler — *UML Distilled* (3rd ed. 2003)
> **Creators:** Grady Booch, Ivar Jacobson, James Rumbaugh

### Structure Diagrams

| Name | Description |
|---|---|
| **Class Diagram** | Shows classes, attributes, methods, and their relationships — the most commonly used UML diagram. |
| **Object Diagram** | A snapshot of actual object instances and their links at a specific moment in time. |
| **Component Diagram** | Shows high-level software components and the interfaces/dependencies between them. |
| **Deployment Diagram** | Shows physical hardware nodes and which software artifacts are deployed on each. |
| **Package Diagram** | Groups classes into packages and shows dependencies between packages — useful for architecture. |

### Behavior Diagrams

| Name | Description |
|---|---|
| **Use Case Diagram** | Shows actors (users/systems) and the goals (use cases) they can achieve with the system. |
| **Sequence Diagram** | Shows the order of messages exchanged between objects over time (vertical axis = time). |
| **Activity Diagram** | A flowchart-like diagram showing the workflow of activities with branching, forking, and merging. |
| **State Machine Diagram** | Shows the states an object can be in and the events/transitions between them. |
| **Communication Diagram** | Shows which objects interact with which, with numbered messages showing the order. |

---

## 20. Pragmatic Practices

> Named principles and tips for being an effective programmer across all domains.
>
> **Canonical source:** Andrew Hunt & David Thomas — *The Pragmatic Programmer* (20th Anniversary Ed. 2019)

| Name | Description |
|---|---|
| **DRY (Don't Repeat Yourself)** | Every piece of knowledge should have a single, unambiguous representation in the system. |
| **Orthogonality** | Components should be independent — changing one shouldn't require changing another. |
| **Tracer Bullets** | Build a thin, end-to-end slice of the system first to validate the architecture before filling in details. |
| **Prototyping** | Build a throwaway version to explore a risky idea — expect to discard it, not ship it. |
| **Design by Contract** | Functions declare preconditions (what they expect), postconditions (what they guarantee), and invariants (what never changes). |
| **Broken Windows Theory** | One piece of bad code (a "broken window") encourages more — fix bad code immediately before it spreads. |
| **Stone Soup** | Start with something small and working, then gradually convince others to contribute until you have the full solution. |
| **Good Enough Software** | Know when to stop polishing — great software shipped today beats perfect software shipped never. |
| **Rubber Ducking** | Explain your problem out loud (even to a rubber duck) — the act of articulating often reveals the solution. |
| **Power of Plain Text** | Store knowledge in human-readable plain text — it outlives any proprietary format. |
| **Reversibility** | Don't make decisions that are hard to reverse — use abstractions so you can swap implementations later. |
| **Domain Languages** | Write code (or config) in the vocabulary of the problem domain, not the solution domain. |
| **Estimating** | Learn to give useful estimates by breaking tasks down, using ranges, and tracking your accuracy over time. |

---

## 21. Simple Design (Kent Beck's Four Rules)

> Four rules for the simplest code that works.
>
> **Canonical source:** Kent Beck — originally from Extreme Programming; elaborated by J.B. Rainsberger

| Name | Description |
|---|---|
| **Passes All Tests** | The code must be correct — if it doesn't work, nothing else matters. (Highest priority.) |
| **Reveals Intention** | Code should clearly express what it does — a reader should understand intent without comments. |
| **No Duplication (DRY)** | Remove every piece of duplicated knowledge — duplication is the root of maintenance pain. |
| **Fewest Elements** | Remove anything that doesn't serve the first three rules — no extra classes, methods, or variables. (Lowest priority.) |

---

## 22. Continuous Delivery / DevOps

> Named practices for reliably releasing software at any time.
>
> **Canonical source:** Jez Humble & Dave Farley — *Continuous Delivery* (2010); Gene Kim et al. — *The DevOps Handbook* (2016)

### CI/CD

| Name | Description |
|---|---|
| **Continuous Integration (CI)** | Every developer merges code into the main branch at least daily, and every merge is verified by an automated build and tests. |
| **Continuous Delivery (CD)** | The codebase is always in a deployable state — any commit can be released to production with a single manual approval. |
| **Continuous Deployment** | Every change that passes the automated pipeline is automatically deployed to production — no human gate. |
| **Deployment Pipeline** | An automated sequence of stages (build, test, stage, deploy) that validates every change. |
| **Build Artifact** | An immutable, versioned package produced by the build step — the exact same artifact moves through every environment. |

### Release Strategies

| Name | Description |
|---|---|
| **Blue-Green Deployment** | Maintain two identical environments — deploy to the idle one, then switch traffic over in one step. |
| **Canary Release** | Route a small percentage of traffic to the new version first — roll out gradually if metrics look good. |
| **Rolling Deployment** | Replace instances one at a time (or in batches) so the service is never fully down during deployment. |
| **Feature Toggle (Feature Flag)** | Wrap new features in a toggle so they can be enabled/disabled at runtime without redeploying. |
| **Dark Launch** | Deploy new code to production but don't expose it to users — test with real traffic behind the scenes. |

### Infrastructure

| Name | Description |
|---|---|
| **Infrastructure as Code (IaC)** | Define servers, networks, and environments in version-controlled code (Terraform, Ansible) instead of manual setup. |
| **Trunk-Based Development** | All developers commit to a single main branch with short-lived feature branches (< 1 day). |
| **Configuration as Code** | Store all app configuration in version control alongside the code, not in manual settings. |
| **GitOps** | Use Git as the single source of truth for infrastructure and deployment — changes via pull requests. |

---

## 23. Anti-Patterns

> Named catalog of common bad solutions — the opposite of design patterns.
>
> **Canonical source:** William Brown et al. — *AntiPatterns: Refactoring Software, Architectures, and Projects in Crisis* (1998)

### Code-Level

| Name | Description |
|---|---|
| **God Object** | One class that knows everything and does everything — the entire system depends on it. |
| **Spaghetti Code** | Unstructured, tangled code with no clear flow — control jumps everywhere. |
| **Copy-Paste Programming** | Duplicating code instead of abstracting it — every bug must be fixed in N places. |
| **Magic Numbers/Strings** | Literal values scattered through code with no name or explanation for what they mean. |
| **Golden Hammer** | Using one familiar tool/pattern for every problem regardless of whether it fits. |
| **Lava Flow** | Dead or experimental code left in the codebase because nobody is sure if it's still needed. |
| **Boat Anchor** | Code kept "just in case" that serves no current purpose — adds complexity for zero value. |
| **Premature Optimization** | Optimizing before measuring — making code complex to solve a performance problem that doesn't exist. |

### Architecture-Level

| Name | Description |
|---|---|
| **Big Ball of Mud** | A system with no discernible architecture — everything depends on everything. |
| **Vendor Lock-In** | Building so tightly around one vendor's tools that switching is prohibitively expensive. |
| **Inner-Platform Effect** | Building a generalized system within a system that poorly reimplements the underlying platform's features. |
| **Architecture by Implication** | No explicit architecture — the team just assumes everyone knows how things should be structured. |
| **Design by Committee** | Too many stakeholders with conflicting opinions produce an incoherent, over-compromised design. |
| **Reinventing the Wheel** | Building a custom solution for a problem that well-tested libraries already solve. |

### Management-Level

| Name | Description |
|---|---|
| **Analysis Paralysis** | Spending so long analyzing and designing that nothing ever gets built. |
| **Death March** | A project everyone knows will fail but continues anyway due to organizational pressure. |
| **Mushroom Management** | Developers are kept in the dark about business goals and decisions — fed nothing, expected to produce. |

---

## 24. Design by Contract (DbC)

> A methodology where classes define precise preconditions, postconditions, and invariants.
>
> **Canonical source:** Bertrand Meyer — *Object-Oriented Software Construction* (2nd ed. 1997)

| Name | Description |
|---|---|
| **Precondition** | What must be true before a method is called — the caller's obligation (e.g., `amount > 0`). |
| **Postcondition** | What the method guarantees to be true after it returns — the method's obligation (e.g., `balance == old_balance - amount`). |
| **Class Invariant** | A condition that must be true for every instance at all stable points — before and after every public method. |
| **Assertion** | A runtime check embedded in code that verifies a condition is true — crashes if violated, signaling a programming error. |
| **Defensive Programming** | Check everything at every boundary — the opposite philosophy to DbC, which trusts contracts between internal components. |
| **Fail Fast** | When a contract is violated, crash immediately with a clear message rather than continuing with corrupt state. |

---

## 25. Functional Programming Patterns

> Named patterns and concepts from the functional paradigm.
>
> **Canonical source:** Scott Wlaschin — *Domain Modeling Made Functional* (2018)

| Name | Description |
|---|---|
| **Pure Function** | A function that always returns the same output for the same input and produces no side effects. |
| **Immutability** | Data never changes after creation — instead, create new copies with modifications. |
| **Higher-Order Function** | A function that takes another function as a parameter or returns one — `map`, `filter`, `sort`. |
| **Map / Filter / Reduce** | The three fundamental collection operations: transform each item, keep matching items, combine all items into one result. |
| **Monad** | A design pattern that wraps values and chains operations on those values while handling context (nullability, errors, async). |
| **Either / Result** | A monad with two cases — `Left` (failure) or `Right` (success) — for error handling without exceptions. |
| **Functor** | An object that can be "mapped over" — you can apply a function to its inner value without unwrapping it. |
| **Pattern Matching** | Branching logic based on the structure/shape of data rather than equality checks — like a powerful `switch`. |
| **Currying** | Transforming a function with multiple parameters into a chain of single-parameter functions. |
| **Composition** | Building complex functions by chaining simple functions: `f(g(x))` or `pipe(g, f)`. |
| **Closure** | A function that "remembers" the variables from the scope where it was created, even after that scope has ended. |
| **Referential Transparency** | An expression can be replaced with its value without changing the program's behavior — a hallmark of pure functions. |

---

## 26. Data Structures & Algorithms

> The foundational computer science discipline.
>
> **Canonical source:** Cormen et al. — *Introduction to Algorithms* (CLRS); Robert Sedgewick — *Algorithms*

### Data Structures

| Name | Description |
|---|---|
| **Array** | A fixed-size, contiguous block of memory with O(1) index access — the most fundamental structure. |
| **Linked List** | Elements connected by pointers — efficient insertion/deletion but O(n) random access. |
| **Stack** | Last-In-First-Out (LIFO) — push and pop from the top only (undo systems, call stacks). |
| **Queue** | First-In-First-Out (FIFO) — enqueue at the back, dequeue from the front (task scheduling, BFS). |
| **Hash Map (Dictionary)** | Key-value pairs with average O(1) lookup — the workhorse of nearly every application. |
| **Set** | A collection of unique elements with fast membership testing. |
| **Tree** | A hierarchical structure with a root node and children — the basis for BSTs, heaps, and file systems. |
| **Binary Search Tree (BST)** | A tree where left children are smaller and right children are larger — O(log n) search, insert, delete. |
| **Heap** | A complete binary tree where every parent is greater (max-heap) or smaller (min-heap) than its children — O(1) to get the extreme value. |
| **Graph** | A set of nodes connected by edges — models networks, social connections, routes, dependencies. |
| **Trie (Prefix Tree)** | A tree where each path from root to node represents a string prefix — fast for autocomplete and dictionaries. |

### Algorithmic Strategies

| Name | Description |
|---|---|
| **Brute Force** | Try all possible solutions — correct but usually too slow for large inputs. |
| **Divide and Conquer** | Split the problem in half, solve each half recursively, combine the results (merge sort, binary search). |
| **Greedy** | At each step, make the locally optimal choice — fast but doesn't always find the global optimum. |
| **Dynamic Programming** | Break a problem into overlapping subproblems, solve each once, and store results to avoid recomputation. |
| **Backtracking** | Try a path; if it leads to a dead end, undo the last choice and try the next option (sudoku solvers, N-queens). |
| **BFS (Breadth-First Search)** | Explore a graph level by level outward from the start — finds the shortest unweighted path. |
| **DFS (Depth-First Search)** | Explore a graph by going as deep as possible before backtracking — useful for exhaustive traversal. |
| **Binary Search** | Eliminate half the sorted input at each step — O(log n) lookup. |
| **Sliding Window** | Maintain a window of elements moving through an array to efficiently compute sums, max, or substrings. |
| **Two Pointers** | Use two pointers moving through a sorted array to find pairs or subarrays in O(n) time. |

### Complexity Analysis

| Name | Description |
|---|---|
| **Big-O Notation** | Describes the upper bound of an algorithm's growth rate — O(1), O(log n), O(n), O(n log n), O(n²). |
| **Space Complexity** | How much extra memory an algorithm uses relative to input size. |
| **Amortized Analysis** | The average cost per operation over a sequence of operations — some are expensive, but rare. |

---

## 27. System Design

> The discipline of designing large-scale software systems.
>
> **Canonical source:** Alex Xu — *System Design Interview* Vol 1 & 2; Martin Kleppmann — *Designing Data-Intensive Applications* (2017)

### Scalability

| Name | Description |
|---|---|
| **Horizontal Scaling** | Add more machines to handle more load — scale out, not up. |
| **Vertical Scaling** | Add more CPU/RAM/disk to a single machine — simpler but has a ceiling. |
| **Load Balancer** | Distributes incoming requests across multiple servers to prevent any single server from being overwhelmed. |
| **Sharding** | Splits a database into smaller partitions (shards), each on a different machine — distributes data and load. |
| **Replication** | Keeps copies of data on multiple nodes for redundancy and read performance — if one dies, others serve. |
| **Consistent Hashing** | Distributes data across nodes using a hash ring — adding/removing a node only moves a small fraction of data. |

### Caching

| Name | Description |
|---|---|
| **CDN (Content Delivery Network)** | Serves static content (images, CSS, JS) from servers geographically close to the user for faster load times. |
| **Write-Through Cache** | Writes data to both cache and database simultaneously — consistent but slower writes. |
| **Write-Back Cache** | Writes data to cache first, syncs to database later asynchronously — fast writes but risk of data loss. |
| **Write-Around Cache** | Writes go directly to the database, bypassing the cache — avoids cache pollution from infrequent data. |
| **Cache Eviction (LRU, LFU, TTL)** | Policies for deciding what to remove when the cache is full — Least Recently Used, Least Frequently Used, or Time-To-Live expiry. |

### Communication

| Name | Description |
|---|---|
| **Message Queue** | A buffer that decouples producers from consumers — producers send messages, consumers process them at their own pace. |
| **REST** | Stateless request-response over HTTP using resources (URLs) and standard methods (GET, POST, PUT, DELETE). |
| **GraphQL** | A query language where the client specifies exactly what data it needs — avoids over-fetching and under-fetching. |
| **gRPC** | A high-performance RPC framework using Protocol Buffers and HTTP/2 — efficient for service-to-service communication. |
| **WebSocket** | A persistent, full-duplex connection between client and server — both sides can push messages at any time. |
| **Long Polling** | Client sends a request and the server holds it open until new data is available — simulates real-time over HTTP. |

### Reliability

| Name | Description |
|---|---|
| **CAP Theorem** | A distributed system can guarantee only two of three: Consistency, Availability, and Partition Tolerance. |
| **Eventual Consistency** | All nodes will converge to the same state eventually, but reads may temporarily return stale data. |
| **Rate Limiter** | Restricts how many requests a client can make in a time window — protects against abuse and overload. |
| **Idempotency** | An operation can be performed multiple times with the same result — critical for safe retries. |
| **Database Indexing** | Creates a data structure (B-tree, hash) that speeds up reads at the cost of slightly slower writes. |
| **Checksum / Hashing** | Detects data corruption by computing a fixed-size fingerprint that changes if even one bit of data changes. |

---

## 28. API Design

> Named principles and styles for designing interfaces between systems.
>
> **Canonical source:** JJ Geewax — *API Design Patterns* (2021)

| Name | Description |
|---|---|
| **REST (Representational State Transfer)** | Resources identified by URLs, manipulated with HTTP verbs, stateless, hypermedia-driven. |
| **GraphQL** | Client-defined queries that return exactly the requested shape — one endpoint, flexible responses. |
| **gRPC** | Strongly-typed RPC using Protocol Buffers for serialization — fast, binary, supports streaming. |
| **HATEOAS** | Responses include links to related actions/resources so the client discovers the API by navigating, not hardcoding URLs. |
| **Idempotency** | `PUT` and `DELETE` should be safe to retry — same request, same result, no duplicate side effects. |
| **Versioning (URI vs Header)** | Strategy for evolving APIs without breaking existing clients — `/v2/users` vs `Accept: application/vnd.api.v2`. |
| **Pagination (Cursor vs Offset)** | Returning large lists in chunks — offset is simple but slow at scale; cursor is stable and performant. |
| **Rate Limiting** | Limit requests per client per time window — return `429 Too Many Requests` when exceeded. |
| **Postel's Law (Robustness Principle)** | Be conservative in what you send, liberal in what you accept — don't break on unexpected fields. |
| **OpenAPI / Swagger** | A machine-readable specification for REST APIs — enables auto-generated docs, SDKs, and mocks. |

---

## 29. Database Design & Normalization

> Named rules for structuring relational data to eliminate redundancy.
>
> **Canonical source:** C.J. Date — *An Introduction to Database Systems*

### Normalization

| Name | Description |
|---|---|
| **1NF (First Normal Form)** | Every column holds atomic (indivisible) values — no lists or nested tables in a single cell. |
| **2NF (Second Normal Form)** | 1NF + every non-key column depends on the entire primary key, not just part of it. |
| **3NF (Third Normal Form)** | 2NF + no non-key column depends on another non-key column — eliminate transitive dependencies. |
| **BCNF (Boyce-Codd NF)** | A stricter version of 3NF — every determinant must be a candidate key. |
| **Denormalization** | Intentionally duplicating data to speed up reads — trading write complexity and storage for faster queries. |

### Concepts

| Name | Description |
|---|---|
| **ER Diagram** | A visual model showing entities (tables), their attributes, and relationships (one-to-many, many-to-many). |
| **Primary Key** | A column (or set of columns) that uniquely identifies each row in a table. |
| **Foreign Key** | A column that references the primary key of another table — enforces referential integrity. |
| **Junction Table** | A table that connects two tables in a many-to-many relationship — holds both foreign keys. |
| **Indexing Strategy** | Choosing which columns to index based on query patterns — speeds reads but slows writes and uses storage. |
| **ACID** | Atomicity, Consistency, Isolation, Durability — the four guarantees of a reliable database transaction. |
| **BASE** | Basically Available, Soft state, Eventually consistent — the trade-off model for distributed NoSQL databases. |

### Non-Relational Models

| Name | Description |
|---|---|
| **Document Model** | Stores data as self-contained JSON/BSON documents — flexible schema, good for nested data (MongoDB). |
| **Key-Value Store** | The simplest model — a dictionary/hash map at database scale, extremely fast for lookups (Redis, DynamoDB). |
| **Column-Family** | Stores data in columns grouped by family — optimized for heavy write loads and wide rows (Cassandra, HBase). |
| **Graph Database** | Stores nodes and edges — optimized for traversing relationships (Neo4j, social networks, recommendation engines). |
| **Polyglot Persistence** | Using different database types for different parts of the system — the best tool for each job. |

---

## 30. The Twelve-Factor App

> A named methodology of 12 principles for building modern cloud-native SaaS applications.
>
> **Canonical source:** Adam Wiggins (Heroku) — [12factor.net](https://12factor.net/)

| Factor | Description |
|---|---|
| **I. Codebase** | One codebase tracked in version control, many deploys — same repo for dev, staging, and production. |
| **II. Dependencies** | Explicitly declare and isolate all dependencies — never rely on system-wide packages being installed. |
| **III. Config** | Store configuration (database URLs, API keys) in environment variables, not in code. |
| **IV. Backing Services** | Treat databases, caches, and queues as attached resources — swap them by changing a URL, not code. |
| **V. Build, Release, Run** | Strictly separate the build stage (compile), release stage (combine with config), and run stage (execute). |
| **VI. Processes** | The app runs as stateless processes — any state lives in a backing service (database, cache), not in memory. |
| **VII. Port Binding** | The app exports HTTP (or other service) by binding to a port — it is self-contained, not deployed into a container. |
| **VIII. Concurrency** | Scale out by running more processes — each process type handles one kind of work. |
| **IX. Disposability** | Processes start fast and shut down gracefully — they can be started, stopped, or restarted at any moment. |
| **X. Dev/Prod Parity** | Keep development, staging, and production as similar as possible — same backing services, same OS, same tools. |
| **XI. Logs** | Treat logs as event streams — the app writes to stdout, and the environment captures, routes, and stores them. |
| **XII. Admin Processes** | Run one-off admin tasks (migrations, scripts) as processes in the same environment as the app. |

---

## 31. Cloud Design Patterns

> Named catalog of 30+ patterns for building applications in cloud environments.
>
> **Canonical source:** [Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/patterns/); [AWS Cloud Design Patterns](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/introduction.html)

### Data Management

| Name | Description |
|---|---|
| **CQRS** | Separate read and write models so each can be optimized, scaled, and secured independently. |
| **Event Sourcing** | Persist the sequence of state-changing events rather than the current state — rebuild state by replaying. |
| **Materialized View** | Precompute and store query results so reads are fast — updated when the underlying data changes. |
| **Sharding** | Partition data across multiple stores to distribute load and scale storage horizontally. |
| **Static Content Hosting** | Serve static assets from a cloud storage service (S3, Blob) or CDN rather than the application server. |

### Reliability

| Name | Description |
|---|---|
| **Circuit Breaker** | Prevent repeated calls to a failing service — open the circuit, fail fast, and periodically test for recovery. |
| **Retry** | Transparently retry transient failures with delays — use exponential backoff to avoid thundering herd. |
| **Compensating Transaction** | Undo a previously committed operation by executing a logically opposite operation (e.g., refund after charge). |
| **Health Endpoint Monitoring** | Expose a `/health` endpoint that infrastructure can poll to detect and replace unhealthy instances. |
| **Queue-Based Load Leveling** | Place a queue between the caller and service to absorb traffic spikes — the service processes at its own pace. |

### Messaging

| Name | Description |
|---|---|
| **Competing Consumers** | Multiple consumers process messages from the same queue in parallel — scales throughput horizontally. |
| **Priority Queue** | Messages with higher priority are processed before lower-priority ones — critical operations go first. |
| **Publisher-Subscriber** | Producers emit events without knowing who consumes them — subscribers register interest and receive copies. |
| **Claim Check** | Store a large payload in external storage and pass only a reference (claim check) through the message channel. |

### Security & Access

| Name | Description |
|---|---|
| **Valet Key** | Issue a limited, time-bound token that grants direct access to a specific resource — avoids proxying all data through the app. |
| **Gatekeeper** | A front-end security layer that validates and sanitizes all requests before passing them to the backend. |
| **Federated Identity** | Delegate authentication to an external identity provider (Google, Azure AD) instead of managing credentials yourself. |

### Design & Structure

| Name | Description |
|---|---|
| **Sidecar** | Deploy a helper container alongside the main app to handle cross-cutting concerns (logging, monitoring, TLS). |
| **Ambassador** | A proxy that sits between the app and external services, handling retries, routing, and circuit-breaking. |
| **Strangler Fig** | Incrementally replace a legacy system by routing requests to new code, gradually expanding until the old system is gone. |
| **Anti-Corruption Layer** | A translation layer that isolates your clean model from a messy external system's interface. |
| **Backends for Frontends** | Build a separate backend API tailored for each frontend (mobile, web) instead of one API for all. |
| **Throttling** | Limit resource consumption per tenant or client to protect shared resources from overuse. |

---

## 32. Reactive Programming

> A paradigm for building systems that are Responsive, Resilient, Elastic, and Message-Driven.
>
> **Canonical source:** [The Reactive Manifesto](https://www.reactivemanifesto.org/); Roland Kuhn — *Reactive Design Patterns* (2017)

| Name | Description |
|---|---|
| **Responsive** | The system responds in a timely manner — latency is bounded and consistent. |
| **Resilient** | The system stays responsive in the face of failure — achieved through replication, containment, isolation. |
| **Elastic** | The system stays responsive under varying workload — scales up and down as demand changes. |
| **Message-Driven** | Components communicate through asynchronous messages — enables loose coupling, isolation, and backpressure. |
| **Observable / Stream** | A push-based data source that emits items over time — subscribers react to each item as it arrives. |
| **Observer** | The consumer that subscribes to a stream and reacts to emitted items, errors, and completion. |
| **Backpressure** | A mechanism where a slow consumer signals the fast producer to slow down — prevents overflow. |
| **Hot vs Cold Observable** | A hot observable emits whether anyone is listening; a cold one starts emitting only when subscribed to. |
| **Operators (map, flatMap, debounce, merge, zip)** | Composable transformations applied to streams — map transforms each item, flatMap flattens nested streams, debounce ignores rapid duplicates. |
| **Scheduler** | Controls which thread or event loop an observable's work runs on — separates what from where. |

---

## 33. Site Reliability Engineering (SRE)

> Google's discipline for running reliable production systems.
>
> **Canonical source:** Betsy Beyer et al. — [*Site Reliability Engineering*](https://sre.google/books/) (free online from Google, 2016)

| Name | Description |
|---|---|
| **SLI (Service Level Indicator)** | A quantitative measure of service behavior — e.g., "99.3% of requests complete in < 200ms." |
| **SLO (Service Level Objective)** | A target value for an SLI — the internal goal you aim for, e.g., "99.9% availability per month." |
| **SLA (Service Level Agreement)** | A contract with users defining consequences if the SLO is missed — e.g., refunds if uptime drops below 99.95%. |
| **Error Budget** | The allowed amount of unreliability (100% - SLO) — if you have budget left, you can ship faster; if spent, focus on reliability. |
| **Toil** | Manual, repetitive, automatable operational work that scales linearly with service size — the enemy of SRE. |
| **Blameless Postmortem** | A structured review after an incident that focuses on systemic causes, not individual blame — leads to real fixes. |
| **On-Call** | Engineers take turns being available to respond to production incidents — shared responsibility across the team. |
| **Capacity Planning** | Predicting future resource needs based on growth trends and load testing — provision before you run out. |
| **50% Rule** | SREs should spend no more than 50% of their time on operational toil — the rest goes to engineering improvements. |
| **Change Management** | Progressive rollouts, canaries, and feature flags to minimize the blast radius of changes — most outages are caused by changes. |
| **Monitoring & Alerting** | Instrumenting systems to collect metrics, set thresholds, and page humans only for actionable conditions. |

---

## 34. Behavior-Driven Development (BDD)

> Extension of TDD where tests are written in natural-language scenarios.
>
> **Canonical source:** Dan North (coined the term); John Ferguson Smart — *BDD in Action*

| Name | Description |
|---|---|
| **Given-When-Then** | The structured format for scenarios: Given a precondition, When an action occurs, Then verify an outcome. |
| **Feature File** | A plain-text file (`.feature`) written in Gherkin syntax that describes a feature's scenarios in business language. |
| **Scenario** | A concrete example of a feature's behavior — one Given-When-Then sequence representing a specific case. |
| **Scenario Outline** | A parameterized scenario template that runs multiple times with different example data. |
| **Step Definition** | The code behind a Gherkin step — maps "Given the user is logged in" to actual test code. |
| **Living Documentation** | Feature files that are both readable specifications and executable tests — always up to date because they run in CI. |
| **Example Mapping** | A workshop where the team writes concrete examples on cards to explore business rules before coding. |
| **Three Amigos** | A meeting between a developer, tester, and business person to discuss and align on scenarios before development. |

---

## 35. Event Storming

> A collaborative workshop technique for discovering and modeling business domains.
>
> **Canonical source:** Alberto Brandolini — *Introducing EventStorming* (2013+)

| Name | Description |
|---|---|
| **Domain Event (orange)** | Something that happened in the past that the business cares about — "Order Placed", "Payment Received." |
| **Command (blue)** | An action that triggers a domain event — "Place Order", "Submit Payment." |
| **Aggregate (yellow)** | The cluster of domain objects that decides whether to accept or reject a command. |
| **Policy (lilac)** | An automated reaction: "When [event] happens, then [command] is triggered" — the business rule that connects events to commands. |
| **Read Model (green)** | The data/view that a user or system needs to make a decision before issuing a command. |
| **External System (pink)** | An outside system involved in the flow — payment gateway, email service, third-party API. |
| **Hot Spot (red/pink)** | A point of confusion, disagreement, or risk discovered during the workshop — revisit and resolve later. |
| **Timeline** | Events are placed on a horizontal timeline from left to right — the wall becomes a visual narrative of the business process. |
| **Bounded Context boundary** | Vertical dividers drawn on the timeline where the language or model changes — identifies natural service boundaries. |

---

## 36. Specification by Example

> A collaborative technique where requirements are expressed as concrete examples that become automated tests.
>
> **Canonical source:** Gojko Adzic — *Specification by Example* (2011)

| Name | Description |
|---|---|
| **Key Examples** | Concrete, specific examples that illustrate a business rule — "If the cart total is over $100, shipping is free." |
| **Executable Specification** | A specification written as automated tests — verifies the system actually behaves as specified. |
| **Living Documentation** | Specifications that are always up to date because they fail when the code diverges from the described behavior. |
| **Illustrating with Examples** | Using real data scenarios to clarify requirements instead of abstract descriptions — avoids ambiguity. |
| **Refining the Specification** | Iteratively adding edge cases and negative examples until the team fully understands the rule. |
| **Deriving Scope from Goals** | Starting with a business goal, then identifying only the features and examples that directly support it. |
| **Automating without Changing Specs** | Connecting the human-readable spec to test code without rewriting the spec in a programming language. |

---

## 37. Software Craftsmanship

> A movement/philosophy that software development is a craft that improves through practice and mentorship.
>
> **Canonical source:** Sandro Mancuso — *The Software Craftsman* (2014)

| Name | Description |
|---|---|
| **Kata** | A small coding exercise practiced repeatedly to build muscle memory for design and refactoring skills. |
| **Coding Dojo** | A group practice session where developers solve a kata together, learning from each other. |
| **Pair Programming** | Two developers work at one machine — one writes code (driver), the other reviews and navigates. |
| **Mob Programming** | The entire team works on one thing at one computer — one driver, everyone else navigates. |
| **Boy Scout Rule** | Leave the codebase better than you found it — every touch is an opportunity to clean up. |
| **Mastery-Apprenticeship Model** | Junior developers learn by working alongside experienced craftspeople — mentorship over documentation. |
| **Manifesto for Software Craftsmanship** | "Not only working software, but also well-crafted software" — values quality, continuous learning, and community. |
| **Sustainable Pace** | Work at a pace you can maintain indefinitely — overtime kills quality and motivation. |

---

## 38. Security Patterns & Practices (OWASP)

> Named catalog of vulnerabilities, attacks, and defense patterns for secure software.
>
> **Canonical source:** [OWASP.org](https://owasp.org/)

### OWASP Top 10 Threats

| Name | Description |
|---|---|
| **Injection (SQL, NoSQL, OS)** | Untrusted data is sent to an interpreter as part of a command — the attacker's input becomes executable code. |
| **Broken Authentication** | Weak login mechanisms allow attackers to compromise passwords, keys, or session tokens to impersonate users. |
| **Cross-Site Scripting (XSS)** | Attacker injects malicious scripts into pages viewed by other users — steals cookies, tokens, or redirects users. |
| **Cross-Site Request Forgery (CSRF)** | Tricks a logged-in user's browser into sending requests to a trusted site on the attacker's behalf. |
| **Insecure Deserialization** | Untrusted data is deserialized into objects — can lead to remote code execution or privilege escalation. |
| **Broken Access Control** | Users can access resources or actions outside their permissions — missing authorization checks. |
| **Server-Side Request Forgery (SSRF)** | The attacker tricks the server into making requests to internal systems that should be unreachable from outside. |
| **Security Misconfiguration** | Default credentials, open cloud storage, verbose error messages, unnecessary services left enabled. |

### Defense Techniques

| Name | Description |
|---|---|
| **Input Validation** | Verify that all input conforms to expected type, length, range, and format before processing. |
| **Output Encoding** | Encode data before rendering it in HTML, SQL, or shell commands to prevent injection. |
| **Parameterized Queries** | Use prepared statements with bound parameters instead of string concatenation to prevent SQL injection. |
| **Principle of Least Privilege** | Grant only the minimum permissions needed — a service that reads data shouldn't have write access. |
| **Defense in Depth** | Layer multiple security controls so that if one fails, others still protect the system. |
| **Secure by Default** | Ship with the most secure configuration — users must opt in to less secure settings, not opt out. |

### Authentication & Authorization

| Name | Description |
|---|---|
| **OAuth 2.0** | An authorization framework that lets third-party apps access resources on behalf of a user without sharing credentials. |
| **OpenID Connect (OIDC)** | An identity layer on top of OAuth 2.0 — adds user authentication and returns identity information. |
| **JWT (JSON Web Token)** | A compact, self-contained token that carries claims (user ID, roles) signed by the server — stateless authentication. |
| **PKCE (Proof Key for Code Exchange)** | An OAuth 2.0 extension that protects mobile and SPA apps from authorization code interception attacks. |
| **RBAC (Role-Based Access Control)** | Permissions are assigned to roles, and users are assigned roles — "admin can delete, editor can edit." |
| **ABAC (Attribute-Based Access Control)** | Access decisions based on attributes (user department, resource owner, time of day) — more flexible than RBAC. |
| **SAML** | An XML-based standard for exchanging authentication and authorization data between an identity provider and a service provider. |

---

## 39. Performance Engineering

> Named techniques for measuring, analyzing, and optimizing software performance.
>
> **Canonical source:** Brendan Gregg — *Systems Performance* (2nd ed. 2020)

### Measurement

| Name | Description |
|---|---|
| **Profiling** | Measuring where a program spends its time (CPU) or memory — identifies actual bottlenecks instead of guessing. |
| **Benchmarking** | Running a standardized test to measure baseline performance — repeatable and comparable across changes. |
| **Load Testing** | Simulating expected production traffic to verify the system handles it within acceptable latency. |
| **Stress Testing** | Pushing beyond expected load to find the breaking point — how does the system degrade and recover? |
| **Flame Graph** | A visualization of profiling data showing which call stacks consume the most time — wide bars are bottlenecks. |

### Optimization Techniques

| Name | Description |
|---|---|
| **Caching** | Storing computed results or fetched data for reuse — avoids repeating expensive work. |
| **Lazy Loading** | Defer loading or computing a resource until it is actually needed — speeds up initial load time. |
| **Eager Loading** | Load all related data upfront in one query — avoids the N+1 problem where each item triggers a separate query. |
| **Connection Pooling** | Reuse a pool of pre-established database connections instead of opening a new one per request. |
| **Object Pooling** | Reuse expensive-to-create objects from a pool instead of allocating and garbage-collecting new ones. |
| **Memoization** | Cache a function's return value based on its arguments — if called again with the same args, return the cached result. |
| **N+1 Query Problem** | Loading a list of N items triggers N additional queries (one per item) — fix with eager loading or batch fetching. |
| **Pagination** | Return large datasets in small chunks instead of all at once — reduces memory and response time. |
| **Premature Optimization** | Optimizing before profiling — the root of much unnecessary complexity (Knuth: "premature optimization is the root of all evil"). |

---

## 40. Agile Methodologies

> Named frameworks for iterative, adaptive software delivery.
>
> **Canonical source:** *The Agile Manifesto* (2001); Ken Schwaber — *Scrum Guide*; Kent Beck — *Extreme Programming Explained*

### Scrum

| Name | Description |
|---|---|
| **Sprint** | A fixed time box (usually 2 weeks) in which a potentially shippable increment is produced. |
| **Product Backlog** | A prioritized list of everything the product might need — maintained by the Product Owner. |
| **Sprint Backlog** | The subset of the product backlog the team commits to delivering in the current sprint. |
| **Daily Standup (Daily Scrum)** | A 15-minute daily meeting: what did I do yesterday, what will I do today, any blockers? |
| **Sprint Review** | The team demonstrates completed work to stakeholders at the end of the sprint for feedback. |
| **Sprint Retrospective** | The team reflects on how the sprint went and identifies one or two improvements for next sprint. |
| **Story Points** | A relative estimate of effort/complexity — "this story is about twice as hard as that 2-point story." |
| **Velocity** | The number of story points a team completes per sprint — used for forecasting, not performance evaluation. |
| **Product Owner** | The person responsible for maximizing product value by managing and prioritizing the backlog. |
| **Scrum Master** | A servant-leader who removes impediments, facilitates ceremonies, and coaches the team on Scrum. |

### Kanban

| Name | Description |
|---|---|
| **WIP Limit (Work in Progress)** | A cap on how many items can be in a stage at once — prevents overload and reveals bottlenecks. |
| **Swimlanes** | Horizontal rows on the board that separate different types of work (bugs, features, expedite). |
| **Lead Time** | The total time from when a request is made until it is delivered to the customer. |
| **Cycle Time** | The time from when work actively starts on an item until it is completed. |
| **Pull System** | Team members pull new work when they have capacity — work is not pushed onto them. |
| **Cumulative Flow Diagram** | A chart showing work items in each stage over time — flat bands mean flow is smooth, bulges mean bottlenecks. |

### XP (Extreme Programming)

| Name | Description |
|---|---|
| **Pair Programming** | Two developers share one workstation — one types, the other reviews and thinks ahead. |
| **Test-Driven Development** | Write a failing test before writing production code — Red, Green, Refactor. |
| **Continuous Integration** | Merge everyone's code into the mainline multiple times a day, verified by automated builds and tests. |
| **Simple Design** | Build the simplest thing that works — don't design for hypothetical future requirements. |
| **Collective Code Ownership** | Anyone on the team can change any code — no individual gatekeepers on modules. |
| **Sustainable Pace** | Work 40-hour weeks — tired developers write bugs, not features. |
| **Planning Game** | Business picks priorities and developers estimate — a negotiation that balances value and cost. |
| **Refactoring** | Continuously improve code structure without changing behavior — a first-class engineering activity, not technical debt cleanup. |
| **Small Releases** | Release to production frequently in small increments — get real feedback fast. |

---

## 41. Modeling & Diagramming Beyond UML

> Other named visual/analytical tools for understanding systems.
>
> **Canonical source:** Simon Brown — [C4 Model](https://c4model.com/); Simon Wardley — *Wardley Maps*; Michael Nygard — [ADR](https://adr.github.io/)

| Name | Description |
|---|---|
| **C4 Model** | Four levels of zoom: Context (who uses the system), Container (deployable units), Component (internal modules), Code (class-level). |
| **Architecture Decision Record (ADR)** | A short document recording a significant architecture decision — the context, the decision, and the consequences. |
| **Wardley Mapping** | A strategic map that plots components by their visibility to the user (y-axis) and evolution stage (x-axis) — reveals where to invest and where to commoditize. |
| **Dependency Structure Matrix (DSM)** | A square matrix showing which modules depend on which — reveals cycles, clusters, and architectural layers at a glance. |
| **Data Flow Diagram (DFD)** | Shows how data moves through a system — processes, data stores, external entities, and data flows. |
| **Entity-Relationship Diagram (ERD)** | Shows database tables (entities), their attributes, and relationships (one-to-many, many-to-many). |
| **Flowchart** | The classic diagram: boxes for steps, diamonds for decisions, arrows for flow — simple and universally understood. |
| **Mind Map** | A radial diagram for brainstorming — central topic with branching sub-topics for free-form exploration. |
| **Sequence Diagram (non-UML)** | Simplified message-flow diagrams (e.g., Mermaid, PlantUML syntax) used in documentation without full UML ceremony. |

---

## Recommended Reading Order

For a developer looking to build a strong foundation, study these in roughly this order:

1. **Clean Code** — start writing readable code immediately
2. **Code Smells** — learn to recognize problems
3. **Refactoring Techniques** — learn to fix problems safely
4. **SOLID Principles** — understand why the fixes work
5. **Design Patterns** — learn proven solutions
6. **OOAD / GRASP** — learn how to assign responsibilities
7. **TDD / Test Doubles** — learn to verify your work
8. **Clean Architecture / DDD** — structure entire systems
9. **PoEAA / EIP** — enterprise-scale patterns
10. **System Design / Cloud Patterns** — distributed systems
11. **SRE / Stability Patterns** — run it in production
12. **Agile / Software Craftsmanship** — work effectively in teams
