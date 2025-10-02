// ignore_for_file: avoid_print

abstract class Item {
  final String? title;
  final String? description;
  final double? currentPrice;

  Item([this.title, this.description, this.currentPrice]);

  double? calculateVat();

  void printItem();
}

class PresentItem extends Item {
  PresentItem(super.title, super.description, super.currentPrice);

  @override
  double? calculateVat() {
    return currentPrice != null ? currentPrice! * 0.2 : null;
  }

  @override
  void printItem() {
    print(
      'Title: $title,\nDescription: $description,\nPrice: \$$currentPrice,\nVAT: \$${calculateVat()}',
    );
  }
}

class NullItem extends Item {
  @override
  double? calculateVat() {
    return 0.0;
  }

  @override
  void printItem() {
    print('No item to display');
  }
}

Item makeItem(Item? item) {
  return item != null
      ? PresentItem(item.title, item.description, item.currentPrice)
      : NullItem();
}

class ItemDisplayController {
  final Item? item;

  ItemDisplayController(this.item);

  void displayTheItem() {
    Item displayItem = makeItem(item);
    displayItem.printItem();
  }
}

void main(List<String> args) {
  print(
    '-------------------------------\n| Null Object Pattern Example |\n-------------------------------',
  );

  // ignore: unused_local_variable
  Item? item;
  item = PresentItem('iPhone 17', 'Very nice phone', 1299.00);

  ItemDisplayController itemDisplayManager = ItemDisplayController(null);
  itemDisplayManager.displayTheItem();

  print('-------------------------------');
}
