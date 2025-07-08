
## SOLVE a transport system using STRATEGY PATTERN

### Step 1: Define the Problem
You need to create a **transportation system** where users can choose different modes of transportation to calculate the travel time for a given distance. The modes of transportation include:
1. **Car**
2. **Bicycle**
3. **Walking**

Each mode of transportation has its own speed and way of calculating the travel time.

---

### Step 2: Requirements
1. Define an interface for the transportation strategy.
2. Implement the strategies for **Car**, **Bicycle**, and **Walking**.
3. Create a context class that uses the transportation strategy.
4. Allow the user to dynamically select a mode of transportation and calculate the travel time for a given distance.

---

### Step 3: Example
- If the user selects **Car**, the travel time is calculated as `distance / carSpeed`.
- If the user selects **Bicycle**, the travel time is calculated as `distance / bicycleSpeed`.
- If the user selects **Walking**, the travel time is calculated as `distance / walkingSpeed`.

---

### Step 4: Solve It
Start by implementing the interface and strategies. Let me know when you're ready for the next step or if you need help!