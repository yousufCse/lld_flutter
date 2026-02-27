# Flutter Lint Rules & Analyzer Configuration Guide

> Complete guide to lint rules and static analysis configuration for clean, maintainable, and performant Flutter applications.

## Table of Contents

- [Overview](#overview)
- [Analyzer Configuration](#analyzer-configuration)
- [Lint Rules](#lint-rules)
- [Usage Guide](#usage-guide)
- [Best Practices](#best-practices)
- [CI/CD Integration](#cicd-integration)

---

## Overview

This project uses a comprehensive set of lint rules designed to enforce:

- ✅ **Clean Code** - Readable and maintainable code
- ✅ **Performance** - Optimized widget rebuilds and memory usage
- ✅ **Type Safety** - Catch errors at compile time
- ✅ **Best Practices** - Follow Flutter/Dart conventions
- ✅ **Error Prevention** - Avoid common pitfalls

**Base Configuration:** `package:flutter_lints/flutter.yaml`
**Custom Rules:** 60+ additional rules for production-grade code

---

## Analyzer Configuration

### File Exclusions

Generated files are excluded from analysis to improve performance and avoid false positives:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"           # json_serializable, injectable, etc.
    - "**/*.freezed.dart"     # freezed immutable models
    - "**/*.gr.dart"          # auto_route routing files
    - "**/*.config.dart"      # configuration files
    - "**/*.mocks.dart"       # mockito test mocks
    - "lib/generated/**"      # plugin registrations
    - "build/**"              # build output
    - ".dart_tool/**"         # Dart tooling cache
```

### Error Severity Levels

#### ❌ Errors (Must Fix)

| Rule | Description |
|------|-------------|
| `missing_required_param` | Required parameters must be provided |
| `missing_return` | All code paths must return values |
| `argument_type_not_assignable` | Type mismatches are errors |
| `invalid_assignment` | Invalid type assignments |
| `invalid_use_of_protected_member` | Respect @protected annotations |
| `invalid_use_of_internal_member` | Respect @internal annotations |
| `invalid_use_of_visible_for_testing_member` | Don't use test-only members in production |

#### ⚠️ Warnings (Should Fix)

| Rule | Description |
|------|-------------|
| `deprecated_member_use` | Using deprecated APIs |
| `unused_import` | Clean up unused imports |
| `unused_local_variable` | Remove unused variables |
| `unused_element` | Remove unused functions/classes |
| `dead_code` | Unreachable code |
| `unawaited_futures` | Missing await keywords (common bug!) |
| `avoid_print` | Use proper logging instead |
| `avoid_dynamic_calls` | Avoid dynamic type calls |

#### 🔕 Ignored

| Rule | Reason |
|------|--------|
| `invalid_annotation_target` | Required for some code generation packages |

### Strict Type Checking

```yaml
language:
  strict-casts: true        # No implicit downcasts
  strict-inference: true    # Stricter type inference
  strict-raw-types: true    # Require type parameters on generics
```

**Impact:** Catches type-related bugs at compile time instead of runtime.

---

## Lint Rules

### 🧹 Clean Code & Maintainability (17 rules)

| Rule | Why It Matters | Example |
|------|----------------|---------|
| `always_declare_return_types` | Self-documenting code | `String getName()` not `getName()` |
| `always_use_package_imports` | Easier refactoring | `import 'package:app/models/user.dart'` |
| `type_annotate_public_apis` | Clear API contracts | `final String name;` not `final name;` |
| `annotate_overrides` | Prevents breaking changes | `@override Widget build()` |
| `prefer_final_locals` | Immutability reduces bugs | `final user = getUser();` |
| `prefer_final_in_for_each` | Immutable loop variables | `for (final item in items)` |
| `avoid_empty_else` | Cleaner conditional logic | Remove empty else blocks |
| `avoid_relative_lib_imports` | Consistent import paths | No `../../` imports from lib/ |
| `avoid_redundant_argument_values` | Less noise | Don't pass default values |
| `prefer_collection_literals` | More readable | `[]` instead of `List()` |
| `prefer_if_null_operators` | Concise null handling | `a ?? b` instead of `a != null ? a : b` |
| `prefer_null_aware_operators` | Safe null access | `user?.name` |
| `prefer_is_not_operator` | Readable negation | `if (x is! String)` |
| `prefer_spread_collections` | Modern syntax | `[...items]` |
| `unnecessary_null_checks` | Avoid redundant checks | Already null-safe |
| `unnecessary_nullable_for_final_variable_declarations` | Cleaner declarations | Remove unnecessary `?` |

### ⚡ Performance (8 rules)

| Rule | Impact | Example |
|------|--------|---------|
| `prefer_const_constructors` | ⭐⭐⭐ Reduces rebuilds | `const Text('Hello')` |
| `prefer_const_constructors_in_immutables` | ⭐⭐⭐ Compile-time widgets | `const MyWidget()` |
| `prefer_const_declarations` | ⭐⭐ Compile-time constants | `const defaultPadding = 16.0` |
| `prefer_const_literals_to_create_immutables` | ⭐⭐⭐ Immutable collections | `const ['a', 'b']` |
| `avoid_function_literals_in_foreach_calls` | ⭐ Better iteration | Use `for-in` loops |
| `sized_box_for_whitespace` | ⭐⭐ Lighter widget | `SizedBox(height: 20)` vs `Container()` |
| `use_decorated_box` | ⭐ More efficient | `DecoratedBox` vs `Container` |

**Performance Impact Legend:**
- ⭐⭐⭐ High impact (widget rebuilds, memory)
- ⭐⭐ Medium impact
- ⭐ Low but cumulative impact

### 🎯 Flutter Best Practices (9 rules)

| Rule | Purpose | Example |
|------|---------|---------|
| `use_key_in_widget_constructors` | Widget identity & state preservation | `const MyWidget({super.key})` |
| `sort_child_properties_last` | Flutter convention | `child:` or `children:` last |
| `use_full_hex_values_for_flutter_colors` | Color clarity | `0xFF000000` not `0x000000` |
| `avoid_print` | Proper logging | Use `debugPrint()` or logger packages |
| `unnecessary_getters_setters` | Simpler code | Use public fields when no logic needed |
| `use_setters_to_change_properties` | Dart convention | Setters for side effects |
| `avoid_implementing_value_types` | Use composition | Don't implement int, String, etc. |

### 🎨 Code Style & Consistency (9 rules)

| Rule | Dart/Flutter Convention | Example |
|------|-------------------------|---------|
| `prefer_single_quotes` | Dart standard | `'hello'` not `"hello"` |
| `curly_braces_in_flow_control_structures` | Prevent bugs | Always use `{}` with if/for/while |
| `prefer_adjacent_string_concatenation` | Cleaner strings | `'hello' 'world'` |
| `prefer_interpolation_to_compose_strings` | Readable | `'Hello $name'` not `'Hello ' + name` |
| `use_rethrow_when_possible` | Preserve stack traces | `rethrow;` not `throw e;` |
| `avoid_catching_errors` | Catch specific exceptions | `on FormatException` not `on Error` |
| `only_throw_errors` | Proper error handling | Throw Exception/Error classes |
| `prefer_void_to_null` | Semantic correctness | `void` for callbacks with no return |

### 🛡️ Error Prevention (10 rules)

| Rule | Prevents | Example |
|------|----------|---------|
| `avoid_returning_null_for_void` | Logic errors | `void` functions shouldn't return null |
| `avoid_slow_async_io` | Performance issues | Avoid sync I/O in async code |
| `cancel_subscriptions` | Memory leaks | Always cancel StreamSubscription |
| `close_sinks` | Memory leaks | Always close StreamController/Sink |
| `avoid_web_libraries_in_flutter` | Platform issues | No `dart:html` in Flutter |
| `no_duplicate_case_values` | Logic errors | Unique case values in switch |
| `valid_regexps` | Runtime errors | Validate regex patterns |
| `avoid_types_as_parameter_names` | Name conflicts | Don't name params 'String', 'int', etc. |

### 🔄 Reusability & Composition (4 rules)

| Rule | Benefits | Example |
|------|----------|---------|
| `prefer_mixin` | Better composition | `mixin` instead of `class X extends Object` |
| `use_function_type_syntax_for_parameters` | Cleaner types | `void Function(int)` not `typedef` |
| `avoid_private_typedef_functions` | Public APIs | Use public typedefs |
| `prefer_generic_function_type_aliases` | Modern syntax | Generic function types |

### 📚 Documentation (2 rules)

| Rule | Purpose | Example |
|------|---------|---------|
| `slash_for_doc_comments` | Standard Dart docs | `/// Documentation` not `/** */` |
| `provide_deprecation_message` | Migration help | `@Deprecated('Use newMethod instead')` |

### 🔒 Null Safety & Security (4 rules)

| Rule | Safety Benefit | Example |
|------|----------------|---------|
| `avoid_dynamic_calls` | Type safety | Avoid calling methods on `dynamic` |
| `null_check_on_nullable_type_parameter` | Proper null handling | Handle nullable generics correctly |
| `no_leading_underscores_for_local_identifiers` | Naming convention | Local vars don't need `_` prefix |
| `no_leading_underscores_for_library_prefixes` | Public imports | Import prefixes are public |

---

## Usage Guide

### Running Analysis

```bash
# Analyze entire project
flutter analyze

# Analyze with fatal info-level issues (stricter)
flutter analyze --fatal-infos

# Analyze specific file
flutter analyze lib/main.dart
```

### Auto-Fixing Issues

```bash
# Show available fixes
dart fix --dry-run

# Apply all automatic fixes
dart fix --apply

# Format code
dart format lib/
```

### IDE Integration

**VS Code:**
- Issues show inline with squiggly lines
- Hover for quick fixes
- `Cmd/Ctrl + .` for quick fixes

**Android Studio / IntelliJ:**
- Issues highlighted in editor
- `Alt + Enter` for quick fixes
- Dart Analysis tool window

### Ignoring Specific Rules

**Single line:**
```dart
// ignore: avoid_print
print('Debug message');
```

**Entire file:**
```dart
// ignore_for_file: avoid_print

void debugFunction() {
  print('Debug info');
}
```

**Specific section:**
```dart
// ignore: prefer_const_constructors
final widget = Container();
// ignore: prefer_const_constructors
final widget2 = Container();
```

---

## Best Practices

### 1. Start Strict, Relax If Needed

✅ **Do:** Enable all rules, then selectively disable problematic ones
❌ **Don't:** Start with minimal rules and add later

### 2. Fix Issues Incrementally

For large codebases with many violations:

```bash
# Fix one category at a time
# 1. Performance issues first
# 2. Error prevention
# 3. Style issues
# 4. Documentation
```

### 3. Use Code Generation Wisely

Always exclude generated files:
```yaml
exclude:
  - "**/*.g.dart"
  - "**/*.freezed.dart"
```

### 4. Team Consistency

- Commit `analysis_options.yaml` to version control
- Review lint violations in PR reviews
- Run `flutter analyze` in CI/CD pipeline

### 5. Gradual Migration

For existing projects:
```yaml
# Start with warnings instead of errors
analyzer:
  errors:
    prefer_const_constructors: warning  # Change to error later
```

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Lint & Analyze
on: [pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run analyzer
        run: flutter analyze --fatal-infos

      - name: Check formatting
        run: dart format --set-exit-if-changed lib/
```

### GitLab CI

```yaml
analyze:
  stage: test
  image: cirrusci/flutter:stable
  script:
    - flutter pub get
    - flutter analyze --fatal-infos
    - dart format --set-exit-if-changed lib/
  only:
    - merge_requests
```

### Pre-commit Hook

Create `.git/hooks/pre-commit`:
```bash
#!/bin/sh
flutter analyze --fatal-infos
if [ $? -ne 0 ]; then
  echo "❌ Analyzer found issues. Commit aborted."
  exit 1
fi
```

---

## Common Issues & Solutions

### Issue: Too Many Violations

**Solution:** Fix by priority
1. Errors first
2. Performance issues
3. Error prevention
4. Style

### Issue: Generated Files Showing Errors

**Solution:** Check exclusions in `analyzer.exclude`

### Issue: False Positives

**Solution:** Use `// ignore:` for specific cases, not entire files

### Issue: Slow Analysis

**Solution:**
- Exclude unnecessary directories
- Close other IDE windows
- Increase IDE memory in settings

---

## Resources

### Official Documentation
- [Dart Lints](https://dart.dev/lints)
- [Flutter Lints Package](https://pub.dev/packages/flutter_lints)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Analysis Options](https://dart.dev/guides/language/analysis-options)

### Recommended Packages
- `flutter_lints` - Official Flutter lint rules
- `very_good_analysis` - Very Good Ventures lint rules
- `lint` - Community-driven lint package
- `custom_lint` - Create your own lint rules

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://reddit.com/r/FlutterDev)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

## Version History

| Date | Changes |
|------|---------|
| 2026-02-15 | Initial comprehensive configuration with 60+ rules |

---

**Maintained by:** Development Team
**Last Updated:** February 15, 2026
**Flutter SDK:** 3.10.0+

---

## Quick Reference Card

### Most Important Rules

| Category | Top 3 Rules |
|----------|-------------|
| **Performance** | `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `sized_box_for_whitespace` |
| **Safety** | `unawaited_futures`, `cancel_subscriptions`, `close_sinks` |
| **Maintainability** | `always_declare_return_types`, `type_annotate_public_apis`, `prefer_final_locals` |

### Commands Cheat Sheet

```bash
flutter analyze                    # Run analysis
flutter analyze --fatal-infos      # Strict mode
dart fix --apply                   # Auto-fix
dart format lib/                   # Format code
flutter pub get                    # Update dependencies
```

---

**Remember:** Lint rules are helpers, not obstacles. They catch bugs before users do! 🎯
