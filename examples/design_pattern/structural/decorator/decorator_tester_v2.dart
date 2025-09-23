// ignore_for_file: avoid_print
abstract class Beverage {
  String getDescription() {
    return description;
  }

  double cost();

  String description = 'Unknown Beverage';
  bool milk = false;
  bool soy = false;
  bool mocha = false;
  bool whip = false;

  bool hasMilk() => milk;
  bool hasSoy() => soy;
  bool hasMocha() => mocha;
  bool hasWhip() => whip;

  void setMilk(bool milk) {
    this.milk = milk;
  }

  void setSoy(bool soy) {
    this.soy = soy;
  }

  void setMocha(bool mocha) {
    this.mocha = mocha;
  }

  void setWhip(bool whip) {
    this.whip = whip;
  }
}

class Espresso extends Beverage {
  Espresso();

  @override
  String getDescription() {
    return 'Expresso, ${hasMilk() ? "milk, " : ""}${hasSoy() ? "soy, " : ""}${hasMocha() ? "mocha, " : ""}${hasWhip() ? "whip" : ""}';
  }

  @override
  double cost() {
    double baseCost = 1.99;
    if (hasMilk()) baseCost += 0.10;
    if (hasSoy()) baseCost += 0.15;
    if (hasMocha()) baseCost += 0.20;
    if (hasWhip()) baseCost += 0.10;
    return baseCost;
  }
}

void main(List<String> args) {
  print('=== Decorator Pattern V2 ===');
  Beverage beverage = Espresso();
  beverage.setMilk(true);
  print('${beverage.getDescription()} \$${beverage.cost()}');
  beverage = Espresso();
  beverage.setSoy(true);
  beverage.setWhip(true);
  print('${beverage.getDescription()} \$${beverage.cost()}');
}
