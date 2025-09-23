// ignore_for_file: avoid_print

/*
Beverage <i>
-------------
String getDescription()
double cost()

CondimentBeverage <i> (Decorator)
----------------------
Beverage beverage
String getDescription()
double cost()

Espresso implements Beverage
-------------
String getDescription() => 'Espresso'
double cost() => 1.99 

Mocha extends CondimentBeverage
-------------
String getDescription() => beverage.getDescription() + ', Mocha'
double cost() => beverage.cost() + 0.20

*/

abstract class Beverage {
  String getDescription();
  double cost();
}

class CondimentDecorator extends Beverage {
  final Beverage beverage;

  CondimentDecorator(this.beverage);

  @override
  String getDescription() {
    return beverage.getDescription();
  }

  @override
  double cost() {
    return beverage.cost();
  }
}

class Espresso implements Beverage {
  @override
  String getDescription() => 'Espresso';

  @override
  double cost() => 1.99;
}

class HouseBlend implements Beverage {
  @override
  String getDescription() => 'House Blend Coffee';

  @override
  double cost() => 0.89;
}

class Mocha extends CondimentDecorator {
  Mocha(super.beverage);

  @override
  String getDescription() => '${beverage.getDescription()}, Mocha';

  @override
  double cost() => beverage.cost() + 0.20;
}

class Whip extends CondimentDecorator {
  Whip(super.beverage);

  @override
  String getDescription() => '${beverage.getDescription()}, Whip';

  @override
  double cost() => beverage.cost() + 0.30;
}

class Soy extends CondimentDecorator {
  Soy(super.beverage);

  @override
  String getDescription() => '${beverage.getDescription()}, Soy';

  @override
  double cost() => beverage.cost() + 0.15;
}

void main(List<String> args) {
  print('=== Decorator Pattern Solution ===');
  print('--------------------------\n');

  Beverage beverage = Espresso();
  beverage = Mocha(beverage);
  beverage = Whip(beverage);
  print('${beverage.getDescription()} \$${beverage.cost().toStringAsFixed(2)}');
  print('--------------------------');
  beverage = HouseBlend();
  beverage = Mocha(beverage);
  beverage = Whip(beverage);
  print('${beverage.getDescription()} \$${beverage.cost().toStringAsFixed(2)}');
  print('--------------------------');
}
