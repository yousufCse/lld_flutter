
# Flutter Theme System - Complete Implementation Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Architecture Overview](#architecture-overview)
3. [Layer 1: Design Tokens](#layer-1-design-tokens)
4. [Layer 2: Styles Manager](#layer-2-styles-manager)
5. [Layer 3: Theme Extensions](#layer-3-theme-extensions)
6. [Layer 4: ThemeData Configuration](#layer-4-themedata-configuration)
7. [Layer 5: Theme Controller](#layer-5-theme-controller)
8. [Implementation Steps](#implementation-steps)
9. [Usage Examples](#usage-examples)
10. [Best Practices](#best-practices)

---

## Introduction

### What is a Theme System?

A theme system is the **single source of truth** for all visual styling in your Flutter app. Instead of writing colors, fonts, and sizes directly in widgets, you define them once in a centralized location.

**Benefits:**
- ✅ Change colors app-wide by editing one file
- ✅ Support dark mode automatically
- ✅ Maintain visual consistency
- ✅ Easy to maintain and scale
- ✅ Better collaboration between designers and developers

### Why This Architecture?

This theme system uses a **layered architecture**:

```
┌─────────────────────────────────────┐
│   Widgets (UI Layer)                │ ← Uses theme values
├─────────────────────────────────────┤
│   ThemeData (Flutter Layer)         │ ← Material Design mapping
├─────────────────────────────────────┤
│   Theme Extensions (Custom Layer)   │ ← Your brand-specific values
├─────────────────────────────────────┤
│   Styles Manager (Logic Layer)      │ ← Text style generators
├─────────────────────────────────────┤
│   Design Tokens (Foundation Layer)  │ ← Raw values (colors, sizes)
└─────────────────────────────────────┘
```

---

## Architecture Overview

### The 5 Layers

**Layer 1: Design Tokens** - Raw values (hex colors, pixel sizes)  
**Layer 2: Styles Manager** - Functions to create text styles  
**Layer 3: Theme Extensions** - Custom brand properties  
**Layer 4: ThemeData** - Flutter's official theme object  
**Layer 5: Theme Controller** - State management for theme switching  

---

## Layer 1: Design Tokens

Design tokens are the **foundation** of your theme. They store raw values that rarely change.

### 1.1 AppColors Class

**Purpose:** Store all color values in one place.

**Location:** `lib/theme/tokens/app_colors.dart`

```dart
class AppColors {
  // Brand Colors
  static const primaryColor = Color(0xFF6750A4);
  static const secondaryColor = Color(0xFF1E88E5);
  
  // Backgrounds
  static const lightBackground = Color(0xFFFFFBFE);
  static const darkBackground = Color(0xFF1C1B1F);
  
  // Greys
  static const greyShade1 = Color(0xFF9E9E9E);
  static const greyShade2 = Color(0xFFE0E0E0);
  
  // Semantic Colors
  static const errorColor = Color(0xFFB3261E);
  static const successColor = Color(0xFF4CAF50);
  
  AppColors._(); // Private constructor prevents instantiation
}
```

**Explanation:**

| Property | Description | Example Use |
|----------|-------------|-------------|
| `primaryColor` | Main brand color | Buttons, AppBar, important actions |
| `secondaryColor` | Supporting brand color | Secondary buttons, accents |
| `lightBackground` | Background for light theme | Scaffold, Cards in light mode |
| `darkBackground` | Background for dark theme | Scaffold, Cards in dark mode |
| `greyShade1`, `greyShade2` | Neutral colors | Borders, disabled states, icons |
| `errorColor` | Error/danger color | Form validation, error messages |
| `successColor` | Success color | Success messages, confirmations |

**Why `AppColors._()`?**  
The private constructor prevents creating instances like `AppColors()`. We only want to use it like `AppColors.primaryColor`.

---

### 1.2 FontWeightManager Class

**Purpose:** Define text weights consistently.

**Location:** `lib/theme/tokens/font_manager.dart`

```dart
class FontWeightManager {
  static const light = FontWeight.w300;      // Thin text
  static const regular = FontWeight.w400;    // Normal text
  static const medium = FontWeight.w500;     // Slightly bold
  static const semiBold = FontWeight.w600;   // Moderately bold
  static const bold = FontWeight.w700;       // Bold text
  static const extraBold = FontWeight.w800;  // Very bold
  
  FontWeightManager._();
}
```

**When to use each:**
- `light` - Subtitles, captions
- `regular` - Body text, paragraphs
- `medium` - Labels, buttons
- `semiBold` - Subheadings
- `bold` - Headings, titles
- `extraBold` - Display text, hero sections

---

### 1.3 FontSize Class

**Purpose:** Define text size scale.

**Location:** `lib/theme/tokens/font_manager.dart`

```dart
class FontSize {
  static const s10 = 10.0;  // Very small (captions)
  static const s12 = 12.0;  // Small (labels)
  static const s14 = 14.0;  // Body text
  static const s16 = 16.0;  // Large body
  static const s18 = 18.0;  // Small heading
  static const s20 = 20.0;  // Medium heading
  static const s24 = 24.0;  // Large heading
  static const s32 = 32.0;  // Display text
  
  FontSize._();
}
```

**Type Scale Guide:**
- 10-12px → Labels, captions
- 14-16px → Body text
- 18-24px → Headings
- 28-40px → Display/Hero text

---

### 1.4 AppSize Class

**Purpose:** Define spacing and sizing scales.

**Location:** `lib/theme/tokens/values_manager.dart`

```dart
class AppSize {
  static const s4 = 4.0;    // Extra small spacing
  static const s8 = 8.0;    // Small spacing
  static const s12 = 12.0;  // Medium spacing
  static const s16 = 16.0;  // Standard spacing
  static const s24 = 24.0;  // Large spacing
  static const s32 = 32.0;  // Extra large spacing
  static const s48 = 48.0;  // Huge spacing
  
  AppSize._();
}
```

**Common Uses:**
- `s4-s8` → Small gaps, tight padding
- `s12-s16` → Standard padding, gaps
- `s24-s32` → Section spacing, large gaps
- `s48+` → Page margins, major sections

---

### 1.5 AppRadius Class

**Purpose:** Define corner radius for rounded corners.

**Location:** `lib/theme/tokens/values_manager.dart`

```dart
class AppRadius {
  static const r4 = Radius.circular(4);    // Slight rounding
  static const r8 = Radius.circular(8);    // Small rounding
  static const r12 = Radius.circular(12);  // Medium rounding
  static const r16 = Radius.circular(16);  // Large rounding
  static const r20 = Radius.circular(20);  // Extra large
  
  AppRadius._();
}
```

**Visual Guide:**
- `r4-r8` → Buttons, inputs, chips
- `r12-r16` → Cards, containers
- `r20+` → Modal sheets, large cards

---

### 1.6 AppElevation Class

**Purpose:** Define shadow/elevation levels.

**Location:** `lib/theme/tokens/values_manager.dart`

```dart
class AppElevation {
  static const level0 = 0.0;  // Flat (no shadow)
  static const level1 = 1.0;  // Subtle shadow
  static const level2 = 2.0;  // Card shadow
  static const level4 = 4.0;  // Raised element
  static const level6 = 6.0;  // FAB shadow
  static const level8 = 8.0;  // Modal shadow
  
  AppElevation._();
}
```

**When to use:**
- `level0` → Flat buttons, AppBar
- `level1-2` → Cards, list items
- `level4-6` → Floating buttons, raised components
- `level8+` → Dialogs, bottom sheets, modals

---

### 1.7 MotionDurations Class

**Purpose:** Define animation durations.

**Location:** `lib/theme/tokens/motion_tokens.dart`

```dart
class MotionDurations {
  static const fast = Duration(milliseconds: 150);    // Quick transitions
  static const normal = Duration(milliseconds: 300);  // Standard animations
  static const slow = Duration(milliseconds: 500);    // Slow animations
  
  MotionDurations._();
}
```

**Animation Guidelines:**
- `fast (150ms)` → Hover effects, small changes
- `normal (300ms)` → Page transitions, theme switching
- `slow (500ms)` → Complex animations, page loads

---

## Layer 2: Styles Manager

The Styles Manager creates **text styles** by combining font sizes, weights, and colors.

**Location:** `lib/theme/styles_manager.dart`

### Base Text Style Function

```dart
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
    height: height,          // Line height multiplier
    letterSpacing: letterSpacing,
  );
}
```

**Parameters Explained:**
- `fontSize` → Size in logical pixels
- `fontWeight` → How bold the text is
- `color` → Text color
- `height` → Line spacing (1.5 = 150% line height)
- `letterSpacing` → Space between characters

### Style Generator Functions

```dart
// Light weight text
TextStyle getLightStyle({
  required Color color,
  double fontSize = FontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color, height: height);
}

// Regular weight text (most common)
TextStyle getRegularStyle({
  required Color color,
  double fontSize = FontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color, height: height);
}

// Medium weight text
TextStyle getMediumStyle({
  required Color color,
  double fontSize = FontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color, height: height);
}

// Semi-bold text
TextStyle getSemiBoldStyle({
  required Color color,
  double fontSize = FontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color, height: height);
}

// Bold text
TextStyle getBoldStyle({
  required Color color,
  double fontSize = FontSize.s14,
  double? height,
}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color, height: height);
}
```

**How to use:**
```dart
// Create a bold headline
Text(
  'Welcome',
  style: getBoldStyle(
    color: Colors.black,
    fontSize: FontSize.s24,
    height: 1.2,
  ),
)

// Create regular body text
Text(
  'This is some content',
  style: getRegularStyle(
    color: Colors.black87,
    fontSize: FontSize.s16,
    height: 1.5,
  ),
)
```

---

## Layer 3: Theme Extensions

Theme Extensions let you add **custom properties** to Flutter's ThemeData that aren't built-in.

### 3.1 AppSpacing Extension

**Purpose:** Store custom spacing values accessible through theme.

**Location:** `lib/theme/extensions/app_spacing.dart`

```dart
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double xs;      // Extra small spacing
  final double small;   // Small spacing
  final double medium;  // Medium spacing
  final double large;   // Large spacing
  final double xl;      // Extra large spacing
  final double xxl;     // Extra extra large spacing

  const AppSpacing({
    required this.xs,
    required this.small,
    required this.medium,
    required this.large,
    required this.xl,
    required this.xxl,
  });

  @override
  AppSpacing copyWith({
    double? xs,
    double? small,
    double? medium,
    double? large,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
    );
  }

  static const light = AppSpacing(
    xs: 4,
    small: 8,
    medium: 16,
    large: 24,
    xl: 32,
    xxl: 48,
  );
}
```

**Method Explanations:**

| Method | Purpose | Why Needed |
|--------|---------|------------|
| `copyWith()` | Create a new instance with some values changed | Allows partial updates without recreating everything |
| `lerp()` | Interpolate between two themes | Enables smooth animated transitions when switching themes |

**`lerpDouble` explained:**  
Linear interpolation - smoothly transitions from one value to another.
```dart
// t = 0.0 → returns first value
// t = 0.5 → returns middle value
// t = 1.0 → returns second value
lerpDouble(8.0, 16.0, 0.5) // Returns 12.0
```

---

### 3.2 MotionTokens Extension

**Purpose:** Store animation durations in theme.

**Location:** `lib/theme/extensions/motion_extension.dart`

```dart
@immutable
class MotionTokens extends ThemeExtension<MotionTokens> {
  final Duration fast;
  final Duration normal;
  final Duration slow;

  const MotionTokens({
    required this.fast,
    required this.normal,
    required this.slow,
  });

  @override
  MotionTokens copyWith({
    Duration? fast,
    Duration? normal,
    Duration? slow,
  }) {
    return MotionTokens(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
    );
  }

  @override
  MotionTokens lerp(ThemeExtension<MotionTokens>? other, double t) {
    if (other is! MotionTokens) return this;
    return MotionTokens(
      fast: Duration(
        milliseconds: lerpDouble(
          fast.inMilliseconds.toDouble(),
          other.fast.inMilliseconds.toDouble(),
          t,
        )!.toInt(),
      ),
      normal: Duration(
        milliseconds: lerpDouble(
          normal.inMilliseconds.toDouble(),
          other.normal.inMilliseconds.toDouble(),
          t,
        )!.toInt(),
      ),
      slow: Duration(
        milliseconds: lerpDouble(
          slow.inMilliseconds.toDouble(),
          other.slow.inMilliseconds.toDouble(),
          t,
        )!.toInt(),
      ),
    );
  }

  static const standard = MotionTokens(
    fast: Duration(milliseconds: 150),
    normal: Duration(milliseconds: 300),
    slow: Duration(milliseconds: 500),
  );
}
```

**How to use:**
```dart
AnimatedContainer(
  duration: Theme.of(context).extension<MotionTokens>()!.normal,
  // ...
)
```

---

### 3.3 AppGradients Extension

**Purpose:** Store custom gradients.

**Location:** `lib/theme/extensions/app_gradients.dart`

```dart
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
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      accentGradient: LinearGradient.lerp(accentGradient, other.accentGradient, t)!,
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
}
```

**LinearGradient properties:**
- `colors` → List of colors to blend
- `begin` → Where gradient starts
- `end` → Where gradient ends

**Common gradient directions:**
```dart
// Top to bottom
begin: Alignment.topCenter,
end: Alignment.bottomCenter,

// Left to right
begin: Alignment.centerLeft,
end: Alignment.centerRight,

// Diagonal
begin: Alignment.topLeft,
end: Alignment.bottomRight,
```

---

## Layer 4: ThemeData Configuration

ThemeData is Flutter's official theme object. This is where everything comes together.

**Location:** `lib/theme/app_theme.dart`

### 4.1 Color Schemes

```dart
class AppTheme {
  // Generate light color scheme from seed color
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
    brightness: Brightness.light,
  );

  // Generate dark color scheme from same seed
  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
    brightness: Brightness.dark,
  );
```

**What is `ColorScheme.fromSeed`?**  
Material 3 feature that generates a complete color palette from one "seed" color. It automatically creates harmonious colors for:
- primary, secondary, tertiary
- backgrounds, surfaces
- error colors
- "on" colors (text colors that look good on each background)

**ColorScheme Properties:**

| Property | Purpose | Example Use |
|----------|---------|-------------|
| `primary` | Main brand color | Buttons, FAB, selected items |
| `onPrimary` | Text on primary color | Button text |
| `secondary` | Supporting color | Chips, badges |
| `onSecondary` | Text on secondary | Chip text |
| `surface` | Container backgrounds | Cards, dialogs |
| `onSurface` | Text on surfaces | Card content |
| `background` | Page backgrounds | Scaffold |
| `onBackground` | Text on backgrounds | Page content |
| `error` | Error states | Error messages |
| `onError` | Text on error | Error text |

---

### 4.2 Core Theme Properties

```dart
static ThemeData lightTheme() {
  return ThemeData(
    // Enable Material 3
    useMaterial3: true,
    
    // Use our color scheme
    colorScheme: lightColorScheme,
    
    // Light or dark
    brightness: Brightness.light,
    
    // Adaptive density for different platforms
    visualDensity: VisualDensity.adaptivePlatformDensity,
    
    // Page background color
    scaffoldBackgroundColor: lightColorScheme.surface,
```

**Property Explanations:**

| Property | What it does |
|----------|--------------|
| `useMaterial3: true` | Use modern Material 3 design (rounded corners, new components) |
| `colorScheme` | Complete color system for the app |
| `brightness` | Tells Flutter if this is light or dark theme |
| `visualDensity` | Automatically adjusts spacing for desktop vs mobile |
| `scaffoldBackgroundColor` | Default background color for all Scaffold widgets |

---

### 4.3 AppBar Theme

```dart
appBarTheme: AppBarTheme(
  backgroundColor: Colors.transparent,
  elevation: AppElevation.level0,
  centerTitle: false,
  iconTheme: IconThemeData(
    color: lightColorScheme.onSurface,
    size: AppSize.s24,
  ),
  titleTextStyle: getBoldStyle(
    color: lightColorScheme.onSurface,
    fontSize: FontSize.s20,
  ),
  systemOverlayStyle: const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ),
),
```

**AppBarTheme Properties:**

| Property | Description | Common Values |
|----------|-------------|---------------|
| `backgroundColor` | AppBar background color | `Colors.transparent`, `colorScheme.primary` |
| `elevation` | Shadow depth | `0.0` (flat), `4.0` (raised) |
| `centerTitle` | Center the title text | `true`, `false` |
| `iconTheme` | Style for AppBar icons | Color, size |
| `titleTextStyle` | Style for AppBar title | TextStyle |
| `systemOverlayStyle` | Status bar styling | See below |

**SystemUiOverlayStyle explained:**
Controls how the Android/iOS status bar looks.

```dart
SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,           // Status bar background
  statusBarBrightness: Brightness.light,        // iOS only
  statusBarIconBrightness: Brightness.dark,     // Android icon color
)
```

- `Brightness.light` → Light background, use dark icons
- `Brightness.dark` → Dark background, use light icons

---

### 4.4 Typography (TextTheme)

```dart
textTheme: TextTheme(
  displayLarge: getBoldStyle(
    color: lightColorScheme.onSurface,
    fontSize: FontSize.s40,
    height: 1.2,
  ),
  headlineLarge: getSemiBoldStyle(
    color: lightColorScheme.onSurface,
    fontSize: FontSize.s24,
    height: 1.3,
  ),
  bodyLarge: getRegularStyle(
    color: lightColorScheme.onSurface,
    fontSize: FontSize.s16,
    height: 1.5,
  ),
  // ... more styles
),
```

**TextTheme Hierarchy:**

| Style Name | Purpose | Typical Size | Weight |
|------------|---------|--------------|--------|
| `displayLarge` | Hero text, landing pages | 40-57px | Bold |
| `displayMedium` | Large headers | 32-45px | Bold |
| `displaySmall` | Medium headers | 28-36px | Bold |
| `headlineLarge` | Section headers | 24-32px | Semi-bold |
| `headlineMedium` | Subsection headers | 20-28px | Semi-bold |
| `headlineSmall` | Small headers | 18-24px | Semi-bold |
| `bodyLarge` | Large body text | 16-18px | Regular |
| `bodyMedium` | Standard body text | 14-16px | Regular |
| `bodySmall` | Small body text | 12-14px | Regular |
| `labelLarge` | Large buttons | 14px | Medium |
| `labelMedium` | Standard buttons | 12px | Medium |
| `labelSmall` | Small buttons, chips | 10-11px | Medium |

**How to use:**
```dart
Text(
  'Heading',
  style: Theme.of(context).textTheme.headlineLarge,
)

Text(
  'Body text',
  style: Theme.of(context).textTheme.bodyMedium,
)
```

---

### 4.5 Button Themes

#### Elevated Button (Filled button with shadow)

```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
    disabledBackgroundColor: AppColors.greyShade2,
    disabledForegroundColor: AppColors.greyShade1,
    elevation: AppElevation.level0,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSize.s20,
      vertical: AppSize.s14,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSize.s12),
    ),
  ),
),
```

**ElevatedButton Properties:**

| Property | Description | Purpose |
|----------|-------------|---------|
| `backgroundColor` | Button fill color | Main button color |
| `foregroundColor` | Text/icon color | Contrasts with background |
| `disabledBackgroundColor` | Color when disabled | Shows button is not interactive |
| `disabledForegroundColor` | Text color when disabled | Low contrast look |
| `elevation` | Shadow depth | Makes button appear raised |
| `padding` | Internal spacing | Button size |
| `shape` | Border shape | Rounded corners |

#### Outlined Button (Border only)

```dart
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
```

**OutlinedButton Properties:**

| Property | Description |
|----------|-------------|
| `foregroundColor` | Text and border color |
| `side` | Border styling (color, width) |
| `padding` | Button internal spacing |
| `shape` | Border shape |

#### Text Button (No background)

```dart
textButtonTheme: TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: lightColorScheme.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSize.s16,
      vertical: AppSize.s12,
    ),
  ),
),
```

**When to use each button type:**
- **ElevatedButton** → Primary actions (Submit, Save, Continue)
- **OutlinedButton** → Secondary actions (Cancel, Back)
- **TextButton** → Tertiary actions (Skip, Learn More)

---

### 4.6 Input Field Theme

```dart
inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: AppColors.greyShade3,
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
    borderSide: BorderSide(color: AppColors.greyShade2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.s12),
    borderSide: BorderSide(
      color: lightColorScheme.primary,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.s12),
    borderSide: BorderSide(color: lightColorScheme.error),
  ),
  labelStyle: getRegularStyle(
    color: AppColors.greyShade1,
    fontSize: FontSize.s14,
  ),
  hintStyle: getRegularStyle(
    color: AppColors.greyShade1,
    fontSize: FontSize.s14,
  ),
),
```

**InputDecorationTheme Properties:**

| Property | Description | When Applied |
|----------|-------------|--------------|
| `filled` | Add background color | Always |
| `fillColor` | Background color | Always |
| `contentPadding` | Internal spacing | Always |
| `border` | Default border | When no state matches |
| `enabledBorder` | Border when not focused | Normal state |
| `focusedBorder` | Border when user is typing | Active/focused state |
| `errorBorder` | Border when validation fails | Error state |
| `focusedErrorBorder` | Border when focused + error | Focused error state |
| `labelStyle` | Floating label text style | Always |
| `hintStyle` | Placeholder text style | When empty |
| `prefixIconColor` | Color of icon before text | Always |
| `suffixIconColor` | Color of icon after text | Always |

**Border States Visual:**
```
Normal: Grey border (enabledBorder)
   ↓
User clicks: Blue border (focusedBorder)
   ↓
User types invalid data: Red border (errorBorder)
   ↓
User clicks while error: Red border (focusedErrorBorder)
```

---

### 4.7 Card Theme

```dart
cardTheme: CardTheme(
  elevation: AppElevation.level2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSize.s16),
  ),
  color: lightColorScheme.surface,
  margin: const EdgeInsets.all(AppSize.s8),
),
```

**CardTheme Properties:**

| Property | Description | Purpose |
|----------|-------------|---------|
| `elevation` | Shadow depth | Makes card stand out from background |
| `shape` | Border shape and corners | Rounded corners look modern |
| `color` | Card background | Should contrast with page background |
| `margin` | Space around card | Prevents cards from touching |

---

### 4.8 Other Component Themes

#### Checkbox Theme
```dart
checkboxTheme: CheckboxThemeData(
  fillColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) {
      return lightColorScheme.primary;
    }
    return Colors.transparent;
  }),
  checkColor: MaterialStateProperty.all(lightColorScheme.onPrimary),
  side: BorderSide(color: AppColors.greyShade1, width: 2),
),
```

**MaterialState explained:**  
Flutter tracks widget states like pressed, hovered, focused, selected, disabled.

Common states:
- `MaterialState.selected` → Checkbox is checked
- `MaterialState.pressed` → User is pressing
- `MaterialState.hovered` → Mouse over (desktop)
- `MaterialState.focused` → Keyboard focus
- `MaterialState.disabled` → Not interactive

#### FloatingActionButton Theme
```dart
floatingActionButtonTheme: FloatingActionButtonThemeData(
  backgroundColor: lightColorScheme.primary,
  foregroundColor: lightColorScheme.onPrimary,
  elevation: AppElevation.level6,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSize.s16),
  ),
),
```

#### Bottom Sheet Theme
```dart
bottomSheetTheme: BottomSheetThemeData(
  backgroundColor: lightColorScheme.surface,
  elevation: AppElevation.level8,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(AppSize.s20),
    ),
  ),
),
```

#### Dialog Theme
```dart
dialogTheme: DialogTheme(
  backgroundColor: lightColorScheme.surface,
  elevation: AppElevation.level6,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSize.s20),
  ),
  titleTextStyle: getBoldStyle(
    color: lightColorScheme.onSurface,
    fontSize: FontSize.s20,
  ),
),
```

---

### 4.9 Adding Extensions to Theme

```dart
extensions: const [
  AppSpacing.light,
  MotionTokens.standard,
  AppGradients.light,
],
```

This makes your custom extensions available throughout the app.

---

## Layer 5: Theme Controller

The Theme Controller manages **theme switching** and **persistence**.

**Location:** `lib/theme/theme_controller.dart`

### Full Implementation

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  static const String _themeModeKey = 'themeMode';
  
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  
  bool get isDarkMode => _mode == ThemeMode.dark;
  bool get isLightMode => _mode == ThemeMode.light;
  bool get isSystemMode => _mode == ThemeMode.system;

  // Load saved theme preference from storage
  Future<void> loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt(_themeModeKey);
      if (savedIndex != null && savedIndex < ThemeMode.values.length) {
        _mode = ThemeMode.values[savedIndex];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  // Set and save theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_mode == mode) return;
    
    _mode = mode;
    notifyListeners();  // Tell listeners to rebuild
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  // Quick toggle between light and dark
  Future<void> toggleTheme() async {
    if (_mode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}
```

**Class Breakdown:**

| Component | Purpose |
|-----------|---------|
| `with ChangeNotifier` | Allows widgets to listen for changes |
| `_themeModeKey` | Key to store theme in phone storage |
| `_mode` | Current theme mode (private) |
| `mode` | Public getter to read theme mode |
| `isDarkMode`, `isLightMode`, `isSystemMode` | Convenient boolean checks |
| `loadThemeMode()` | Load saved theme when app starts |
| `setThemeMode()` | Change theme and save preference |
| `toggleTheme()` | Quick switch between light/dark |
| `notifyListeners()` | Tells widgets to rebuild with new theme |

**ThemeMode Options:**
- `ThemeMode.system` → Follow device settings (auto dark mode)
- `ThemeMode.light` → Always use light theme
- `ThemeMode.dark` → Always use dark theme

---

## Implementation Steps

### Step 1: Add Dependencies

In `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  shared_preferences: ^2.0.0
```

Run: `flutter pub get`

---

### Step 2: Create Folder Structure

```
lib/
├── theme/
│   ├── tokens/
│   │   ├── app_colors.dart
│   │   ├── font_manager.dart
│   │   └── values_manager.dart
│   ├── extensions/
│   │   ├── app_spacing.dart
│   │   ├── motion_extension.dart
│   │   └── app_gradients.dart
│   ├── styles_manager.dart
│   ├── app_theme.dart
│   └── theme_controller.dart
└── main.dart
```

---

### Step 3: Create Token Files

Copy all token classes:
- `AppColors`
- `FontWeightManager`
- `FontSize`
- `AppSize`
- `AppRadius`
- `AppElevation`
- `MotionDurations`

---

### Step 4: Create Styles Manager

Copy the `styles_manager.dart` with all text style functions.

---

### Step 5: Create Extensions

Copy all three extension classes:
- `AppSpacing`
- `MotionTokens`
- `AppGradients`

---

### Step 6: Create Theme Factory

Copy `AppTheme` class with both `lightTheme()` and `darkTheme()` methods.

---

### Step 7: Create Theme Controller

Copy `ThemeController` class.

---

### Step 8: Update Main.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create and load theme controller
  final themeController = ThemeController();
  await themeController.loadThemeMode();
  
  runApp(
    ChangeNotifierProvider.value(
      value: themeController,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeController.mode,
      home: const HomePage(),
    );
  }
}
```

**Code Explanation:**

| Line | What it does |
|------|--------------|
| `WidgetsFlutterBinding.ensureInitialized()` | Required before async operations in main() |
| `await themeController.loadThemeMode()` | Load saved theme preference |
| `ChangeNotifierProvider.value` | Makes theme controller available to all widgets |
| `context.watch<ThemeController>()` | Listen for theme changes |
| `theme: AppTheme.lightTheme()` | Light theme data |
| `darkTheme: AppTheme.darkTheme()` | Dark theme data |
| `themeMode: themeController.mode` | Which theme to use |

---

## Usage Examples

### Example 1: Access Theme Colors

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      color: colorScheme.primary,
      child: Text(
        'Hello',
        style: TextStyle(color: colorScheme.onPrimary),
      ),
    );
  }
}
```

### Example 2: Use Custom Spacing

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    
    return Padding(
      padding: EdgeInsets.all(spacing.medium),
      child: Column(
        children: [
          Text('Item 1'),
          SizedBox(height: spacing.small),
          Text('Item 2'),
          SizedBox(height: spacing.large),
          Text('Item 3'),
        ],
      ),
    );
  }
}
```

### Example 3: Use Text Styles

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Heading',
          style: textTheme.headlineLarge,
        ),
        Text(
          'Body text goes here',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
```

### Example 4: Use Gradients

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gradients = Theme.of(context).extension<AppGradients>()!;
    
    return Container(
      decoration: BoxDecoration(
        gradient: gradients.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(20),
      child: Text('Gradient Card'),
    );
  }
}
```

### Example 5: Toggle Theme

```dart
class ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.brightness_6),
      onPressed: () {
        context.read<ThemeController>().toggleTheme();
      },
    );
  }
}
```

### Example 6: Theme Picker

```dart
class ThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();
    
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: Text('Light'),
          value: ThemeMode.light,
          groupValue: controller.mode,
          onChanged: (mode) => controller.setThemeMode(mode!),
        ),
        RadioListTile<ThemeMode>(
          title: Text('Dark'),
          value: ThemeMode.dark,
          groupValue: controller.mode,
          onChanged: (mode) => controller.setThemeMode(mode!),
        ),
        RadioListTile<ThemeMode>(
          title: Text('System'),
          value: ThemeMode.system,
          groupValue: controller.mode,
          onChanged: (mode) => controller.setThemeMode(mode!),
        ),
      ],
    );
  }
}
```

### Example 7: Helper Extension (Optional)

Create this for easier access:

```dart
// lib/theme/theme_extensions_helper.dart
import 'package:flutter/material.dart';
import 'extensions/app_spacing.dart';
import 'extensions/motion_extension.dart';
import 'extensions/app_gradients.dart';

extension ThemeHelper on BuildContext {
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
  MotionTokens get motion => Theme.of(this).extension<MotionTokens>()!;
  AppGradients get gradients => Theme.of(this).extension<AppGradients>()!;
  
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
}
```

**Usage:**
```dart
// Instead of:
final spacing = Theme.of(context).extension<AppSpacing>()!;

// You can write:
final spacing = context.spacing;
```

---

## Best Practices

### 1. **Never Hardcode Colors**
❌ Bad:
```dart
Container(color: Color(0xFF6750A4))
```

✅ Good:
```dart
Container(color: Theme.of(context).colorScheme.primary)
```

### 2. **Never Hardcode Text Styles**
❌ Bad:
```dart
Text(
  'Hello',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)
```

✅ Good:
```dart
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

### 3. **Use Semantic Names**
❌ Bad:
```dart
static const blueColor = Color(0xFF6750A4);
static const redColor = Color(0xFFB3261E);
```

✅ Good:
```dart
static const primaryColor = Color(0xFF6750A4);
static const errorColor = Color(0xFFB3261E);
```

### 4. **Maintain Consistent Spacing**
❌ Bad:
```dart
Padding(padding: EdgeInsets.all(13))
Padding(padding: EdgeInsets.all(17))
Padding(padding: EdgeInsets.all(21))
```

✅ Good:
```dart
Padding(padding: EdgeInsets.all(spacing.small))   // 8
Padding(padding: EdgeInsets.all(spacing.medium))  // 16
Padding(padding: EdgeInsets.all(spacing.large))   // 24
```

### 5. **Test Both Themes**
Always test your app in:
- ✅ Light mode
- ✅ Dark mode
- ✅ System mode (auto-switch)
- ✅ Large text (accessibility)

### 6. **Use const Constructors**
```dart
const EdgeInsets.all(AppSize.s16)  // More performant
const SizedBox(height: AppSize.s8)
```

### 7. **Group Related Tokens**
Keep related values in the same class:
```dart
// ✅ Good organization
class AppSize {
  static const s8 = 8.0;
  static const s16 = 16.0;
  static const s24 = 24.0;
}
```

### 8. **Document Custom Values**
```dart
class AppColors {
  /// Primary brand color - used for buttons, links, highlights
  static const primaryColor = Color(0xFF6750A4);
  
  /// Background color for light theme
  static const lightBackground = Color(0xFFFFFBFE);
}
```

### 9. **Accessibility Checks**
Ensure good contrast ratios:
- Normal text: 4.5:1 minimum
- Large text: 3:1 minimum
- Use online contrast checkers

### 10. **Version Control**
When updating theme:
1. Create a new branch
2. Update tokens first
3. Update theme configuration
4. Test thoroughly
5. Merge to main

---

## Common Issues and Solutions

### Issue 1: Theme Not Updating
**Problem:** Changed colors but app still shows old colors.

**Solution:** Hot restart (not hot reload)
```bash
# In terminal
r  # Hot restart
```

### Issue 2: Null Theme Extension
**Problem:** `Theme.of(context).extension<AppSpacing>()` returns null.

**Solution:** Make sure extension is added to ThemeData:
```dart
ThemeData(
  extensions: const [
    AppSpacing.light,  // ← Must be here
  ],
)
```

### Issue 3: Colors Look Wrong
**Problem:** Text is invisible or hard to read.

**Solution:** Always use "on" colors:
```dart
// ✅ Correct
Container(
  color: colorScheme.primary,
  child: Text(
    'Text',
    style: TextStyle(color: colorScheme.onPrimary),  // ← Correct contrast
  ),
)
```

### Issue 4: Theme Not Persisting
**Problem:** Theme resets when app restarts.

**Solution:** Ensure you call `loadThemeMode()`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final controller = ThemeController();
  await controller.loadThemeMode();  // ← Must load saved preference
  
  runApp(MyApp());
}
```

### Issue 5: Slow Theme Switching
**Problem:** Theme changes are janky.

**Solution:** Use `AnimatedTheme`:
```dart
AnimatedTheme(
  data: currentTheme,
  duration: Duration(milliseconds: 300),
  child: MaterialApp(...),
)
```

---

## Quick Reference

### Common Theme Access Patterns

```dart
// Get color scheme
final colors = Theme.of(context).colorScheme;

// Get text theme
final textTheme = Theme.of(context).textTheme;

// Get custom extension
final spacing = Theme.of(context).extension<AppSpacing>()!;

// Check current brightness
final isDark = Theme.of(context).brightness == Brightness.dark;

// Get platform brightness
final systemDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
```

### ColorScheme Quick Reference

```dart
colorScheme.primary          // Main brand color
colorScheme.onPrimary        // Text on primary
colorScheme.secondary        // Secondary brand
colorScheme.onSecondary      // Text on secondary
colorScheme.surface          // Card/container background
colorScheme.onSurface        // Text on surface
colorScheme.background       // Page background
colorScheme.onBackground     // Text on background
colorScheme.error            // Error color
colorScheme.onError          // Text on error
```

### TextTheme Quick Reference

```dart
textTheme.displayLarge       // Largest text (40px)
textTheme.displayMedium      // Large display (32px)
textTheme.displaySmall       // Small display (28px)
textTheme.headlineLarge      // Main heading (24px)
textTheme.headlineMedium     // Sub heading (20px)
textTheme.headlineSmall      // Small heading (18px)
textTheme.bodyLarge          // Large body (16px)
textTheme.bodyMedium         // Normal body (14px)
textTheme.bodySmall          // Small body (12px)
textTheme.labelLarge         // Button text (14px)
```

---

## Conclusion

You now have a complete, production-ready Flutter theme system! This setup:

✅ **Centralizes all styling** - Change once, update everywhere  
✅ **Supports dark mode** - Automatically adapts  
✅ **Persists preferences** - Remembers user choice  
✅ **Scales easily** - Add new tokens as needed  
✅ **Follows best practices** - Material 3, accessibility, performance  
✅ **Type-safe** - Extensions prevent runtime errors  

### Next Steps

1. **Customize colors** - Replace with your brand colors
2. **Adjust spacing** - Modify token values to match design
3. **Add more extensions** - Create extensions for shadows, animations
4. **Test thoroughly** - Check light/dark modes, accessibility
5. **Document changes** - Keep team informed of updates

**Remember:** A good theme system is like a good foundation - invisible but essential. Invest time setting it up properly, and you'll save countless hours later!

---

## Resources

- [Material Design 3](https://m3.material.io/)
- [Flutter ThemeData Documentation](https://api.flutter.dev/flutter/material/ThemeData-class.html)
- [Flutter ColorScheme Documentation](https://api.flutter.dev/flutter/material/ColorScheme-class.html)
- [Material Color Tool](https://material.io/resources/color/)
- [Contrast Checker](https://webaim.org/resources/contrastchecker/)

---

*Last Updated: 2025*