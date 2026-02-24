# Cracking the Coding Interview — Complete Learning Guide with Claude
## For Flutter/Dart Developers | From Zero to Interview Expert

---

## PROJECT SETUP INSTRUCTIONS

### Step 1: Create a Claude Project
Go to claude.ai → Projects → New Project → Name it: **"CTCI Interview Mastery"**

### Step 2: Paste This as Project Custom Instructions

```
You are my personal coding interview coach. I am a Flutter/Dart developer preparing for software engineering interviews.

RULES:
1. Teach me everything from "Cracking the Coding Interview" — topic by topic, chapter by chapter.
2. Always explain concepts in simple language FIRST with real-world analogies, then go technical.
3. Show all code examples in DART (primary) and PYTHON (secondary — widely used in interviews).
4. For every data structure or algorithm, always explain:
   - What it is (simple analogy)
   - Why it exists (what problem it solves)
   - How it works internally (step-by-step with visual text diagrams)
   - Time & Space complexity (Big O) with WHY, not just the answer
   - When to use it in interviews (pattern recognition)
   - Common mistakes and edge cases
   - Real-world Flutter/mobile use cases
5. When I ask you to solve a problem:
   - First, ask me if I want hints or the full solution
   - If hints: give me 3 progressive hints (small → medium → big)
   - If full solution: walk me through your THOUGHT PROCESS step by step before writing code
   - Always show: brute force first → then optimize → then the optimal solution
   - Always analyze time/space complexity for each approach
6. When I say "quiz me" — give me 5-10 questions mixing conceptual + coding + tricky edge cases
7. When I say "mock interview" — act as a strict FAANG interviewer. Grade me on: problem solving, code quality, communication, edge cases, optimization
8. When I say "next topic" — move to the next topic in the CTCI curriculum order
9. If I paste code, review it like a senior engineer: find bugs, suggest improvements, check edge cases
10. Track my progress. At the start of each session, briefly remind me where I left off.
11. If I say "explain like I'm 5" — use the simplest possible explanation with everyday analogies
12. If I say "go deeper" — give me the advanced/internal implementation details
13. Always encourage me but be honest about gaps in my understanding
```

---

## COMPLETE CURRICULUM — TOPIC BY TOPIC

Use these prompts in order. Copy-paste each one when you're ready for that topic.

---

### PHASE 1: FOUNDATIONS (Week 1-2)

---

#### TOPIC 0: The Interview Process & Big O

**Prompt:**
```
Let's start from the very beginning.

Teach me:
1. How the technical interview process works at top companies (Google, Meta, Amazon, Apple, Microsoft)
   - What rounds to expect
   - What interviewers are actually evaluating
   - How to structure my answer during a live interview

2. The CTCI "7-Step Approach" to solving any coding problem:
   - Listen carefully
   - Draw an example
   - State the brute force
   - Optimize (BUD: Bottlenecks, Unnecessary work, Duplicated work)
   - Walk through the approach
   - Write code
   - Test

3. Big O Notation — from absolute zero:
   - What is time complexity? What is space complexity?
   - O(1), O(log n), O(n), O(n log n), O(n^2), O(2^n), O(n!) — explain each with real-world analogies
   - How to calculate Big O for any code (with 5 examples, easy to hard)
   - Amortized time complexity
   - Best case, worst case, average case
   - Space complexity with recursion (call stack)
   - Common mistakes people make with Big O

Give me 5 practice exercises where I calculate the Big O of code snippets.
```

---

#### TOPIC 1: Arrays & Strings

**Prompt:**
```
Teach me Arrays & Strings for coding interviews — complete coverage.

PART A — CONCEPT:
1. How arrays work in memory (contiguous memory, indexing)
2. Static vs Dynamic arrays — how dynamic arrays resize (amortized doubling)
3. Strings as character arrays — immutability in Dart
4. List<> in Dart — how it works internally
5. StringBuilder / StringBuffer in Dart — when and why to use

PART B — ESSENTIAL TECHNIQUES (teach each with an example):
1. Two Pointer technique (same direction & opposite direction)
2. Sliding Window technique
3. Hash Map / Hash Set for O(1) lookups
4. Frequency counting / character counting
5. In-place array manipulation
6. String manipulation techniques (reverse, palindrome, anagram, permutation)
7. Matrix/2D array traversal
8. Prefix sum technique
9. Sorting + Two pointers combo

PART C — PROBLEMS:
Give me 10 problems in increasing difficulty (easy → medium → hard).
For the first 3, walk me through the complete thought process.
For the remaining 7, let me try first — I'll ask for hints if stuck.

PART D — PATTERNS:
What are the top "signals" in a problem statement that tell me to use each technique?
Create a cheat sheet: "When you see X in the problem → use Y technique"
```

---

#### TOPIC 2: Linked Lists

**Prompt:**
```
Teach me Linked Lists — complete interview coverage.

PART A — CONCEPT:
1. What is a Linked List? Explain with a real-world analogy
2. Singly vs Doubly vs Circular Linked Lists — with text diagrams
3. How it differs from Array in memory (visual comparison)
4. Node structure in Dart — implement from scratch
5. When to use Linked List vs Array/List in real applications

PART B — ESSENTIAL OPERATIONS (implement each in Dart):
1. Insert at head, tail, middle
2. Delete a node (by value, by position)
3. Search for a value
4. Reverse a linked list (iterative AND recursive — this is asked in 90% of interviews)
5. Find the middle node (slow/fast pointer)
6. Detect a cycle (Floyd's algorithm — explain step by step)
7. Find cycle start point
8. Merge two sorted linked lists
9. Remove duplicates (sorted and unsorted)

PART C — THE RUNNER TECHNIQUE:
Explain the "runner" (fast/slow pointer) technique in detail with 3 different applications.

PART D — PROBLEMS:
Give me 8 problems (easy → hard). Walk me through the first 2 completely.

PART E — COMMON INTERVIEW MISTAKES:
What mistakes do candidates make with Linked List problems? How to avoid them?
```

---

#### TOPIC 3: Stacks & Queues

**Prompt:**
```
Teach me Stacks & Queues — complete interview coverage.

PART A — CONCEPTS:
1. Stack (LIFO) — explain with real-world analogy, implement in Dart from scratch
2. Queue (FIFO) — explain with real-world analogy, implement in Dart from scratch
3. Deque (Double-ended queue) — when to use
4. Priority Queue / Min-Heap / Max-Heap — concept overview (we'll deep dive later)
5. How the call stack works (critical for understanding recursion)

PART B — ESSENTIAL TECHNIQUES:
1. Using stack for matching brackets/parentheses
2. Monotonic stack — what it is, when to use
3. Using stack to simulate recursion
4. Queue for BFS (breadth-first search) — preview
5. Implementing a queue using two stacks
6. Implementing a stack using two queues
7. Min Stack (stack that supports getMin in O(1))
8. Stack for expression evaluation (infix, postfix)

PART C — PROBLEMS:
Give me 8 problems. Walk me through the first 2 completely.

PART D — FLUTTER CONNECTION:
Where are stacks/queues used in Flutter? (Navigator stack, event queue, etc.)
```

---

### PHASE 2: CORE DATA STRUCTURES (Week 3-5)

---

#### TOPIC 4: Hash Tables / Hash Maps

**Prompt:**
```
Teach me Hash Tables — complete interview coverage.

1. How hashing works internally (hash function → index → bucket)
2. Collision handling: chaining vs open addressing — with diagrams
3. Load factor and rehashing
4. Map<> and Set<> in Dart — internal implementation
5. LinkedHashMap in Dart — why insertion order matters
6. Time complexity: average O(1) vs worst case O(n) — when does worst case happen?

TECHNIQUES:
1. Two Sum pattern (most classic hash map problem)
2. Frequency counting pattern
3. Grouping/bucketing pattern (group anagrams, etc.)
4. Hash Set for O(1) existence check
5. Hash Map as cache / memoization

Give me 8 problems (easy → hard) that use hash maps. Walk me through the first 2.
```

---

#### TOPIC 5: Trees & Binary Search Trees

**Prompt:**
```
Teach me Trees — this is a HUGE interview topic, so be thorough.

PART A — TREE BASICS:
1. What is a tree? Terminology (root, leaf, parent, child, height, depth, level)
2. Binary Tree vs Binary Search Tree (BST) — the key difference
3. Balanced vs Unbalanced trees — why it matters for Big O
4. Complete, Full, Perfect binary trees — differences with diagrams
5. Implement a binary tree node in Dart

PART B — TREE TRAVERSALS (implement ALL in Dart, both recursive and iterative):
1. In-order (Left, Root, Right) — produces sorted output for BST
2. Pre-order (Root, Left, Right) — used for serialization
3. Post-order (Left, Root, Right) — used for deletion
4. Level-order / BFS (using queue) — level by level
5. When to use which traversal — decision guide

PART C — BST OPERATIONS:
1. Insert into BST
2. Search in BST
3. Delete from BST (3 cases — this is tricky, explain each)
4. Find min/max
5. Validate if a tree is a valid BST
6. Find successor / predecessor

PART D — ESSENTIAL TREE TECHNIQUES:
1. Recursion on trees — the "trust the recursion" mental model
2. Height/depth calculation
3. Diameter of a tree
4. Lowest Common Ancestor (LCA)
5. Path sum problems
6. Serialize/deserialize a tree
7. Convert sorted array to balanced BST
8. Check if two trees are identical / mirror

PART E — PROBLEMS:
Give me 12 problems (4 easy, 4 medium, 4 hard). Walk me through the first 3.
```

---

#### TOPIC 6: Heaps & Priority Queues

**Prompt:**
```
Teach me Heaps & Priority Queues — complete coverage.

1. What is a heap? Min-heap vs Max-heap — with visual tree diagrams
2. How a heap is stored in an array (parent/child index formulas)
3. Heap operations: insert (bubble up), extract min/max (bubble down) — step by step
4. Heapify — building a heap from array in O(n)
5. Implement a MinHeap in Dart from scratch
6. Dart's built-in approach to priority queues

KEY PATTERNS:
1. Top K elements (use min-heap of size K)
2. Kth largest/smallest element
3. Merge K sorted lists
4. Median from data stream (two heaps technique)
5. Task scheduling problems

Give me 6 problems. Walk me through the first 2.
```

---

#### TOPIC 7: Graphs

**Prompt:**
```
Teach me Graphs — complete interview coverage. This is critical.

PART A — CONCEPTS:
1. What is a graph? Real-world examples (social networks, maps, etc.)
2. Directed vs Undirected graphs
3. Weighted vs Unweighted graphs
4. Cyclic vs Acyclic graphs
5. Connected components
6. Graph representations: Adjacency List vs Adjacency Matrix — when to use which
7. Implement both representations in Dart

PART B — GRAPH TRAVERSALS:
1. BFS (Breadth-First Search) — implement in Dart with step-by-step walkthrough
   - When to use BFS (shortest path in unweighted graph)
2. DFS (Depth-First Search) — implement in Dart (recursive AND iterative)
   - When to use DFS (path finding, cycle detection, topological sort)
3. BFS vs DFS — comparison table with use cases

PART C — ESSENTIAL GRAPH ALGORITHMS:
1. Detect cycle in directed graph (DFS with coloring)
2. Detect cycle in undirected graph
3. Topological Sort (Kahn's BFS + DFS approach) — for job scheduling, course prerequisites
4. Shortest path: Dijkstra's algorithm — step by step
5. Connected components — counting islands pattern
6. Union-Find / Disjoint Set — concept and implementation
7. Bipartite graph check

PART D — GRAPH PATTERNS FOR INTERVIEWS:
1. "Number of Islands" pattern (grid as graph)
2. "Course Schedule" pattern (topological sort)
3. "Word Ladder" pattern (BFS shortest path)
4. "Clone Graph" pattern (BFS/DFS with hash map)
5. Matrix traversal as graph problems

Give me 10 problems. Walk me through the first 3.
```

---

#### TOPIC 8: Tries (Prefix Trees)

**Prompt:**
```
Teach me Tries (Prefix Trees) — complete coverage.

1. What is a Trie? Real-world analogy (autocomplete, dictionary)
2. How it works internally — with visual text diagram
3. Implement a Trie in Dart from scratch with: insert, search, startsWith
4. Time & space complexity analysis
5. When to use Trie vs Hash Map — decision guide

PROBLEMS:
1. Implement autocomplete system
2. Word search in a board
3. Design a search suggestion system
4. Longest common prefix

Walk me through 2 problems completely.
```

---

### PHASE 3: ALGORITHMS (Week 6-9)

---

#### TOPIC 9: Sorting & Searching

**Prompt:**
```
Teach me Sorting & Searching algorithms — interview-ready.

SORTING (implement each in Dart, explain with visual step-by-step):
1. Bubble Sort — O(n^2) — just to understand, never use in interviews
2. Selection Sort — O(n^2)
3. Insertion Sort — O(n^2) — when is it actually useful?
4. Merge Sort — O(n log n) — most important! Explain divide & conquer
5. Quick Sort — O(n log n) avg — partition scheme, pivot selection
6. Counting Sort — O(n+k) — when to use (small range integers)
7. Radix Sort — concept
8. Comparison of all sorting algorithms — table with time, space, stability

SEARCHING:
1. Linear Search — O(n)
2. Binary Search — O(log n) — implement iterative AND recursive
3. Binary Search variations:
   - Find first/last occurrence
   - Search in rotated sorted array
   - Find peak element
   - Search in 2D sorted matrix
   - Binary search on answer (min/max problems)

Give me 10 problems (5 sorting, 5 binary search). Walk me through the first 3.
```

---

#### TOPIC 10: Recursion & Backtracking

**Prompt:**
```
Teach me Recursion & Backtracking — many candidates struggle here, make it crystal clear.

PART A — RECURSION FUNDAMENTALS:
1. What is recursion? The simplest analogy possible
2. Base case vs recursive case — why base case is critical
3. How the call stack works — draw it step by step for factorial(5)
4. Stack overflow — when it happens and how to prevent
5. Recursion vs Iteration — when to choose which
6. Tail recursion — what it is, does Dart support it?
7. Memoization — recursion + caching = power

PRACTICE RECURSION (implement each, trace the call stack):
1. Factorial
2. Fibonacci (naive → memoized → bottom-up)
3. Power function
4. String reversal
5. Tower of Hanoi — explain step by step
6. All subsets of a set
7. All permutations of a string

PART B — BACKTRACKING:
1. What is backtracking? The "choose → explore → unchoose" pattern
2. Decision tree visualization — draw it for a simple example
3. Template for backtracking problems in Dart

BACKTRACKING PROBLEMS:
1. Generate all permutations
2. Generate all subsets (power set)
3. N-Queens problem
4. Sudoku solver
5. Word search in grid
6. Combination sum
7. Generate valid parentheses

Walk me through 3 problems completely with decision tree diagrams.
```

---

#### TOPIC 11: Dynamic Programming (THE HARDEST TOPIC)

**Prompt:**
```
Teach me Dynamic Programming — this is where most people fail. Make it simple and build my intuition.

PART A — UNDERSTANDING DP:
1. What is Dynamic Programming? Simplest possible explanation
2. The TWO properties that tell you it's a DP problem:
   - Optimal substructure
   - Overlapping subproblems
3. Top-down (memoization) vs Bottom-up (tabulation) — explain both with same example
4. How to identify a DP problem in an interview (signals in the problem statement)
5. The 5-step DP framework:
   - Define the state
   - Define the recurrence relation
   - Define base cases
   - Define the computation order
   - Optimize space if possible

PART B — DP PATTERNS (teach each pattern with 2 examples):

Pattern 1: LINEAR DP
- Climbing Stairs
- House Robber
- Maximum Subarray (Kadane's algorithm)

Pattern 2: KNAPSACK PATTERN
- 0/1 Knapsack
- Subset Sum
- Coin Change (minimum coins)
- Coin Change 2 (number of ways)

Pattern 3: STRING DP
- Longest Common Subsequence (LCS)
- Longest Palindromic Substring
- Edit Distance
- String interleaving

Pattern 4: GRID DP
- Unique Paths
- Minimum Path Sum
- Maximal Square

Pattern 5: INTERVAL DP
- Matrix Chain Multiplication
- Burst Balloons

Pattern 6: DECISION MAKING DP
- Best Time to Buy and Sell Stock (all variations)
- Paint House

PART C — THE DP PROBLEM SOLVING METHOD:
For each problem, show me:
1. Brute force recursive solution first
2. Add memoization (top-down)
3. Convert to tabulation (bottom-up)
4. Optimize space

Give me 15 problems organized by pattern. Walk me through 5 completely.
```

---

#### TOPIC 12: Greedy Algorithms

**Prompt:**
```
Teach me Greedy Algorithms — when and how to use them.

1. What makes an algorithm "greedy"? Simple analogy
2. Greedy vs Dynamic Programming — how to decide which to use
3. When does greedy work? (Greedy choice property + Optimal substructure)
4. When does greedy FAIL? (show an example where greedy gives wrong answer)

KEY PROBLEMS:
1. Activity/Interval scheduling
2. Fractional Knapsack
3. Jump Game
4. Gas Station
5. Task Scheduler
6. Minimum number of platforms/meeting rooms
7. Huffman Coding — concept

Walk me through 3 problems completely.
```

---

#### TOPIC 13: Bit Manipulation

**Prompt:**
```
Teach me Bit Manipulation for interviews.

1. Binary number system — quick refresher
2. Bitwise operators: AND, OR, XOR, NOT, Left Shift, Right Shift — with examples
3. Common bit tricks:
   - Check if number is even/odd
   - Check if number is power of 2
   - Count set bits
   - Toggle a specific bit
   - Get/set/clear a bit at position
   - XOR properties (a ^ a = 0, a ^ 0 = a)
4. Two's complement — how negative numbers work in binary

KEY PROBLEMS:
1. Single Number (find the one non-duplicate using XOR)
2. Number of 1 bits
3. Reverse bits
4. Missing number
5. Power of two
6. Counting bits

Walk me through 3 problems.
```

---

### PHASE 4: SYSTEM DESIGN & ADVANCED (Week 10-12)

---

#### TOPIC 14: Object-Oriented Design

**Prompt:**
```
Teach me Object-Oriented Design for interviews — focused on Dart/Flutter.

1. OOP Principles: Encapsulation, Abstraction, Inheritance, Polymorphism — with Dart examples
2. SOLID Principles — explain each with a Flutter/Dart example
3. Common Design Patterns used in interviews:
   - Singleton (with Dart implementation)
   - Factory
   - Observer
   - Strategy
   - Builder
   - Adapter
4. How to approach OOD interview questions — the step-by-step method

PRACTICE DESIGN PROBLEMS:
1. Design a Parking Lot system
2. Design a Deck of Cards
3. Design a Chat system (classes only)
4. Design a File System
5. Design an LRU Cache — implement in Dart

Walk me through 2 design problems completely.
```

---

#### TOPIC 15: System Design Basics

**Prompt:**
```
Teach me System Design basics for interviews.

1. How to approach a system design interview — the framework:
   - Clarify requirements (functional & non-functional)
   - Estimate scale (users, data, requests per second)
   - Define API
   - Design high-level architecture
   - Deep dive into components
   - Address bottlenecks

2. KEY CONCEPTS (explain each simply):
   - Client-Server architecture
   - Load Balancing
   - Caching (Redis, CDN)
   - Database: SQL vs NoSQL — when to use which
   - Database indexing & sharding
   - Message Queues (Kafka, RabbitMQ)
   - Microservices vs Monolith
   - REST vs GraphQL
   - WebSockets (relevant for Flutter!)
   - CAP Theorem
   - Consistent Hashing
   - Rate Limiting
   - API Gateway

3. PRACTICE DESIGNS:
   - Design a URL shortener (like bit.ly)
   - Design a chat application (relevant for Flutter)
   - Design Instagram/Twitter feed
   - Design a notification system
   - Design a ride-sharing app

Walk me through 2 system designs step by step.
```

---

#### TOPIC 16: Behavioral Interview

**Prompt:**
```
Prepare me for behavioral interviews.

1. The STAR method: Situation, Task, Action, Result — with examples
2. Help me prepare answers for these common questions:
   - Tell me about yourself (as a Flutter developer)
   - Tell me about a challenging technical problem you solved
   - Tell me about a time you disagreed with your team
   - Tell me about a project you're most proud of
   - Why do you want to leave your current company?
   - Where do you see yourself in 5 years?
   - Tell me about a time you failed
   - How do you handle tight deadlines?
   - Tell me about a time you had to learn something quickly

3. Questions to ask the interviewer — give me 10 good ones

For each question, give me a template answer structure. Then I'll practice with my own experiences.
```

---

### PHASE 5: MOCK INTERVIEWS & MASTERY (Week 13+)

---

#### MOCK INTERVIEW PROMPTS

**Easy Mock Interview:**
```
Conduct a 45-minute mock coding interview for a mid-level Flutter developer position.
- Give me 1 easy + 1 medium problem
- Time me (tell me when 20 minutes have passed for the first problem)
- Act as a helpful interviewer who gives small hints if I'm stuck
- After each problem, give me detailed feedback:
  - Communication: Did I explain my thinking?
  - Correctness: Does my code work?
  - Efficiency: Is the Big O optimal?
  - Edge cases: Did I handle them?
  - Code quality: Is it clean and readable?
- Give me a score out of 10 and tell me if I would pass
```

**Hard Mock Interview:**
```
Conduct a strict FAANG-level coding interview.
- Give me 1 medium + 1 hard problem
- Don't give hints unless I explicitly ask
- Evaluate me strictly — as a Google/Meta interviewer would
- Grade me: Strong Hire / Hire / Lean Hire / Lean No Hire / No Hire
- Tell me exactly what I need to improve
```

**System Design Mock:**
```
Conduct a system design interview.
- Give me a design problem
- Let me drive the conversation
- Ask follow-up questions like a real interviewer
- Challenge my design choices
- After 30 minutes, give me detailed feedback
```

---

## DAILY STUDY PROMPTS

### Quick Start (paste this every day):

```
Let's continue my CTCI study session. Quick recap:
1. Quiz me on what we covered last time (5 quick questions)
2. Then let's move to the next topic
```

### Weekend Review:

```
It's review day. Let's review everything I've learned this week:
1. Give me 10 mixed questions from all topics we covered this week
2. For each wrong answer, re-explain the concept
3. Give me 3 problems to solve — one from each topic this week
4. Rate my overall understanding: Weak / Developing / Strong / Expert
```

### Pattern Recognition Training:

```
Give me 10 problem descriptions (just the problem statement, no hints).
For each one, I'll tell you:
- Which data structure to use
- Which algorithm/technique to use
- The expected time complexity

Then grade my pattern recognition ability.
```

---

## CHEAT SHEET PROMPTS

### Generate Personal Cheat Sheets:

```
Create a one-page cheat sheet for [TOPIC] covering:
- Key concepts (bullet points)
- Time/space complexity table
- Code template in Dart
- Common patterns and when to use them
- Top 3 tricks for interviews
```

Use this for: Arrays, Linked Lists, Trees, Graphs, DP, Sorting, etc.

### "The Night Before" Interview Cheat Sheet:

```
Create the ultimate "night before the interview" revision sheet:
- Top 20 patterns I must remember
- Top 10 most common interview problems and their approach
- Common Big O complexities to memorize
- Key formulas and code templates
- Top 5 mistakes to avoid during the interview
- Things to say/do during the interview to impress
```

---

## PROGRESS TRACKER

Copy this and update as you go:

```
PHASE 1 - FOUNDATIONS
[ ] Topic 0: Interview Process & Big O
[ ] Topic 1: Arrays & Strings
[ ] Topic 2: Linked Lists
[ ] Topic 3: Stacks & Queues

PHASE 2 - CORE DATA STRUCTURES
[ ] Topic 4: Hash Tables
[ ] Topic 5: Trees & BST
[ ] Topic 6: Heaps & Priority Queues
[ ] Topic 7: Graphs
[ ] Topic 8: Tries

PHASE 3 - ALGORITHMS
[ ] Topic 9: Sorting & Searching
[ ] Topic 10: Recursion & Backtracking
[ ] Topic 11: Dynamic Programming
[ ] Topic 12: Greedy Algorithms
[ ] Topic 13: Bit Manipulation

PHASE 4 - DESIGN & ADVANCED
[ ] Topic 14: Object-Oriented Design
[ ] Topic 15: System Design
[ ] Topic 16: Behavioral Interview

PHASE 5 - MASTERY
[ ] Easy Mock Interview (pass 3 times)
[ ] Hard Mock Interview (pass 2 times)
[ ] System Design Mock (pass 2 times)
[ ] Solve 100+ problems total
[ ] Can recognize patterns in under 2 minutes
```

---

## TIPS FOR BEST RESULTS

1. **One topic per day** — Don't rush. Deep understanding > speed.
2. **Always try problems yourself first** — Struggle for 15-20 minutes before asking Claude.
3. **Explain back to Claude** — After learning a topic, teach it back. Claude will catch your gaps.
4. **Use "explain like I'm 5"** — Whenever something is confusing.
5. **Use "go deeper"** — When you want internal implementation details.
6. **Use "quiz me"** — At the start of every session to reinforce yesterday's learning.
7. **Solve problems in Dart first** — Then also practice in Python for versatility.
8. **Review weekly** — Every weekend, review all topics from that week.
9. **Mock interview weekly** — From week 4 onwards, do at least 1 mock per week.
10. **Don't skip Dynamic Programming** — It's the hardest but most asked topic. Spend 2 weeks on it.

---

## START HERE

Open your Claude Project and paste this first message:

```
I'm a Flutter/Dart developer starting my coding interview preparation journey.
I want to master everything in "Cracking the Coding Interview" — from scratch to expert level.
Let's begin with Topic 0: The Interview Process & Big O.
Teach me everything. Start simple, build to advanced. I'm ready.
```

Good luck! You've got this.
