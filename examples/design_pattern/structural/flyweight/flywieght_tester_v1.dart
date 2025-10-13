// ignore_for_file: avoid_print

class TreeType {
  final String name;
  final String color;

  TreeType({required this.name, required this.color});

  void draw(int x, int y) {
    print('Displaying $name of color $color at ($x, $y)');
  }
}

class TreeFactory {
  static final Map<String, TreeType> _treeTypes = {};

  static TreeType getTreeType({required String name, required String color}) {
    final key = '$name-$color';

    if (_treeTypes.containsKey(key)) {
      return _treeTypes[key]!;
    } else {
      _treeTypes.putIfAbsent(key, () => TreeType(name: name, color: color));
      return _treeTypes[key]!;
    }
  }
}

class Tree {
  final int x;
  final int y;
  final TreeType type;

  Tree(this.x, this.y, this.type);

  void draw() {
    type.draw(x, y);
  }
}

void main(List<String> args) {
  print(
    '---------------------------------\n| Flyweight Pattern Example v1 |\n---------------------------------',
  );

  final oakType = TreeFactory.getTreeType(name: 'Oak', color: 'Green');
  final pineType = TreeFactory.getTreeType(name: 'Pine', color: 'Dark Green');

  final trees = <Tree>[
    Tree(10, 20, oakType),
    Tree(15, 25, oakType),
    Tree(30, 40, pineType),
    Tree(50, 60, pineType),
  ];

  for (var tree in trees) {
    tree.draw();
  }
}
