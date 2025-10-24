### Basic Refactorings

(1) - **Extract Function (Extract Method) (106)**: Pull code fragment into separate function.  
Purpose: Break down long or complex code into reusable, named functions.  
When to use: When a method is too long or code is duplicated across methods.  
Smells: Long Function, Duplicated Code.  
Anti-refactoring: Inline Function (Inline Method).  
Anti-pattern: God Object.  
Similar: Extract Variable, Decompose Conditional.

(2) - **Inline Function (Inline Method) (115)**: Replace function call with its body.  
Purpose: Eliminate unnecessary small functions for clarity.  
When to use: When a function is trivial or called only once and inlining simplifies code.  
Smells: Unnecessary Abstraction.  
Anti-refactoring: Extract Function (Extract Method).  
Anti-pattern: Over-Abstraction.  
Similar: Inline Variable, Inline Class.

(3) - **Extract Variable (119)**: Pull expression into local variable.  
Purpose: Clarify complex expressions by naming intermediate results.  
When to use: When an expression is complex or reused within a method.  
Smells: Complex Expression.  
Anti-refactoring: Inline Variable.  
Anti-pattern: Magic Inline Code.  
Similar: Extract Function, Replace Temp with Query.

(4) - **Inline Variable (Inline Temp) (123)**: Replace variable references with expression.  
Purpose: Simplify code by removing unnecessary temporary variables.  
When to use: When a variable adds no clarity and is used only once.  
Smells: Unnecessary Temporary.  
Anti-refactoring: Extract Variable.  
Anti-pattern: Overuse of Variables.  
Similar: Inline Function.

(5) - **Change Function Declaration (124)**: Alter function name/parameters (includes Add Parameter, Remove Parameter, Rename Method).  
Purpose: Improve function clarity or adapt signature to new needs.  
When to use: When a function’s name is unclear or parameters need adjustment.  
Smells: Unclear Function Name, Long Parameter List.  
Anti-refactoring: None.  
Anti-pattern: Cryptic Signatures.  
Similar: Parameterize Function.

(6) - **Encapsulate Variable (132)**: Wrap variable access in functions (includes Encapsulate Field).  
Purpose: Protect data by controlling access through methods.  
When to use: When fields are accessed directly or need validation.  
Smells: Data Clumps, Feature Envy.  
Anti-refactoring: None.  
Anti-pattern: Public Fields.  
Similar: Encapsulate Collection.

(7) - **Rename Variable (137)**: Change variable name for clarity.  
Purpose: Improve code readability with descriptive names.  
When to use: When a variable’s name is vague or misleading.  
Smells: Unclear Variable Name.  
Anti-refactoring: None.  
Anti-pattern: Cryptic Variables.  
Similar: Change Function Declaration.

(8) - **Introduce Parameter Object (140)**: Group parameters into object.  
Purpose: Reduce parameter list size and group related data.  
When to use: When a method has too many parameters or related data is passed together.  
Smells: Long Parameter List, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Parameter Soup.  
Similar: Preserve Whole Object.

(9) - **Combine Functions into Class (144)**: Group functions into class (includes Replace Method with Method Object).  
Purpose: Organize related functions into a cohesive class.  
When to use: When functions operate on the same data or share behavior.  
Smells: Feature Envy, Shotgun Surgery.  
Anti-refactoring: None.  
Anti-pattern: Procedural Code.  
Similar: Extract Class.

(10) - **Combine Functions into Transform (149)**: Enrich data with derived values.  
Purpose: Transform input data into a richer structure.  
When to use: When processing raw data into a more usable form.  
Smells: Data Clumps, Primitive Obsession.  
Anti-refactoring: None.  
Anti-pattern: Raw Data Processing.  
Similar: Split Phase.

(11) - **Split Phase (154)**: Separate code phases.  
Purpose: Break complex processing into distinct steps.  
When to use: When a method mixes multiple processing concerns.  
Smells: Long Function, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Monolithic Processing.  
Similar: Split Loop.

### Encapsulation

(12) - **Encapsulate Record (162)**: Wrap record in class (includes Replace Record with Data Class).  
Purpose: Encapsulate raw data structures for better management.  
When to use: When using raw records or structs that need behavior.  
Smells: Primitive Obsession, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Naked Data.  
Similar: Replace Primitive with Object.

(13) - **Encapsulate Collection (170)**: Make collection read-only with add/remove.  
Purpose: Control collection modifications through methods.  
When to use: When a collection is exposed and modified directly.  
Smells: Mutable Collection Exposure.  
Anti-refactoring: None.  
Anti-pattern: Leaky Abstraction.  
Similar: Encapsulate Variable.

(14) - **Replace Primitive with Object (174)**: Turn primitive into class (includes Replace Data Value with Object).  
Purpose: Add behavior to primitive data types.  
When to use: When primitives carry implicit meaning or need methods.  
Smells: Primitive Obsession, Type Code.  
Anti-refactoring: None.  
Anti-pattern: Type Abuse.  
Similar: Replace Array with Object.

(15) - **Replace Temp with Query (178)**: Turn temp into method.  
Purpose: Replace temporary variables with method calls for clarity.  
When to use: When temporary variables hold derived data that can be computed.  
Smells: Temporary Field, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Inline Computation.  
Similar: Extract Variable.

(16) - **Extract Class (182)**: Split class responsibilities.  
Purpose: Reduce class size by extracting unrelated responsibilities.  
When to use: When a class has too many responsibilities.  
Smells: Large Class, Divergent Change.  
Anti-refactoring: Inline Class.  
Anti-pattern: God Class.  
Similar: Move Function, Move Field.

(17) - **Inline Class (186)**: Merge class into another.  
Purpose: Simplify by removing unnecessary classes.  
When to use: When a class has minimal responsibilities or duplicates another.  
Smells: Lazy Class, Speculative Generality.  
Anti-refactoring: Extract Class.  
Anti-pattern: Over-Abstraction.  
Similar: Inline Function.

(18) - **Hide Delegate (189)**: Hide delegation chain.  
Purpose: Simplify access by hiding intermediate objects.  
When to use: When clients access objects through a chain of calls.  
Smells: Message Chains, Feature Envy.  
Anti-refactoring: Remove Middle Man.  
Anti-pattern: Law of Demeter Violation.  
Similar: None.

(19) - **Remove Middle Man (192)**: Expose delegate directly.  
Purpose: Remove unnecessary delegation for direct access.  
When to use: When a class only delegates without adding value.  
Smells: Middle Man, Inappropriate Intimacy.  
Anti-refactoring: Hide Delegate.  
Anti-pattern: Unnecessary Hiding.  
Similar: None.

(20) - **Substitute Algorithm (195)**: Replace algorithm with clearer one.  
Purpose: Swap complex algorithm for a simpler or more efficient one.  
When to use: When an algorithm is overly complex or outdated.  
Smells: Complex Algorithm, Obscure Code.  
Anti-refactoring: None.  
Anti-pattern: Obscure Logic.  
Similar: Replace Conditional with Polymorphism.

### Moving Features

(21) - **Move Function (198)**: Relocate function to better class (includes Move Method).  
Purpose: Place function in the class that uses its data most.  
When to use: When a function uses data from another class excessively.  
Smells: Feature Envy, Inappropriate Intimacy.  
Anti-refactoring: None.  
Anti-pattern: Wrong Location.  
Similar: Move Field.

(22) - **Move Field (207)**: Relocate field to better class.  
Purpose: Move field to the class that uses it most.  
When to use: When a field is accessed more by another class.  
Smells: Feature Envy, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Data Envy.  
Similar: Move Function.

(23) - **Move Statements into Function (213)**: Pull statements into called function.  
Purpose: Consolidate duplicated or related code into a function.  
When to use: When code is repeated before/after function calls.  
Smells: Duplicated Code, Long Function.  
Anti-refactoring: Move Statements to Callers.  
Anti-pattern: Fragmented Logic.  
Similar: Slide Statements.

(24) - **Move Statements to Callers (217)**: Push statements out to callers.  
Purpose: Move function-specific logic to its callers.  
When to use: When a function does too much for some callers.  
Smells: Divergent Change, Shotgun Surgery.  
Anti-refactoring: Move Statements into Function.  
Anti-pattern: Over-General Function.  
Similar: None.

(25) - **Replace Inline Code with Function Call (222)**: Swap code with function call.  
Purpose: Eliminate duplicated inline code with a reusable function.  
When to use: When inline code is duplicated or complex.  
Smells: Duplicated Code, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Inline Duplication.  
Similar: Extract Function.

(26) - **Slide Statements (223)**: Reorder code statements.  
Purpose: Improve code readability by logical statement order.  
When to use: When statements are in a confusing or suboptimal order.  
Smells: Poor Code Flow, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Illogical Order.  
Similar: Split Loop.

(27) - **Split Loop (227)**: Separate loop concerns.  
Purpose: Split a loop handling multiple tasks into separate loops.  
When to use: When a loop performs multiple unrelated tasks.  
Smells: Long Loop, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Multi-Purpose Loop.  
Similar: Replace Loop with Pipeline.

(28) - **Replace Loop with Pipeline (231)**: Use collection pipeline.  
Purpose: Replace imperative loops with functional pipelines.  
When to use: When loops can be simplified with map/filter/reduce.  
Smells: Long Loop, Imperative Code.  
Anti-refactoring: None.  
Anti-pattern: Old-Style Iteration.  
Similar: Split Loop.

(29) - **Remove Dead Code (237)**: Delete unused code.  
Purpose: Clean up code by removing obsolete or unused parts.  
When to use: When code is no longer used or maintained.  
Smells: Dead Code, Speculative Generality.  
Anti-refactoring: None.  
Anti-pattern: Zombie Code.  
Similar: None.

(30) - **Introduce Foreign Method**: Add method to unmodifiable class.  
Purpose: Extend third-party classes with needed behavior.  
When to use: When a library class lacks a needed utility method.  
Smells: Incomplete Library Class.  
Anti-refactoring: None.  
Anti-pattern: Monkey Patching.  
Similar: Introduce Local Extension.

(31) - **Introduce Local Extension**: Extend external class locally.  
Purpose: Add behavior to unmodifiable classes via wrapper or subclass.  
When to use: When multiple methods need to be added to a library class.  
Smells: Incomplete Library Class.  
Anti-refactoring: None.  
Anti-pattern: Monkey Patching.  
Similar: Introduce Foreign Method.

### Organizing Data

(32) - **Split Variable (240)**: Separate variable uses (includes Split Temporary Variable).  
Purpose: Split a variable used for multiple purposes into distinct ones.  
When to use: When a variable holds different values for different purposes.  
Smells: Divergent Change, Temporary Field.  
Anti-refactoring: None.  
Anti-pattern: Overloaded Temp.  
Similar: Replace Temp with Query.

(33) - **Replace Derived Variable with Query (248)**: Compute on-demand.  
Purpose: Replace stored derived data with a method call.  
When to use: When derived data can be computed when needed.  
Smells: Temporary Field, Mutable Derived Data.  
Anti-refactoring: None.  
Anti-pattern: Cached Inconsistency.  
Similar: Replace Temp with Query.

(34) - **Change Reference to Value (252)**: Make immutable value object.  
Purpose: Convert a mutable reference to an immutable value.  
When to use: When an object doesn’t need identity and can be immutable.  
Smells: Mutable Reference, Inappropriate Intimacy.  
Anti-refactoring: Change Value to Reference.  
Anti-pattern: Shared Mutable.  
Similar: None.

(35) - **Change Value to Reference (256)**: Use shared reference object.  
Purpose: Convert a value object to a shared reference.  
When to use: When objects need shared identity or state.  
Smells: Duplicated Objects, Data Clumps.  
Anti-refactoring: Change Reference to Value.  
Anti-pattern: Flyweight Missing.  
Similar: None.

(36) - **Duplicate Observed Data**: Sync GUI/domain data.  
Purpose: Copy data to separate GUI and domain concerns.  
When to use: When UI and domain logic are tightly coupled.  
Smells: Feature Envy, Inappropriate Intimacy.  
Anti-refactoring: None.  
Anti-pattern: Presentation Logic in Domain.  
Similar: None.

(37) - **Replace Array with Object**: Turn array into class.  
Purpose: Replace arrays with objects to add behavior.  
When to use: When arrays are used as makeshift structures.  
Smells: Primitive Obsession, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Array as Struct.  
Similar: Replace Primitive with Object.

(38) - **Change Unidirectional Association to Bidirectional**: Add backpointer.  
Purpose: Allow navigation in both directions between objects.  
When to use: When both objects need to reference each other.  
Smells: Inappropriate Intimacy, Incomplete Navigation.  
Anti-refactoring: Change Bidirectional to Unidirectional.  
Anti-pattern: One-Way Link.  
Similar: None.

(39) - **Change Bidirectional Association to Unidirectional**: Remove backpointer.  
Purpose: Simplify by removing unnecessary two-way links.  
When to use: When one direction of association is unused.  
Smells: Inappropriate Intimacy, Shotgun Surgery.  
Anti-refactoring: Change Unidirectional to Bidirectional.  
Anti-pattern: Over-Coupled.  
Similar: None.

(40) - **Replace Magic Number with Symbolic Constant**: Use constant for literal.  
Purpose: Replace hardcoded numbers with named constants.  
When to use: When literals are repeated or unclear.  
Smells: Magic Number, Duplicated Code.  
Anti-refactoring: None.  
Anti-pattern: Hardcoded Values.  
Similar: Replace Primitive with Object.

(41) - **Remove Assignments to Parameters**: Use local for mods.  
Purpose: Avoid modifying method parameters for clarity.  
When to use: When parameters are reassigned within a method.  
Smells: Modified Parameter, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Side-Effecting Params.  
Similar: Split Variable.

### Simplifying Conditional Logic

(42) - **Decompose Conditional (260)**: Extract conditional parts.  
Purpose: Break complex conditionals into smaller methods.  
When to use: When conditionals are long or hard to read.  
Smells: Long Function, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Arrow Code.  
Similar: Replace Nested Conditional with Guard Clauses.

(43) - **Consolidate Conditional Expression (263)**: Combine conditions.  
Purpose: Merge multiple conditions into a single expression.  
When to use: When conditions share a common outcome.  
Smells: Duplicated Code, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Fragmented Logic.  
Similar: Consolidate Duplicate Conditional Fragments.

(44) - **Replace Nested Conditional with Guard Clauses (266)**: Use early returns.  
Purpose: Simplify control flow with early exits.  
When to use: When nested conditionals create deep indentation.  
Smells: Complex Conditional, Arrow Code.  
Anti-refactoring: None.  
Anti-pattern: Arrowhead Code.  
Similar: Decompose Conditional.

(45) - **Replace Conditional with Polymorphism (272)**: Use subclasses for variants.  
Purpose: Replace conditional logic with object-oriented polymorphism.  
When to use: When conditionals switch on type or state.  
Smells: Switch Statements, Type Code.  
Anti-refactoring: None.  
Anti-pattern: Type-Based Logic.  
Similar: Replace Type Code with Subclasses.

(46) - **Introduce Special Case (289)**: Handle special case with object (includes Introduce Null Object).  
Purpose: Replace null checks with a special case object.  
When to use: When null checks are repeated across code.  
Smells: Repeated Null Checks, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Null Hell.  
Similar: Introduce Assertion.

(47) - **Introduce Assertion (302)**: Add runtime checks.  
Purpose: Ensure assumptions about state are valid.  
When to use: When code relies on unchecked conditions.  
Smells: Unverified Assumptions, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Silent Failures.  
Similar: Introduce Special Case.

(48) - **Consolidate Duplicate Conditional Fragments**: Move common code out.  
Purpose: Extract duplicated code from conditional branches.  
When to use: When branches share identical code.  
Smells: Duplicated Code, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Repeated Fragments.  
Similar: Consolidate Conditional Expression.

(49) - **Remove Control Flag**: Replace flag with break/return.  
Purpose: Simplify loops by removing control flags.  
When to use: When flags control loop termination.  
Smells: Control Flag, Long Loop.  
Anti-refactoring: None.  
Anti-pattern: Loop Flags.  
Similar: Replace Loop with Pipeline.

### Refactoring APIs

(50) - **Separate Query from Modifier (306)**: Split side-effect/query.  
Purpose: Separate methods that query from those that modify state.  
When to use: When a method mixes queries and side effects.  
Smells: Side Effects in Queries, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Mutating Getter.  
Similar: Replace Query with Parameter.

(51) - **Parameterize Function (310)**: Generalize with param (includes Parameterize Method).  
Purpose: Generalize similar functions by adding a parameter.  
When to use: When functions differ only by a value.  
Smells: Duplicated Code, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Copied Code.  
Similar: Change Function Declaration.

(52) - **Remove Flag Argument (314)**: Split methods by flag.  
Purpose: Replace boolean flags with separate methods.  
When to use: When a flag changes method behavior significantly.  
Smells: Flag Argument, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Boolean Switch.  
Similar: Replace Parameter with Explicit Methods.

(53) - **Preserve Whole Object (319)**: Pass object not fields.  
Purpose: Pass entire object instead of individual fields.  
When to use: When multiple fields from an object are passed as parameters.  
Smells: Long Parameter List, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Field Extraction.  
Similar: Introduce Parameter Object.

(54) - **Replace Parameter with Query (324)**: Compute param in method.  
Purpose: Remove a parameter by computing its value via a method call.  
When to use: When a parameter can be derived from existing data.  
Smells: Long Parameter List, Feature Envy.  
Anti-refactoring: Replace Query with Parameter.  
Anti-pattern: Dependent Params.  
Similar: None.

(55) - **Replace Query with Parameter (327)**: Move query to param.  
Purpose: Replace a method call with a parameter to reduce dependencies.  
When to use: When a method’s dependency can be externalized as a parameter.  
Smells: Feature Envy, Inappropriate Intimacy.  
Anti-refactoring: Replace Parameter with Query.  
Anti-pattern: Hidden State.  
Similar: None.

(56) - **Remove Setting Method (331)**: Remove setter for immutable.  
Purpose: Eliminate setters for fields that shouldn’t change.  
When to use: When a field is intended to be immutable after creation.  
Smells: Mutable Field, Feature Envy.  
Anti-refactoring: None.  
Anti-pattern: Unnecessary Setter.  
Similar: Encapsulate Variable.

(57) - **Replace Constructor with Factory Function (334)**: Use factory for creation (includes Replace Constructor with Factory Method).  
Purpose: Replace constructor with a factory for flexibility.  
When to use: When object creation needs customization or abstraction.  
Smells: Complex Constructor, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Exposed Creation.  
Similar: Replace Function with Command.

(58) - **Replace Function with Command (337)**: Wrap in command object.  
Purpose: Encapsulate complex function logic in a command object.  
When to use: When a function needs state or complex execution.  
Smells: Long Function, Complex Algorithm.  
Anti-refactoring: Replace Command with Function.  
Anti-pattern: Long Procedural.  
Similar: None.

(59) - **Replace Command with Function (344)**: Unwrap command to function.  
Purpose: Simplify by replacing command object with a function.  
When to use: When a command object is overkill for simple logic.  
Smells: Over-Objectified, Lazy Class.  
Anti-refactoring: Replace Function with Command.  
Anti-pattern: Unnecessary Command.  
Similar: None.

(60) - **Replace Parameter with Explicit Methods**: Split by param value.  
Purpose: Replace parameterized method with specific methods.  
When to use: When a parameter dictates different behaviors.  
Smells: Flag Argument, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Switch on Param.  
Similar: Remove Flag Argument.

(61) - **Hide Method**: Make method private.  
Purpose: Restrict method visibility to reduce coupling.  
When to use: When a method is unnecessarily public.  
Smells: Public Overexposure, Inappropriate Intimacy.  
Anti-refactoring: None.  
Anti-pattern: Leaky Interface.  
Similar: Remove Middle Man.

(62) - **Replace Error Code with Exception**: Use exceptions not codes.  
Purpose: Replace error codes with exceptions for clearer error handling.  
When to use: When methods return error codes instead of throwing exceptions.  
Smells: Error Codes, Complex Conditional.  
Anti-refactoring: Replace Exception with Test.  
Anti-pattern: C-Style Errors.  
Similar: None.

(63) - **Replace Exception with Test**: Use check before op.  
Purpose: Replace exceptions with pre-condition checks.  
When to use: When exceptions are used for normal control flow.  
Smells: Exceptional Control Flow, Complex Conditional.  
Anti-refactoring: Replace Error Code with Exception.  
Anti-pattern: Exception for Control.  
Similar: None.

### Dealing with Inheritance

(64) - **Pull Up Method (350)**: Move method to superclass.  
Purpose: Eliminate duplication by moving shared method to superclass.  
When to use: When subclasses share identical methods.  
Smells: Duplicated Code, Shotgun Surgery.  
Anti-refactoring: Push Down Method.  
Anti-pattern: Copied Subclass Code.  
Similar: Pull Up Field.

(65) - **Pull Up Field (353)**: Move field to superclass.  
Purpose: Share common field across subclasses in superclass.  
When to use: When subclasses duplicate fields.  
Smells: Duplicated Code, Data Clumps.  
Anti-refactoring: Push Down Field.  
Anti-pattern: Parallel Hierarchies.  
Similar: Pull Up Method.

(66) - **Pull Up Constructor Body (355)**: Move constructor code up.  
Purpose: Share constructor logic in superclass.  
When to use: When subclasses duplicate constructor code.  
Smells: Duplicated Code, Shotgun Surgery.  
Anti-refactoring: None.  
Anti-pattern: Subclass Init Dupe.  
Similar: Pull Up Method.

(67) - **Push Down Method (359)**: Move method to subclasses.  
Purpose: Move superclass method to relevant subclasses.  
When to use: When a method is only used by some subclasses.  
Smells: Speculative Generality, Divergent Change.  
Anti-refactoring: Pull Up Method.  
Anti-pattern: Generalization Overuse.  
Similar: Push Down Field.

(68) - **Push Down Field (361)**: Move field to subclasses.  
Purpose: Move superclass field to relevant subclasses.  
When to use: When a field is only used by some subclasses.  
Smells: Speculative Generality, Divergent Change.  
Anti-refactoring: Pull Up Field.  
Anti-pattern: Broad Superclass.  
Similar: Push Down Method.

(69) - **Replace Type Code with Subclasses (362)**: Subclass per type code.  
Purpose: Replace type codes with subclass-specific behavior.  
When to use: When type codes drive conditional logic.  
Smells: Type Code, Switch Statements.  
Anti-refactoring: None.  
Anti-pattern: Primitive Type Switch.  
Similar: Replace Conditional with Polymorphism.

(70) - **Remove Subclass (369)**: Eliminate unused subclass.  
Purpose: Remove unnecessary subclasses to simplify hierarchy.  
When to use: When a subclass adds no value or is unused.  
Smells: Speculative Generality, Lazy Class.  
Anti-refactoring: None.  
Anti-pattern: Dead Hierarchy.  
Similar: Collapse Hierarchy.

(71) - **Extract Superclass (375)**: Create superclass from common.  
Purpose: Extract shared behavior into a superclass.  
When to use: When classes share common methods or fields.  
Smells: Duplicated Code, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Parallel Classes.  
Similar: Extract Subclass.

(72) - **Collapse Hierarchy (380)**: Merge super/subclass.  
Purpose: Simplify by merging unnecessary inheritance levels.  
When to use: When super/subclass have minimal differences.  
Smells: Speculative Generality, Lazy Class.  
Anti-refactoring: None.  
Anti-pattern: Over-Abstracted.  
Similar: Remove Subclass.

(73) - **Replace Subclass with Delegate (381)**: Use delegation not inheritance.  
Purpose: Replace inheritance with composition for flexibility.  
When to use: When inheritance creates tight coupling or violates is-a.  
Smells: Inappropriate Intimacy, Type Code.  
Anti-refactoring: None.  
Anti-pattern: Is-A Violation.  
Similar: Replace Superclass with Delegate.

(74) - **Replace Superclass with Delegate (399)**: Delegate instead of extend.  
Purpose: Use composition to avoid fragile base class issues.  
When to use: When inheriting from a superclass causes maintenance issues.  
Smells: Inappropriate Intimacy, Fragile Base Class.  
Anti-refactoring: None.  
Anti-pattern: Inheritance Abuse.  
Similar: Replace Subclass with Delegate.

(75) - **Extract Subclass**: Create subclass for variant.  
Purpose: Handle variations with dedicated subclasses.  
When to use: When a class has behavior specific to certain cases.  
Smells: Large Class, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Conditional Subclassing.  
Similar: Extract Superclass.

(76) - **Extract Interface**: Extract common interface.  
Purpose: Define a common interface for shared behavior.  
When to use: When multiple classes need a shared contract.  
Smells: Divergent Change, Shotgun Surgery.  
Anti-refactoring: None.  
Anti-pattern: No Interface.  
Similar: Extract Superclass.

(77) - **Form Template Method**: Define skeleton in super.  
Purpose: Share algorithm structure while allowing subclass customization.  
When to use: When subclasses share a similar algorithm with variations.  
Smells: Duplicated Code, Switch Statements.  
Anti-refactoring: None.  
Anti-pattern: Copied Subclass Logic.  
Similar: Replace Conditional with Polymorphism.

(78) - **Replace Inheritance with Delegation**: Use composition.  
Purpose: Replace inheritance with delegation for loose coupling.  
When to use: When inheritance creates unnecessary dependencies.  
Smells: Inappropriate Intimacy, Fragile Base Class.  
Anti-refactoring: Replace Delegation with Inheritance.  
Anti-pattern: Misused Is-A.  
Similar: Replace Subclass with Delegate.

(79) - **Replace Delegation with Inheritance**: Extend instead of delegate.  
Purpose: Simplify by using inheritance when composition is overkill.  
When to use: When delegation adds unnecessary complexity.  
Smells: Speculative Generality, Lazy Class.  
Anti-refactoring: Replace Inheritance with Delegation.  
Anti-pattern: Over-Composition.  
Similar: None.
