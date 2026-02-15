import 'package:flutter/material.dart';

import '../../resources/app_sizes.dart';

ThemeData buildAppTheme(Color seedColor) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: _buildTextTheme(),

    // ─── Buttons ───────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, AppSizes.buttonHeight),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, AppSizes.buttonHeight),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, AppSizes.buttonHeight),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
        ),
      ),
    ),

    // ─── Input ─────────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.space16,
        vertical: AppSizes.space16,
      ),
    ),

    // ─── App Bar ───────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),

    // ─── Card ──────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      elevation: 2,
      surfaceTintColor: colorScheme.surfaceTint,
    ),

    // ─── Dialog ────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.dialogRadius),
      ),
      elevation: 8,
    ),

    // ─── Snack Bar ─────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
    ),

    // ─── Bottom Navigation ─────────────────────────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      elevation: 8,
    ),

    // ─── Icons ─────────────────────────────────────────────────────
    iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),

    // ─── Bottom Sheet ──────────────────────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.bottomSheetRadius),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      showDragHandle: true,
      dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      dragHandleSize: Size(
        AppSizes.bottomSheetDragHandleWidth,
        AppSizes.bottomSheetDragHandleHeight,
      ),
      constraints: BoxConstraints(
        maxWidth: 640, // Material 3 spec for large screens
      ),
    ),
  );
}

/// Material 3 type scale.
///
/// Sizes follow the M3 spec. Weights are adjusted for this app:
/// headlines are bold, titles are semibold.
///
/// Colors are NOT set here. Apply them at usage sites via colorScheme
/// (e.g. onSurface for primary text, onSurfaceVariant for muted text).
TextTheme _buildTextTheme() => const TextTheme(
  // Display
  displayLarge: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
  displayMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
  displaySmall: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),

  // Headline
  headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),

  // Title
  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),

  // Body
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

  // Label
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
);
