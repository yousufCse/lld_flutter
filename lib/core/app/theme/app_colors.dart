import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Seed colors per flavor.
  // ColorScheme.fromSeed() derives the full palette (primary, secondary,
  // surface, error, onPrimary, etc.) from this single color.
  // Do NOT manually define those — let Material handle it.
  static const Color seedDev = Color(0xFF1565C0);
  static const Color seedProd = Color(0xFF00897B);
  static const Color seedStaging = Colors.orange;
}
