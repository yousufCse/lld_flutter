# flutter_gen — Asset Management Guide

Type-safe asset accessors for Niramoy Health App. Adding an asset is now a
two-step process: drop the file in the right folder → run codegen. The
compiler catches every typo.

---

## Table of Contents

1. [How It Works](#how-it-works)
2. [Project Setup (already done)](#project-setup-already-done)
3. [Adding a New Asset](#adding-a-new-asset)
   - [PNG / JPG image](#adding-a-png--jpg-image)
   - [SVG icon](#adding-an-svg-icon)
   - [Lottie animation](#adding-a-lottie-animation)
   - [A new asset directory](#adding-a-new-asset-directory)
4. [Using Assets in Widgets](#using-assets-in-widgets)
5. [Running Codegen](#running-codegen)
6. [Configuration Reference](#configuration-reference)
7. [File Structure](#file-structure)
8. [Common Mistakes](#common-mistakes)
9. [Starting from Scratch (for new projects)](#starting-from-scratch-for-new-projects)

---

## How It Works

```
Your file                  build_runner              Widget
assets/icons/ui/close.svg  ──────────────────►  Assets.icons.ui.close.svg(...)
                            generates
                            lib/gen/assets.gen.dart
```

Three packages collaborate:

| Package | Type | Role |
|---|---|---|
| `flutter_gen` | `dependency` | Runtime types: `AssetGenImage`, `SvgGenImage` |
| `flutter_gen_runner` | `dev_dependency` | build_runner plugin that generates `assets.gen.dart` |
| `flutter_svg` | `dependency` | SVG rendering; enables `SvgGenImage` type |

The generated file `lib/gen/assets.gen.dart` is **committed to git**. It is
the public API for all assets. CI can build without running codegen.

---

## Project Setup (already done)

This section documents what was configured. You do not need to repeat these
steps — they are already in the codebase.

### 1. Packages in `pubspec.yaml`

```yaml
dependencies:
  flutter_svg: ^2.0.10
  flutter_gen: ^5.8.0        # runtime types

dev_dependencies:
  flutter_gen_runner: ^5.8.0  # code generator
```

### 2. `flutter_gen:` configuration block

Placed at the **top level** of `pubspec.yaml` (same level as `name:`,
`dependencies:`) — NOT inside the `flutter:` section:

```yaml
flutter_gen:
  output: lib/gen/       # where assets.gen.dart is written
  line_length: 120

  integrations:
    flutter_svg: true    # enables SvgGenImage type with .svg() method

  assets:
    exclude:
      - .env.dev         # keep flutter_dotenv working but hide from Assets class
      - .env.prod
      - .env.staging
```

> **Why `exclude`?**
> The `.env.*` files must be declared in `flutter: assets:` so `flutter_dotenv`
> can load them. But they are config files, not assets you reference in
> widgets. Without `exclude`, all three would generate a conflicting `aEnv`
> field (they share the same file stem). Exclude keeps the generated `Assets`
> class clean.
> Note: `exclude` is nested under `assets:`, NOT at the top level of
> `flutter_gen:`.

### 3. Asset directories in `flutter: assets:`

```yaml
flutter:
  assets:
    # Environment files (loaded by flutter_dotenv, excluded from flutter_gen)
    - .env.dev
    - .env.prod
    - .env.staging

    # Image assets
    - assets/images/
    - assets/images/illustrations/

    # Icon assets (SVG)
    - assets/icons/health/
    - assets/icons/ui/

    # Animation assets (Lottie)
    - assets/animations/
```

### 4. Barrel export

`lib/core/resources/resources.dart` re-exports the generated file:

```dart
export 'app_sizes.dart';
export 'strings/strings.dart';
export '../../gen/assets.gen.dart';   // flutter_gen generated
```

Any file that imports `resources.dart` gets `Assets` for free.

---

## Adding a New Asset

### Adding a PNG / JPG image

1. Drop the file into `assets/images/` or a subdirectory:
   ```
   assets/images/logo.png
   assets/images/illustrations/empty_state.png
   ```

2. Run codegen (see [Running Codegen](#running-codegen)).

3. Use it:
   ```dart
   // PNG rendered as a widget
   Assets.images.logo.image(width: 120)

   // As an ImageProvider
   Assets.images.illustrations.emptyState.provider()

   // Raw path string (for Image.asset, CachedNetworkImage placeholder, etc.)
   Assets.images.logo.path   // → 'assets/images/logo.png'
   ```

No `pubspec.yaml` change is needed — the directory is already declared.

---

### Adding an SVG icon

1. Drop the `.svg` file into the appropriate subdirectory:
   ```
   assets/icons/health/heart_rate.svg
   assets/icons/ui/close.svg
   ```

2. Run codegen.

3. Use it:
   ```dart
   // Rendered as a widget (returns SvgPicture)
   Assets.icons.health.heartRate.svg(
     width: 24,
     height: 24,
     colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
   )

   // Raw path (for SvgPicture.asset directly)
   Assets.icons.ui.close.path   // → 'assets/icons/ui/close.svg'
   ```

The accessor name is the camelCase of the filename: `heart_rate.svg` →
`heartRate`.

---

### Adding a Lottie animation

> Lottie files are `.json`. If you also add the `lottie` pub package, a
> future integration can be wired in. For now, use the raw path.

1. Drop the file into `assets/animations/`:
   ```
   assets/animations/loading_spinner.json
   ```

2. Run codegen.

3. Use the path:
   ```dart
   Lottie.asset(Assets.animations.loadingSpinner.path)
   ```

---

### Adding a new asset directory

If you need a new category (e.g. `assets/fonts/`, `assets/images/onboarding/`):

1. Create the directory and add a `.gitkeep` so git tracks it:
   ```
   assets/images/onboarding/.gitkeep
   ```

   > **Why `.gitkeep`?** Flutter fails to build if a declared asset directory
   > is empty. The `.gitkeep` placeholder prevents the error until real files
   > are added.

2. Declare it in `pubspec.yaml` under `flutter: assets:`:
   ```yaml
   flutter:
     assets:
       - assets/images/onboarding/
   ```

3. Run codegen — a new `$AssetsImagesOnboardingGen` class appears in
   `assets.gen.dart`.

4. Commit both the `.gitkeep` and the updated `pubspec.yaml`.

---

## Using Assets in Widgets

Import via the resources barrel (preferred):

```dart
import 'package:niramoy_health_app/core/resources/resources.dart';
```

Or import the generated file directly:

```dart
import 'package:niramoy_health_app/gen/assets.gen.dart';
```

### PNG

```dart
Assets.images.appIconDev.image(
  width: 80,
  height: 80,
  fit: BoxFit.contain,
)
```

### SVG

```dart
Assets.icons.health.heartRate.svg(
  width: 24,
  height: 24,
  colorFilter: const ColorFilter.mode(
    AppColors.primary,
    BlendMode.srcIn,
  ),
)
```

### Lottie (raw path)

```dart
Lottie.asset(
  Assets.animations.loadingSpinner.path,
  width: 200,
  repeat: true,
)
```

---

## Running Codegen

Always run this after adding, removing, or renaming an asset file:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

This is the same command used for injectable and freezed — it regenerates
everything including `assets.gen.dart`.

> If `fvm` is not on your PATH, use the project's local SDK:
> ```bash
> dart run build_runner build --delete-conflicting-outputs
> ```

You can also use the build script:

```bash
./build.sh codegen
```

---

## Configuration Reference

Full `flutter_gen:` block with all used options:

```yaml
flutter_gen:
  output: lib/gen/
  line_length: 120

  integrations:
    flutter_svg: true   # enables SvgGenImage — requires flutter_svg in dependencies

  assets:
    exclude:
      - .env.dev        # glob patterns — see package:glob for syntax
      - .env.prod
      - .env.staging
```

### Key rules

| Rule | Reason |
|---|---|
| `flutter_gen:` is top-level, not inside `flutter:` | It's a separate config key, not a Flutter SDK option |
| `exclude:` must be under `assets:`, not under `flutter_gen:` directly | Putting it at the top level causes an "unrecognized keys" build error |
| `flutter_gen` goes in `dependencies` (not `dev_dependencies`) | It provides runtime types (`AssetGenImage`) used in widget code |
| `flutter_gen_runner` goes in `dev_dependencies` | It's only used during code generation, not at runtime |
| Re-run codegen after every asset change | The generator does not watch for file changes in `build` mode |

---

## File Structure

```
niramoy_health_app/
├── assets/
│   ├── images/
│   │   ├── app-icon-dev.png        ← existing launcher icons (do not move)
│   │   ├── app-icon-prod.png
│   │   ├── app-icon-staging.png
│   │   └── illustrations/
│   │       └── .gitkeep            ← placeholder until real files are added
│   ├── icons/
│   │   ├── health/                 ← domain SVG icons (heart rate, steps, etc.)
│   │   │   └── .gitkeep
│   │   └── ui/                     ← generic UI SVG icons (close, back, etc.)
│   │       └── .gitkeep
│   └── animations/                 ← Lottie .json files
│       └── .gitkeep
├── lib/
│   ├── gen/
│   │   └── assets.gen.dart         ← GENERATED — do not edit by hand
│   └── core/
│       └── resources/
│           └── resources.dart      ← barrel export; includes assets.gen.dart
└── pubspec.yaml
```

---

## Common Mistakes

### 1. Forgetting to run codegen after adding a file

The `Assets` class reflects what was there at the last codegen run. If you add
`heart_rate.svg` but don't regenerate, `Assets.icons.health.heartRate` will
not exist and the build will fail.

**Fix:** always run codegen after adding, removing, or renaming an asset.

---

### 2. Declaring a directory that doesn't exist (or is empty without `.gitkeep`)

Flutter will fail at build time with:
```
Asset manifest contains an entry that doesn't exist: assets/icons/health/
```

**Fix:** ensure each declared directory contains at least one file. Use
`.gitkeep` as a placeholder.

---

### 3. Putting `flutter_gen:` inside `flutter:`

```yaml
# WRONG
flutter:
  flutter_gen:     ← this does nothing; Flutter ignores unknown keys here
    output: lib/gen/
```

```yaml
# CORRECT
flutter_gen:       ← top-level key
  output: lib/gen/

flutter:
  uses-material-design: true
```

---

### 4. Putting `exclude:` at the wrong level

```yaml
# WRONG — causes "Unrecognized keys: [exclude]" build error
flutter_gen:
  output: lib/gen/
  exclude:           ← wrong level
    - .env.dev
```

```yaml
# CORRECT
flutter_gen:
  assets:
    exclude:         ← nested under assets:
      - .env.dev
```

---

### 5. Putting `flutter_gen` in `dev_dependencies`

`flutter_gen` provides `AssetGenImage` and `SvgGenImage` which are used in
widget code at runtime. If it's in `dev_dependencies`, release builds will
fail.

```yaml
# WRONG
dev_dependencies:
  flutter_gen: ^5.8.0
  flutter_gen_runner: ^5.8.0

# CORRECT
dependencies:
  flutter_gen: ^5.8.0        # runtime types

dev_dependencies:
  flutter_gen_runner: ^5.8.0 # generator only
```

---

### 6. Editing `assets.gen.dart` by hand

The file is regenerated on every codegen run. Any manual edits will be
overwritten.

**Fix:** configure the generator via `pubspec.yaml`'s `flutter_gen:` block,
not by editing the output file.

---

## Starting from Scratch (for new projects)

Follow these steps in order if you are setting up flutter_gen in a project
that doesn't have it yet.

### Step 1 — Create the asset directory structure

```bash
mkdir -p assets/images/illustrations
mkdir -p assets/icons/health
mkdir -p assets/icons/ui
mkdir -p assets/animations

touch assets/images/illustrations/.gitkeep
touch assets/icons/health/.gitkeep
touch assets/icons/ui/.gitkeep
touch assets/animations/.gitkeep
```

### Step 2 — Add packages to `pubspec.yaml`

```yaml
dependencies:
  flutter_svg: ^2.0.10
  flutter_gen: ^5.8.0

dev_dependencies:
  flutter_gen_runner: ^5.8.0
```

### Step 3 — Add `flutter_gen:` config to `pubspec.yaml`

Add at the **top level** (same level as `name:`, `dependencies:`):

```yaml
flutter_gen:
  output: lib/gen/
  line_length: 120

  integrations:
    flutter_svg: true

  # Optional: exclude asset-bundle files that are not widget assets
  # assets:
  #   exclude:
  #     - path/to/config-file.json
```

### Step 4 — Declare directories in `flutter: assets:`

```yaml
flutter:
  assets:
    - assets/images/
    - assets/images/illustrations/
    - assets/icons/health/
    - assets/icons/ui/
    - assets/animations/
```

### Step 5 — Get dependencies

```bash
fvm flutter pub get
```

### Step 6 — Run codegen

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### Step 7 — Verify output

```bash
cat lib/gen/assets.gen.dart
```

You should see an `Assets` class with accessors for every declared asset
directory.

### Step 8 — Export from your resources barrel

```dart
// lib/core/resources/resources.dart
export '../../gen/assets.gen.dart';
```

### Step 9 — Commit

```bash
git add pubspec.yaml pubspec.lock assets/ lib/gen/assets.gen.dart lib/core/resources/resources.dart
git commit -m "chore: add flutter_gen asset pipeline with SVG support"
```

> `assets.gen.dart` is committed intentionally. It is stable, human-readable,
> and lets CI build without running codegen.
