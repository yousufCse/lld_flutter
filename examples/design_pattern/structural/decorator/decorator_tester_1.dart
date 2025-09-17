// ignore_for_file: avoid_print

abstract class Beverage {
  String getDescription();
  double cost();
}

class Espresso implements Beverage {
  @override
  String getDescription() => 'Espresso';

  @override
  double cost() => 1.99;
}

class DarkRoast implements Beverage {
  @override
  String getDescription() => 'Dark Roast Coffee';

  @override
  double cost() => 0.99;
}

class DarkRoastWithMocha extends Beverage {
  @override
  String getDescription() => 'Dark Roast with Mocha';

  @override
  double cost() => 0.99 + 0.20;
}

class DarkRoastWithMochaAndWhip extends Beverage {
  @override
  String getDescription() => 'Dark Roast with Mocha and Whip';

  @override
  double cost() => 0.99 + 0.20 + 0.30;
}

void main(List<String> args) {
  print('=== Decorator Pattern ===');
  Beverage beverage = DarkRoast();
  print('${beverage.getDescription()} \$${beverage.cost()}');
  print('------------------------');

  Beverage beverage2 = DarkRoastWithMocha();
  print('${beverage2.getDescription()} \$${beverage2.cost()}');
  print('------------------------');
  Beverage beverage3 = DarkRoastWithMochaAndWhip();
  print('${beverage3.getDescription()} \$${beverage3.cost()}');
}
