# Responsive & Adaptive UI Strategy

## Overview

A lightweight, zero-dependency responsive system that scales spacing and text across phone sizes using a continuous scale factor. No discrete breakpoints — the scale factor smoothly adapts to any screen width.

**Design reference width:** 375 logical pixels (industry standard)

## Architecture

### Scale Formulas

- **General scale:** `clamp(screenWidth / 375, 0.85, 1.3)`
  - 0.85 floor: prevents values from becoming too small on 320dp devices
  - 1.3 ceiling: prevents excessive scaling on large phones
- **Text scale:** `clamp(screenWidth / 375, 0.9, 1.15)` — more conservative to preserve readability

### Device Scale Reference

| Device | Width | Scale Factor | Text Scale |
|--------|-------|-------------|------------|
| iPhone SE 1st gen | 320dp | ~0.85 | 0.9 |
| iPhone 13 mini | 375dp | 1.0 (baseline) | 1.0 |
| Pixel 5 | 393dp | ~1.05 | ~1.05 |
| iPhone 15 Pro Max | 430dp | ~1.15 | ~1.15 |
| Galaxy Fold (unfolded) | ~585dp | 1.3 (capped) | 1.15 (capped) |

## Files

All under `lib/core/responsive/`:

| File | Purpose |
|------|---------|
| `responsive_data.dart` | `ResponsiveData` InheritedWidget — caches screen dimensions and scale factors. Uses 0.01 threshold in `updateShouldNotify` to avoid rebuilds during keyboard animations. |
| `responsive_extensions.dart` | `BuildContext` extensions: `scaled()`, `scaledText()`, `screenWidth`, `screenHeight`, `screenPaddingH`, `screenPaddingAll` |
| `responsive.dart` | Barrel export |

## Usage

### Setup (already done)

`ResponsiveData` is injected in `lib/core/app/app.dart` via the `MaterialApp.router` builder. This is the **only** place `MediaQuery.of(context)` is called for responsive data.

### Scaling values

```dart
// Spacing, padding, icon sizes — use context.scaled()
EdgeInsets.all(context.scaled(AppSizes.screenPadding))
Gap.vertical(context.scaled(AppSizes.space16))
Icon(Icons.check, size: context.scaled(AppSizes.space24))

// Font sizes (when not using theme text styles) — use context.scaledText()
TextStyle(fontSize: context.scaledText(14))

// Screen dimensions — cached, no extra MediaQuery call
context.screenWidth
context.screenHeight

// Convenience paddings
Padding(padding: context.screenPaddingH)    // horizontal only
Padding(padding: context.screenPaddingAll)  // all sides
```

### Preferred approach: theme text styles

Prefer Material 3 theme text styles over manual font sizes. They work well across phone sizes without additional scaling:

```dart
// Preferred
Text('Hello', style: theme.textTheme.bodyLarge)

// Only when theme styles don't fit
Text('Hello', style: TextStyle(fontSize: context.scaledText(14)))
```

## What We Do NOT Scale

| Element | Reason |
|---------|--------|
| Button height (48dp) | Material minimum touch target, accessibility requirement |
| Text field height (56dp) | Material standard, same reason |
| Action icon sizes (24dp) | Standard touch target |
| Border radii | Visual, not size-dependent |

## AppSizes Relationship

`AppSizes` remains the single source of design-time constants. It is **not modified**. Responsive scaling wraps these values at usage sites:

```dart
// Still valid (no breaking change):
EdgeInsets.all(AppSizes.screenPadding)

// Responsive:
EdgeInsets.all(context.scaled(AppSizes.screenPadding))
```

## Testing

Unit tests are at `test/core/responsive/responsive_data_test.dart` covering:
- Scale factor clamping at edge widths
- Text scale conservatism
- `updateShouldNotify` threshold behavior
- Height-only changes not triggering rebuilds
- Widget integration via `ResponsiveData.of`

## Future: Tablet Support

When tablet support is required, add on top of this system:

1. `screen_breakpoint.dart` — enum with `phone`, `tablet`, `tabletLarge` breakpoints
2. `responsive_builder.dart` — widget that switches layouts per breakpoint
3. `content_width_constraint.dart` — max-width wrapper (600dp) for tablets
4. Update `ResponsiveData` to include a breakpoint field
5. In `AppScaffold`, switch `BottomNavigationBar` to `NavigationRail` for tablet

This is a small additive change, not a rewrite.
