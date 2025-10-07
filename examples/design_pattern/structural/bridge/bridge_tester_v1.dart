// ignore_for_file: avoid_print

abstract class Shape {
  final Color color;
  Shape(this.color);

  String draw();
}

class Circle extends Shape {
  Circle(super.color);

  @override
  String draw() => 'Drawing a Circle & ${color.fill()}';
}

class Square extends Shape {
  Square(super.color);

  @override
  String draw() => 'Drawing a Square & ${color.fill()}';
}

abstract class Color {
  String fill();
}

class Red implements Color {
  @override
  String fill() => 'Filling with Red color';
}

class Blue implements Color {
  @override
  String fill() => 'Filling with Blue color';
}

void main(List<String> args) {
  print(
    '---------------------------------\n| Bridge Pattern Example (v1)   |\n---------------------------------',
  );

  final Shape circleAndBlue = Circle(Blue());
  final Shape squareAndRed = Square(Red());
  print(circleAndBlue.draw());
  print(squareAndRed.draw());
  print('----------------------------------------');
}
