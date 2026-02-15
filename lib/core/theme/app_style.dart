import 'package:flutter/material.dart';
import 'package:flutter_exercise/core/theme/app_font_weight.dart';

import 'app_font_size.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color, {
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

// Light Text Styles
TextStyle getLightStyle({
  required Color color,
  double fontSize = AppFontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, AppFontWeight.light, color, height: height);
}

TextStyle getRegularStyle({
  required Color color,
  double fontSize = AppFontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, AppFontWeight.regular, color, height: height);
}

TextStyle getMediumStyle({
  required Color color,
  double fontSize = AppFontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, AppFontWeight.medium, color, height: height);
}

TextStyle getSemiBoldStyle({
  required Color color,
  double fontSize = AppFontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, AppFontWeight.semiBold, color, height: height);
}

TextStyle getBoldStyle({
  required Color color,
  double fontSize = AppFontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, AppFontWeight.bold, color, height: height);
}
