import 'package:flutter/material.dart';

import 'responsive_data.dart';

extension ResponsiveExtensions on BuildContext {
  ResponsiveData get _data => ResponsiveData.of(this);

  double scaled(double value) => value * _data.scaleFactor;

  double scaledText(double value) => value * _data.textScaleFactor;

  double get screenWidth => _data.screenWidth;

  double get screenHeight => _data.screenHeight;

  EdgeInsets get screenPaddingH =>
      EdgeInsets.symmetric(horizontal: scaled(24.0));

  EdgeInsets get screenPaddingAll => EdgeInsets.all(scaled(24.0));
}
