
## Refactoring: Improving the Design of Existing Code

The first step of refactoring is TEST


1. When you have to add a feature to a program but the code is not structured in
a convenient way, first refactor the program to make it easy to add the feature, then
add the feature.

2. Before you start refactoring, make sure you have a solid suite of tests. These
tests must be self­checking.

3. Refactoring changes the programs in small steps, so if you make a mistake, it
is easy to find where the bug is.

4. Any fool can write code that a computer can understand. Good programmers
write code that humans can understand.


**Others**
1. The compiler doesn’t care whether the code is ugly or clean, but human do.
    A poorly designed system is hard to change.

2.  If I’m writing a program that will never change again, this kind of
    copy­and­paste is fine. But if it’s a long­lived program, then duplication is a menace.

3. When refactoring a long function like this, I mentally try to identify points that separate
    different parts of the overall behavior.

4. Mentally to Code

5. Small changes and testing after each change.

6. It’s my coding standard to always call the return value from a function “result”

7. Never be afraid to change names to improve clarity.

8. When I’m breaking down a long function,
    I like to get rid of variables like play, because
    temporary variables create a lot of locally scoped names that complicate extractions.

9.

10.

11.


**Again, I compile, test, and commit.**