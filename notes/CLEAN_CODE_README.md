


1. *Use Intention-Revealing Names*  
    Choosing good names takes time but saves more than it takes.
    Name should tell you why it exists, what it does, and how it is used.
    If a name requires a comment, then the name does not reveal its intent.

2. *Avoid Disinformation*
    Programmers must avoid leaving false clues that obscure the meaning of code.


*Programmers create problems for themselves when they write code solely to satisfy a compiler or interpreter.*

Number-series naming (a1, a2, .. aN) is the opposite of intentional naming.
Such names are not disinformative—they are noninformative; they provide no clue to the
author’s intention. Consider:

public static void copyChars(char a1[], char a2[]) {
    for (int i = 0; i < a1.length; i++) {
        a2[i] = a1[i];
    }
}
This function reads much better when source and destination are used for the argument names.

3. *Use Pronounceable Names*

My personal preference is that single-letter names can ONLY be used as local vari-
ables inside short methods.

Java programmers don’t need type encoding.


Classes and objects should have noun or noun phrase names like Customer, WikiPage,
Account, and AddressParser. Avoid words like Manager, Processor, Data, or Info in the name
of a class.
A class name should not be a verb.

Method Names
Methods should have verb or verb phrase names like postPayment, deletePage, or save.
Accessors, mutators, and predicates should be named for their value and prefixed with get,
set, and is according to the javabean standard.4


## Function
1. *Keep function small*
    - Function should be very small - typically 2-4 lines, rerely exceeding 20 lines.
    - Function should do only thing only, do it well, and do it only.
    - Each function should lead you to the next in a compelling story.

2. *Avoid flag arguments*
    - Boolean arguments indicated the function does more that one thing.
    - Split into multiple functions instead.

3. *Avoid Side Effets*
    - Functions should do what ther name promises - nothing more
    - Don't make unexpected changed to:
        - Parameter passed by referenced
        - Global variables
        - System state

4. *Command - Query Seperation*
    - Function should either:
        - Do something (commands) OR
        - Answer something (queries)
    - But not both!

5. *Prefer Exceptions to Error Code*
    - Returing error codes leads to deeply nested structures.
    - Exceptions allow error processing to be separated from the happy path

6. Do One Thing
