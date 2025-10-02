// ignore_for_file: avoid_print

class Item {
  final String? title;
  final String? description;
  final String? currentPrice;

  Item([this.title, this.description, this.currentPrice]);
}

class ItemPrinter {
  static void printItem(Item? item) {
    if (item != null) {
      print(
        'Title: ${item.title},\nDescription: ${item.description},\nPrice: ${item.currentPrice}',
      );
    } else {
      print('No item to display');
    }
  }
}

void main(List<String> args) {
  print(
    '-------------------------------\n| Null Object Pattern Example |\n-------------------------------',
  );

  Item? item;
  item = Item('iPhone 17', 'Very nice phone', '\$999');

  ItemPrinter.printItem(item);

  print('-------------------------------');
}
