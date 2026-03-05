# Section 10: CI/CD, Flavors & App Release

## Flutter Senior Interview Preparation Guide

---

**Q:** What are Flutter flavors? How do you set up dev/staging/prod environments in both Android and iOS? What is the difference between dart-define and flavor?

**A:**

Flavors (also called build variants or schemes) let you produce multiple versions of your app from the same codebase. Each flavor can have its own app ID, app name, icon, API endpoint, and Firebase config. A typical setup includes three flavors: dev, staging, and prod.

**Android Setup (build.gradle):**

In `android/app/build.gradle`, you define product flavors inside the `android` block. Each flavor specifies a unique `applicationIdSuffix` and a `resValue` for the app name. The `flavorDimensions` declaration is required by Gradle.

```groovy
// android/app/build.gradle
android {
    flavorDimensions "environment"

    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            resValue "string", "app_name", "MyApp Dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            resValue "string", "app_name", "MyApp Staging"
        }
        prod {
            dimension "environment"
            resValue "string", "app_name", "MyApp"
        }
    }
}
```

**iOS Setup (Xcode Schemes + Configurations):**

In Xcode, you duplicate the existing Debug and Release configurations for each flavor (e.g. Debug-dev, Release-dev, Debug-staging, Release-staging). Then you create a new Scheme for each flavor, pointing each scheme to its matching configurations. Each configuration can set a different `PRODUCT_BUNDLE_IDENTIFIER` and `PRODUCT_NAME` in the build settings.

**Flavor vs dart-define:**

A flavor is a native build concept — it changes the app ID, name, icon, and native resources at the platform level. The `--dart-define` flag passes compile-time string constants into Dart code only. Flavors operate at the Android/iOS build system layer; dart-define operates at the Dart compiler layer. You typically use both together: flavors for native differentiation and dart-define for Dart-level configuration such as API URLs.

**Example:**

```bash
# Run with flavor
flutter run --flavor dev -t lib/main_dev.dart
```

```
  +---------------------+
  |   Flutter Codebase   |
  +----------+----------+
             |
    +--------+--------+--------+
    |        |        |        |
  [dev]  [staging]  [prod]
    |        |        |
  .dev ID  .stg ID  prod ID
  Dev icon  Stg icon Prod icon
  Dev API   Stg API  Prod API
```

**Why it matters:**
Interviewers want to confirm you can manage multiple environments without code duplication or manual config changes. This is fundamental for any team with a CI/CD pipeline and QA process.

**Common mistake:**
Confusing flavors with dart-define. Saying "I just use dart-define for everything" misses that dart-define cannot change the app ID, native resources, or icons. Another mistake is forgetting `flavorDimensions` on Android, which causes Gradle to fail silently or with a cryptic error.

---

**Q:** How does `--dart-define` work? How do you pass environment variables at build time?

**A:**

The `--dart-define` flag passes key-value pairs as compile-time constants to Dart code. These values are baked into the binary at build time — they are not runtime variables. The values are accessed in Dart using `String.fromEnvironment`, `bool.fromEnvironment`, or `int.fromEnvironment`. Because they are `const`, tree-shaking can eliminate dead code branches based on these values.

**Example:**

Passing values:

```bash
# Single variable
flutter run --dart-define=API_URL=https://dev.api.com

# Multiple variables
flutter run \
  --dart-define=API_URL=https://dev.api.com \
  --dart-define=API_KEY=abc123 \
  --dart-define=ENABLE_LOGS=true
```

Reading in Dart:

```dart
class EnvConfig {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://localhost',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  static const bool enableLogs = bool.fromEnvironment(
    'ENABLE_LOGS',
    defaultValue: false,
  );
}
```

Using `--dart-define-from-file` (Flutter 3.7+):

Instead of passing many flags, you can put them in a JSON file and reference it. This is cleaner for CI pipelines and avoids leaking secrets in command-line history.

```json
// env/dev.json
{
  "API_URL": "https://dev.api.com",
  "API_KEY": "abc123",
  "ENABLE_LOGS": "true"
}
```

```bash
flutter run --dart-define-from-file=env/dev.json
```

**Why it matters:**
This tests whether you understand compile-time vs runtime configuration. It also tests whether you know how to keep secrets out of source code — using CI environment variables injected via dart-define, rather than hardcoding values.

**Common mistake:**
Trying to read dart-define values using `Platform.environment` — that is for runtime OS environment variables, not compile-time defines. Another mistake is committing env JSON files with production secrets to version control.

---

**Q:** How do you manage different API URLs, keys, and configs per environment?

**A:**

The standard pattern is to combine flavors (for native-level separation) with a Dart environment config class that reads values from dart-define. You create a config class that exposes the correct API URL, keys, and feature flags based on the current environment. The environment is determined either by a dart-define value or by using separate main entry points per flavor.

**Example:**

Approach 1 — Separate entry points:

```dart
// lib/main_dev.dart
void main() {
  AppConfig.init(Environment.dev);
  runApp(const MyApp());
}

// lib/main_staging.dart
void main() {
  AppConfig.init(Environment.staging);
  runApp(const MyApp());
}

// lib/main_prod.dart
void main() {
  AppConfig.init(Environment.prod);
  runApp(const MyApp());
}
```

Config class:

```dart
enum Environment { dev, staging, prod }

class AppConfig {
  static late Environment env;
  static late String apiUrl;
  static late String apiKey;
  static late bool enableLogging;

  static void init(Environment e) {
    env = e;
    switch (e) {
      case Environment.dev:
        apiUrl = 'https://dev.api.example.com';
        apiKey = 'dev_key_xxx';
        enableLogging = true;
      case Environment.staging:
        apiUrl = 'https://staging.api.example.com';
        apiKey = 'staging_key_xxx';
        enableLogging = true;
      case Environment.prod:
        apiUrl = 'https://api.example.com';
        apiKey = const String.fromEnvironment('PROD_API_KEY');
        enableLogging = false;
    }
  }
}
```

Approach 2 — Pure dart-define (no separate entry points):

```dart
// Single main.dart reads everything from dart-define
void main() {
  final config = AppConfig(
    apiUrl: const String.fromEnvironment('API_URL'),
    apiKey: const String.fromEnvironment('API_KEY'),
    enableLogs: const bool.fromEnvironment('ENABLE_LOGS'),
  );
  runApp(MyApp(config: config));
}
```

```bash
# Build commands per environment:
flutter run --dart-define-from-file=env/dev.json
flutter run --dart-define-from-file=env/staging.json
flutter run --dart-define-from-file=env/prod.json
```

```
  CI Pipeline
      |
      v
  [env/dev.json] ---> --dart-define-from-file
      |                        |
      v                        v
  --flavor dev         Dart const values baked in
      |                        |
      v                        v
  Native: app ID,      Dart: API_URL, API_KEY,
  icon, name           feature flags
```

**Why it matters:**
Interviewers evaluate your ability to architect a clean environment separation strategy. Hardcoded URLs scattered across the codebase is a red flag. They want to see a centralized, maintainable config pattern.

**Common mistake:**
Hardcoding API URLs directly in service classes and using if-else to switch them. Another mistake is storing production API keys in the repository. Production secrets should be injected by the CI system, never committed.

---

**Q:** How does Flutter versioning work? Explain the pubspec version format (1.0.0+1) and how to auto-increment the build number in CI.

**A:**

The `version` field in `pubspec.yaml` follows the format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`. The part before the `+` is the version name (user-facing, shown in app stores). The part after the `+` is the build number (internal integer, used by the OS and stores to determine update ordering).

**Example:**

```yaml
# pubspec.yaml
version: 1.2.3+45
#        ^^^^^  ^^
#        |      |
#        |      +-- Build number (versionCode on Android,
#        |          CFBundleVersion on iOS)
#        |
#        +--------- Version name (versionName on Android,
#                    CFBundleShortVersionString on iOS)
```

Key rules:

On Android, the build number (`versionCode`) must be a strictly increasing integer for every upload to the Play Store. On iOS, the build number (`CFBundleVersion`) must increase for each upload to App Store Connect within the same version name. The version name is what users see (e.g. "1.2.3") and follows semantic versioning conventions.

Auto-incrementing in CI:

You can override the pubspec version at build time using the `--build-name` and `--build-number` flags. This means CI can compute the build number dynamically without editing `pubspec.yaml`.

```bash
# Use CI run number as build number
flutter build apk \
  --build-name=1.2.3 \
  --build-number=$GITHUB_RUN_NUMBER

# Or derive from git commit count
BUILD_NUM=$(git rev-list --count HEAD)
flutter build appbundle \
  --build-name=1.2.3 \
  --build-number=$BUILD_NUM
```

GitHub Actions example:

```yaml
- name: Build APK
  run: |
    flutter build apk \
      --release \
      --build-name=1.2.3 \
      --build-number=${{ github.run_number }}
```

**Why it matters:**
Interviewers want to know you understand why the build number must always increase and how to automate it. Manually editing pubspec.yaml for every build is error-prone and blocks CI automation.

**Common mistake:**
Forgetting that the Play Store rejects uploads if the versionCode does not strictly increase. Another mistake is confusing `build-name` (the display version) with `build-number` (the internal integer). Re-using the same build number after a failed upload is a common CI debugging headache.

---

**Q:** How do you set up a basic CI pipeline for Flutter using GitHub Actions (test, build APK/IPA)?

**A:**

GitHub Actions uses YAML workflow files placed in `.github/workflows/`. A basic Flutter CI pipeline typically has three stages: analyze, test, and build. The workflow triggers on push or pull request events, sets up the Flutter SDK, restores dependencies, and then runs each stage sequentially.

**Example:**

Complete workflow file:

```yaml
# .github/workflows/flutter_ci.yml
name: Flutter CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest     # Use macos-latest for iOS
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze code
        run: flutter analyze --fatal-infos

      - name: Run tests
        run: flutter test --coverage

      - name: Build APK
        run: |
          flutter build apk --release \
            --build-number=${{ github.run_number }}

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

For iOS builds, you need macOS runners (`macos-latest`) and code signing setup. The IPA build command is `flutter build ipa --release`. You must install certificates and provisioning profiles before the build step, typically using Fastlane match or manual setup via base64-encoded secrets.

```
  Push/PR to main
       |
       v
  +------------+     +-----------+     +------------+
  |  Checkout   | --> |  flutter  | --> |  flutter   |
  |  + Setup    |     |  analyze  |     |  test      |
  +------------+     +-----------+     +-----+------+
                                             |
                                    +--------+--------+
                                    |                 |
                              +-----+-----+    +-----+-----+
                              | Build APK |    | Build IPA |
                              | (Linux)   |    | (macOS)   |
                              +-----------+    +-----------+
                                    |                 |
                              Upload artifacts  Upload artifacts
```

**Why it matters:**
CI is expected in professional Flutter development. Interviewers want to see that you can automate quality checks and builds, not just code features. Knowing the YAML structure, caching, and artifact upload demonstrates production readiness.

**Common mistake:**
Trying to build iOS on a Linux runner — iOS builds require macOS and Xcode. Another mistake is not caching Flutter SDK or pub dependencies, which makes every CI run slow. Forgetting to upload the build artifact means the APK/IPA is lost when the runner is destroyed.

---

**Q:** What is Fastlane? How does Fastlane match work for iOS signing, and how does supply work for Android deployment?

**A:**

Fastlane is an open-source automation tool for building and releasing mobile apps. It eliminates manual steps for code signing, building, testing, and deploying to app stores. Fastlane uses a `Fastfile` (written in Ruby) to define lanes — each lane is a sequence of automated actions.

**Fastlane match (iOS signing):**

Managing iOS certificates and provisioning profiles manually across a team is painful. Fastlane match solves this by storing a single set of certificates and profiles in a private Git repo (or cloud storage). Every developer and CI machine fetches from the same source, guaranteeing consistent signing.

**Example:**

```ruby
# Initialize match (one-time setup)
fastlane match init

# Generate or fetch certificates
fastlane match development   # Dev profiles
fastlane match appstore      # Distribution profiles

# In Fastfile:
lane :beta do
  match(type: "appstore")     # Fetch signing assets
  build_app(
    scheme: "prod",
    export_method: "app-store"
  )
  upload_to_testflight
end
```

How match works:

```
  Private Git Repo (encrypted)
  +-----------------------------+
  | - Certificates (.cer, .p12) |
  | - Provisioning profiles     |
  +-------------+---------------+
                |
    +-----------+-----------+
    |           |           |
  Dev A       Dev B       CI Server
  (match)     (match)     (match)
    |           |           |
  Same certs  Same certs  Same certs
```

**Fastlane supply (Android deployment):**

Supply uploads your APK or AAB directly to the Google Play Store. It can target different tracks (internal, alpha, beta, production) and can also update store listings, screenshots, and metadata.

```ruby
# In Fastfile:
lane :deploy_android do
  supply(
    track: "internal",
    aab: "../build/app/outputs/bundle/prodRelease/app-prod-release.aab",
    json_key: "play-store-key.json",  # Service account key
    package_name: "com.example.myapp"
  )
end

# Promote from internal to production:
lane :promote do
  supply(
    track: "internal",
    track_promote_to: "production",
    json_key: "play-store-key.json",
    package_name: "com.example.myapp"
  )
end
```

**Why it matters:**
Interviewers look for experience with release automation. Manual app store uploads and signing do not scale for teams. Knowing Fastlane demonstrates that you have shipped production apps in a professional environment.

**Common mistake:**
Confusing match with cert and sigh — those are older Fastlane tools that create new certificates each time, leading to the revocation mess match was designed to prevent. Another mistake is committing the Google Play JSON key to the repo instead of injecting it as a CI secret.

---

**Q:** Explain code signing. What are an Android keystore and iOS certificates & provisioning profiles?

**A:**

Code signing is a security mechanism that proves your app was built by you and has not been tampered with. Both Android and iOS require apps to be signed before they can be installed on devices or uploaded to stores. The signing process uses public-key cryptography — you sign with your private key, and the OS or store verifies with your public key.

**Android Keystore:**

A keystore (`.jks` or `.keystore`) is a binary file containing one or more private keys, each protected by a password. When you build a release APK/AAB, Gradle signs it using the key from this keystore. The same keystore must be used for every update to the same app on the Play Store — if you lose it, you cannot update your app (unless you use Play App Signing).

**Example:**

```bash
# Generate a keystore
keytool -genkey -v \
  -keystore my-release-key.jks \
  -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -alias my-key-alias
```

```properties
# android/key.properties (NOT committed to git)
storePassword=myStorePass
keyPassword=myKeyPass
keyAlias=my-key-alias
storeFile=../my-release-key.jks
```

Configure Gradle to use it:

```groovy
// android/app/build.gradle
def keystoreProperties = new Properties()
keystoreProperties.load(
  new FileInputStream(rootProject.file("key.properties"))
)

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

**iOS Certificates & Provisioning Profiles:**

iOS signing requires two components working together. A signing certificate contains your private key and identity — it proves who built the app. A provisioning profile ties together the certificate, the app ID, and (for development/ad-hoc) a list of allowed device UUIDs. The profile tells iOS which certificate signed the app and where it is allowed to run.

```
  iOS Signing Model:

  +-------------------+       +-------------------------+
  | Signing           |       | Provisioning Profile    |
  | Certificate       |       |                         |
  | (.p12)            |       | Links:                  |
  |                   | <---- | - Certificate           |
  | Contains:         |       | - App ID (bundle ID)    |
  | - Private key     |       | - Device UUIDs (dev/ad) |
  | - Public key      |       | - Entitlements          |
  | - Identity        |       |                         |
  +-------------------+       +-------------------------+

  Profile types:
  - Development      -> run on registered test devices
  - Ad Hoc           -> distribute to specific devices
  - App Store        -> submit to App Store / TestFlight
  - Enterprise       -> internal company distribution
```

**Why it matters:**
Code signing issues are one of the most common blockers for junior-to-mid developers. Interviewers want to know that you understand the mechanics, can troubleshoot signing errors, and know how to manage keys securely across a team.

**Common mistake:**
Committing the keystore or `key.properties` to Git. Losing the Android keystore without having enrolled in Play App Signing. On iOS, creating multiple distribution certificates manually instead of using match, which causes revocation of teammates' certificates.

---

**Q:** How does Firebase App Distribution work for distributing test builds?

**A:**

Firebase App Distribution lets you send pre-release builds (APK, AAB, or IPA) to testers without going through an app store. Testers receive an email or in-app notification, click a link, and install the build directly on their device. It supports tester groups, build notes, and integrates with CI tools.

**Example:**

How the flow works:

```
  Developer / CI
       |
       v
  Build APK/IPA
       |
       v
  Upload to Firebase App Distribution
  (via CLI, Fastlane plugin, or console)
       |
       v
  Firebase sends invite emails
  to tester groups
       |
       v
  Testers:
  - Android: click link -> install APK
  - iOS: register device UDID -> install IPA
    (ad-hoc profile must include their device)
```

Upload via Firebase CLI:

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Upload APK
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_FIREBASE_APP_ID \
  --groups "qa-team,designers" \
  --release-notes "Fixed login bug, added dark mode"
```

Upload via Fastlane:

```ruby
# In Fastfile
lane :distribute do
  firebase_app_distribution(
    app: "1:1234567890:android:abc123",
    groups: "qa-team",
    release_notes: "Build from CI ##{ENV['BUILD_NUMBER']}",
    apk_path: "../build/app/outputs/flutter-apk/app-release.apk"
  )
end
```

Important iOS caveat: For iOS, you must use ad-hoc provisioning profiles that include each tester's device UDID. Firebase App Distribution can collect UDIDs via its onboarding flow, but you still need to regenerate the profile and rebuild when new testers are added. Alternatively, for iOS you can use TestFlight which does not require device registration.

**Why it matters:**
Distributing test builds efficiently is critical for fast iteration. Interviewers want to see that you know how to get builds to QA quickly without manual APK file sharing or ad-hoc methods like email attachments.

**Common mistake:**
On iOS, forgetting that ad-hoc distribution requires device UDIDs in the provisioning profile. Uploading an IPA signed with an App Store profile to Firebase — it will not install on devices because App Store profiles only work through TestFlight and App Store.

---

**Q:** How do you submit an app to the Google Play Store? Explain the tracks: internal, alpha, beta, production.

**A:**

Google Play Console organizes releases into tracks, each representing a stage in your rollout pipeline. You upload an AAB (or APK) to a track, and only users assigned to or opted into that track receive the build.

**Example:**

The four tracks:

```
  Track          Max testers      Approval    Use case
  -------        -----------      --------    --------
  Internal       100 (by email)   None        Quick smoke tests by team
  Closed/Alpha   Unlimited*       None        Wider internal / external QA
  Open/Beta      Unlimited        None        Public beta, anyone can opt-in
  Production     All users        Review**    Full public release

  * By invite link or tester lists
  ** First submission requires full review; updates may be faster
```

Submission steps:

1. Build a signed AAB: `flutter build appbundle --release`.
2. Log into Google Play Console, create a new release in your chosen track.
3. Upload the AAB. Google Play will generate optimized APKs for each device configuration via App Bundle processing.
4. Fill in release notes.
5. Review and roll out. For production, the first release requires a full review (store listing, content rating, privacy policy, etc.).

Staged rollout:

Production releases support staged rollouts. You can release to 5% of users, monitor crash rates and ANR data, then gradually increase to 100%. If issues appear, you can halt the rollout.

Promoting between tracks:

```
  Internal --> Closed/Alpha --> Open/Beta --> Production
     |              |               |             |
   100 testers   QA team      Public beta    All users
   No review     No review    No review      Full review
```

```ruby
# Promote via Fastlane supply:
supply(
  track: "internal",
  track_promote_to: "beta",
  json_key: "play-store-key.json"
)
```

**Why it matters:**
Understanding the Play Store release pipeline shows you have shipped apps professionally. Interviewers often ask about staged rollouts and how to handle a bad release — knowing you can halt a staged rollout demonstrates operational awareness.

**Common mistake:**
Uploading an APK instead of an AAB. Google Play now requires AAB for new apps. Another mistake is not understanding that the internal track has a 100-tester limit and is not suitable for large QA teams — use closed testing for that. Forgetting to increment the versionCode before uploading will cause the upload to be rejected.

---

**Q:** How do you submit an app to the Apple App Store? Describe the TestFlight flow.

**A:**

Submitting to the Apple App Store goes through App Store Connect. The process has two main phases: TestFlight for pre-release testing, and App Store submission for public release. Both start with uploading a signed IPA to App Store Connect.

**Example:**

Build and upload:

```bash
# Build IPA
flutter build ipa --release \
  --export-options-plist=ios/ExportOptions.plist

# Upload via Xcode (Transporter) or CLI
xcrun altool --upload-app \
  -f build/ios/ipa/MyApp.ipa \
  -t ios \
  --apiKey YOUR_KEY_ID \
  --apiIssuer YOUR_ISSUER_ID

# Or via Fastlane:
upload_to_testflight
```

TestFlight flow:

```
  Build IPA (signed with App Store cert)
       |
       v
  Upload to App Store Connect
       |
       v
  Apple processes build (5-30 min)
       |
       +----> Internal Testing
       |      - Up to 100 Apple Developer members
       |      - No Apple review needed
       |      - Available immediately after processing
       |
       +----> External Testing
              - Up to 10,000 testers (by email or link)
              - Requires Beta App Review (usually <24 hrs)
              - Testers install via TestFlight app
              - Build expires after 90 days
```

App Store submission:

Once testing is complete: 1) Select the build in App Store Connect. 2) Fill in app metadata — description, screenshots, keywords, privacy policy URL, app category. 3) Submit for App Review. Apple reviews typically take 24-48 hours. If approved, you can release immediately, on a scheduled date, or manually.

Key differences from Google Play:

Apple requires review even for external TestFlight builds. There is no direct equivalent to Google's internal track without review — internal TestFlight is limited to your developer account members. All iOS test builds expire after 90 days. There is no staged rollout percentage on iOS (though phased release over 7 days exists for production).

**Why it matters:**
iOS submission has more friction than Android, and many developers find it confusing. Interviewers want to see that you have navigated the full cycle — build, sign, upload, TestFlight, review, release. This is a strong signal of real-world shipping experience.

**Common mistake:**
Forgetting that external TestFlight requires Beta App Review. Signing with a development certificate instead of a distribution certificate — the upload will succeed but processing will fail. Not providing an `ExportOptions.plist`, which causes the `flutter build ipa` command to produce an incorrectly signed archive.

---

**Q:** What is app obfuscation? Why do it and how do you enable it in Flutter?

**A:**

Obfuscation renames your classes, methods, and fields to meaningless identifiers (like `aa`, `ab`, `b0`) in the compiled output. This makes it significantly harder for attackers to reverse-engineer your app using tools like apktool, jadx, or Hopper. Without obfuscation, someone can decompile your APK and read your business logic, API endpoints, and algorithms almost as if reading source code.

**Example:**

Enabling obfuscation:

```bash
# Build with obfuscation enabled
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/debug-info/

flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/debug-info/

flutter build ipa --release \
  --obfuscate \
  --split-debug-info=build/debug-info/
```

Why `--split-debug-info` is required:

The `--obfuscate` flag requires `--split-debug-info`. This flag extracts debug symbols into a separate directory. These symbols are a mapping from obfuscated names back to original names. You need them to decode stack traces from crash reports. Without them, crash reports show meaningless symbols and are useless for debugging.

Decoding obfuscated stack traces:

```bash
# When you receive a crash report with obfuscated symbols:
flutter symbolize \
  -i crash_stack_trace.txt \
  -d build/debug-info/

# This outputs the human-readable stack trace
# with original class and method names
```

What obfuscation does NOT protect:

Obfuscation does not encrypt strings. If you have `const String apiKey = 'secret123'` in your code, that string literal is still visible in the binary. For sensitive values, use server-side storage or runtime retrieval, not hardcoded constants. Obfuscation also does not prevent all reverse engineering — it only raises the difficulty.

```
  Before obfuscation:         After obfuscation:

  class PaymentService {      class a0 {
    String processCard(         String b(
      CardInfo info               c d
    ) {                         ) {
      validateCVV(info);          e(d);
      chargeAmount(info);         f(d);
    }                           }
  }                           }
```

**Why it matters:**
Interviewers evaluate your security awareness. Shipping without obfuscation is a security liability, especially for fintech, health, or enterprise apps. Knowing to archive the debug symbols shows you think about production supportability, not just development.

**Common mistake:**
Using `--obfuscate` without `--split-debug-info` — the build will fail because Flutter requires both. Another mistake is discarding the `debug-info` directory after the build. Without it, you cannot symbolize production crash reports. Always archive these symbols in CI alongside the build artifact.

---

**Q:** What is a build artifact? Explain the difference between APK and AAB, and why Google Play prefers AAB.

**A:**

A build artifact is any output produced by your build process — APKs, AABs, IPAs, debug symbols, test reports, and coverage files. In the context of Flutter Android releases, the two main artifacts are APK (Android Package) and AAB (Android App Bundle).

**APK (Android Package):**

An APK is a self-contained installable file. It includes compiled code, all resources for every screen density, all native libraries for every CPU architecture, and all language strings. The user downloads the full APK regardless of their device. An APK can be installed directly on a device (sideloaded) or distributed via any channel.

**AAB (Android App Bundle):**

An AAB is a publishing format — not directly installable. You upload it to the Play Store, and Google Play generates optimized APKs for each device configuration. A user with a Pixel 7 downloads only the resources for their screen density, their CPU architecture (arm64), and their language. This results in significantly smaller downloads.

**Example:**

```
  APK (monolithic):
  +----------------------------------+
  | Code (arm, arm64, x86, x86_64)   |
  | Resources (mdpi, hdpi, xhdpi,    |
  |   xxhdpi, xxxhdpi)               |
  | Strings (en, es, fr, de, ja ...) |
  | Total: ~25 MB                    |
  +----------------------------------+
           User downloads ALL of it

  AAB (split by Google Play):
  +----------------------------------+
  | Upload AAB to Play Store         |
  +----------------------------------+
           |
           v  Google generates splits
  +-------------+  +-------------+  +-------------+
  | Pixel 7     |  | Galaxy S23  |  | Budget phone|
  | arm64       |  | arm64       |  | arm         |
  | xxhdpi      |  | xxxhdpi     |  | hdpi        |
  | en only     |  | ko only     |  | es only     |
  | ~10 MB      |  | ~11 MB      |  | ~8 MB       |
  +-------------+  +-------------+  +-------------+
```

Build commands:

```bash
# Build APK (for direct distribution, testing, sideloading)
flutter build apk --release

# Build AAB (for Google Play Store)
flutter build appbundle --release

# APK output: build/app/outputs/flutter-apk/app-release.apk
# AAB output: build/app/outputs/bundle/release/app-release.aab
```

Why Google Play requires AAB for new apps:

Since August 2021, Google Play requires AAB for all new apps. The primary reason is download size optimization — smaller downloads mean higher install conversion rates and less storage used on devices. Google reports that apps using AAB see an average 15% size reduction. AAB also enables on-demand delivery of features and assets, dynamic feature modules, and Play Asset Delivery for large files like game assets.

When you still need APKs:

APKs remain necessary for: Firebase App Distribution, direct QA testing, enterprise sideloading, alternative app stores that do not support AAB, and local device testing during development.

**Why it matters:**
This is a foundational Android knowledge question. Interviewers expect you to know why AAB exists and when to use APK vs AAB. It also touches on app size optimization, which directly impacts user acquisition metrics.

**Common mistake:**
Thinking APK and AAB are interchangeable. Trying to sideload an AAB onto a device — it is not installable. Uploading an APK to Google Play for a new app — it will be rejected. Not understanding that AAB requires Google to sign your app with their key (Play App Signing), which some teams resist due to key ownership concerns.

---
