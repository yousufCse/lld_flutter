import 'package:flutter/material.dart';

@immutable
class AppGradients extends ThemeExtension<AppGradients> {
  final LinearGradient primaryGradient;
  final LinearGradient accentGradient;

  const AppGradients({
    required this.primaryGradient,
    required this.accentGradient,
  });

  @override
  AppGradients copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? accentGradient,
  }) {
    return AppGradients(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      accentGradient: accentGradient ?? this.accentGradient,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) return this;
    return AppGradients(
      primaryGradient: LinearGradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      )!,
      accentGradient: LinearGradient.lerp(
        accentGradient,
        other.accentGradient,
        t,
      )!,
    );
  }

  static const light = AppGradients(
    primaryGradient: LinearGradient(
      colors: [Color(0xFF6750A4), Color(0xFF8E7CC3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static const dark = AppGradients(
    primaryGradient: LinearGradient(
      colors: [Color(0xFF4A3A70), Color(0xFF6750A4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}
