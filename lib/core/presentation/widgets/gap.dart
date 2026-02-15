import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap._({this.width = 0, this.height = 0});

  final double width;
  final double height;

  factory Gap.vertical(double height) => Gap._(height: height);
  factory Gap.horizontal(double width) => Gap._(width: width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
