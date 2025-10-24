### Basic Refactorings

(1) - **Extract Function (Extract Method) (106)**: Pull code fragment into separate function.  
Smells: Long Function, Duplicated Code.  
Anti-refactoring: Inline Function (Inline Method).  
Anti-pattern: God Object.  
Similar: Extract Variable, Decompose Conditional.

(2) - **Inline Function (Inline Method) (115)**: Replace function call with its body.  
Smells: Unnecessary Abstraction.  
Anti-refactoring: Extract Function (Extract Method).  
Anti-pattern: Over-Abstraction.  
Similar: Inline Variable, Inline Class.

(3) - **Extract Variable (119)**: Pull expression into local variable.  
Smells: Complex Expression.  
Anti-refactoring: Inline Variable.  
Anti-pattern: Magic Inline Code.  
Similar: Extract Function, Replace Temp with Query.

(4) - **Inline Variable (Inline Temp) (123)**: Replace variable references with expression.  
Smells: Unnecessary Temporary.  
Anti-refactoring: Extract Variable.  
Anti-pattern: Overuse of Variables.  
Similar: Inline Function.

(5) - **Change Function Declaration (124)**: Alter function name/parameters.  
Smells: Unclear Function Name, Long Parameter List.  
Anti-refactoring: None.  
Anti-pattern: Cryptic Signatures.  
Similar: Parameterize Function.

(6) - **Encapsulate Variable (132)**: Wrap variable access in functions.  
Smells: Data Clumps, Feature Envy.  
Anti-refactoring: None.  
Anti-pattern: Public Fields.  
Similar: Encapsulate Collection.

(7) - **Rename Variable (137)**: Change variable name for clarity.  
Smells: Unclear Variable Name.  
Anti-refactoring: None.  
Anti-pattern: Cryptic Variables.  
Similar: Change Function Declaration.

(8) - **Introduce Parameter Object (140)**: Group parameters into object.  
Smells: Long Parameter List, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Parameter Soup.  
Similar: Preserve Whole Object.

(9) - **Combine Functions into Class (144)**: Group functions into class.  
Smells: Feature Envy, Shotgun Surgery.  
Anti-refactoring: None.  
Anti-pattern: Procedural Code.  
Similar: Extract Class.

(10) - **Combine Functions into Transform (149)**: Enrich data with derived values.  
Smells: Data Clumps, Primitive Obsession.  
Anti-refactoring: None.  
Anti-pattern: Raw Data Processing.  
Similar: Split Phase.

(11) - **Split Phase (154)**: Separate code phases.  
Smells: Long Function, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Monolithic Processing.  
Similar: Split Loop.

### Encapsulation

(12) - **Encapsulate Record (162)**: Wrap record in class.  
Smells: Primitive Obsession, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Naked Data.  
Similar: Replace Primitive with Object.

(13) - **Encapsulate Collection (170)**: Make collection read-only with add/remove.  
Smells: Mutable Collection Exposure.  
Anti-refactoring: None.  
Anti-pattern: Leaky Abstraction.  
Similar: Encapsulate Variable.

(14) - **Replace Primitive with Object (174)**: Turn primitive into class.  
Smells: Primitive Obsession, Type Code.  
Anti-refactoring: None.  
Anti-pattern: Type Abuse.  
Similar: Replace Array with Object.

(15) - **Replace Temp with Query (178)**: Turn temp into method.  
Smells: Temporary Field, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Inline Computation.  
Similar: Extract Variable.

(16) - **Extract Class (182)**: Split class responsibilities.  
Smells: Large Class, Divergent Change.  
Anti-refactoring: Inline Class.  
Anti-pattern: God Class.  
Similar: Move Function, Move Field.

(17) - **Inline Class (186)**: Merge class into another.  
Smells: Lazy Class, Speculative Generality.  
Anti-refactoring: Extract Class.  
Anti-pattern: Over-Abstraction.  
Similar: Inline Function.

(18) - **Hide Delegate (189)**: Hide delegation chain.  
Smells: Message Chains, Feature Envy.  
Anti-refactoring: Remove Middle Man.  
Anti-pattern: Law of Demeter Violation.  
Similar: None.

(19) - **Remove Middle Man (192)**: Expose delegate directly.  
Smells: Middle Man, Inappropriate Intimacy.  
Anti-refactoring: Hide Delegate.  
Anti-pattern: Unnecessary Hiding.  
Similar: None.

(20) - **Substitute Algorithm (195)**: Replace algorithm with clearer one.  
Smells: Complex Algorithm, Obscure Code.  
Anti-refactoring: None.  
Anti-pattern: Obscure Logic.  
Similar: Replace Conditional with Polymorphism.

### Moving Features

(21) - **Move Function (198)**: Relocate function to better class.  
Smells: Feature Envy, Inappropriate Intimacy.  
Anti-refactoring: None.  
Anti-pattern: Wrong Location.  
Similar: Move Field.

(22) - **Move Field (207)**: Relocate field to better class.  
Smells: Feature Envy, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Data Envy.  
Similar: Move Function.

(23) - **Move Statements into Function (213)**: Pull statements into called function.  
Smells: Duplicated Code, Long Function.  
Anti-refactoring: Move Statements to Callers.  
Anti-pattern: Fragmented Logic.  
Similar: Slide Statements.

(24) - **Move Statements to Callers (217)**: Push statements out to callers.  
Smells: Divergent Change, Shotgun Surgery.  
Anti-refactoring: Move Statements into Function.  
Anti-pattern: Over-General Function.  
Similar: None.

(25) - **Replace Inline Code with Function Call (222)**: Swap code with function call.  
Smells: Duplicated Code, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Inline Duplication.  
Similar: Extract Function.

(26) - **Slide Statements (223)**: Reorder code statements.  
Smells: Poor Code Flow, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Illogical Order.  
Similar: Split Loop.

(27) - **Split Loop (227)**: Separate loop concerns.  
Smells: Long Loop, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Multi-Purpose Loop.  
Similar: Replace Loop with Pipeline.

(28) - **Replace Loop with Pipeline (231)**: Use collection pipeline.  
Smells: Long Loop, Imperative Code.  
Anti-refactoring: None.  
Anti-pattern: Old-Style Iteration.  
Similar: Split Loop.

(29) - **Remove Dead Code (237)**: Delete unused code.  
Smells: Dead Code, Speculative Generality.  
Anti-refactoring: None.  
Anti-pattern: Zombie Code.  
Similar: None.

(30) - **Introduce Foreign Method**: Add method to unmodifiable class.  
Smells: Incomplete Library Class.  
Anti-refactoring: None.  
Anti-pattern: Monkey Patching.  
Similar: Introduce Local Extension.

(31) - **Introduce Local Extension**: Extend external class locally.  
Smells: Incomplete Library Class.  
Anti-refactoring: None.  
Anti-pattern: Monkey Patching.  
Similar: Introduce Foreign Method.

### Organizing Data

(32) - **Split Variable (240)**: Separate variable uses.  
Smells: Divergent Change, Temporary Field.  
Anti-refactoring: None.  
Anti-pattern: Overloaded Temp.  
Similar: Replace Temp with Query.

(33) - **Replace Derived Variable with Query (248)**: Compute on-demand.  
Smells: Temporary Field, Mutable Derived Data.  
Anti-refactoring: None.  
Anti-pattern: Cached Inconsistency.  
Similar: Replace Temp with Query.

(34) - **Change Reference to Value (252)**: Make immutable value object.  
Smells: Mutable Reference, Inappropriate Intimacy.  
Anti-refactoring: Change Value to Reference.  
Anti-pattern: Shared Mutable.  
Similar: None.

(35) - **Change Value to Reference (256)**: Use shared reference object.  
Smells: Duplicated Objects, Data Clumps.  
Anti-refactoring: Change Reference to Value.  
Anti-pattern: Flyweight Missing.  
Similar: None.

(36) - **Duplicate Observed Data**: Sync GUI/domain data.  
Smells: Feature Envy, Inappropriate Intimacy.  
Anti-refactoring: None.  
Anti-pattern: Presentation Logic in Domain.  
Similar: None.

(37) - **Replace Array with Object**: Turn array into class.  
Smells: Primitive Obsession, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Array as Struct.  
Similar: Replace Primitive with Object.

(38) - **Change Unidirectional Association to Bidirectional**: Add backpointer.  
Smells: Inappropriate Intimacy, Incomplete Navigation.  
Anti-refactoring: Change Bidirectional to Unidirectional.  
Anti-pattern: One-Way Link.  
Similar: None.

(39) - **Change Bidirectional Association to Unidirectional**: Remove backpointer.  
Smells: Inappropriate Intimacy, Shotgun Surgery.  
Anti-refactoring: Change Unidirectional to Bidirectional.  
Anti-pattern: Over-Coupled.  
Similar: None.

(40) - **Replace Magic Number with Symbolic Constant**: Use constant for literal.  
Smells: Magic Number, Duplicated Code.  
Anti-refactoring: None.  
Anti-pattern: Hardcoded Values.  
Similar: Replace Primitive with Object.

(41) - **Remove Assignments to Parameters**: Use local for mods.  
Smells: Modified Parameter, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Side-Effecting Params.  
Similar: Split Variable.

### Simplifying Conditional Logic

(42) - **Decompose Conditional (260)**: Extract conditional parts.  
Smells: Long Function, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Arrow Code.  
Similar: Replace Nested Conditional with Guard Clauses.

(43) - **Consolidate Conditional Expression (263)**: Combine conditions.  
Smells: Duplicated Code, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Fragmented Logic.  
Similar: Consolidate Duplicate Conditional Fragments.

(44) - **Replace Nested Conditional with Guard Clauses (266)**: Use early returns.  
Smells: Complex Conditional, Arrow Code.  
Anti-refactoring: None.  
Anti-pattern: Arrowhead Code.  
Similar: Decompose Conditional.

(45) - **Replace Conditional with Polymorphism (272)**: Use subclasses for variants.  
Smells: Switch Statements, Type Code.  
Anti-refactoring: None.  
Anti-pattern: Type-Based Logic.  
Similar: Replace Type Code with Subclasses.

(46) - **Introduce Special Case (289)**: Handle special case with object.  
Smells: Repeated Null Checks, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Null Hell.  
Similar: Introduce Assertion.

(47) - **Introduce Assertion (302)**: Add runtime checks.  
Smells: Unverified Assumptions, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Silent Failures.  
Similar: Introduce Special Case.

(48) - **Consolidate Duplicate Conditional Fragments**: Move common code out.  
Smells: Duplicated Code, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Repeated Fragments.  
Similar: Consolidate Conditional Expression.

(49) - **Remove Control Flag**: Replace flag with break/return.  
Smells: Control Flag, Long Loop.  
Anti-refactoring: None.  
Anti-pattern: Loop Flags.  
Similar: Replace Loop with Pipeline.

### Refactoring APIs

(50) - **Separate Query from Modifier (306)**: Split side-effect/query.  
Smells: Side Effects in Queries, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Mutating Getter.  
Similar: Replace Query with Parameter.

(51) - **Parameterize Function (310)**: Generalize with param.  
Smells: Duplicated Code, Long Function.  
Anti-refactoring: None.  
Anti-pattern: Copied Code.  
Similar: Change Function Declaration.

(52) - **Remove Flag Argument (314)**: Split methods by flag.  
Smells: Flag Argument, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Boolean Switch.  
Similar: Replace Parameter with Explicit Methods.

(53) - **Preserve Whole Object (319)**: Pass object not fields.  
Smells: Long Parameter List, Data Clumps.  
Anti-refactoring: None.  
Anti-pattern: Field Extraction.  
Similar: Introduce Parameter Object.

(54) - **Replace Parameter with Query (324)**: Compute param in method.  
Smells: Long Parameter List, Feature Envy.  
Anti-refactoring: Replace Query with Parameter.  
Anti-pattern: Dependent Params.  
Similar: None.

(55) - **Replace Query with Parameter (327)**: Move query to param.  
Smells: Feature Envy, Inappropriate Intimacy.  
Anti-refactoring: Replace Parameter with Query.  
Anti-pattern: Hidden State.  
Similar: None.

(56) - **Remove Setting Method (331)**: Remove setter for immutable.  
Smells: Mutable Field, Feature Envy.  
Anti-refactoring: None.  
Anti-pattern: Unnecessary Setter.  
Similar: Encapsulate Variable.

(57) - **Replace Constructor with Factory Function (334)**: Use factory for creation.  
Smells: Complex Constructor, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Exposed Creation.  
Similar: Replace Function with Command.

(58) - **Replace Function with Command (337)**: Wrap in command object.  
Smells: Long Function, Complex Algorithm.  
Anti-refactoring: Replace Command with Function.  
Anti-pattern: Long Procedural.  
Similar: None.

(59) - **Replace Command with Function (344)**: Unwrap command to function.  
Smells: Over-Objectified, Lazy Class.  
Anti-refactoring: Replace Function with Command.  
Anti-pattern: Unnecessary Command.  
Similar: None.

(60) - **Replace Parameter with Explicit Methods**: Split by param value.  
Smells: Flag Argument, Complex Conditional.  
Anti-refactoring: None.  
Anti-pattern: Switch on Param.  
Similar: Remove Flag Argument.

(61) - **Hide Method**: Make method private.  
Smells: Public Overexposure, Inappropriate Intimacy.  
Anti-refactoring: None.  
Anti-pattern: Leaky Interface.  
Similar: Remove Middle Man.

(62) - **Replace Error Code with Exception**: Use exceptions not codes.  
Smells: Error Codes, Complex Conditional.  
Anti-refactoring: Replace Exception with Test.  
Anti-pattern: C-Style Errors.  
Similar: None.

(63) - **Replace Exception with Test**: Use check before op.  
Smells: Exceptional Control Flow, Complex Conditional.  
Anti-refactoring: Replace Error Code with Exception.  
Anti-pattern: Exception for Control.  
Similar: None.

### Dealing with Inheritance

(64) - **Pull Up Method (350)**: Move method to superclass.  
Smells: Duplicated Code, Shotgun Surgery.  
Anti-refactoring: Push Down Method.  
Anti-pattern: Copied Subclass Code.  
Similar: Pull Up Field.

(65) - **Pull Up Field (353)**: Move field to superclass.  
Smells: Duplicated Code, Data Clumps.  
Anti-refactoring: Push Down Field.  
Anti-pattern: Parallel Hierarchies.  
Similar: Pull Up Method.

(66) - **Pull Up Constructor Body (355)**: Move constructor code up.  
Smells: Duplicated Code, Shotgun Surgery.  
Anti-refactoring: None.  
Anti-pattern: Subclass Init Dupe.  
Similar: Pull Up Method.

(67) - **Push Down Method (359)**: Move method to subclasses.  
Smells: Speculative Generality, Divergent Change.  
Anti-refactoring: Pull Up Method.  
Anti-pattern: Generalization Overuse.  
Similar: Push Down Field.

(68) - **Push Down Field (361)**: Move field to subclasses.  
Smells: Speculative Generality, Divergent Change.  
Anti-refactoring: Pull Up Field.  
Anti-pattern: Broad Superclass.  
Similar: Push Down Method.

(69) - **Replace Type Code with Subclasses (362)**: Subclass per type code.  
Smells: Type Code, Switch Statements.  
Anti-refactoring: None.  
Anti-pattern: Primitive Type Switch.  
Similar: Replace Conditional with Polymorphism.

(70) - **Remove Subclass (369)**: Eliminate unused subclass.  
Smells: Speculative Generality, Lazy Class.  
Anti-refactoring: None.  
Anti-pattern: Dead Hierarchy.  
Similar: Collapse Hierarchy.

(71) - **Extract Superclass (375)**: Create superclass from common.  
Smells: Duplicated Code, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Parallel Classes.  
Similar: Extract Subclass.

(72) - **Collapse Hierarchy (380)**: Merge super/subclass.  
Smells: Speculative Generality, Lazy Class.  
Anti-refactoring: None.  
Anti-pattern: Over-Abstracted.  
Similar: Remove Subclass.

(73) - **Replace Subclass with Delegate (381)**: Use delegation not inheritance.  
Smells: Inappropriate Intimacy, Type Code.  
Anti-refactoring: None.  
Anti-pattern: Is-A Violation.  
Similar: Replace Superclass with Delegate.

(74) - **Replace Superclass with Delegate (399)**: Delegate instead of extend.  
Smells: Inappropriate Intimacy, Fragile Base Class.  
Anti-refactoring: None.  
Anti-pattern: Inheritance Abuse.  
Similar: Replace Subclass with Delegate.

(75) - **Extract Subclass**: Create subclass for variant.  
Smells: Large Class, Divergent Change.  
Anti-refactoring: None.  
Anti-pattern: Conditional Subclassing.  
Similar: Extract Superclass.

(76) - **Extract Interface**: Extract common interface.  
Smells: Divergent Change, Shotgun Surgery.  
Anti-refactoring: None.  
Anti-pattern: No Interface.  
Similar: Extract Superclass.

(77) - **Form Template Method**: Define skeleton in super.  
Smells: Duplicated Code, Switch Statements.  
Anti-refactoring: None.  
Anti-pattern: Copied Subclass Logic.  
Similar: Replace Conditional with Polymorphism.

(78) - **Replace Inheritance with Delegation**: Use composition.  
Smells: Inappropriate Intimacy, Fragile Base Class.  
Anti-refactoring: Replace Delegation with Inheritance.  
Anti-pattern: Misused Is-A.  
Similar: Replace Subclass with Delegate.

(79) - **Replace Delegation with Inheritance**: Extend instead of delegate.  
Smells: Speculative Generality, Lazy Class.  
Anti-refactoring: Replace Inheritance with Delegation.  
Anti-pattern: Over-Composition.  
Similar: None.