# Section 8: Platform Channels & Native Integration

---

**Q:** What is a Platform Channel? Why is it needed?

**A:** A Platform Channel is Flutter's mechanism for communicating between Dart code and native platform code (Kotlin/Java on Android, Swift/Objective-C on iOS). It acts as a named, asynchronous message-passing bridge.

Flutter's engine renders its own UI and runs Dart in its own VM. It does not have direct access to platform-specific APIs like the camera hardware, Bluetooth stack, biometric authentication, battery info, or any OS-level service. Platform Channels solve this by letting Dart send a message across the bridge, the native side receives it, does the platform work, and sends a result back.

```
  Dart (Flutter)                        Native (Android / iOS)
 ┌──────────────────┐                  ┌──────────────────────┐
 │                  │   method name    │                      │
 │  invokeMethod()  │ ──────────────►  │  onMethodCall()      │
 │                  │   + arguments    │  (Kotlin / Swift)    │
 │                  │                  │                      │
 │  await result    │ ◄──────────────  │  result.success()    │
 │                  │   return value   │                      │
 └──────────────────┘                  └──────────────────────┘
           ▲                                     ▲
           └──────── Platform Channel ───────────┘
                  (named, async, binary)
```

There are three types of Platform Channels:

- **MethodChannel** — one-shot request/response calls (most common).
- **EventChannel** — continuous streams of data from native to Dart.
- **BasicMessageChannel** — free-form message passing with a codec.

All three use asynchronous messaging; you never block the UI thread.

**Example:**
```dart
// Check battery level — not available in pure Dart
final channel = MethodChannel('com.example.app/battery');
final int level = await channel.invokeMethod('getBatteryLevel');
```

**Why it matters:** Interviewers want to know you understand Flutter's architecture boundary. If you think Flutter can directly call Android/iOS APIs, that's a fundamental misunderstanding.

**Common mistake:** Saying Platform Channels are synchronous or that they use HTTP. They use binary message passing through the Flutter engine on the same device — there is no network involved. Also, candidates sometimes forget these calls must be async.

---

**Q:** How does MethodChannel work — calling native code from Dart and returning a result? Show an example with Android (Kotlin), iOS (Swift), and Dart.

**A:** MethodChannel uses a name string (like `"com.example.app/battery"`) shared between Dart and native. Dart calls `invokeMethod` with a method name and optional arguments. The native side registers a handler that receives the call, performs the work, and returns a result through the `Result` callback.

The flow:

```
Dart                     Engine                    Native
 │                         │                         │
 │ invokeMethod("getX")    │                         │
 │ ──────────────────────► │ ──────────────────────► │
 │                         │  binary message          │
 │                         │                         │ runs native code
 │                         │                         │
 │          result         │ ◄────────────────────── │
 │ ◄────────────────────── │  result.success(val)    │
 │                         │                         │
```

Messages are encoded using `StandardMethodCodec`, which supports: `null`, `bool`, `int`, `double`, `String`, `Uint8List`, `List`, and `Map`.

**Example:**

**Dart side (lib/battery_service.dart):**
```dart
import 'package:flutter/services.dart';

class BatteryService {
  static const _channel = MethodChannel('com.example.app/battery');

  Future<int> getBatteryLevel() async {
    try {
      final int level = await _channel.invokeMethod('getBatteryLevel');
      return level;
    } on PlatformException catch (e) {
      throw Exception('Failed to get battery level: ${e.message}');
    }
  }
}
```

**Android side (android/app/.../MainActivity.kt):**
```kotlin
package com.example.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.BatteryManager
import android.content.Context

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.app/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getBatteryLevel" -> {
                        val batteryManager =
                            getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                        val level = batteryManager.getIntProperty(
                            BatteryManager.BATTERY_PROPERTY_CAPACITY
                        )
                        if (level != -1) {
                            result.success(level)
                        } else {
                            result.error("UNAVAILABLE", "Battery level not available", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
```

**iOS side (ios/Runner/AppDelegate.swift):**
```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.example.app/battery",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "getBatteryLevel":
                UIDevice.current.isBatteryMonitoringEnabled = true
                let level = Int(UIDevice.current.batteryLevel * 100)
                if level >= 0 {
                    result(level)
                } else {
                    result(FlutterError(
                        code: "UNAVAILABLE",
                        message: "Battery level not available",
                        details: nil
                    ))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

**Why it matters:** This is the single most common Platform Channel question. The interviewer checks whether you can wire all three layers correctly, handle errors properly, and understand the asynchronous nature.

**Common mistake:** Forgetting to handle `notImplemented()` for unknown methods on the native side. Another mistake is using a mismatched channel name between Dart and native — the string must be identical. Also, not wrapping the Dart call in `try/catch` for `PlatformException`.

---

**Q:** How does EventChannel work for continuous data streams from native? Give an example use case.

**A:** EventChannel establishes a long-lived stream from native to Dart. Instead of a one-shot call-and-response, native code can continuously push events to Dart. On the Dart side, you listen via a `Stream`. On the native side, you implement a `StreamHandler` with `onListen` (start sending) and `onCancel` (stop sending) callbacks.

```
Dart                          Native
 │                              │
 │  stream.listen(...)          │
 │ ──────────────────────────►  │ onListen() → start producing events
 │                              │
 │  ◄── event 1 ──────────     │ eventSink.success(data)
 │  ◄── event 2 ──────────     │ eventSink.success(data)
 │  ◄── event 3 ──────────     │ eventSink.success(data)
 │  ...                         │
 │                              │
 │  subscription.cancel()       │
 │ ──────────────────────────►  │ onCancel() → stop & clean up
 │                              │
```

Typical use cases: sensor data (accelerometer, gyroscope), GPS location updates, Bluetooth data streams, connectivity changes, native audio level metering.

**Example — Streaming accelerometer data:**

**Dart side:**
```dart
import 'package:flutter/services.dart';

class AccelerometerService {
  static const _channel = EventChannel('com.example.app/accelerometer');

  Stream<Map<String, double>> get accelerometerEvents {
    return _channel.receiveBroadcastStream().map((event) {
      final data = Map<String, dynamic>.from(event);
      return {
        'x': (data['x'] as num).toDouble(),
        'y': (data['y'] as num).toDouble(),
        'z': (data['z'] as num).toDouble(),
      };
    });
  }
}

// Usage in a widget:
// AccelerometerService().accelerometerEvents.listen((data) {
//   print('x=${data['x']}, y=${data['y']}, z=${data['z']}');
// });
```

**Android side (Kotlin):**
```kotlin
import io.flutter.plugin.common.EventChannel
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager

class AccelerometerStreamHandler(private val sensorManager: SensorManager)
    : EventChannel.StreamHandler, SensorEventListener {

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        val accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_UI)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this)
        eventSink = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            eventSink?.success(mapOf(
                "x" to it.values[0],
                "y" to it.values[1],
                "z" to it.values[2]
            ))
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}
```

**Why it matters:** Interviewers test whether you know the difference between one-shot (MethodChannel) and streaming (EventChannel) patterns. Many candidates only know MethodChannel.

**Common mistake:** Using MethodChannel with polling (calling it repeatedly on a timer) instead of EventChannel for continuous data. Another mistake is forgetting to unregister the native listener in `onCancel`, causing memory leaks and battery drain. Also, not handling the case where the Dart subscription is cancelled — native must respect `onCancel`.

---

**Q:** What is BasicMessageChannel? When would you use it instead of MethodChannel?

**A:** BasicMessageChannel is the simplest form of Platform Channel. It sends raw messages back and forth with a specified codec — no concept of "method names" or "method calls." Both sides can send and receive messages freely.

You choose a codec when creating the channel:

- `StringCodec` — plain text strings.
- `BinaryCodec` — raw `ByteData`.
- `JSONMessageCodec` — JSON-encoded maps/lists.
- `StandardMessageCodec` — Flutter's default binary codec.

```
   MethodChannel                    BasicMessageChannel
 ┌──────────────────┐            ┌──────────────────────┐
 │ invokeMethod(     │            │ send(message)        │
 │   'methodName',   │            │                      │
 │   arguments       │            │ (any shape, no       │
 │ )                 │            │  method dispatch)     │
 │                   │            │                      │
 │ Has built-in      │            │ No method routing.   │
 │ method dispatch.  │            │ You parse the data   │
 │                   │            │ yourself.            │
 └──────────────────┘            └──────────────────────┘
```

**When to use BasicMessageChannel instead of MethodChannel:**

1. You need bidirectional communication where native initiates messages to Dart frequently (not just responses).
2. You are exchanging simple data (like a JSON config blob) without the overhead of method names.
3. You want to implement a custom protocol or message format.
4. You are sending large binary data (with `BinaryCodec`) where MethodChannel's codec overhead is unnecessary.

**Example:**
```dart
import 'package:flutter/services.dart';

// Dart side — exchanging JSON messages
final channel = BasicMessageChannel<String>(
  'com.example.app/config',
  StringCodec(),
);

// Send a message to native
final String? reply = await channel.send('{"action": "getConfig"}');

// Receive messages from native
channel.setMessageHandler((String? message) async {
  print('Native says: $message');
  return 'acknowledged'; // reply back
});
```

**Why it matters:** Interviewers check if you understand the full Platform Channel spectrum, not just MethodChannel. Knowing when BasicMessageChannel fits shows architectural depth.

**Common mistake:** Saying BasicMessageChannel is deprecated or not useful. It is actively maintained and is the right choice when you don't need method-call semantics. Another mistake is confusing it with EventChannel — BasicMessageChannel is bidirectional but message-based, not stream-based.

---

**Q:** What is Dart FFI (dart:ffi)? How does it differ from Platform Channels? When would you use it?

**A:** Dart FFI (Foreign Function Interface) lets Dart call C/C++ functions directly, synchronously, without going through the Flutter engine's message-passing system. You load a shared library (`.so` on Android, `.dylib` on macOS/iOS) and call its exported functions from Dart.

```
  Platform Channels                          Dart FFI
 ┌─────────────────────────┐    ┌──────────────────────────────┐
 │ Dart ↔ Engine ↔ Native  │    │ Dart ───► C/C++ library      │
 │                         │    │ (direct function call)        │
 │ Async, message-based    │    │ Synchronous, zero-copy        │
 │ Supports Kotlin/Swift   │    │ Only C/C++ ABI               │
 │ Runs on platform thread │    │ Runs on calling isolate       │
 │ ~0.1ms overhead/call    │    │ ~microsecond overhead          │
 └─────────────────────────┘    └──────────────────────────────┘
```

Key differences:

| Aspect | Platform Channels | Dart FFI |
|--------|-------------------|----------|
| Target language | Kotlin/Java, Swift/ObjC | C / C++ |
| Communication | Async messages | Sync function calls |
| Performance | Good (~0.1ms per call) | Excellent (~μs per call) |
| Data passing | Serialized via codecs | Pointers, structs, raw memory |
| Use case | OS APIs, UI-layer native code | Crypto, image processing, audio DSP |

**Example:**
```dart
import 'dart:ffi';
import 'dart:io' show Platform;

// Define the C function signature
typedef NativeAdd = Int32 Function(Int32 a, Int32 b);
typedef DartAdd = int Function(int a, int b);

void main() {
  // Load the native library
  final DynamicLibrary nativeLib = Platform.isAndroid
      ? DynamicLibrary.open('libnative_math.so')
      : DynamicLibrary.open('native_math.framework/native_math');

  // Look up the function
  final add = nativeLib.lookupFunction<NativeAdd, DartAdd>('add_numbers');

  // Call it — synchronous, no await needed
  final result = add(3, 7);
  print(result); // 10
}
```

Corresponding C code:
```c
// native_math.c
#include <stdint.h>

int32_t add_numbers(int32_t a, int32_t b) {
    return a + b;
}
```

**When to use Dart FFI:**

- You need high-frequency calls with very low latency (audio processing, physics simulations).
- You already have a C/C++ library you want to reuse (SQLite, OpenCV, TensorFlow Lite C API).
- You need synchronous results without `await`.
- You want to share native code across platforms without writing Kotlin and Swift separately.

Use the `ffigen` package to auto-generate Dart bindings from C header files.

**Why it matters:** FFI shows you understand performance trade-offs. Interviewers want to see you can pick the right tool: Platform Channels for OS APIs, FFI for computational libraries.

**Common mistake:** Saying FFI replaces Platform Channels. It does not — you cannot call Kotlin or Swift APIs through FFI. FFI only works with C-ABI-compatible code. Also, candidates sometimes forget that FFI calls block the current isolate, so heavy FFI work should be run in a separate isolate.

---

**Q:** How do you add a Flutter module to an existing native Android or iOS app?

**A:** This is called "add-to-app." You create a Flutter module (not a full Flutter app), then embed it into the existing native project as a dependency.

```
 Existing Native App
 ┌─────────────────────────────────────┐
 │  Native Activity / ViewController   │
 │  ┌───────────────────────────────┐  │
 │  │  FlutterActivity /            │  │
 │  │  FlutterViewController        │  │
 │  │  ┌─────────────────────────┐  │  │
 │  │  │   Flutter Module UI     │  │  │
 │  │  │   (Dart code)           │  │  │
 │  │  └─────────────────────────┘  │  │
 │  └───────────────────────────────┘  │
 │  Other native screens...            │
 └─────────────────────────────────────┘
```

**Step 1: Create the Flutter module:**
```bash
flutter create --template module my_flutter_module
```

This creates a module with a `.android/` and `.ios/` hidden directory (host app wrappers for development) and a `lib/` directory for your Dart code.

**Step 2 (Android): Add to the native Android app:**

In the native app's `settings.gradle`:
```groovy
// settings.gradle
include ':app'

setBinding(new Binding([gradle: this]))
evaluate(new File(
    settingsDir.parentFile,
    'my_flutter_module/.android/include_flutter.groovy'
))
```

In the native app's `app/build.gradle`:
```groovy
dependencies {
    implementation project(':flutter')
}
```

Then launch Flutter from a native Activity:
```kotlin
import io.flutter.embedding.android.FlutterActivity

// Open Flutter as a full screen
startActivity(
    FlutterActivity.createDefaultIntent(this)
)

// Or with a specific Dart entrypoint / route
startActivity(
    FlutterActivity
        .withNewEngine()
        .initialRoute("/settings")
        .build(this)
)
```

**Step 2 (iOS): Add to the native iOS app:**

In the native app's `Podfile`:
```ruby
flutter_application_path = '../my_flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'MyNativeApp' do
  install_all_flutter_pods(flutter_application_path)
end
```

Then run `pod install`. In Swift:
```swift
import Flutter

let flutterEngine = FlutterEngine(name: "my flutter engine")
flutterEngine.run()

let flutterVC = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
present(flutterVC, animated: true)
```

**Step 3:** Use `FlutterEngine` caching for faster startup if the Flutter screen is opened frequently. Pre-warm the engine in `Application` / `AppDelegate`.

**Why it matters:** Many companies adopt Flutter incrementally. Interviewers want to know if you can integrate Flutter into a brownfield (existing) project, not just build greenfield apps.

**Common mistake:** Confusing `flutter create --template module` with `flutter create --template app`. A module does not have its own `android/` and `ios/` directories in the same way — it has hidden `.android/` and `.ios/` wrappers. Another mistake is not pre-warming the FlutterEngine, leading to a visible delay when the Flutter screen first opens.

---

**Q:** How do you write a simple Flutter plugin package? Describe the structure, pubspec, and platform implementations.

**A:** A Flutter plugin is a package that includes platform-specific code (Kotlin/Swift) alongside Dart code. It exposes a unified Dart API that internally uses Platform Channels.

**Create the plugin:**
```bash
flutter create --template=plugin --platforms=android,ios my_plugin
```

**Directory structure:**
```
my_plugin/
├── lib/
│   ├── my_plugin.dart              ← Public Dart API
│   ├── my_plugin_method_channel.dart ← MethodChannel implementation
│   └── my_plugin_platform_interface.dart ← Abstract interface
├── android/
│   └── src/main/kotlin/.../
│       └── MyPlugin.kt             ← Android implementation
├── ios/
│   └── Classes/
│       └── MyPlugin.swift           ← iOS implementation
├── test/                            ← Dart unit tests
├── example/                         ← Example app using the plugin
└── pubspec.yaml
```

**pubspec.yaml:**
```yaml
name: my_plugin
description: A Flutter plugin for device info.
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'

dependencies:
  flutter:
    sdk: flutter
  plugin_platform_interface: ^2.1.0

flutter:
  plugin:
    platforms:
      android:
        package: com.example.my_plugin
        pluginClass: MyPlugin
      ios:
        pluginClass: MyPlugin
```

**Platform interface (lib/my_plugin_platform_interface.dart):**
```dart
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'my_plugin_method_channel.dart';

abstract class MyPluginPlatform extends PlatformInterface {
  MyPluginPlatform() : super(token: _token);
  static final Object _token = Object();
  static MyPluginPlatform _instance = MethodChannelMyPlugin();

  static MyPluginPlatform get instance => _instance;
  static set instance(MyPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getDeviceName();
}
```

**MethodChannel implementation (lib/my_plugin_method_channel.dart):**
```dart
import 'package:flutter/services.dart';
import 'my_plugin_platform_interface.dart';

class MethodChannelMyPlugin extends MyPluginPlatform {
  final _channel = const MethodChannel('my_plugin');

  @override
  Future<String?> getDeviceName() async {
    return await _channel.invokeMethod<String>('getDeviceName');
  }
}
```

**Public API (lib/my_plugin.dart):**
```dart
import 'my_plugin_platform_interface.dart';

class MyPlugin {
  Future<String?> getDeviceName() {
    return MyPluginPlatform.instance.getDeviceName();
  }
}
```

**Android (MyPlugin.kt):**
```kotlin
class MyPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "my_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getDeviceName") {
            result.success(android.os.Build.MODEL)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
```

**iOS (MyPlugin.swift):**
```swift
public class MyPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "my_plugin",
            binaryMessenger: registrar.messenger()
        )
        let instance = MyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getDeviceName" {
            result(UIDevice.current.name)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
```

**Why it matters:** Plugin authoring is a key skill for senior Flutter developers. Interviewers test whether you understand the federated plugin architecture (platform interface, method channel implementation, public API) and can maintain clean separation of concerns.

**Common mistake:** Putting platform channel logic directly in the public API class instead of using the platform interface pattern. Modern Flutter plugins use the `plugin_platform_interface` package so that platform implementations can be swapped (e.g., for testing or for web support). Also, forgetting to clean up the handler in `onDetachedFromEngine` on Android.

---

**Q:** What is Pigeon? How does it improve Platform Channel type safety?

**A:** Pigeon is a code-generation tool from the Flutter team that generates type-safe Platform Channel code from a Dart schema definition. Instead of manually writing string-based method names and casting untyped arguments, you define a Dart interface with concrete types, and Pigeon generates the Dart, Kotlin, Swift (and optionally C++/ObjC) boilerplate.

```
  Without Pigeon                       With Pigeon
 ┌────────────────────┐    ┌──────────────────────────────┐
 │ channel.invokeMethod│    │ Define schema in Dart        │
 │   ('getUser',       │    │           │                  │
 │    {'id': 42})      │    │     ┌─────▼─────┐            │
 │                     │    │     │  pigeon    │            │
 │ result is dynamic   │    │     │  codegen   │            │
 │ cast manually       │    │     └─────┬─────┘            │
 │ typos cause runtime │    │    ┌──────┼──────┐           │
 │ errors              │    │    ▼      ▼      ▼           │
 └────────────────────┘    │  Dart  Kotlin  Swift          │
                            │  (typed classes & methods)    │
                            │  Compile-time type safety     │
                            └──────────────────────────────┘
```

**Step 1: Define the schema (pigeons/messages.dart):**
```dart
import 'package:pigeon/pigeon.dart';

class UserRequest {
  late int userId;
}

class UserResponse {
  late String name;
  late String email;
  late int age;
}

@HostApi() // Native implements, Dart calls
abstract class UserApi {
  UserResponse getUser(UserRequest request);
}

@FlutterApi() // Dart implements, Native calls
abstract class UserNotificationApi {
  void onUserUpdated(UserResponse user);
}
```

**Step 2: Run code generation:**
```bash
dart run pigeon \
  --input pigeons/messages.dart \
  --dart_out lib/src/generated/messages.g.dart \
  --kotlin_out android/src/main/kotlin/com/example/Messages.g.kt \
  --swift_out ios/Classes/Messages.g.swift
```

**Step 3: Implement the native side (Kotlin example):**
```kotlin
// Pigeon generates the UserApi interface — you just implement it
class UserApiImpl : UserApi {
    override fun getUser(request: UserRequest): UserResponse {
        // Real database or API call here
        return UserResponse(
            name = "Alice",
            email = "alice@example.com",
            age = 30
        )
    }
}

// Register in configureFlutterEngine:
UserApi.setUp(flutterEngine.dartExecutor.binaryMessenger, UserApiImpl())
```

**Step 4: Call from Dart:**
```dart
final api = UserApi();
final response = await api.getUser(UserRequest(userId: 42));
print(response.name);  // "Alice" — fully typed, no casting
```

**Benefits over raw Platform Channels:**

- Compile-time errors if types don't match.
- No string-based method names to mistype.
- Auto-generated serialization — no manual codec work.
- `@HostApi` and `@FlutterApi` clearly define communication direction.
- Generated code handles null safety properly.

**Why it matters:** Pigeon is officially recommended by the Flutter team for non-trivial plugins. Interviewers want to see you know the modern tooling and aren't hand-rolling error-prone channel code for complex APIs.

**Common mistake:** Thinking Pigeon is a third-party package — it is maintained by the Flutter team (`package:pigeon`). Also, some candidates think Pigeon replaces Platform Channels. It does not — it generates Platform Channel code for you. Under the hood, the generated code still uses `BasicMessageChannel` with `StandardMessageCodec`.

---

**Q:** How do you handle platform-specific UI differences (adaptive design) in Flutter?

**A:** Platform-adaptive design means your app looks and feels native on each platform — Material on Android, Cupertino on iOS — while sharing the same business logic and most of the widget tree.

**Approach 1: Check the platform at runtime:**
```dart
import 'dart:io' show Platform;

Widget buildButton() {
  if (Platform.isIOS) {
    return CupertinoButton(
      child: Text('Tap me'),
      onPressed: _handleTap,
    );
  }
  return ElevatedButton(
    child: Text('Tap me'),
    onPressed: _handleTap,
  );
}
```

**Approach 2: Use Flutter's built-in adaptive constructors:**
```dart
// These widgets automatically adapt to the platform
AlertDialog.adaptive(
  title: Text('Confirm'),
  content: Text('Are you sure?'),
  actions: [
    adaptiveAction(context: context, child: Text('Cancel'), onPressed: () {}),
    adaptiveAction(context: context, child: Text('OK'), onPressed: () {}),
  ],
);

Switch.adaptive(value: _isOn, onChanged: _toggle);
Slider.adaptive(value: _volume, onChanged: _setVolume);
CircularProgressIndicator.adaptive();
```

**Approach 3: Build an adaptive widget helper:**
```dart
class AdaptiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const AdaptiveScaffold({
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text(title)),
        child: SafeArea(child: body),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
```

**Approach 4: Use `Theme.of(context).platform` for testability:**
```dart
Widget build(BuildContext context) {
  final platform = Theme.of(context).platform;
  switch (platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return _buildCupertinoLayout();
    default:
      return _buildMaterialLayout();
  }
}
```

Using `Theme.of(context).platform` is preferred over `dart:io Platform` because it can be overridden in tests and widget previews.

**Why it matters:** Interviewers want to know you can ship a single codebase that feels native on both platforms. This directly impacts user experience and app store review outcomes.

**Common mistake:** Using `dart:io Platform` everywhere instead of `Theme.of(context).platform`. The `dart:io` import crashes on web. Also, candidates sometimes over-adapt by writing entirely separate widget trees for each platform, defeating the purpose of cross-platform development. Adapt only the parts that genuinely differ (navigation style, dialogs, switches), not every widget.

---

**Q:** How do you check and request permissions (camera, location, notification) in Flutter?

**A:** Flutter does not have built-in permission management. The most widely used solution is the `permission_handler` package, which provides a unified API for both Android and iOS.

**Step 1: Add the dependency:**
```yaml
# pubspec.yaml
dependencies:
  permission_handler: ^11.0.0
```

**Step 2: Configure native projects:**

**Android (android/app/src/main/AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**iOS (ios/Runner/Info.plist):**
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby stores.</string>
```

On iOS, you must provide a usage description string or the app will crash when requesting.

**Step 3: Check and request in Dart:**
```dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Check status without prompting
  Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Request with full status handling
  Future<bool> requestCamera() async {
    final status = await Permission.camera.request();

    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        // User said no — can ask again next time
        return false;
      case PermissionStatus.permanentlyDenied:
        // User said "Don't ask again" — must go to Settings
        await openAppSettings();
        return false;
      case PermissionStatus.restricted:
        // iOS only — parental controls or MDM restriction
        return false;
      case PermissionStatus.limited:
        // iOS 14+ — limited photo access
        return false;
      default:
        return false;
    }
  }

  /// Request multiple at once
  Future<void> requestMultiple() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
      Permission.notification,
    ].request();

    statuses.forEach((permission, status) {
      print('$permission: $status');
    });
  }
}
```

**Permission request flow:**

```
  App requests permission
         │
         ▼
  ┌──────────────┐     Already granted?
  │ Check status │────── YES ──► Use the feature
  └──────┬───────┘
         │ NO
         ▼
  ┌──────────────┐     User taps Allow?
  │   .request() │────── YES ──► Use the feature
  └──────┬───────┘
         │ NO
         ▼
  ┌──────────────────┐
  │ permanentlyDenied?│── YES ──► openAppSettings()
  └──────┬───────────┘
         │ NO (just denied)
         ▼
  Show rationale, try later
```

**Why it matters:** Every production app needs permissions. Interviewers evaluate whether you handle all states (especially `permanentlyDenied`) gracefully and understand the platform differences (iOS usage descriptions, Android manifest declarations).

**Common mistake:** Only checking for `granted` and `denied` while ignoring `permanentlyDenied`. On Android, after the user denies twice, the system won't show the dialog again — you must direct them to app settings. Another mistake is forgetting the iOS `Info.plist` usage description strings, which cause an immediate crash, not a graceful error.

---

**Q:** How do you integrate a native SDK (e.g., payment SDK, maps) that has no existing Flutter plugin?

**A:** You have two main options: write a custom plugin package, or use Platform Channels directly in your app. For a one-off integration, in-app Platform Channels are simpler. For reusable or complex SDKs, create a proper plugin.

**Strategy overview:**

```
 Option A: In-App Channels              Option B: Plugin Package
 (quick, single project)               (reusable, publishable)
 ┌────────────────────┐                ┌─────────────────────────┐
 │ Your Flutter App   │                │  my_sdk_plugin/         │
 │ ├── lib/           │                │  ├── lib/               │
 │ │   └── sdk_bridge │                │  │   └── dart API       │
 │ ├── android/       │                │  ├── android/           │
 │ │   └── native glue│                │  │   └── native glue    │
 │ └── ios/           │                │  ├── ios/               │
 │     └── native glue│                │  │   └── native glue    │
 └────────────────────┘                │  └── example/           │
                                       └─────────────────────────┘
```

**Step-by-step (in-app approach):**

**Step 1: Add the native SDK.**

Android — add to `android/app/build.gradle`:
```groovy
dependencies {
    implementation 'com.payment.sdk:core:2.5.0'
}
```

iOS — add to `ios/Podfile`:
```ruby
target 'Runner' do
  pod 'PaymentSDK', '~> 2.5'
end
```

**Step 2: Write native bridge code.**

Android (Kotlin):
```kotlin
import com.payment.sdk.PaymentClient
import com.payment.sdk.PaymentResult

class PaymentBridge(private val activity: Activity)
    : MethodChannel.MethodCallHandler {

    private val client = PaymentClient(activity)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "processPayment" -> {
                val amount = call.argument<Double>("amount") ?: run {
                    result.error("INVALID_ARG", "Amount required", null)
                    return
                }
                val currency = call.argument<String>("currency") ?: "USD"

                client.processPayment(amount, currency) { paymentResult ->
                    when (paymentResult) {
                        is PaymentResult.Success ->
                            result.success(mapOf(
                                "transactionId" to paymentResult.transactionId,
                                "status" to "success"
                            ))
                        is PaymentResult.Failure ->
                            result.error(
                                "PAYMENT_FAILED",
                                paymentResult.message,
                                null
                            )
                    }
                }
            }
            else -> result.notImplemented()
        }
    }
}
```

Register in `MainActivity`:
```kotlin
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    val channel = MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "com.example.app/payment"
    )
    channel.setMethodCallHandler(PaymentBridge(this))
}
```

**Step 3: Write the Dart API:**
```dart
class PaymentService {
  static const _channel = MethodChannel('com.example.app/payment');

  Future<PaymentResult> processPayment({
    required double amount,
    String currency = 'USD',
  }) async {
    try {
      final result = await _channel.invokeMethod<Map>(
        'processPayment',
        {'amount': amount, 'currency': currency},
      );
      final map = Map<String, dynamic>.from(result!);
      return PaymentResult(
        transactionId: map['transactionId'] as String,
        status: map['status'] as String,
      );
    } on PlatformException catch (e) {
      throw PaymentException(e.message ?? 'Unknown payment error');
    }
  }
}

class PaymentResult {
  final String transactionId;
  final String status;
  PaymentResult({required this.transactionId, required this.status});
}

class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);
}
```

**Step 4: Repeat the native bridge for iOS (Swift) with the same channel name.**

**When the SDK needs a native View (like a map or card input field):**

Use `PlatformView` (`AndroidView` / `UiKitView`) to embed the native view into the Flutter widget tree:
```dart
// Dart side
Widget build(BuildContext context) {
  if (Platform.isAndroid) {
    return AndroidView(
      viewType: 'payment-card-input',
      creationParams: {'theme': 'dark'},
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
  return UiKitView(
    viewType: 'payment-card-input',
    creationParams: {'theme': 'dark'},
    creationParamsCodec: const StandardMessageCodec(),
  );
}
```

Register the native view factory on each platform. On Android, implement `PlatformViewFactory`; on iOS, implement `FlutterPlatformViewFactory`.

**Why it matters:** This is a practical, real-world skill. Many enterprise apps use proprietary SDKs with no community plugin. Interviewers want to see you can bridge the gap yourself.

**Common mistake:** Trying to call native SDK methods directly from Dart without a Platform Channel bridge. Another mistake is forgetting that native SDK callbacks often run on background threads — you must dispatch results back to the main/UI thread before calling `result.success()`. On Android, use `activity.runOnUiThread { }` if needed. Also, not handling the case where the native SDK requires Activity lifecycle awareness (like `onActivityResult` for payment flows).
