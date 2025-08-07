// ignore_for_file: avoid_print

/*
  Now details of Coffee Recipe
1. Boil some water
2. Brew coffee grounds
3. Pour into cup
4. Add sugar and milk

Now details of Tea Recipe
1. Boil some water
2. Steep tea bag
3. Pour into cup
4. Add lemon
 */

// Let's first create seperate classes for Coffee and Tea recipes.

class Coffee {
  void prepareRecipe() {
    boilWater();
    brewCoffeeGrounds();
    pourInCup();
    addCondiments();
  }

  void boilWater() {
    print("Boiling water");
  }

  void brewCoffeeGrounds() {
    print("Dripping Coffee through filter");
  }

  void pourInCup() {
    print("Pouring into cup");
  }

  void addCondiments() {
    print("Adding Sugar and Milk");
  }
}

class Tea {
  void prepareRecipe() {
    boilWater();
    steepTeaBag();
    pourInCup();
    addCondiments();
  }

  void boilWater() {
    print("Boiling water");
  }

  void steepTeaBag() {
    print("Steeping the tea bag");
  }

  void pourInCup() {
    print("Pouring into cup");
  }

  void addCondiments() {
    print("Adding Lemon");
  }
}

void main() {
  print("Making Coffee:");
  Coffee coffee = Coffee();
  coffee.prepareRecipe();

  print("\nMaking Tea:");
  Tea tea = Tea();
  tea.prepareRecipe();
}
