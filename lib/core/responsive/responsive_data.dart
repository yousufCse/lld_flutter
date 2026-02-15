import 'package:flutter/material.dart';

class ResponsiveData extends InheritedWidget {
  const ResponsiveData._({
    required super.child,
    required this.screenWidth,
    required this.screenHeight,
    required this.scaleFactor,
    required this.textScaleFactor,
  });

  static const double designWidth = 375.0;
  static const double minScale = 0.85;
  static const double maxScale = 1.3;
  static const double minTextScale = 0.9;
  static const double maxTextScale = 1.15;

  final double screenWidth;
  final double screenHeight;
  final double scaleFactor;
  final double textScaleFactor;

  factory ResponsiveData.fromMediaQuery({
    required MediaQueryData mediaQuery,
    required Widget child,
  }) {
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final raw = width / designWidth;

    return ResponsiveData._(
      screenWidth: width,
      screenHeight: height,
      scaleFactor: raw.clamp(minScale, maxScale),
      textScaleFactor: raw.clamp(minTextScale, maxTextScale),
      child: child,
    );
  }

  static ResponsiveData of(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<ResponsiveData>();
    assert(data != null, 'No ResponsiveData found in context');
    return data!;
  }

  @override
  bool updateShouldNotify(ResponsiveData oldWidget) {
    return (scaleFactor - oldWidget.scaleFactor).abs() > 0.01 ||
        (textScaleFactor - oldWidget.textScaleFactor).abs() > 0.01;
  }
}
