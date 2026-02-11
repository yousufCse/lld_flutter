# Flutter Flavor Implementation Guide

A comprehensive guide to implementing multi-environment (Dev, Staging, Production) configurations in Flutter with injectable dependency injection.

## Table of Contents

1. [Overview](#overview)
2. [Why Use Flavors?](#why-use-flavors)
3. [Architecture](#architecture)
4. [Step-by-Step Implementation](#step-by-step-implementation)
5. [Android Configuration](#android-configuration)
6. [iOS Configuration](#ios-configuration)
7. [Injectable Integration](#injectable-integration)
8. [Running & Building](#running--building)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)

---

## Overview

Flavors (also called build variants or schemes) allow you to create multiple versions of your app from a single codebase, each with different configurations, API endpoints, app names, and bundle identifiers.

### What You'll Achieve

- ✅ Three separate app versions: Dev, Staging, Production
- ✅ Different API endpoints per environment
- ✅ Different app names and icons
- ✅ Separate bundle identifiers (install all versions simultaneously)
- ✅ Environment-specific dependencies with injectable
- ✅ Type-safe configuration management

---

## Why Use Flavors?

### Without Flavors ❌

```dart
void main() {
  // Manual configuration changes
  String apiUrl = 'https://dev-api.example.com'; // Must change manually!
  bool debug = true; // Might forget to disable!
  runApp(MyApp());
}
```

**Problems:**
- Risk of deploying with wrong configuration
- Can't install dev and prod versions together
- Manual code changes required
- Easy to make mistakes

### With Flavors ✅

```dart
// main_dev.dart - Always uses dev settings
// main_staging.dart - Always uses staging settings
// main_prod.dart - Always uses production settings
```

**Benefits:**
- No manual configuration changes
- Install all versions on one device
- Automatic environment switching
- Type-safe configuration
- Reduced deployment errors

---

## Architecture

### File Structure

```
flutter_project/
├── .env.dev                          # Dev environment variables
├── .env.staging                      # Staging environment variables
├── .env.prod                         # Production environment variables
├── .env.example                      # Template for environment files
├── .gitignore                        # Exclude sensitive env files
│
├── lib/
│   ├── main_dev.dart                 # Dev entry point
│   ├── main_staging.dart             # Staging entry point
│   ├── main_prod.dart                # Production entry point
│   ├── main_common.dart              # Shared initialization logic
│   ├── app.dart                      # Root app widget
│   │
│   └── core/
│       ├── config/
│       │   ├── flavor_config.dart    # Flavor enum definition
│       │   ├── env_config.dart       # Environment configuration
│       │   └── app_config.dart       # App-wide configuration
│       │
│       ├── di/
│       │   ├── injectable_container.dart
│       │   ├── injection_names.dart
│       │   └── modules/
│       │       ├── external_module.dart
│       │       └── network_module.dart
│       │
│       └── constants/
│           ├── app_strings.dart
│           ├── app_paddings.dart
│           └── app_colors.dart
│
├── android/
│   └── app/
│       ├── build.gradle              # Flavor configuration
│       └── src/
│           ├── main/
│           ├── dev/                  # Dev-specific resources
│           ├── staging/              # Staging-specific resources
│           └── prod/                 # Prod-specific resources
│
└── ios/
    ├── Flutter/
    │   ├── Dev.xcconfig              # Dev configuration
    │   ├── Staging.xcconfig          # Staging configuration
    │   └── Prod.xcconfig             # Production configuration
    └── Runner.xcodeproj/
        └── project.pbxproj           # Xcode configurations
```

### Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│  flutter run -t lib/main_dev.dart --flavor dev             │
└─────────────────────────┬───────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  main_dev.dart                                              │
│  └─ AppConfig.initialize(Flavor.dev)                        │
│     └─ Loads .env.dev                                       │
│        └─ API: https://dev-api.example.com                  │
│           └─ Logging: VERBOSE                               │
└─────────────────────────┬───────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  mainCommon(Flavor.dev)                                     │
│  └─ configureDependencies(Flavor.dev)                       │
│     └─ getIt.init(environment: 'dev')                       │
│        └─ Injects @dev annotated services                   │
│           └─ DevLogger (verbose, colorful)                  │
│              └─ DevAnalytics (console only)                 │
└─────────────────────────┬───────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  runApp(MyApp())                                            │
│  └─ Uses AppConfig.instance for settings                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Step-by-Step Implementation

### 1. Add Dependencies

Update `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Dependency Injection
  get_it: ^7.6.0
  injectable: ^2.3.2
  
  # Environment Management
  flutter_dotenv: ^5.1.0
  
  # Networking
  dio: ^5.4.0
  
  # State Management
  flutter_bloc: ^8.1.3

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.7
  injectable_generator: ^2.4.1

flutter:
  assets:
    - .env.dev
    - .env.staging
    - .env.prod
```

Install dependencies:

```bash
flutter pub get
```

---

### 2. Create Environment Files

#### `.env.dev`

```bash
APP_NAME=MyApp Dev
API_BASE_URL=https://dev-api.example.com
API_KEY=dev_api_key_12345
ENABLE_LOGGING=true
SENTRY_DSN=
```

#### `.env.staging`

```bash
APP_NAME=MyApp Staging
API_BASE_URL=https://staging-api.example.com
API_KEY=staging_api_key_67890
ENABLE_LOGGING=true
SENTRY_DSN=https://staging-sentry-dsn
```

#### `.env.prod`

```bash
APP_NAME=MyApp
API_BASE_URL=https://api.example.com
API_KEY=prod_api_key_secret
ENABLE_LOGGING=false
SENTRY_DSN=https://prod-sentry-dsn
```

#### `.env.example` (Template)

```bash
APP_NAME=MyApp
API_BASE_URL=https://api.example.com
API_KEY=your_api_key_here
ENABLE_LOGGING=true
SENTRY_DSN=
```

#### Update `.gitignore`

```bash
# Environment files (exclude production secrets)
.env.dev
.env.staging
.env.prod

# Keep example file
!.env.example
```

---

### 3. Create Flavor Configuration

#### `lib/core/config/flavor_config.dart`

```dart
enum Flavor {
  dev,
  staging,
  prod;

  bool get isDev => this == Flavor.dev;
  bool get isStaging => this == Flavor.staging;
  bool get isProd => this == Flavor.prod;

  String get name {
    switch (this) {
      case Flavor.dev:
        return 'dev';
      case Flavor.staging:
        return 'staging';
      case Flavor.prod:
        return 'prod';
    }
  }

  String get displayName {
    switch (this) {
      case Flavor.dev:
        return 'Development';
      case Flavor.staging:
        return 'Staging';
      case Flavor.prod:
        return 'Production';
    }
  }

  String get envFile {
    switch (this) {
      case Flavor.dev:
        return '.env.dev';
      case Flavor.staging:
        return '.env.staging';
      case Flavor.prod:
        return '.env.prod';
    }
  }
}
```

---

### 4. Create Environment Configuration

#### `lib/core/config/env_config.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';

class EnvConfig {
  static Flavor? _currentFlavor;

  static Flavor get flavor => _currentFlavor!;

  static Future<void> initialize(Flavor flavor) async {
    _currentFlavor = flavor;
    await dotenv.load(fileName: flavor.envFile);
  }

  // API Configuration
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  // App Configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'MyApp';
  static bool get enableLogging => 
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

  // Third-party Services
  static String get sentryDsn => dotenv.env['SENTRY_DSN'] ?? '';

  // Feature Flags
  static bool get isAnalyticsEnabled => !flavor.isDev;
  static bool get isCrashReportingEnabled => flavor.isProd;
}
```

---

### 5. Create App Configuration

#### `lib/core/config/app_config.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_exercise/core/config/env_config.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';

class AppConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final ThemeData theme;

  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.theme,
  });

  static AppConfig? _instance;

  static AppConfig get instance => _instance!;

  static Future<void> initialize(Flavor flavor) async {
    await EnvConfig.initialize(flavor);

    _instance = AppConfig._(
      flavor: flavor,
      appName: EnvConfig.appName,
      apiBaseUrl: EnvConfig.apiBaseUrl,
      enableLogging: EnvConfig.enableLogging,
      theme: _getThemeForFlavor(flavor),
    );
  }

  static ThemeData _getThemeForFlavor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return ThemeData.light().copyWith(
          primaryColor: Colors.green,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        );
      case Flavor.staging:
        return ThemeData.light().copyWith(
          primaryColor: Colors.orange,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        );
      case Flavor.prod:
        return ThemeData.light().copyWith(
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        );
    }
  }

  bool get isProduction => flavor.isProd;
  bool get isDevelopment => flavor.isDev;
  bool get isStaging => flavor.isStaging;
}
```

---

### 6. Create Entry Points

#### `lib/main_dev.dart`

```dart
import 'package:flutter_exercise/core/config/app_config.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';
import 'package:flutter_exercise/main_common.dart';

/// 🟢 DEV ENVIRONMENT ENTRY POINT
/// Run with: flutter run -t lib/main_dev.dart --flavor dev
Future<void> main() async {
  await AppConfig.initialize(Flavor.dev);
  await mainCommon(Flavor.dev);
}
```

#### `lib/main_staging.dart`

```dart
import 'package:flutter_exercise/core/config/app_config.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';
import 'package:flutter_exercise/main_common.dart';

/// 🟡 STAGING ENVIRONMENT ENTRY POINT
/// Run with: flutter run -t lib/main_staging.dart --flavor staging
Future<void> main() async {
  await AppConfig.initialize(Flavor.staging);
  await mainCommon(Flavor.staging);
}
```

#### `lib/main_prod.dart`

```dart
import 'package:flutter_exercise/core/config/app_config.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';
import 'package:flutter_exercise/main_common.dart';

/// 🔴 PRODUCTION ENVIRONMENT ENTRY POINT
/// Run with: flutter run -t lib/main_prod.dart --flavor prod
Future<void> main() async {
  await AppConfig.initialize(Flavor.prod);
  await mainCommon(Flavor.prod);
}
```

---

### 7. Create Common Main

#### `lib/main_common.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_exercise/core/config/app_config.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';
import 'package:flutter_exercise/core/di/injectable_container.dart';
import 'package:flutter_exercise/app.dart';

Future<void> mainCommon(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection with flavor
  await configureDependencies(flavor);

  // Setup error handlers for production
  if (AppConfig.instance.isProduction) {
    FlutterError.onError = (details) {
      // Send to crash reporting service (Sentry, Crashlytics)
    };
  }

  runApp(const MyApp());
}
```

---

### 8. Create App Widget

#### `lib/app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_exercise/core/config/app_config.dart';
import 'package:flutter_exercise/core/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return MaterialApp.router(
      title: config.appName,
      theme: config.theme,
      routerConfig: router,
      debugShowCheckedModeBanner: config.isDevelopment,
      
      // Show environment banner in dev/staging
      builder: (context, child) {
        if (!config.isProduction) {
          return Banner(
            message: config.flavor.displayName.toUpperCase(),
            location: BannerLocation.topEnd,
            color: config.flavor.isDev ? Colors.green : Colors.orange,
            child: child!,
          );
        }
        return child!;
      },
    );
  }
}
```

---

## Android Configuration

### 1. Update `android/app/build.gradle`

```gradle
android {
    namespace = "com.example.flutter_exercise"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.flutter_exercise"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName
    }

    // ADD FLAVOR DIMENSIONS
    flavorDimensions = ["environment"]
    
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MyApp Dev"
        }
        
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MyApp Staging"
        }
        
        prod {
            dimension "environment"
            resValue "string", "app_name", "MyApp"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.debug
            minifyEnabled = true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            minifyEnabled = false
        }
    }
}
```

### 2. Update `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:label="@string/app_name"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Your activities here -->
        
    </application>
</manifest>
```

### 3. Create Flavor-Specific Resources (Optional)

```
android/app/src/
├── main/
│   ├── AndroidManifest.xml
│   └── res/
│       └── mipmap-*/
│           └── ic_launcher.png
├── dev/
│   └── res/
│       ├── mipmap-*/
│       │   └── ic_launcher.png      # Green icon
│       └── values/
│           └── strings.xml
├── staging/
│   └── res/
│       └── mipmap-*/
│           └── ic_launcher.png      # Orange icon
└── prod/
    └── res/
        └── mipmap-*/
            └── ic_launcher.png      # Blue icon
```

#### Example `strings.xml` for Dev:

```xml
<!-- android/app/src/dev/res/values/strings.xml -->
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">MyApp Dev</string>
</resources>
```

---

## iOS Configuration

### 1. Configuration Approach

You have **two options** for iOS configuration:

**Option A: Minimal Setup (Recommended for Beginners)** - Configure everything manually in Xcode  
**Option B: xcconfig Files (Advanced)** - Automate with configuration files

---

### Option A: Manual Xcode Configuration (Simple)

You don't need to create `.xcconfig` files. Just configure directly in Xcode:

#### Step 1: Open Xcode
```bash
cd ios
open Runner.xcworkspace
```

#### Step 2: Configure Build Settings Manually
1. Select **Runner** project → **Runner** target
2. Go to **Build Settings** tab
3. Search for **"Product Bundle Identifier"**
4. Click the dropdown arrow to expand per-configuration
5. Set different bundle IDs for each:
   - **Debug-dev**: `com.example.flutterExercise.dev`
   - **Debug-staging**: `com.example.flutterExercise.staging`
   - **Debug-prod**: `com.example.flutterExercise`
   - **Release-dev**: `com.example.flutterExercise.dev`
   - **Release-staging**: `com.example.flutterExercise.staging`
   - **Release-prod**: `com.example.flutterExercise`

6. Search for **"Product Name"** and set:
   - **Debug-dev**: `MyApp Dev`
   - **Debug-staging**: `MyApp Staging`
   - **Debug-prod**: `MyApp`
   - (Same for Release-*)

That's it! Skip to **Step 2: Configure Xcode** below.

---

### Option B: Using xcconfig Files (Advanced - Optional)

Create configuration files for automation (you can skip this if using Option A):

#### `ios/Flutter/Dev.xcconfig`

```ruby
#include "Generated.xcconfig"

// Required: Bundle identifier for dev flavor
PRODUCT_BUNDLE_IDENTIFIER=com.example.flutterExercise.dev

// Required: App display name
DISPLAY_NAME=MyApp Dev

// Optional: Specify entry point (if not using -t flag)
// FLUTTER_TARGET=lib/main_dev.dart

// Optional: Different app icon (only if you created AppIcon-Dev)
// ASSETCATALOG_COMPILER_APPICON_NAME=AppIcon-Dev
```

#### `ios/Flutter/Staging.xcconfig`

```ruby
#include "Generated.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER=com.example.flutterExercise.staging
DISPLAY_NAME=MyApp Staging
```

#### `ios/Flutter/Prod.xcconfig`

```ruby
#include "Generated.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER=com.example.flutterExercise
DISPLAY_NAME=MyApp
```

**What each line does:**

| Line | Required? | Purpose |
|------|-----------|---------|
| `#include "Generated.xcconfig"` | ✅ YES | Includes Flutter's generated settings |
| `PRODUCT_BUNDLE_IDENTIFIER` | ✅ YES | Sets unique bundle ID per flavor |
| `DISPLAY_NAME` | ✅ YES | Sets app name shown on device |
| `FLUTTER_TARGET` | ❌ Optional | Auto-selects entry point (not needed if using `-t` flag) |
| `ASSETCATALOG_COMPILER_APPICON_NAME` | ❌ Optional | Uses different icons (only if you created them) |

**Minimal version (Recommended):**

```ruby
#include "Generated.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER=com.example.flutterExercise.dev
DISPLAY_NAME=MyApp Dev
```

### 2. Configure Xcode

Open Xcode:

```bash
cd ios
open Runner.xcworkspace
```

#### Step 2.1: Create Build Configurations

1. Select **Runner** project in navigator
2. Select **Runner** target
3. Go to **Info** tab
4. Under **Configurations**, duplicate existing configurations:
   - Duplicate **Debug** → **Debug-dev**
   - Duplicate **Debug** → **Debug-staging**
   - Duplicate **Debug** → **Debug-prod**
   - Duplicate **Release** → **Release-dev**
   - Duplicate **Release** → **Release-staging**
   - Duplicate **Release** → **Release-prod**

#### Step 2.2: Assign Configuration Files

For each configuration, assign the appropriate `.xcconfig` file:

| Configuration | Based on | Configuration File |
|--------------|----------|-------------------|
| Debug-dev | Debug | Dev.xcconfig |
| Debug-staging | Debug | Staging.xcconfig |
| Debug-prod | Debug | Prod.xcconfig |
| Release-dev | Release | Dev.xcconfig |
| Release-staging | Release | Staging.xcconfig |
| Release-prod | Release | Prod.xcconfig |

#### Step 2.3: Create Schemes

1. Go to **Product → Scheme → Manage Schemes**
2. Click **+** to create new schemes
3. Create three schemes:

**Dev Scheme:**
- Name: `dev`
- Build Configuration:
  - Run: Debug-dev
  - Test: Debug-dev
  - Profile: Release-dev
  - Analyze: Debug-dev
  - Archive: Release-dev

**Staging Scheme:**
- Name: `staging`
- Build Configuration:
  - Run: Debug-staging
  - Test: Debug-staging
  - Profile: Release-staging
  - Analyze: Debug-staging
  - Archive: Release-staging

**Prod Scheme:**
- Name: `prod`
- Build Configuration:
  - Run: Debug-prod
  - Test: Debug-prod
  - Profile: Release-prod
  - Analyze: Debug-prod
  - Archive: Release-prod

### 3. Update Info.plist

Edit `ios/Runner/Info.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    
    <key>CFBundleDisplayName</key>
    <string>$(DISPLAY_NAME)</string>
    
    <key>CFBundleName</key>
    <string>$(DISPLAY_NAME)</string>
    
    <!-- Other keys remain unchanged -->
</dict>
</plist>
```

---

## Injectable Integration

### 1. Update Injectable Container

#### `lib/core/di/injectable_container.dart`

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_exercise/core/config/flavor_config.dart';

import 'injectable_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies(Flavor flavor) async {
  // Pass flavor name to injectable
  getIt.init(environment: flavor.name.toLowerCase());
}
```

### 2. Create Custom Environment Annotations

#### `lib/core/config/injectable_environments.dart`

```dart
import 'package:injectable/injectable.dart';

// Custom environment annotations
const dev = Environment('dev');
const staging = Environment('staging');
const prod = Environment('prod');
```

### 3. Create Environment-Specific Modules

#### `lib/core/di/modules/external_module.dart`

```dart
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Common module (all environments)
@module
abstract class ExternalModule {
  @lazySingleton
  SharedPreferencesAsync get sharedPreferencesAsync => SharedPreferencesAsync();

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker.createInstance();
}

// Dev-only module
@dev
@module
abstract class DevModule {
  @lazySingleton
  Logger get logger => Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );
}

// Staging-only module
@staging
@module
abstract class StagingModule {
  @lazySingleton
  Logger get logger => Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
  );
}

// Production-only module
@prod
@module
abstract class ProdModule {
  @lazySingleton
  Logger get logger => Logger(
    printer: SimplePrinter(),
    level: Level.error, // Only errors in production
  );
}
```

### 4. Create Network Module

#### `lib/core/di/modules/network_module.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_exercise/core/config/env_config.dart';
import 'package:flutter_exercise/core/di/injection_names.dart';

@module
abstract class NetworkModule {
  @Named(InjectionNames.dioBasic)
  @lazySingleton
  Dio get basicDio {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': EnvConfig.apiKey,
        },
      ),
    );

    // Add logging interceptor only for dev/staging
    if (EnvConfig.enableLogging) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ));
    }

    return dio;
  }
}
```

### 5. Create Environment-Specific Services

#### `lib/core/services/analytics_service.dart`

```dart
import 'package:injectable/injectable.dart';

abstract class AnalyticsService {
  void logEvent(String name, Map<String, dynamic>? parameters);
}

// Dev implementation (console logging only)
@dev
@LazySingleton(as: AnalyticsService)
class DevAnalyticsService implements AnalyticsService {
  @override
  void logEvent(String name, Map<String, dynamic>? parameters) {
    print('📊 [DEV] Analytics: $name - $parameters');
  }
}

// Production implementation (real analytics)
@prod
@staging
@LazySingleton(as: AnalyticsService)
class ProdAnalyticsService implements AnalyticsService {
  @override
  void logEvent(String name, Map<String, dynamic>? parameters) {
    // Firebase Analytics, Mixpanel, etc.
    // FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }
}
```

### 6. Generate Injectable Code

Run code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates `injectable_container.config.dart` with all dependencies registered.

---

## Running & Building

### Development Commands

```bash
# Run on connected device
flutter run -t lib/main_dev.dart --flavor dev

# Run staging
flutter run -t lib/main_staging.dart --flavor staging

# Run production
flutter run -t lib/main_prod.dart --flavor prod
```

### Build Commands

#### Android

```bash
# Build Dev APK
flutter build apk -t lib/main_dev.dart --flavor dev

# Build Staging APK
flutter build apk -t lib/main_staging.dart --flavor staging

# Build Production APK (Release)
flutter build apk -t lib/main_prod.dart --flavor prod --release

# Build App Bundle for Play Store
flutter build appbundle -t lib/main_prod.dart --flavor prod --release
```

#### iOS

```bash
# Build Dev
flutter build ios -t lib/main_dev.dart --flavor dev

# Build Staging
flutter build ios -t lib/main_staging.dart --flavor staging

# Build Production IPA
flutter build ipa -t lib/main_prod.dart --flavor prod --release
```

### VS Code Configuration

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "🟢 Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
      "args": ["--flavor", "dev"]
    },
    {
      "name": "🟡 Staging",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_staging.dart",
      "args": ["--flavor", "staging"]
    },
    {
      "name": "🔴 Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": ["--flavor", "prod", "--release"]
    }
  ]
}
```

---

## Troubleshooting

### Issue: Bundle ID Not Changing (iOS)

**Solution:**

1. Clean build folder:
   ```bash
   cd ios
   rm -rf build
   flutter clean
   flutter pub get
   ```

2. Verify `.xcconfig` files are in `ios/Flutter/`
3. Check that schemes use correct configurations
4. Rebuild from Xcode

### Issue: Multiple Apps with Same Bundle ID

**Cause:** Xcode configurations not properly set.

**Solution:**

1. Open `Runner.xcworkspace` in Xcode
2. Go to Build Settings
3. Search for "Product Bundle Identifier"
4. Ensure it's set to `$(PRODUCT_BUNDLE_IDENTIFIER)`

### Issue: Environment Variables Not Loading

**Solution:**

1. Verify `.env.*` files are in project root
2. Check `pubspec.yaml` includes assets:
   ```yaml
   flutter:
     assets:
       - .env.dev
       - .env.staging
       - .env.prod
   ```
3. Run `flutter clean` and `flutter pub get`

### Issue: Injectable Not Finding Dependencies

**Solution:**

1. Ensure you ran code generation:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. Check that `injectable_container.config.dart` exists

3. Verify imports in modules use correct annotations

### Issue: Wrong Environment Running

**Solution:**

Always specify both `-t` and `--flavor`:

```bash
# ✅ Correct
flutter run -t lib/main_dev.dart --flavor dev

# ❌ Wrong (might use wrong configuration)
flutter run lib/main_dev.dart
```

---

## Best Practices

### 1. Security

- ❌ Never commit `.env.prod` with real secrets
- ✅ Use CI/CD to inject production secrets
- ✅ Keep `.env.example` in version control
- ✅ Add sensitive files to `.gitignore`

```gitignore
.env.dev
.env.staging
.env.prod
!.env.example
```

### 2. Naming Conventions

- Use lowercase for flavor names: `dev`, `staging`, `prod`
- Use descriptive display names: "MyApp Dev", "MyApp Staging"
- Suffix bundle IDs: `.dev`, `.staging`

### 3. Visual Differentiation

- Different app icons per flavor (green, orange, blue)
- Show environment banner in non-production builds
- Different theme colors per flavor

### 4. Dependency Injection

- Use `@dev`, `@staging`, `@prod` annotations
- Create separate implementations per environment
- Keep common dependencies in base module

### 5. Testing

```dart
// Test with specific flavor
void main() {
  setUp(() async {
    await AppConfig.initialize(Flavor.dev);
    await configureDependencies(Flavor.dev);
  });
  
  test('should load dev configuration', () {
    expect(AppConfig.instance.flavor, Flavor.dev);
    expect(EnvConfig.apiBaseUrl, contains('dev'));
  });
}
```

### 6. CI/CD Integration

#### GitHub Actions Example

```yaml
name: Build & Deploy

on:
  push:
    branches: [ main, develop ]

jobs:
  build-android-prod:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Create .env.prod
        run: echo "${{ secrets.ENV_PROD }}" > .env.prod
        
      - name: Build APK
        run: flutter build apk -t lib/main_prod.dart --flavor prod --release
        
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-prod-release.apk
          path: build/app/outputs/flutter-apk/app-prod-release.apk
```

#### Fastlane Configuration

**Android Fastfile** (`android/fastlane/Fastfile`):

```ruby
default_platform(:android)

platform :android do
  
  # Build and deploy Dev flavor
  lane :dev do
    sh("flutter clean")
    sh("flutter pub get")
    sh("flutter build apk -t lib/main_dev.dart --flavor dev")
  end
  
  # Build and deploy Staging flavor
  lane :staging do
    sh("flutter clean")
    sh("flutter pub get")
    sh("flutter build apk -t lib/main_staging.dart --flavor staging")
  end
  
  # Build and deploy Production flavor
  lane :prod do
    sh("flutter clean")
    sh("flutter pub get")
    sh("flutter build appbundle -t lib/main_prod.dart --flavor prod --release")
  end
  
  # Upload to Play Store (Internal Testing)
  lane :deploy_internal do
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/prodRelease/app-prod-release.aab'
    )
  end
  
  # Upload to Play Store (Production)
  lane :deploy_production do
    upload_to_play_store(
      track: 'production',
      aab: '../build/app/outputs/bundle/prodRelease/app-prod-release.aab'
    )
  end
  
end
```

**iOS Fastfile** (`ios/fastlane/Fastfile`):

```ruby
default_platform(:ios)

platform :ios do
  
  # Build Dev flavor
  lane :dev do
    sh("flutter clean")
    sh("flutter pub get")
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "dev",
      export_method: "development",
      output_directory: "../build/ios/ipa",
      output_name: "app-dev.ipa"
    )
  end
  
  # Build Staging flavor
  lane :staging do
    sh("flutter clean")
    sh("flutter pub get")
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "staging",
      export_method: "ad-hoc",
      output_directory: "../build/ios/ipa",
      output_name: "app-staging.ipa"
    )
  end
  
  # Build Production flavor
  lane :prod do
    sh("flutter clean")
    sh("flutter pub get")
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "prod",
      export_method: "app-store",
      output_directory: "../build/ios/ipa",
      output_name: "app-prod.ipa"
    )
  end
  
  # Upload to TestFlight
  lane :deploy_testflight do
    upload_to_testflight(
      ipa: "../build/ios/ipa/app-prod.ipa",
      skip_waiting_for_build_processing: true
    )
  end
  
  # Upload to App Store
  lane :deploy_appstore do
    upload_to_app_store(
      ipa: "../build/ios/ipa/app-prod.ipa",
      submit_for_review: false,
      automatic_release: false
    )
  end
  
end
```

**Usage:**

```bash
# Android
cd android
fastlane dev          # Build dev flavor
fastlane staging      # Build staging flavor
fastlane prod         # Build production flavor
fastlane deploy_internal    # Deploy to Play Store (Internal)
fastlane deploy_production  # Deploy to Play Store (Production)

# iOS
cd ios
fastlane dev                # Build dev flavor
fastlane staging            # Build staging flavor
fastlane prod               # Build production flavor
fastlane deploy_testflight  # Upload to TestFlight
fastlane deploy_appstore    # Upload to App Store
```

---

## Summary

### What You've Implemented

✅ **Multi-environment setup** (Dev, Staging, Production)  
✅ **Platform-specific configurations** (Android & iOS)  
✅ **Injectable integration** for environment-specific dependencies  
✅ **Type-safe configuration** management  
✅ **Separate bundle identifiers** for simultaneous installation  
✅ **Environment-specific theming** and branding  
✅ **Automated dependency injection** with code generation  

### Key Benefits

- 🚀 No manual configuration changes
- 🔒 Secure secret management
- 🧪 Easy testing across environments
- 📦 Professional deployment workflow
- 🎨 Visual differentiation per environment
- 🔧 Maintainable and scalable architecture

### Next Steps

1. Add feature flags for A/B testing
2. Integrate analytics per environment
3. Setup crash reporting (Sentry, Crashlytics)
4. Configure push notifications per flavor
5. Add CI/CD pipeline
6. Create separate Firebase projects per environment

---

## Resources

- [Flutter Flavors Documentation](https://docs.flutter.dev/deployment/flavors)
- [Injectable Package](https://pub.dev/packages/injectable)
- [flutter_dotenv Package](https://pub.dev/packages/flutter_dotenv)
- [Get_it Package](https://pub.dev/packages/get_it)

---

**Document Version:** 1.0  
**Last Updated:** January 2026  
**Author:** Md. Yousuf Ali
