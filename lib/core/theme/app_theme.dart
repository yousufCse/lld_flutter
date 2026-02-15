import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exercise/core/theme/app_color.dart';
import 'package:flutter_exercise/core/theme/app_elevation.dart';
import 'package:flutter_exercise/core/theme/app_font_size.dart';
import 'package:flutter_exercise/core/theme/app_size.dart';
import 'package:flutter_exercise/core/theme/app_style.dart';
import 'package:flutter_exercise/core/theme/extensions/app_gradient.dart';
import 'package:flutter_exercise/core/theme/extensions/app_spacing.dart';
import 'package:flutter_exercise/core/theme/extensions/motion_tokens.dart';

class AppTheme {
  static const fontFamily = 'VendSans';

  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColor.primaryColor,
    brightness: Brightness.light,
    primary: AppColor.primaryColor,
    secondary: AppColor.secondaryColor,
    tertiary: AppColor.tertiaryColor,
    error: AppColor.errorColor,
    surface: AppColor.lightBackground,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColor.primaryColor,
    brightness: Brightness.dark,
    primary: AppColor.primaryColor,
    secondary: AppColor.secondaryColor,
    tertiary: AppColor.tertiaryColor,
    error: AppColor.errorColor,
    surface: AppColor.darkBackground,
  );

  // LIGHT THEME

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: lightColorScheme.surface,
      fontFamily: fontFamily,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary,
        elevation: AppElevation.level0,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: lightColorScheme.onSurface,
          size: AppSize.s24,
        ),
        titleTextStyle: getBoldStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s20,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: getBoldStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s40,
          height: 1.2,
        ),
        displayMedium: getBoldStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s32,
          height: 1.2,
        ),
        displaySmall: getBoldStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s28,
          height: 1.2,
        ),
        headlineLarge: getSemiBoldStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s24,
          height: 1.3,
        ),
        headlineMedium: getSemiBoldStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s20,
          height: 1.3,
        ),
        headlineSmall: getSemiBoldStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s18,
          height: 1.3,
        ),
        bodyLarge: getRegularStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s16,
          height: 1.5,
        ),
        bodyMedium: getRegularStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s14,
          height: 1.5,
        ),
        bodySmall: getRegularStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s12,
          height: 1.4,
        ),
        labelLarge: getMediumStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s14,
        ),
        labelMedium: getMediumStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s12,
        ),
        labelSmall: getMediumStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s10,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          disabledBackgroundColor: AppColor.greyShade2,
          disabledForegroundColor: AppColor.greyShade1,
          elevation: AppElevation.level0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s20,
            vertical: AppSize.s14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12),
          ),
          textStyle: getMediumStyle(
            color: lightColorScheme.onPrimary,
            fontSize: AppFontSize.s16,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          side: BorderSide(color: lightColorScheme.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s20,
            vertical: AppSize.s14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12),
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s16,
            vertical: AppSize.s12,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColor.greyShade3,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSize.s16,
          vertical: AppSize.s14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: const BorderSide(color: AppColor.greyShade2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: BorderSide(color: lightColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: BorderSide(color: lightColorScheme.error, width: 2),
        ),
        labelStyle: getRegularStyle(
          color: AppColor.greyShade1,
          fontSize: AppFontSize.s14,
        ),
        hintStyle: getRegularStyle(
          color: AppColor.greyShade1,
          fontSize: AppFontSize.s14,
        ),
        prefixIconColor: AppColor.greyShade1,
        suffixIconColor: AppColor.greyShade1,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppElevation.level2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s16),
        ),
        color: lightColorScheme.surface,
        margin: const EdgeInsets.all(AppSize.s8),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(lightColorScheme.onPrimary),
        side: const BorderSide(color: AppColor.greyShade1, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s4),
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary;
          }
          return AppColor.greyShade1;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary.withValues(alpha: 0.5);
          }
          return AppColor.greyShade2;
        }),
      ),

      // Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary;
          }
          return AppColor.greyShade1;
        }),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: AppElevation.level6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s16),
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColorScheme.surface,
        elevation: AppElevation.level8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSize.s20),
          ),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: lightColorScheme.surface,
        elevation: AppElevation.level6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s20),
        ),
        titleTextStyle: getBoldStyle(
          color: lightColorScheme.onSurface,
          fontSize: AppFontSize.s20,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightColorScheme.inverseSurface,
        contentTextStyle: getRegularStyle(
          color: lightColorScheme.onInverseSurface,
          fontSize: AppFontSize.s14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightColorScheme.surface,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: AppColor.greyShade1,
        selectedLabelStyle: getMediumStyle(
          color: lightColorScheme.primary,
          fontSize: AppFontSize.s12,
        ),
        unselectedLabelStyle: getRegularStyle(
          color: AppColor.greyShade1,
          fontSize: AppFontSize.s12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: AppElevation.level8,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColor.greyShade2,
        thickness: 1,
        space: AppSize.s16,
      ),

      // Text Selection
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: lightColorScheme.primary,
        selectionColor: lightColorScheme.primary.withValues(alpha: 0.3),
        selectionHandleColor: lightColorScheme.primary,
      ),

      extensions: const [
        AppSpacing.light,
        MotionTokens.standard,
        AppGradients.light,
      ],
    );
  }

  // DARK THEME
  // ============================================================================
  static ThemeData darkTheme() {
    return ThemeData(
      // Core
      useMaterial3: true,
      colorScheme: darkColorScheme,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Scaffold
      scaffoldBackgroundColor: darkColorScheme.surface,
      fontFamily: fontFamily,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: AppElevation.level0,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: darkColorScheme.onSurface,
          size: AppSize.s24,
        ),
        titleTextStyle: getBoldStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s20,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: getBoldStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s40,
          height: 1.2,
        ),
        displayMedium: getBoldStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s32,
          height: 1.2,
        ),
        displaySmall: getBoldStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s28,
          height: 1.2,
        ),
        headlineLarge: getSemiBoldStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s24,
          height: 1.3,
        ),
        headlineMedium: getSemiBoldStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s20,
          height: 1.3,
        ),
        headlineSmall: getSemiBoldStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s18,
          height: 1.3,
        ),
        bodyLarge: getRegularStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s16,
          height: 1.5,
        ),
        bodyMedium: getRegularStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s14,
          height: 1.5,
        ),
        bodySmall: getRegularStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s12,
          height: 1.4,
        ),
        labelLarge: getMediumStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s14,
        ),
        labelMedium: getMediumStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s12,
        ),
        labelSmall: getMediumStyle(
          color: darkColorScheme.onSurface,
          fontSize: AppFontSize.s10,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          disabledBackgroundColor: AppColor.greyShade2.withValues(alpha: 0.3),
          disabledForegroundColor: AppColor.greyShade1.withValues(alpha: 0.6),
          elevation: AppElevation.level0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s20,
            vertical: AppSize.s14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12),
          ),
          textStyle: getMediumStyle(
            color: darkColorScheme.onPrimary,
            fontSize: AppFontSize.s16,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSize.s16,
          vertical: AppSize.s14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: BorderSide(color: darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
          borderSide: BorderSide(color: darkColorScheme.error),
        ),
        labelStyle: getRegularStyle(
          color: darkColorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: AppFontSize.s14,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppElevation.level2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s16),
        ),
        color: darkColorScheme.surfaceContainerHighest,
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        elevation: AppElevation.level6,
      ),

      // Extensions
      extensions: const [
        AppSpacing.dark,
        MotionTokens.standard,
        AppGradients.dark,
      ],
    );
  }
}
