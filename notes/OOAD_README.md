# Head First Object Oriented Analysis and Desing books notes


Give them what the want


1. What is requirement?
Ans: It's a specific thing your system has to do to work correctly.

2. Usecase
Ans: A use case describes what your system does to accomplish a particular customer goal.

3. Scenario
Ans: A complete path through a use case, from the frist step to the last, is called a scenario. Most use cases have several different scenarios, but the always share the same user goal.


Sometimes a change in requirements reveals probelms with your system that you didn't even know were there.
Change is constant, and your system shoul always improve every time your work on it.

4. Textual Analysis
Ans: Looking at the nouns (and verbs) in your use case to figure out classes and methods is called textual analysis.

A good use case clearly and accurately explains what a system does, in language that's easily understood.

With a good use case complete, textual analysis is a quick and easy way to figure out the classess in your system.


### Chapter 5 (part 1):
**good desing = flexible software**

***Change is inevitable***

* Abstract classes are placeholders for actual implementation classess.

* The abstract class defined behavior, and the subclasses implement that behavior.

* Whenever you find common behaviour in two or more places, look to abstract that behaviour into a class, and then reuse that behaviour in the common classes.

* Coading to an interface, rather than to an implementation, makes your software easier to extends.

* By coading to an interface, your code will word with all of ther interface's subclasses - even ones that haven't been created yet.

* Inherit common behavior.

* We used encapsulation to prevent duplicate code. But encapsulation also helps you protect your classes form unnecessary changes.
    - Encapsulate what varies

* Change: Make sure each class has only one reason to change.

### Design Principle
***A desing principle** is a basic tool or technique that can be applied to designing or wirting code to make that code more maintainble, flexible, or extensible.*

### OOP Principles
- Encapsulate what varies.
- Code to an interface rather that to an implemntation.
- Each class in your application should have only one reason to change.
- Classes are all about behaviour and functionality.


1. OCP - Open Closed Principle: Classes should be open for extension, and closed for modification.
2. DRY - Don't Repeat Yourself: Avoid duplicate code by abstracting out things that are common and placing those things in a single location.










