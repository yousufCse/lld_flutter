# Section 11: Data Structures & Algorithms (Dart)

---

## 1. Big O Notation

---

**Q:** What is Big O Notation and why does it matter in software development?

**A:** Big O Notation is a mathematical way to describe how the performance of an algorithm scales as the input size grows. It measures the **upper bound** (worst case) of time or space an algorithm consumes relative to its input size `n`. It deliberately ignores constants and lower-order terms because at large scale, only the dominant term matters.

There are two dimensions:
- **Time complexity** — how many operations as input grows
- **Space complexity** — how much extra memory as input grows

```
Growth Rate Comparison (n = 1000):

O(1)      |█                                        → 1
O(log n)  |████                                     → ~10
O(n)      |████████████████████                      → 1,000
O(n log n)|████████████████████████████              → ~10,000
O(n²)     |████████████████████████████████████████  → 1,000,000
```

**Example:**
```dart
// O(1) — Constant time: always one operation regardless of size
int getFirst(List<int> list) => list[0];

// O(n) — Linear time: operations grow proportionally with input
int sumAll(List<int> list) {
  int total = 0;
  for (var num in list) {  // visits every element once
    total += num;
  }
  return total;
}

// O(log n) — Logarithmic: halves the problem each step
int binarySearch(List<int> sorted, int target) {
  int low = 0, high = sorted.length - 1;
  while (low <= high) {
    int mid = (low + high) ~/ 2;
    if (sorted[mid] == target) return mid;
    else if (sorted[mid] < target) low = mid + 1;
    else high = mid - 1;
  }
  return -1;
}

// O(n²) — Quadratic: nested loops over the same data
List<List<int>> allPairs(List<int> list) {
  List<List<int>> pairs = [];
  for (int i = 0; i < list.length; i++) {       // n times
    for (int j = i + 1; j < list.length; j++) {  // n times (roughly)
      pairs.add([list[i], list[j]]);
    }
  }
  return pairs;
}
```

**Why it matters:** Interviewers want to see that you don't just write code that works — you write code that **scales**. If you can't analyze complexity, you can't optimize. Every algorithm discussion in an interview ends with "What's the time and space complexity?"

**Common mistake:** Saying "O(2n) is different from O(n)." Constants are dropped in Big O. O(2n) = O(n). Also, confusing **best case** with **worst case** — Big O conventionally refers to worst case unless stated otherwise.

---

**Q:** What is space complexity and how does it differ from time complexity?

**A:** Space complexity measures the **extra memory** an algorithm needs beyond the input itself. Time complexity counts operations; space complexity counts memory allocations.

Key distinction: the input itself doesn't count toward auxiliary space complexity. Only **additional** allocations do.

```
Algorithm          | Time     | Space
-------------------|----------|--------
In-place reverse   | O(n)     | O(1)     ← swaps in the same list
Create reversed    | O(n)     | O(n)     ← allocates a new list
Merge sort         | O(n log n)| O(n)    ← temporary arrays
Recursive fib      | O(2^n)   | O(n)     ← call stack depth
```

**Example:**
```dart
// O(1) space — reverses in place, no extra list created
void reverseInPlace(List<int> list) {
  int left = 0, right = list.length - 1;
  while (left < right) {
    int temp = list[left];
    list[left] = list[right];
    list[right] = temp;
    left++;
    right--;
  }
}

// O(n) space — creates a brand-new list of size n
List<int> reverseWithCopy(List<int> list) {
  return list.reversed.toList(); // allocates new list
}
```

**Why it matters:** In mobile development (Flutter), memory is limited. An algorithm that's fast but allocates huge amounts of memory can cause jank or OOM crashes on lower-end devices. Interviewers check if you think about **both** dimensions.

**Common mistake:** Forgetting that **recursion uses stack space**. A recursive function with depth `n` uses O(n) space even if it allocates no variables, because each call frame sits on the call stack.

---

## 2. Arrays / Lists

---

**Q:** How do Dart Lists work internally and what is the time complexity of common operations?

**A:** Dart `List` is a dynamic array (similar to `ArrayList` in Java or `std::vector` in C++). Internally, it allocates a contiguous block of memory. When capacity is exceeded, it allocates a new larger block and copies elements over (amortized cost).

There are two types:
- **Fixed-length:** `List.filled(5, 0)` — cannot add/remove, only modify
- **Growable:** `[]` or `List.empty(growable: true)` — can resize

```
List memory layout (contiguous):

Index:  [  0  ][  1  ][  2  ][  3  ][  4  ][ ... capacity ]
Value:  [ 10  ][ 20  ][ 30  ][ 40  ][ 50  ][  unused     ]
         ↑
         Base address — any index = base + (index × element_size)
         This is why random access is O(1).
```

```
Operation                | Time Complexity
-------------------------|------------------
Access by index (list[i])| O(1)
Add to end (add)         | O(1) amortized
Insert at index (insert) | O(n) — shifts elements right
Remove at index          | O(n) — shifts elements left
Remove last (removeLast) | O(1)
Search (contains)        | O(n) — linear scan
Length                   | O(1) — tracked as a field
```

**Example:**
```dart
void main() {
  // Growable list
  List<int> numbers = [10, 20, 30, 40, 50];

  // O(1) — direct index access
  print(numbers[2]); // 30

  // O(1) amortized — append to end
  numbers.add(60);

  // O(n) — inserts at index 1, shifts [20,30,40,50,60] right
  numbers.insert(1, 15);
  // Now: [10, 15, 20, 30, 40, 50, 60]

  // O(n) — removes at index 0, shifts everything left
  numbers.removeAt(0);
  // Now: [15, 20, 30, 40, 50, 60]

  // O(n) — must scan every element
  bool found = numbers.contains(40); // true

  // O(1) — removes the last element, no shifting
  numbers.removeLast();
}
```

**Why it matters:** Lists are the most commonly used data structure in Flutter apps (rendering lists of widgets, processing API data). Knowing the cost of operations helps you choose the right approach — for example, avoiding repeated `insert(0, ...)` on large lists because it's O(n) each time, making the whole loop O(n²).

**Common mistake:** Assuming `add()` is always O(1). It is **amortized** O(1) — occasionally the internal array must be resized (copy all elements), which is O(n). Over many calls, it averages to O(1). Also, forgetting that `List.filled(n, [])` with mutable default values shares the **same reference** for all elements.

---

## 3. Map (HashMap)

---

**Q:** How does Dart's `Map` work internally and what are the time complexities?

**A:** Dart's default `Map` (created with `{}` or `Map()`) is a `LinkedHashMap`. It uses **hashing** to store key-value pairs and maintains **insertion order** (unlike `HashMap` in Java which doesn't guarantee order).

How hashing works:
1. When you insert `map[key] = value`, Dart calls `key.hashCode`
2. The hash is mapped to a bucket index: `bucket = hashCode % numBuckets`
3. The value is stored in that bucket
4. On retrieval, the same process finds the bucket in O(1)

```
Hashing Flow:

  key: "name"
       │
       ▼
  hashCode → 37856291
       │
       ▼
  bucket = 37856291 % 8 = 3
       │
       ▼
  Buckets: [ ][ ][ ]["name":"Ali"][ ][ ][ ][ ]
             0  1  2       3       4  5  6  7
```

**Collision handling:** When two keys land in the same bucket, Dart uses a strategy (typically open addressing or chaining) to resolve it. Collisions degrade performance toward O(n) but are rare with good hash functions.

```
Operation           | Average | Worst Case
--------------------|---------|------------
Insert (map[k] = v) | O(1)   | O(n) — all keys collide
Lookup (map[k])     | O(1)   | O(n)
Remove (remove(k))  | O(1)   | O(n)
containsKey         | O(1)   | O(n)
containsValue       | O(n)   | O(n) — must scan all values
Iteration           | O(n)   | O(n)
```

**Example:**
```dart
void main() {
  // Default Map in Dart is LinkedHashMap (preserves insertion order)
  Map<String, int> ages = {};

  // O(1) — insert
  ages['Alice'] = 30;
  ages['Bob'] = 25;
  ages['Charlie'] = 35;

  // O(1) — lookup by key
  print(ages['Bob']); // 25

  // O(1) — check if key exists
  print(ages.containsKey('Alice')); // true

  // O(n) — must scan every value
  print(ages.containsValue(35)); // true

  // O(1) — remove by key
  ages.remove('Bob');

  // Iteration preserves insertion order in Dart
  ages.forEach((key, value) {
    print('$key: $value');
  });

  // Counting character frequency — classic Map use case
  String word = 'flutter';
  Map<String, int> freq = {};
  for (var char in word.split('')) {
    freq[char] = (freq[char] ?? 0) + 1;
  }
  print(freq); // {f: 1, l: 1, u: 1, t: 2, e: 1, r: 1}
}
```

**Why it matters:** Maps are foundational for countless tasks: caching, lookup tables, counting frequencies, parsing JSON (which arrives as `Map<String, dynamic>`), and memoization. Understanding why lookup is O(1) and why `containsValue` is O(n) shows algorithmic maturity.

**Common mistake:** Using `containsValue()` in a loop, creating O(n²) performance. If you need fast value lookups, maintain a reverse map. Also, forgetting that custom class keys need proper `hashCode` and `==` overrides — otherwise, two "equal" objects may land in different buckets.

---

## 4. Set

---

**Q:** What is a Set in Dart, how is it different from a List, and when should you use it?

**A:** A `Set` is an **unordered** collection of **unique** elements. Dart's default `Set` is a `LinkedHashSet`, which actually preserves insertion order (like `Map`) but still enforces uniqueness.

```
List vs Set:

List: [1, 2, 3, 2, 1]  ← allows duplicates, indexed access
Set:  {1, 2, 3}         ← unique elements only, no index access
```

```
Operation             | List   | Set
----------------------|--------|--------
Add                   | O(1)*  | O(1)
Contains / lookup     | O(n)   | O(1)  ← biggest advantage
Remove by value       | O(n)   | O(1)
Access by index       | O(1)   | N/A
Preserves duplicates  | Yes    | No
Ordered by index      | Yes    | No**
```
_* amortized  ** LinkedHashSet preserves insertion order_

**Example:**
```dart
void main() {
  Set<int> numbers = {1, 2, 3, 4, 5};

  // O(1) — adding an element
  numbers.add(6);

  // O(1) — duplicate silently ignored
  numbers.add(3);
  print(numbers); // {1, 2, 3, 4, 5, 6}

  // O(1) — fast membership check (vs O(n) for List)
  print(numbers.contains(4)); // true

  // O(1) — fast removal by value
  numbers.remove(2);

  // Set operations — powerful for comparisons
  Set<int> a = {1, 2, 3, 4};
  Set<int> b = {3, 4, 5, 6};

  print(a.union(b));        // {1, 2, 3, 4, 5, 6}
  print(a.intersection(b)); // {3, 4}
  print(a.difference(b));   // {1, 2}

  // Practical: remove duplicates from a list
  List<int> withDupes = [1, 2, 2, 3, 3, 3, 4];
  List<int> unique = withDupes.toSet().toList();
  print(unique); // [1, 2, 3, 4]
}
```

**Why it matters:** Choosing Set over List for membership checks converts O(n) to O(1), which is huge when checking if items exist in a collection. In Flutter, this is useful for tracking selected IDs, filtering already-seen items, or managing tag systems.

**Common mistake:** Using `list.contains(x)` inside a loop over another list — that's O(n×m). Convert one list to a Set first for O(n+m). Also, forgetting that Set uses `hashCode` and `==` for uniqueness, so custom objects need those overrides.

---

## 5. Stack

---

**Q:** What is a Stack, how does it work, and how do you implement one in Dart?

**A:** A Stack is a **LIFO** (Last In, First Out) data structure. The last element added is the first one removed. Think of a stack of plates — you take from the top.

Core operations:
- **push** — add to top
- **pop** — remove from top
- **peek/top** — view top without removing
- **isEmpty** — check if empty

```
Stack operations:

  push(3)   push(7)   push(1)    pop()     peek()
                                  → 1       → 7
  ┌───┐     ┌───┐     ┌───┐     ┌───┐     ┌───┐
  │ 3 │     │ 7 │     │ 1 │ ←   │ 7 │  ←  │ 7 │
  └───┘     ├───┤     ├───┤     ├───┤     ├───┤
            │ 3 │     │ 7 │     │ 3 │     │ 3 │
            └───┘     ├───┤     └───┘     └───┘
                      │ 3 │
                      └───┘
```

All core operations are **O(1)**.

Dart has no built-in `Stack` class, but `List` works perfectly as a stack.

**Example:**
```dart
class Stack<T> {
  final List<T> _list = [];

  void push(T value) => _list.add(value);            // O(1)
  T pop() => _list.removeLast();                      // O(1)
  T get peek => _list.last;                           // O(1)
  bool get isEmpty => _list.isEmpty;                  // O(1)
  int get size => _list.length;                       // O(1)

  @override
  String toString() => _list.reversed.toList().toString();
}

void main() {
  final stack = Stack<int>();
  stack.push(10);
  stack.push(20);
  stack.push(30);
  print(stack.peek); // 30
  print(stack.pop()); // 30
  print(stack.peek); // 20

  // Classic use case: checking balanced parentheses
  bool isBalanced(String s) {
    final stack = Stack<String>();
    final pairs = {')': '(', ']': '[', '}': '{'};

    for (var char in s.split('')) {
      if (pairs.containsValue(char)) {
        stack.push(char);
      } else if (pairs.containsKey(char)) {
        if (stack.isEmpty || stack.pop() != pairs[char]) {
          return false;
        }
      }
    }
    return stack.isEmpty;
  }

  print(isBalanced('({[]})')); // true
  print(isBalanced('({[}])'));  // false
}
```

**Why it matters:** Stacks underpin many core computer science concepts: function call stacks, undo/redo systems, expression parsing, DFS traversal, and navigation stacks (which Flutter's `Navigator` uses). Showing you can implement and apply a stack demonstrates foundational understanding.

**Common mistake:** Using `removeAt(0)` instead of `removeLast()` — that turns your stack into a queue and makes removal O(n). Also, not handling the empty-stack case (calling `pop()` on an empty list throws a `RangeError`).

---

## 6. Queue

---

**Q:** What is a Queue, how does it differ from a Stack, and how do you use it in Dart?

**A:** A Queue is a **FIFO** (First In, First Out) data structure. The first element added is the first one removed. Think of a line at a store — first person in line is served first.

```
Queue operations:

  add(A)    add(B)    add(C)    removeFirst()
                                → A
  ┌─────────────────────────┐
  │  A  │  B  │  C  │      │   Front → A B C ← Back
  └─────────────────────────┘
                                After remove:
  ┌─────────────────────────┐
  │  B  │  C  │             │   Front → B C ← Back
  └─────────────────────────┘
```

Dart provides a built-in `Queue` class from `dart:collection`, implemented as a **doubly-linked list**, making both ends O(1).

```
Operation           | Queue (dart:collection) | List (used as queue)
--------------------|-------------------------|---------------------
Add to back         | O(1) — addLast          | O(1) — add
Remove from front   | O(1) — removeFirst      | O(n) — removeAt(0) ⚠️
Peek front          | O(1) — first            | O(1) — first
isEmpty             | O(1)                    | O(1)
```

**Example:**
```dart
import 'dart:collection';

void main() {
  // Dart's built-in Queue
  Queue<String> queue = Queue<String>();

  // Enqueue — O(1)
  queue.add('Alice');
  queue.add('Bob');
  queue.add('Charlie');
  print(queue); // {Alice, Bob, Charlie}

  // Peek — O(1)
  print(queue.first); // Alice

  // Dequeue — O(1)
  String served = queue.removeFirst();
  print(served); // Alice
  print(queue);  // {Bob, Charlie}

  // Practical: BFS uses a queue (see Trees section)
  // Practical: task scheduling, rate limiting, event processing

  // Simple task processor
  Queue<String> taskQueue = Queue.from([
    'fetch data',
    'parse JSON',
    'update UI',
  ]);

  while (taskQueue.isNotEmpty) {
    String task = taskQueue.removeFirst();
    print('Processing: $task');
  }
}
```

**Why it matters:** Queues are essential for BFS, task scheduling, message processing, and event handling. Flutter's event loop itself is conceptually a queue. Knowing to use `Queue` instead of `List.removeAt(0)` shows performance awareness.

**Common mistake:** Using a `List` as a queue by calling `removeAt(0)` — this is O(n) because it shifts every remaining element. Always use `Queue` from `dart:collection` for true FIFO behavior with O(1) operations on both ends.

---

## 7. Linked List

---

**Q:** What is a Linked List, how does it differ from an array, and what are the trade-offs?

**A:** A Linked List stores elements in **nodes**, where each node holds a value and a **pointer (reference)** to the next node. Unlike arrays, elements are **not contiguous** in memory — each node can be anywhere in the heap.

```
Singly Linked List:

  Head
   │
   ▼
  ┌───┬───┐    ┌───┬───┐    ┌───┬───┐    ┌───┬──────┐
  │ 5 │  ─┼───▶│ 8 │  ─┼───▶│ 3 │  ─┼───▶│ 1 │ null │
  └───┴───┘    └───┴───┘    └───┴───┘    └───┴──────┘
   data next    data next    data next    data  next


Doubly Linked List:

       ┌───┬───┬───┐    ┌───┬───┬───┐    ┌───┬───┬───┐
 null◀─┤   │ 5 │  ─┼───▶│◀──│ 8 │  ─┼───▶│◀──│ 3 │   ├─▶null
       └───┴───┴───┘    └───┴───┴───┘    └───┴───┴───┘
       prev data next   prev data next   prev data next
```

**Singly linked:** each node points to the next only. Can only traverse forward.
**Doubly linked:** each node points to both next and previous. Can traverse both ways, but uses more memory.

```
Operation          | Array/List | Linked List
-------------------|------------|------------
Access by index    | O(1)       | O(n) — must traverse
Insert at head     | O(n)       | O(1) — just update pointer
Insert at tail     | O(1)*      | O(1) if tail pointer kept
Insert at middle   | O(n)       | O(1) after finding position†
Delete at head     | O(n)       | O(1)
Search             | O(n)       | O(n)
Memory             | Compact    | Extra per-node overhead
Cache performance  | Excellent  | Poor (non-contiguous)
```
_* amortized  † finding the position is O(n); the actual insert is O(1)_

**Example:**
```dart
// Singly Linked List implementation in Dart
class Node<T> {
  T data;
  Node<T>? next;
  Node(this.data, [this.next]);
}

class SinglyLinkedList<T> {
  Node<T>? head;
  int _size = 0;

  int get size => _size;
  bool get isEmpty => head == null;

  // O(1) — insert at head
  void insertFirst(T data) {
    head = Node(data, head);
    _size++;
  }

  // O(n) — insert at tail
  void insertLast(T data) {
    if (head == null) {
      head = Node(data);
    } else {
      var current = head;
      while (current!.next != null) {
        current = current.next;
      }
      current.next = Node(data);
    }
    _size++;
  }

  // O(1) — delete from head
  T? deleteFirst() {
    if (head == null) return null;
    T data = head!.data;
    head = head!.next;
    _size--;
    return data;
  }

  // O(n) — search
  bool contains(T data) {
    var current = head;
    while (current != null) {
      if (current.data == data) return true;
      current = current.next;
    }
    return false;
  }

  void printList() {
    var current = head;
    final buffer = StringBuffer();
    while (current != null) {
      buffer.write('${current.data}');
      if (current.next != null) buffer.write(' -> ');
      current = current.next;
    }
    print(buffer.toString());
  }
}

void main() {
  var list = SinglyLinkedList<int>();
  list.insertFirst(3);
  list.insertFirst(2);
  list.insertFirst(1);
  list.insertLast(4);
  list.printList(); // 1 -> 2 -> 3 -> 4

  print(list.contains(3)); // true
  list.deleteFirst();
  list.printList(); // 2 -> 3 -> 4
}
```

**Why it matters:** Linked Lists rarely appear directly in Flutter code, but they're a fundamental data structure tested in interviews. They teach pointer manipulation, memory layout, and form the basis of stacks, queues, and graph adjacency lists. Dart's `Queue` internally uses a linked structure.

**Common mistake:** Losing the reference to the head when inserting/deleting, causing the entire list to become unreachable (memory leak conceptually). Also, forgetting to handle the empty list case (`head == null`) separately.

---

## 8. Binary Search

---

**Q:** How does Binary Search work and when can you use it?

**A:** Binary Search finds a target element in a **sorted** collection by repeatedly dividing the search range in half. At each step, it checks the middle element:
- If it matches → found
- If target is smaller → search the left half
- If target is larger → search the right half

**Prerequisite:** The collection **must be sorted**. If it's not sorted, binary search gives wrong results.

```
Binary Search for target = 7 in [1, 3, 5, 7, 9, 11, 13]:

Step 1:  [1, 3, 5, 7, 9, 11, 13]
          L           M           H      mid=7 → FOUND!
                      ↑
         low=0, mid=3, high=6
         list[3] = 7 == target ✓

For target = 9:

Step 1:  [1, 3, 5, 7, 9, 11, 13]
          L        M            H      mid=7 < 9, go right
Step 2:           [9, 11, 13]
                   L   M    H          mid=11 > 9, go left
Step 3:           [9]
                  L=H=M                 mid=9 == target ✓

Time: O(log n) — halving the range each time
Space: O(1) iterative, O(log n) recursive
```

**Example:**
```dart
// Iterative binary search — O(log n) time, O(1) space
int binarySearch(List<int> sorted, int target) {
  int low = 0;
  int high = sorted.length - 1;

  while (low <= high) {
    int mid = low + (high - low) ~/ 2; // avoids integer overflow
    if (sorted[mid] == target) {
      return mid;
    } else if (sorted[mid] < target) {
      low = mid + 1;
    } else {
      high = mid - 1;
    }
  }
  return -1; // not found
}

// Recursive binary search — O(log n) time, O(log n) space
int binarySearchRecursive(List<int> sorted, int target, int low, int high) {
  if (low > high) return -1;

  int mid = low + (high - low) ~/ 2;
  if (sorted[mid] == target) return mid;
  if (sorted[mid] < target) {
    return binarySearchRecursive(sorted, target, mid + 1, high);
  }
  return binarySearchRecursive(sorted, target, low, mid - 1);
}

void main() {
  List<int> numbers = [2, 5, 8, 12, 16, 23, 38, 56, 72, 91];

  print(binarySearch(numbers, 23)); // 5
  print(binarySearch(numbers, 50)); // -1

  print(binarySearchRecursive(numbers, 23, 0, numbers.length - 1)); // 5
}
```

**Why it matters:** Binary search is one of the most frequently tested algorithms. It's the foundation for understanding divide-and-conquer, and it appears in database indexing, searching sorted API responses, and bisect-style debugging.

**Common mistake:** Using `(low + high) ~/ 2` for mid calculation — this can overflow with very large integers. Use `low + (high - low) ~/ 2` instead. Also, forgetting the requirement that data must be sorted, or using `low < high` instead of `low <= high` (which misses the single-element case).

---

## 9. Sorting Algorithms

---

**Q:** Explain Bubble Sort, Insertion Sort, Merge Sort, and Quick Sort — their approach and time complexity.

**A:**

```
Sorting Algorithms Summary:

Algorithm       | Best     | Average  | Worst    | Space  | Stable?
----------------|----------|----------|----------|--------|--------
Bubble Sort     | O(n)     | O(n²)   | O(n²)   | O(1)   | Yes
Insertion Sort  | O(n)     | O(n²)   | O(n²)   | O(1)   | Yes
Merge Sort      | O(n log n)| O(n log n)| O(n log n)| O(n)| Yes
Quick Sort      | O(n log n)| O(n log n)| O(n²)  | O(log n)| No
```

**Bubble Sort** — Repeatedly walks through the list, comparing adjacent elements and swapping if out of order. Largest elements "bubble" to the end.

**Insertion Sort** — Builds the sorted array one item at a time. Picks each element and inserts it into its correct position among the already-sorted portion. Great for nearly-sorted data.

**Merge Sort** — Divide-and-conquer. Splits the array in half recursively until single elements, then merges the sorted halves back together. Guaranteed O(n log n) but needs O(n) extra space.

**Quick Sort** — Divide-and-conquer. Picks a "pivot," partitions elements into smaller-than-pivot and greater-than-pivot groups, then recurses on each group. Fast in practice but O(n²) worst case with bad pivot choice.

```
Merge Sort visualization:

        [38, 27, 43, 3, 9, 82, 10]
               /              \
      [38, 27, 43, 3]    [9, 82, 10]
        /         \         /       \
    [38, 27]   [43, 3]   [9, 82]  [10]
     /   \      /   \     /   \      |
   [38] [27] [43]  [3] [9]  [82]  [10]
     \   /      \   /     \   /      |
    [27, 38]   [3, 43]   [9, 82]  [10]
        \         /         \       /
      [3, 27, 38, 43]    [9, 10, 82]
               \              /
        [3, 9, 10, 27, 38, 43, 82]
```

**Example:**
```dart
// ======= Bubble Sort =======
List<int> bubbleSort(List<int> list) {
  var arr = List<int>.from(list);
  int n = arr.length;
  for (int i = 0; i < n - 1; i++) {
    bool swapped = false;
    for (int j = 0; j < n - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
        swapped = true;
      }
    }
    if (!swapped) break; // optimization: already sorted
  }
  return arr;
}

// ======= Insertion Sort =======
List<int> insertionSort(List<int> list) {
  var arr = List<int>.from(list);
  for (int i = 1; i < arr.length; i++) {
    int key = arr[i];
    int j = i - 1;
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    arr[j + 1] = key;
  }
  return arr;
}

// ======= Merge Sort =======
List<int> mergeSort(List<int> list) {
  if (list.length <= 1) return list;

  int mid = list.length ~/ 2;
  List<int> left = mergeSort(list.sublist(0, mid));
  List<int> right = mergeSort(list.sublist(mid));

  return _merge(left, right);
}

List<int> _merge(List<int> left, List<int> right) {
  List<int> result = [];
  int i = 0, j = 0;

  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {
      result.add(left[i++]);
    } else {
      result.add(right[j++]);
    }
  }

  // Add remaining elements
  result.addAll(left.sublist(i));
  result.addAll(right.sublist(j));

  return result;
}

// ======= Quick Sort =======
List<int> quickSort(List<int> list) {
  if (list.length <= 1) return list;

  int pivot = list[list.length ~/ 2];
  List<int> less = list.where((e) => e < pivot).toList();
  List<int> equal = list.where((e) => e == pivot).toList();
  List<int> greater = list.where((e) => e > pivot).toList();

  return [...quickSort(less), ...equal, ...quickSort(greater)];
}

void main() {
  var data = [38, 27, 43, 3, 9, 82, 10];

  print(bubbleSort(data));    // [3, 9, 10, 27, 38, 43, 82]
  print(insertionSort(data)); // [3, 9, 10, 27, 38, 43, 82]
  print(mergeSort(data));     // [3, 9, 10, 27, 38, 43, 82]
  print(quickSort(data));     // [3, 9, 10, 27, 38, 43, 82]
}
```

**Why it matters:** Sorting questions test your understanding of divide-and-conquer, recursion, and algorithmic trade-offs. Knowing when to pick merge sort (guaranteed O(n log n), stable) vs quick sort (faster in practice, less memory) shows real engineering judgment. Dart's built-in `List.sort()` uses a modified merge sort (TimSort).

**Common mistake:** Saying quick sort is always O(n log n) — it's O(n²) worst case with a bad pivot (e.g., always picking the smallest element in an already sorted list). Also, implementing merge sort without understanding the O(n) space cost — it's not in-place.

---

## 10. Two Pointers Technique

---

**Q:** What is the Two Pointers technique and when do you use it?

**A:** Two Pointers is a technique where you use two index variables (pointers) that move through a data structure, usually from **opposite ends toward the center** or **both from the start at different speeds**. It converts O(n²) brute force solutions into O(n) solutions for problems involving pairs or partitions in sorted/sequential data.

```
Two Pointers (Opposite Direction):

  [1, 2, 3, 4, 5, 6, 7, 8, 9]
   ↑                          ↑
  left                      right
  
  → left moves right
  ← right moves left
  They meet in the middle → O(n)


Two Pointers (Same Direction / Fast & Slow):

  [1, 1, 2, 2, 3, 4, 4, 5]
   ↑  ↑
  slow fast
  
  Both move forward, fast skips ahead
```

**Example:**
```dart
// Problem: Find a pair in a SORTED array that sums to a target
// Brute force: O(n²) — check every pair
// Two pointers: O(n) — converge from both ends

List<int>? twoSumSorted(List<int> sorted, int target) {
  int left = 0;
  int right = sorted.length - 1;

  while (left < right) {
    int sum = sorted[left] + sorted[right];
    if (sum == target) {
      return [left, right];
    } else if (sum < target) {
      left++;   // need a bigger sum → move left pointer right
    } else {
      right--;  // need a smaller sum → move right pointer left
    }
  }
  return null; // no pair found
}

// Problem: Remove duplicates from sorted array in place
int removeDuplicates(List<int> sorted) {
  if (sorted.isEmpty) return 0;

  int slow = 0; // points to last unique element

  for (int fast = 1; fast < sorted.length; fast++) {
    if (sorted[fast] != sorted[slow]) {
      slow++;
      sorted[slow] = sorted[fast];
    }
  }
  return slow + 1; // count of unique elements
}

// Problem: Check if a string is a palindrome (ignoring case)
bool isPalindromeTwoPointers(String s) {
  String cleaned = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  int left = 0;
  int right = cleaned.length - 1;

  while (left < right) {
    if (cleaned[left] != cleaned[right]) return false;
    left++;
    right--;
  }
  return true;
}

void main() {
  print(twoSumSorted([1, 3, 5, 7, 11, 15], 16)); // [2, 4] → 5+11=16
  
  var arr = [1, 1, 2, 2, 3, 4, 4, 5];
  int uniqueCount = removeDuplicates(arr);
  print(arr.sublist(0, uniqueCount)); // [1, 2, 3, 4, 5]

  print(isPalindromeTwoPointers('A man, a plan, a canal: Panama')); // true
}
```

**Why it matters:** Two Pointers is one of the most common patterns in coding interviews. It appears in problems about sorted arrays, palindromes, container with most water, merging arrays, and linked list cycle detection (fast/slow). Recognizing when to apply it is a key interview skill.

**Common mistake:** Trying to use Two Pointers on an **unsorted** array for sum-finding — it only works on sorted data in that context. For unsorted arrays, use a HashMap instead. Also, off-by-one errors with the `left < right` vs `left <= right` condition.

---

## 11. Sliding Window

---

**Q:** What is the Sliding Window technique and when should you use it?

**A:** Sliding Window maintains a **contiguous subset (window)** of elements and slides it across the data structure. Instead of recalculating everything for each position, you add the new element entering the window and remove the element leaving it. This converts O(n×k) brute force into O(n).

Use it when the problem involves:
- Subarrays/substrings of a **fixed or variable size**
- Maximum/minimum/sum of contiguous elements
- Longest substring with some constraint

```
Sliding Window — max sum of 3 consecutive elements:

  [2, 1, 5, 1, 3, 2]
  
  Window 1: [2, 1, 5]          sum = 8
  Window 2:    [1, 5, 1]       sum = 8 - 2 + 1 = 7
  Window 3:       [5, 1, 3]    sum = 7 - 1 + 3 = 9  ← max
  Window 4:          [1, 3, 2] sum = 9 - 5 + 2 = 6
  
  Instead of recalculating the sum each time (3 additions),
  we just subtract the outgoing and add the incoming element.
```

**Example:**
```dart
// Fixed-size window: find max sum of k consecutive elements
// Brute force: O(n*k)  |  Sliding window: O(n)
int maxSumSubarray(List<int> arr, int k) {
  if (arr.length < k) throw ArgumentError('Array smaller than k');

  // Calculate sum of first window
  int windowSum = 0;
  for (int i = 0; i < k; i++) {
    windowSum += arr[i];
  }

  int maxSum = windowSum;

  // Slide the window: remove leftmost, add rightmost
  for (int i = k; i < arr.length; i++) {
    windowSum += arr[i] - arr[i - k]; // add new, remove old
    maxSum = maxSum > windowSum ? maxSum : windowSum;
  }

  return maxSum;
}

// Variable-size window: smallest subarray with sum >= target
int minSubarrayLength(List<int> arr, int target) {
  int minLen = arr.length + 1; // impossible large
  int windowSum = 0;
  int left = 0;

  for (int right = 0; right < arr.length; right++) {
    windowSum += arr[right];

    // Shrink window from left while condition is met
    while (windowSum >= target) {
      int currentLen = right - left + 1;
      minLen = minLen < currentLen ? minLen : currentLen;
      windowSum -= arr[left];
      left++;
    }
  }

  return minLen <= arr.length ? minLen : 0;
}

// Longest substring without repeating characters
int longestUniqueSubstring(String s) {
  Map<String, int> lastSeen = {};
  int maxLen = 0;
  int left = 0;

  for (int right = 0; right < s.length; right++) {
    String char = s[right];
    if (lastSeen.containsKey(char) && lastSeen[char]! >= left) {
      left = lastSeen[char]! + 1; // shrink window past the duplicate
    }
    lastSeen[char] = right;
    int currentLen = right - left + 1;
    maxLen = maxLen > currentLen ? maxLen : currentLen;
  }

  return maxLen;
}

void main() {
  print(maxSumSubarray([2, 1, 5, 1, 3, 2], 3)); // 9

  print(minSubarrayLength([2, 3, 1, 2, 4, 3], 7)); // 2 → [4,3]

  print(longestUniqueSubstring('abcabcbb')); // 3 → "abc"
  print(longestUniqueSubstring('pwwkew'));   // 3 → "wke"
}
```

**Why it matters:** Sliding Window is a top-tier interview pattern. It appears in problems about subarrays, substrings, and streaming data. In Flutter, conceptually similar patterns appear when processing chunks of data from streams or paginated APIs.

**Common mistake:** Recalculating the entire window from scratch each time you slide, defeating the purpose (still O(n×k)). The whole point is incremental updates. Also, mixing up fixed-size and variable-size window logic — fixed windows always have the same size, variable windows shrink and grow based on a condition.

---

## 12. Tree — Binary Tree, BFS vs DFS

---

**Q:** What is a Binary Tree and how do BFS and DFS traversals work?

**A:** A **Binary Tree** is a hierarchical data structure where each node has at most **two children** (left and right). The topmost node is the **root**.

```
Binary Tree:

            10           ← root (depth 0)
          /    \
        5       15       ← depth 1
       / \     /  \
      3   7   12   20    ← depth 2 (leaves)
```

Two fundamental traversal strategies:

**BFS (Breadth-First Search)** — visits level by level, left to right. Uses a **Queue**.
→ Order: 10, 5, 15, 3, 7, 12, 20

**DFS (Depth-First Search)** — goes as deep as possible before backtracking. Uses a **Stack** (or recursion).
Three DFS orders:
- **In-order** (Left → Node → Right): 3, 5, 7, 10, 12, 15, 20 — gives sorted order in BST
- **Pre-order** (Node → Left → Right): 10, 5, 3, 7, 15, 12, 20 — useful for copying the tree
- **Post-order** (Left → Right → Node): 3, 7, 5, 12, 20, 15, 10 — useful for deletion

```
BFS visits by level:          DFS (in-order) goes deep first:

  Level 0:     10                    10
  Level 1:   5   15               /     \
  Level 2: 3 7 12 20            5        15
                               / \      /  \
  Queue: [10]→[5,15]→         3   7   12   20
         [15,3,7]→            ↑   ↑   ↑    ↑
         [3,7,12,20]          1st 3rd 5th  7th
                                2nd  4th  6th
```

**Example:**
```dart
import 'dart:collection';

class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  TreeNode(this.value, [this.left, this.right]);
}

// ======= BFS — Level Order Traversal (uses Queue) =======
List<int> bfs(TreeNode? root) {
  if (root == null) return [];

  List<int> result = [];
  Queue<TreeNode> queue = Queue();
  queue.add(root);

  while (queue.isNotEmpty) {
    TreeNode current = queue.removeFirst();
    result.add(current.value);

    if (current.left != null) queue.add(current.left!);
    if (current.right != null) queue.add(current.right!);
  }

  return result;
}

// ======= DFS — In-order (recursive) =======
List<int> inOrder(TreeNode? node) {
  if (node == null) return [];
  return [...inOrder(node.left), node.value, ...inOrder(node.right)];
}

// ======= DFS — Pre-order (recursive) =======
List<int> preOrder(TreeNode? node) {
  if (node == null) return [];
  return [node.value, ...preOrder(node.left), ...preOrder(node.right)];
}

// ======= DFS — Post-order (recursive) =======
List<int> postOrder(TreeNode? node) {
  if (node == null) return [];
  return [...postOrder(node.left), ...postOrder(node.right), node.value];
}

// ======= DFS — In-order (iterative with explicit stack) =======
List<int> inOrderIterative(TreeNode? root) {
  List<int> result = [];
  List<TreeNode> stack = [];
  TreeNode? current = root;

  while (current != null || stack.isNotEmpty) {
    while (current != null) {
      stack.add(current);
      current = current.left;
    }
    current = stack.removeLast();
    result.add(current.value);
    current = current.right;
  }

  return result;
}

void main() {
  //          10
  //        /    \
  //       5      15
  //      / \    /  \
  //     3   7  12   20
  var tree = TreeNode(10,
    TreeNode(5, TreeNode(3), TreeNode(7)),
    TreeNode(15, TreeNode(12), TreeNode(20)),
  );

  print('BFS:        ${bfs(tree)}');        // [10, 5, 15, 3, 7, 12, 20]
  print('In-order:   ${inOrder(tree)}');    // [3, 5, 7, 10, 12, 15, 20]
  print('Pre-order:  ${preOrder(tree)}');   // [10, 5, 3, 7, 15, 12, 20]
  print('Post-order: ${postOrder(tree)}');  // [3, 7, 5, 12, 20, 15, 10]
}
```

**Why it matters:** Trees appear everywhere: Flutter's widget tree is a tree, DOM is a tree, file systems are trees. BFS/DFS are the two fundamental ways to explore any hierarchical or graph structure. In interviews, tree problems are extremely common.

**Common mistake:** Confusing BFS and DFS data structures — BFS uses a **Queue**, DFS uses a **Stack** (or recursion, which implicitly uses the call stack). Also, mixing up the three DFS orderings. Remember: the name (in/pre/post) refers to when the **node itself** is visited relative to its children.

---

## 13. Recursion

---

**Q:** How does recursion work, what is a base case, and what is tail recursion?

**A:** Recursion is when a function **calls itself** to solve a smaller subproblem. Every recursive function needs:
1. **Base case** — the condition that stops recursion (without it → stack overflow)
2. **Recursive case** — the function calls itself with a smaller/simpler input

Each recursive call adds a **frame** to the call stack. When the base case is hit, frames resolve in reverse order (LIFO).

```
Call stack for factorial(4):

  factorial(4) waits for factorial(3)
    factorial(3) waits for factorial(2)
      factorial(2) waits for factorial(1)
        factorial(1) → returns 1        ← base case
      factorial(2) → returns 2 * 1 = 2
    factorial(3) → returns 3 * 2 = 6
  factorial(4) → returns 4 * 6 = 24

Stack depth = n → O(n) space
```

**Tail recursion** is when the recursive call is the **very last operation** — nothing happens after it returns. Some compilers optimize this into a loop (no extra stack frames). Dart/Flutter does **NOT** currently perform tail call optimization, so in Dart it's mainly a conceptual understanding.

**Example:**
```dart
// ======= Standard Recursion =======
int factorial(int n) {
  if (n <= 1) return 1;        // base case
  return n * factorial(n - 1);  // recursive case — multiplication AFTER the call
}

// ======= Tail Recursive Version =======
// The recursive call is the LAST thing — no pending multiplication
int factorialTail(int n, [int accumulator = 1]) {
  if (n <= 1) return accumulator;           // base case
  return factorialTail(n - 1, n * accumulator); // tail position
}

// ======= Sum of a list recursively =======
int sumList(List<int> list, [int index = 0]) {
  if (index >= list.length) return 0;         // base case
  return list[index] + sumList(list, index + 1); // recursive case
}

// ======= Count nested depth of a structure =======
int maxDepth(Map<String, dynamic> obj) {
  int depth = 0;
  for (var value in obj.values) {
    if (value is Map<String, dynamic>) {
      int childDepth = maxDepth(value);
      depth = depth > childDepth ? depth : childDepth;
    }
  }
  return depth + 1;
}

// ======= Converting recursion to iteration =======
// Recursive
int sumRecursive(int n) {
  if (n <= 0) return 0;
  return n + sumRecursive(n - 1);
}

// Iterative equivalent — often preferred in Dart
int sumIterative(int n) {
  int total = 0;
  for (int i = 1; i <= n; i++) {
    total += i;
  }
  return total;
}

void main() {
  print(factorial(5));     // 120
  print(factorialTail(5)); // 120
  print(sumList([1, 2, 3, 4, 5])); // 15

  var nested = {
    'a': {
      'b': {
        'c': {'d': 1}
      }
    }
  };
  print(maxDepth(nested)); // 4
}
```

**Why it matters:** Recursion is the backbone of tree traversal, divide-and-conquer algorithms (merge sort, quick sort, binary search), backtracking, and dynamic programming. In Flutter, the widget tree itself is built recursively. Understanding the call stack helps debug `StackOverflowError`.

**Common mistake:** Forgetting the base case → infinite recursion → stack overflow. Also, not realizing the space cost — each recursive call consumes stack memory. For large `n`, prefer iterative solutions in Dart since there's no tail call optimization. Another mistake: using recursion where a simple loop would be clearer and more efficient.

---

## 14. Common Interview Coding Problems (Dart Solutions)

---

### 14a. Reverse a String

---

**Q:** Write a function that reverses a string.

**A:** There are multiple approaches: using built-in methods, two pointers, or recursion. In an interview, showing the manual approach demonstrates understanding, then mentioning the built-in shows pragmatism.

**Example:**
```dart
// Method 1: Built-in (pragmatic)
String reverseBuiltIn(String s) {
  return s.split('').reversed.join('');
}

// Method 2: Two pointers (shows understanding)
String reverseManual(String s) {
  List<String> chars = s.split('');
  int left = 0, right = chars.length - 1;

  while (left < right) {
    String temp = chars[left];
    chars[left] = chars[right];
    chars[right] = temp;
    left++;
    right--;
  }

  return chars.join('');
}

// Method 3: Iterative build
String reverseIterative(String s) {
  String result = '';
  for (int i = s.length - 1; i >= 0; i--) {
    result += s[i];
  }
  return result;
}

void main() {
  print(reverseBuiltIn('Flutter'));  // rettulF
  print(reverseManual('Flutter'));   // rettulF
  print(reverseIterative('Flutter'));// rettulF
}
```

**Why it matters:** Tests basic string manipulation and understanding of immutability. Dart strings are immutable, so you must work with character lists or build a new string.

**Common mistake:** In Method 3, string concatenation in a loop creates a new string object each time — O(n²). For performance, use `StringBuffer` or the `split/join` approach.

---

### 14b. Check if a String is a Palindrome

---

**Q:** Write a function to check if a string is a palindrome.

**A:** A palindrome reads the same forwards and backwards. The most efficient approach uses two pointers converging from both ends — O(n) time, O(1) extra space (beyond the cleaned string).

**Example:**
```dart
// Simple approach
bool isPalindromeSimple(String s) {
  String cleaned = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  return cleaned == cleaned.split('').reversed.join('');
}

// Two pointers — more efficient, no extra reversed copy
bool isPalindrome(String s) {
  String cleaned = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  int left = 0, right = cleaned.length - 1;

  while (left < right) {
    if (cleaned[left] != cleaned[right]) return false;
    left++;
    right--;
  }
  return true;
}

void main() {
  print(isPalindrome('racecar'));                        // true
  print(isPalindrome('A man, a plan, a canal: Panama')); // true
  print(isPalindrome('hello'));                          // false
  print(isPalindrome(''));                               // true (edge case)
}
```

**Why it matters:** Tests string handling, edge case thinking (empty string, single character, special characters), and the two-pointer pattern.

**Common mistake:** Not cleaning the string first — spaces, punctuation, and case differences cause false negatives. Also, not handling empty/single-character strings (both are palindromes).

---

### 14c. Find Duplicates in an Array

---

**Q:** Write a function to find all duplicate elements in a list.

**A:** The optimal approach uses a `Set` to track seen elements. As you iterate, if an element is already in the set, it's a duplicate. This is O(n) time, O(n) space.

**Example:**
```dart
// Method 1: Using Set — O(n) time, O(n) space
List<int> findDuplicates(List<int> arr) {
  Set<int> seen = {};
  Set<int> duplicates = {};

  for (var num in arr) {
    if (!seen.add(num)) {
      // Set.add returns false if element already exists
      duplicates.add(num);
    }
  }

  return duplicates.toList();
}

// Method 2: Using Map to count frequency
List<int> findDuplicatesMap(List<int> arr) {
  Map<int, int> freq = {};
  for (var num in arr) {
    freq[num] = (freq[num] ?? 0) + 1;
  }
  return freq.entries
      .where((e) => e.value > 1)
      .map((e) => e.key)
      .toList();
}

// Method 3: Brute force — O(n²) — avoid this
List<int> findDuplicatesBrute(List<int> arr) {
  Set<int> duplicates = {};
  for (int i = 0; i < arr.length; i++) {
    for (int j = i + 1; j < arr.length; j++) {
      if (arr[i] == arr[j]) duplicates.add(arr[i]);
    }
  }
  return duplicates.toList();
}

void main() {
  var data = [1, 3, 5, 3, 7, 1, 9, 5];
  print(findDuplicates(data));    // [3, 1, 5]
  print(findDuplicatesMap(data)); // [3, 1, 5]
}
```

**Why it matters:** Tests your understanding of Set/Map for O(1) lookups and whether you can optimize from O(n²) brute force to O(n). This pattern (tracking seen elements) appears in many variations.

**Common mistake:** Using nested loops (O(n²)) when a Set gives O(n). Also, returning a List of duplicates that contains duplicates itself — using a Set for the result prevents this.

---

### 14d. FizzBuzz

---

**Q:** Write a FizzBuzz program: for numbers 1 to n, print "Fizz" for multiples of 3, "Buzz" for multiples of 5, "FizzBuzz" for multiples of both, otherwise the number.

**A:** FizzBuzz is deceptively simple — the key is checking the combined condition **first** (multiples of both 3 and 5), otherwise you'll print "Fizz" or "Buzz" instead of "FizzBuzz" for multiples of 15.

**Example:**
```dart
List<String> fizzBuzz(int n) {
  List<String> result = [];

  for (int i = 1; i <= n; i++) {
    if (i % 15 == 0) {
      result.add('FizzBuzz'); // check 15 FIRST (or 3 && 5)
    } else if (i % 3 == 0) {
      result.add('Fizz');
    } else if (i % 5 == 0) {
      result.add('Buzz');
    } else {
      result.add('$i');
    }
  }

  return result;
}

// Alternative: string concatenation approach (more extensible)
List<String> fizzBuzzConcat(int n) {
  List<String> result = [];

  for (int i = 1; i <= n; i++) {
    String output = '';
    if (i % 3 == 0) output += 'Fizz';
    if (i % 5 == 0) output += 'Buzz';
    result.add(output.isEmpty ? '$i' : output);
  }

  return result;
}

void main() {
  print(fizzBuzz(15));
  // [1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, FizzBuzz]
}
```

**Why it matters:** FizzBuzz is a baseline "can you write code at all" question. Interviewers use it as a quick filter. The concatenation approach shows extensibility thinking — easy to add "Jazz" for multiples of 7 without exponential if-else chains.

**Common mistake:** Checking `i % 3` before `i % 15`, which means multiples of 15 print "Fizz" instead of "FizzBuzz" because the first condition matches. The concatenation approach avoids this entirely.

---

### 14e. Fibonacci (Iterative and Recursive)

---

**Q:** Write a function to compute the nth Fibonacci number both iteratively and recursively.

**A:** Fibonacci: each number is the sum of the two before it. `0, 1, 1, 2, 3, 5, 8, 13, 21...`

```
Recursive Fibonacci call tree for fib(5):

                    fib(5)
                  /        \
              fib(4)       fib(3)
             /     \       /     \
          fib(3)  fib(2) fib(2) fib(1)
          /   \    / \    / \
       fib(2) fib(1) ... ...
       
  → Massive duplication! fib(3) calculated 2 times,
    fib(2) calculated 3 times. Time: O(2^n)
```

**Example:**
```dart
// ======= Recursive — O(2^n) time, O(n) space (call stack) =======
// Simple but extremely slow for large n
int fibRecursive(int n) {
  if (n <= 0) return 0;   // base case
  if (n == 1) return 1;   // base case
  return fibRecursive(n - 1) + fibRecursive(n - 2);
}

// ======= Recursive + Memoization — O(n) time, O(n) space =======
// Caches results to avoid recomputation
int fibMemo(int n, [Map<int, int>? memo]) {
  memo ??= {};
  if (n <= 0) return 0;
  if (n == 1) return 1;
  if (memo.containsKey(n)) return memo[n]!;

  memo[n] = fibMemo(n - 1, memo) + fibMemo(n - 2, memo);
  return memo[n]!;
}

// ======= Iterative — O(n) time, O(1) space =======
// Best approach: no recursion overhead, minimal memory
int fibIterative(int n) {
  if (n <= 0) return 0;
  if (n == 1) return 1;

  int prev2 = 0; // fib(0)
  int prev1 = 1; // fib(1)

  for (int i = 2; i <= n; i++) {
    int current = prev1 + prev2;
    prev2 = prev1;
    prev1 = current;
  }

  return prev1;
}

void main() {
  // All produce the same results
  print(fibRecursive(10));  // 55 (slow for large n)
  print(fibMemo(10));       // 55 (fast)
  print(fibIterative(10));  // 55 (fast, least memory)

  // Performance comparison for large n
  var sw = Stopwatch()..start();
  fibRecursive(35);
  print('Recursive: ${sw.elapsedMilliseconds}ms');

  sw.reset();
  sw.start();
  fibIterative(35);
  print('Iterative: ${sw.elapsedMilliseconds}ms');
}
```

**Why it matters:** Fibonacci is the gateway to understanding recursion, memoization, and dynamic programming. Interviewers want to see if you can identify the O(2^n) problem with naive recursion and optimize it. Showing all three versions (naive → memoized → iterative) demonstrates algorithm optimization thinking.

**Common mistake:** Submitting the naive recursive solution and calling it done. The naive approach computes fib(3) many times redundantly — it's O(2^n). Always mention the optimization path. Also, off-by-one errors in the base cases.

---

### 14f. Two Sum Problem

---

**Q:** Given a list of integers and a target sum, find two indices whose elements add up to the target.

**A:** The optimal solution uses a **HashMap** to store seen values. For each element, check if `target - element` exists in the map. This gives O(n) time vs O(n²) brute force.

```
Two Sum walkthrough: arr = [2, 7, 11, 15], target = 9

Step 1: num=2, need=9-2=7, map={}       → 7 not in map, store {2:0}
Step 2: num=7, need=9-7=2, map={2:0}    → 2 IS in map at index 0!
        → return [0, 1]
```

**Example:**
```dart
// ======= Brute Force — O(n²) time, O(1) space =======
List<int>? twoSumBrute(List<int> nums, int target) {
  for (int i = 0; i < nums.length; i++) {
    for (int j = i + 1; j < nums.length; j++) {
      if (nums[i] + nums[j] == target) {
        return [i, j];
      }
    }
  }
  return null;
}

// ======= HashMap — O(n) time, O(n) space =======
List<int>? twoSum(List<int> nums, int target) {
  Map<int, int> seen = {}; // value → index

  for (int i = 0; i < nums.length; i++) {
    int complement = target - nums[i];

    if (seen.containsKey(complement)) {
      return [seen[complement]!, i];
    }

    seen[nums[i]] = i;
  }

  return null; // no pair found
}

// ======= Return all pairs (variation) =======
List<List<int>> twoSumAllPairs(List<int> nums, int target) {
  List<List<int>> result = [];
  Map<int, List<int>> seen = {};

  for (int i = 0; i < nums.length; i++) {
    int complement = target - nums[i];
    if (seen.containsKey(complement)) {
      for (var j in seen[complement]!) {
        result.add([j, i]);
      }
    }
    seen.putIfAbsent(nums[i], () => []).add(i);
  }

  return result;
}

void main() {
  print(twoSum([2, 7, 11, 15], 9));      // [0, 1]
  print(twoSum([3, 2, 4], 6));            // [1, 2]
  print(twoSum([3, 3], 6));               // [0, 1]
  print(twoSum([1, 2, 3], 10));           // null
}
```

**Why it matters:** Two Sum is arguably the most famous interview problem (LeetCode #1). It tests your ability to optimize with HashMaps and think about trade-offs (time vs space). It's also a building block for Three Sum, Four Sum, and similar problems.

**Common mistake:** Using the same element twice (returning `[i, i]`). The check `seen.containsKey(complement)` must happen **before** inserting the current element. Also, not handling the case where two identical values sum to the target (e.g., `[3, 3]` with target 6).

---

### 14g. Find the Maximum in a List Without Using max()

---

**Q:** Write a function to find the maximum value in a list without using any built-in max function.

**A:** Initialize a tracker variable with the first element, then scan through the list, updating whenever you find something larger. This is O(n) time, O(1) space — and you cannot do better because every element must be checked at least once.

**Example:**
```dart
// ======= Iterative — O(n) time, O(1) space =======
int findMax(List<int> list) {
  if (list.isEmpty) throw ArgumentError('List cannot be empty');

  int max = list[0]; // start with first element, not 0 or -infinity

  for (int i = 1; i < list.length; i++) {
    if (list[i] > max) {
      max = list[i];
    }
  }

  return max;
}

// ======= Using reduce (functional style) =======
int findMaxReduce(List<int> list) {
  if (list.isEmpty) throw ArgumentError('List cannot be empty');
  return list.reduce((a, b) => a > b ? a : b);
}

// ======= Recursive =======
int findMaxRecursive(List<int> list, [int index = 0]) {
  if (list.isEmpty) throw ArgumentError('List cannot be empty');
  if (index == list.length - 1) return list[index]; // base case

  int maxOfRest = findMaxRecursive(list, index + 1);
  return list[index] > maxOfRest ? list[index] : maxOfRest;
}

// ======= Also find the index of max =======
MapEntry<int, int> findMaxWithIndex(List<int> list) {
  if (list.isEmpty) throw ArgumentError('List cannot be empty');

  int maxVal = list[0];
  int maxIdx = 0;

  for (int i = 1; i < list.length; i++) {
    if (list[i] > maxVal) {
      maxVal = list[i];
      maxIdx = i;
    }
  }

  return MapEntry(maxIdx, maxVal);
}

void main() {
  var data = [3, 7, 2, 9, 1, 5, 9, 4];

  print(findMax(data));           // 9
  print(findMaxReduce(data));     // 9
  print(findMaxRecursive(data));  // 9
  print(findMaxWithIndex(data));  // MapEntry(3: 9) — index 3

  // Edge cases
  print(findMax([42]));           // 42 (single element)
  print(findMax([-5, -2, -8]));   // -2 (all negatives)
}
```

**Why it matters:** Tests fundamental loop logic and edge case handling. It's simple but reveals whether you handle empty lists, single-element lists, and all-negative lists correctly.

**Common mistake:** Initializing `max` to `0` instead of `list[0]` — this fails when all values are negative (e.g., `[-5, -2, -8]` would incorrectly return `0`). Also, not handling the empty list case. Some candidates initialize to `double.negativeInfinity`, which works but is unnecessary when `list[0]` is available.

---

## Quick Reference Card

```
╔═══════════════════════════════════════════════════════════╗
║           DATA STRUCTURES — CHEAT SHEET                   ║
╠═══════════════════════════════════════════════════════════╣
║ Structure    │ Access  │ Search  │ Insert  │ Delete       ║
║──────────────┼─────────┼─────────┼─────────┼──────────    ║
║ List (Array) │ O(1)    │ O(n)    │ O(n)*   │ O(n)        ║
║ Map (Hash)   │ O(1)    │ O(1)    │ O(1)    │ O(1)        ║
║ Set          │ N/A     │ O(1)    │ O(1)    │ O(1)        ║
║ Stack        │ O(n)    │ O(n)    │ O(1)    │ O(1)        ║
║ Queue        │ O(n)    │ O(n)    │ O(1)    │ O(1)        ║
║ Linked List  │ O(n)    │ O(n)    │ O(1)†   │ O(1)†       ║
║ Binary Tree  │ O(log n)│O(log n) │O(log n) │ O(log n)‡   ║
╠═══════════════════════════════════════════════════════════╣
║           ALGORITHMS — CHEAT SHEET                        ║
╠═══════════════════════════════════════════════════════════╣
║ Algorithm      │ Time        │ Space    │ Key Pattern     ║
║────────────────┼─────────────┼──────────┼─────────────    ║
║ Binary Search  │ O(log n)    │ O(1)     │ Sorted data     ║
║ Bubble Sort    │ O(n²)       │ O(1)     │ Adjacent swap   ║
║ Insertion Sort │ O(n²)       │ O(1)     │ Nearly sorted   ║
║ Merge Sort     │ O(n log n)  │ O(n)     │ Divide+merge    ║
║ Quick Sort     │ O(n log n)* │ O(log n) │ Pivot+partition ║
║ Two Pointers   │ O(n)        │ O(1)     │ Sorted/sequence ║
║ Sliding Window │ O(n)        │ O(1-k)   │ Contiguous sub  ║
║ BFS            │ O(V+E)      │ O(V)     │ Level-by-level  ║
║ DFS            │ O(V+E)      │ O(V)     │ Go deep first   ║
╠═══════════════════════════════════════════════════════════╣
║ * List insert at end is amortized O(1)                    ║
║ † After finding the position                              ║
║ ‡ For balanced BST; worst case O(n) for skewed tree       ║
║ * Quick sort worst case is O(n²) with bad pivot           ║
╚═══════════════════════════════════════════════════════════╝
```
