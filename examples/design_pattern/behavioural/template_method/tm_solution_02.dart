// ignore_for_file: avoid_print

/*
 Let's check the common code in both Coffee and Tea classes
 in tm_solution_01.dart file.
 and abstract the common code into a base class
 */

abstract class Beverage {
  void prepareRecipe();

  void boilWater() {
    print("Boiling water");
  }

  void pourInCup() {
    print("Pouring into cup");
  }
}

class Coffee extends Beverage {
  @override
  void prepareRecipe() {
    boilWater();
    brewCoffeeGrounds();
    pourInCup();
    addSugarAndMilk();
  }

  void brewCoffeeGrounds() {
    print("Dripping Coffee through filter");
  }

  void addSugarAndMilk() {
    print("Adding Sugar and Milk");
  }
}

class Tea extends Beverage {
  @override
  void prepareRecipe() {
    boilWater();
    steepTeaBag();
    pourInCup();
    addLemon();
  }

  void steepTeaBag() {
    print("Steeping the tea bag");
  }

  void addLemon() {
    print("Adding Lemon");
  }
}

void main() {
  print("Making Coffee:");
  Beverage coffee = Coffee();
  coffee.prepareRecipe();

  print("\nMaking Tea:");
  Beverage tea = Tea();
  tea.prepareRecipe();
}
