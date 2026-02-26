# iOS App Distribution — Complete Guide

> All content in this guide is sourced from official Apple documentation:
> - [Apple Developer — Certificates Overview](https://developer.apple.com/help/account/certificates/certificates-overview)
> - [Apple Developer — Create a CSR](https://developer.apple.com/help/account/certificates/create-a-certificate-signing-request)
> - [Apple Developer — Register a Single Device](https://developer.apple.com/help/account/register-devices/register-a-single-device)
> - [Apple Developer — Upload Builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds)
> - [App Store Connect Help — TestFlight Overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview)
> - [App Store Connect Help — Invite External Testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)
> - [App Store Connect Help — Add a New App](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app)

---

## Table of Contents

1. [Build Modes](#1-build-modes)
2. [Certificates](#2-certificates)
   - 2.1 [What is a Certificate and Why Is It Needed?](#21-what-is-a-certificate-and-why-is-it-needed)
   - 2.2 [Certificate Types](#22-certificate-types)
   - 2.3 [Create a Certificate Signing Request (CSR)](#23-create-a-certificate-signing-request-csr)
   - 2.4 [Create Apple Distribution Certificate — via Xcode](#24-create-apple-distribution-certificate--via-xcode)
   - 2.5 [Create Apple Distribution Certificate — via Apple Developer Web Portal](#25-create-apple-distribution-certificate--via-apple-developer-web-portal)
   - 2.6 [Certificate Expiration — What Happens](#26-certificate-expiration--what-happens)
3. [App ID](#3-app-id)
   - 3.1 [What is an App ID and Why Is It Needed?](#31-what-is-an-app-id-and-why-is-it-needed)
   - 3.2 [Create an App ID](#32-create-an-app-id)
4. [Devices and UDID](#4-devices-and-udid)
   - 4.1 [What is a UDID and Why Is It Needed?](#41-what-is-a-udid-and-why-is-it-needed)
   - 4.2 [How to Find a Device UDID](#42-how-to-find-a-device-udid)
   - 4.3 [Register a Device in Apple Developer Portal](#43-register-a-device-in-apple-developer-portal)
5. [Provisioning Profiles](#5-provisioning-profiles)
   - 5.1 [What is a Provisioning Profile and Why Is It Needed?](#51-what-is-a-provisioning-profile-and-why-is-it-needed)
   - 5.2 [Profile Types](#52-profile-types)
   - 5.3 [Create an Ad Hoc Provisioning Profile](#53-create-an-ad-hoc-provisioning-profile)
   - 5.4 [Create an App Store Provisioning Profile](#54-create-an-app-store-provisioning-profile)
6. [Ad Hoc Distribution](#6-ad-hoc-distribution)
   - 6.1 [What is Ad Hoc and Why Use It?](#61-what-is-ad-hoc-and-why-use-it)
   - 6.2 [Full Walkthrough — Ad Hoc to a Real Device](#62-full-walkthrough--ad-hoc-to-a-real-device)
7. [TestFlight Distribution](#7-testflight-distribution)
   - 7.1 [What is TestFlight and Why Use It?](#71-what-is-testflight-and-why-use-it)
   - 7.2 [Internal vs External Testing](#72-internal-vs-external-testing)
   - 7.3 [Full Walkthrough — Publish to TestFlight](#73-full-walkthrough--publish-to-testflight)
   - 7.4 [Invite Internal Testers](#74-invite-internal-testers)
   - 7.5 [Invite External Testers](#75-invite-external-testers)
8. [Ad Hoc vs TestFlight — Comparison](#8-ad-hoc-vs-testflight--comparison)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Build Modes

### What are Build Modes and Why Do They Exist?

Apple requires different build configurations for different stages of development. Each mode controls the level of optimization, debugging capability, and which signing identity is required. Using the wrong mode for the wrong purpose causes either poor performance or broken installs.

### The 3 Flutter Build Modes

| Mode | Command | Certificate Required | App Works After Unplug? | Performance |
|---|---|---|---|---|
| **Debug** | `fvm flutter run` | Apple Development | ❌ No | Slow |
| **Profile** | `fvm flutter run --profile` | Apple Development | ❌ No | Fast (release-level) |
| **Release** | `fvm flutter run --release` | Apple Distribution | ✅ Yes | Fast |

### Debug Mode

```bash
fvm flutter run --flavor prod -t lib/main_prod.dart
```

**Why this exists:** Debug mode keeps your app connected to the Dart VM running on your Mac. This connection is what enables hot reload and step-by-step debugging. Because the app depends on your Mac being present, iOS terminates it the moment the cable is unplugged.

- ✅ Hot reload and hot restart
- ✅ Step-by-step debugging in IDE
- ✅ Works with Development certificate (no setup needed)
- ❌ App is terminated when Mac is disconnected
- ❌ Not optimized — slower than what users experience
- ❌ Never use for user-facing testing

### Profile Mode

```bash
fvm flutter run --flavor prod -t lib/main_prod.dart --profile
```

**Why this exists:** Profile mode compiles the app the same way Release does — fully optimized, no debug overhead — but keeps the Dart VM profiler service alive so you can measure real performance. It uses the same Development certificate as Debug, so no extra signing setup is needed.

- ✅ Release-level performance and speed
- ✅ Works with Development certificate
- ✅ Use this to measure frame rates, memory, CPU
- ❌ App still terminates when Mac is disconnected
- ❌ Not for end-user distribution

### Release Mode

```bash
fvm flutter run --flavor prod -t lib/main_prod.dart --release
```

**Why this exists:** Release mode produces the final, fully compiled and optimized binary that real users run. The Dart VM is not included — the app is self-contained. Because it is self-contained and not supervised by Xcode, it requires a Distribution certificate to prove it was legitimately built by a registered developer.

- ✅ Fully optimized — what real users experience
- ✅ App works completely after unplugging
- ✅ App survives device reboot
- ❌ Requires Apple Distribution certificate
- ❌ Requires Ad Hoc or App Store provisioning profile

---

## 2. Certificates

### 2.1 What is a Certificate and Why Is It Needed?

> *"Certificates are essential for app development and distribution across Apple platforms."*
> — [Apple Developer, Certificates Overview](https://developer.apple.com/help/account/certificates/certificates-overview)

A certificate is a digital document that **proves your identity** to Apple and to iOS devices. When you build an app, Apple's code-signing process embeds your certificate into the app binary. When a device tries to run the app, iOS checks that certificate to verify the app came from a trusted, registered developer — not a malicious source.

Without a valid certificate, iOS will refuse to install or launch your app. It is not optional.

### 2.2 Certificate Types

According to Apple's documentation, the two most important certificate types for iOS app developers are:

| Certificate Type | Purpose | Who Can Create | Limit |
|---|---|---|---|
| **Apple Development** | Run apps on devices during development and testing | Any team member | 2 per person |
| **Apple Distribution** | Distribute apps via Ad Hoc, TestFlight, or App Store | Account Holder or Admin only | 1 per team |

> *"Development Certificates belong to individuals... Distribution Certificates belong to the team, with only one of each type allowed per team."*
> — [Apple Developer, Certificates Overview](https://developer.apple.com/help/account/certificates/certificates-overview)

**Why two types?**

- The **Development** certificate allows Xcode to "supervise" your app on a device — the app is tied to your Mac session. This is intentional; it prevents unreviewed development builds from running freely.
- The **Distribution** certificate removes that supervision. It tells iOS: "this app has been properly packaged for independent use." Only Account Holders and Admins can create this, because it carries real responsibility.

> ⚠️ **Security note from Apple:** *"Keep credentials secure: Don't share your Apple Account or authentication credentials. Protect certificates: Don't share Apple Certificates outside your organization."*
> — [Apple Developer, Certificates Overview](https://developer.apple.com/help/account/certificates/certificates-overview)

### 2.3 Create a Certificate Signing Request (CSR)

**Why is a CSR needed?**

A CSR is a file your Mac generates that contains your **public key**. When you submit it to Apple, Apple signs it and sends back your certificate. This process ensures your private key never leaves your Mac — Apple never sees it. This is a standard cryptographic security practice.

> According to [Apple's documentation](https://developer.apple.com/help/account/certificates/create-a-certificate-signing-request), you create a CSR using Keychain Access on your Mac.

**Steps:**

1. Open **Keychain Access** — find it in `/Applications/Utilities/` or use Spotlight (`Cmd + Space` → type "Keychain Access")

2. In the menu bar: **Keychain Access → Certificate Assistant → Request a Certificate from a Certificate Authority...**

3. Fill in the dialog:
   - **User Email Address:** your Apple Developer email
   - **Common Name:** a name for this key (e.g. `Niramoy Distribution Key`)
   - **CA Email Address:** leave this **empty**
   - **Request is:** select **Saved to disk**

4. Click **Continue** → choose where to save the `.certSigningRequest` file → **Save**

You now have a CSR file ready to upload to Apple.

### 2.4 Create Apple Distribution Certificate — via Xcode

**Why use Xcode?** Xcode automates the CSR step and certificate installation in one action. This is the fastest method.

1. Open Xcode
2. Go to **Xcode → Settings** (`Cmd + ,`) → **Accounts** tab
3. Select your **Apple ID** from the list
4. Select your **Team** (e.g. UMR Holdings International Corp.)
5. Click **Manage Certificates...**
6. Click the **+** button (bottom left of the sheet)
7. Select **Apple Distribution**
8. Xcode generates the CSR, submits it to Apple, downloads the certificate, and installs it into your Keychain — all automatically ✅

**Verify it was created:**
```bash
security find-identity -v -p codesigning
```
You should see a line like:
```
"Apple Distribution: Your Name (XXXXXXXXXX)"
```

### 2.5 Create Apple Distribution Certificate — via Apple Developer Web Portal

**Why use the web portal?** If you are on a new Mac, if Xcode does not have your Apple ID, or if you prefer manual control, you can create the certificate entirely through the web portal. You need the CSR file from [Section 2.3](#23-create-a-certificate-signing-request-csr) first.

**Step 1 — Go to Certificates**
1. Open [developer.apple.com](https://developer.apple.com)
2. Sign in with your Apple ID
3. Click **Account** in the top navigation
4. Under **Certificates, Identifiers & Profiles**, click **Certificates**

**Step 2 — Create a New Certificate**
1. Click the **+** button (top left, next to "Certificates")
2. Under the **Software** section, select **Apple Distribution**

   > **Why Apple Distribution?** Per Apple's documentation, this is the certificate type used to "distribute or submit apps to App Store with Xcode 11+." It covers both Ad Hoc and App Store distribution — you do not need separate certificates for each.

3. Click **Continue**

**Step 3 — Upload Your CSR**
1. Click **Choose File**
2. Select the `.certSigningRequest` file you created in [Section 2.3](#23-create-a-certificate-signing-request-csr)
3. Click **Continue**

**Step 4 — Download and Install**
1. Click **Download** — saves a `.cer` file to your Mac
2. Double-click the downloaded `.cer` file
3. Keychain Access opens and installs the certificate automatically ✅

**Verify it was installed:**
```bash
security find-identity -v -p codesigning
```

### 2.6 Certificate Expiration — What Happens

> *"App Store Distribution: Can't upload new versions (existing apps remain available if membership is valid)."*
> — [Apple Developer, Certificates Overview](https://developer.apple.com/help/account/certificates/certificates-overview)

- Distribution certificates expire after **1 year**
- After expiry: you cannot build or upload new versions, but existing installs continue to work
- Fix: create a new Distribution certificate following the same steps above
- Renew proactively — don't wait until it expires in the middle of a release

---

## 3. App ID

### 3.1 What is an App ID and Why Is It Needed?

An App ID is your app's **unique address** in Apple's system. It ties your app to your developer account and to specific capabilities (like Push Notifications, Sign in with Apple, etc.). Every provisioning profile must reference a specific App ID — without one, you cannot create a profile, and without a profile, your app cannot be distributed.

The format is reverse-domain notation:
```
com.yourcompany.yourapp
```

### 3.2 Create an App ID

1. Go to [developer.apple.com](https://developer.apple.com) → **Account** → **Certificates, Identifiers & Profiles**
2. Click **Identifiers** in the left sidebar
3. Click the **+** button
4. Select **App IDs** → click **Continue**
5. Select **App** → click **Continue**
6. Fill in:
   - **Description:** `Niramoy Health App` (human-readable label)
   - **Bundle ID:** select **Explicit** → enter `com.niramoy.healthapp`

   > **Why Explicit?** An Explicit Bundle ID locks the App ID to one specific app and is required for capabilities like Push Notifications, In-App Purchase, and Sign in with Apple. A Wildcard (`com.niramoy.*`) covers multiple apps but disables these features.

7. Scroll down and **enable any Capabilities** your app needs (e.g. Push Notifications)
8. Click **Continue** → review → click **Register** ✅

> ⚠️ The Bundle ID you register here **must exactly match** the Bundle Identifier in your Xcode project. A mismatch will cause provisioning to fail.

---

## 4. Devices and UDID

### 4.1 What is a UDID and Why Is It Needed?

UDID stands for **Unique Device Identifier** — a string of letters and numbers that identifies one specific iPhone or iPad. No two devices share the same UDID.

> *"To create a development or ad hoc provisioning profile, you need to register a device using its device name and Unique Device Identifier (UDID)."*
> — [Apple Developer, Register a Single Device](https://developer.apple.com/help/account/register-devices/register-a-single-device)

**Why is this needed?** Ad Hoc distribution works by listing permitted devices inside the provisioning profile. iOS checks this list at install time — if the device's UDID is not in the list, the install is rejected. This is Apple's mechanism for ensuring Ad Hoc builds don't spread beyond your intended testers.

TestFlight does **not** require UDIDs — Apple manages device authorization itself through the TestFlight app and Apple IDs.

### 4.2 How to Find a Device UDID

**Method 1 — Terminal (when device is plugged in)**
```bash
xcrun devicectl list devices
```

**Method 2 — Xcode**
```
Plug in the iPhone via cable
Xcode → Window → Devices and Simulators
→ Select the device in the left list
→ The Identifier field shows the UDID — click to copy
```

**Method 3 — Finder (no Xcode required)**
```
Plug in iPhone → open Finder
→ Click device name in the left sidebar
→ Click on the model/capacity line under the device name
→ It cycles through: Capacity → Serial Number → UDID
→ Right-click the UDID → Copy
```

### 4.3 Register a Device in Apple Developer Portal

> Per [Apple's documentation](https://developer.apple.com/help/account/register-devices/register-a-single-device):
> *"Required permissions: Account Holder or Admin role required."*

**Steps:**

1. Go to [developer.apple.com](https://developer.apple.com) → **Account** → **Certificates, Identifiers & Profiles**
2. Click **Devices** in the left sidebar
3. Click the **+** button (top left)
4. Select platform: **iOS, iPadOS, tvOS, watchOS, visionOS**
5. Enter:
   - **Device Name:** a recognisable label, e.g. `Ali's iPhone X`
   - **Device ID (UDID):** paste the UDID you copied above
6. Click **Continue**
7. Review the details → click **Register** ✅

> ⚠️ **Device limit:** Apple allows a maximum of **100 devices per device type per year** for Development and Ad Hoc profiles combined. This limit resets annually when your Apple Developer membership renews. Removed devices still count against the limit until renewal.

---

## 5. Provisioning Profiles

### 5.1 What is a Provisioning Profile and Why Is It Needed?

A provisioning profile is a **permission slip** that Apple issues to you. It bundles three things together:

```
Certificate  (proves who built the app)
     +
App ID       (identifies which app)
     +
Devices      (lists which iPhones may run it — for Ad Hoc)
     =
Provisioning Profile
```

iOS checks this profile every time your app is launched. If the certificate is expired, if the App ID doesn't match, or if the device isn't listed (for Ad Hoc), the app will not run.

Without a provisioning profile, you cannot install any app on a real device — Apple uses profiles as the enforcement mechanism for their developer program rules.

### 5.2 Profile Types

| Profile Type | Used For | Needs Devices Listed | Review Required |
|---|---|---|---|
| **Development** | Debug and Profile builds | ✅ Yes (up to 100) | ❌ No |
| **Ad Hoc** | Release builds, direct install | ✅ Yes (up to 100) | ❌ No |
| **App Store Connect** | TestFlight and App Store | ❌ No | ✅ For external testing |
| **Enterprise** | Internal company apps | ❌ No | ❌ No (requires $299/yr account) |

**Why are there different types?**

Each type encodes a different level of trust. Development profiles carry `get-task-allow = true`, which tells iOS to allow a debugger to attach — essential for development, but a security risk in production. Distribution profiles (`get-task-allow = false`) do not allow debugger attachment, which is why iOS permits them to run freely without a Mac present.

### 5.3 Create an Ad Hoc Provisioning Profile

> **Prerequisites:** You must have completed Sections 2, 3, and 4 — Distribution certificate, App ID, and registered devices must all exist before creating this profile.

1. Go to [developer.apple.com](https://developer.apple.com) → **Account** → **Certificates, Identifiers & Profiles**
2. Click **Profiles** in the left sidebar
3. Click the **+** button (top left)
4. Under **Distribution**, select **Ad Hoc** → click **Continue**

   > **Why Ad Hoc?** Ad Hoc profiles embed the list of permitted device UDIDs directly into the profile. This allows the app to be installed on those specific devices without going through the App Store or TestFlight.

5. **App ID:** select `com.niramoy.healthapp` → click **Continue**
6. **Certificate:** select your **Apple Distribution** certificate → click **Continue**
7. **Devices:** check all the devices you want to allow → click **Continue**
8. **Provisioning Profile Name:** enter something descriptive, e.g. `Niramoy AdHoc Prod`
9. Click **Generate** → click **Download**
10. Double-click the downloaded `.mobileprovision` file — it installs into Xcode automatically ✅

### 5.4 Create an App Store Provisioning Profile

This profile is needed for both **TestFlight** and **App Store** submission. It does not list specific devices — Apple manages device access through its own systems.

1. Go to [developer.apple.com](https://developer.apple.com) → **Profiles** → **+**
2. Under **Distribution**, select **App Store Connect** → click **Continue**
3. **App ID:** select `com.niramoy.healthapp` → click **Continue**
4. **Certificate:** select your **Apple Distribution** certificate → click **Continue**
5. **Provisioning Profile Name:** e.g. `Niramoy AppStore Prod`
6. Click **Generate** → **Download**
7. Double-click the `.mobileprovision` to install it ✅

---

## 6. Ad Hoc Distribution

### 6.1 What is Ad Hoc and Why Use It?

Ad Hoc distribution lets you install a Release build directly on up to **100 specific iPhones** — without the App Store, without TestFlight, and without Apple review.

**Use Ad Hoc when:**
- You need to test the app on a specific physical device
- You need the app to work after the cable is unplugged
- You want to give a build to a small, known group (1–100 people)
- You want to test the release build before uploading to TestFlight

**Limitations:**
- You must know the UDID of every device in advance
- Adding a new device requires rebuilding the IPA (you must regenerate the profile with the new UDID)
- Maximum 100 devices per year

### 6.2 Full Walkthrough — Ad Hoc to a Real Device

#### One-Time Setup (do this once per device)

**Step 1 — Get Apple Distribution Certificate**
Follow [Section 2.4](#24-create-apple-distribution-certificate--via-xcode) or [Section 2.5](#25-create-apple-distribution-certificate--via-apple-developer-web-portal).

**Step 2 — Register the target device**
Follow [Section 4.2](#42-how-to-find-a-device-udid) to get the UDID, then [Section 4.3](#43-register-a-device-in-apple-developer-portal) to register it.

**Step 3 — Create Ad Hoc Provisioning Profile**
Follow [Section 5.3](#53-create-an-ad-hoc-provisioning-profile).

**Step 4 — Configure Xcode Signing**

1. Open the project:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. In Xcode, click **Runner** in the left Project Navigator
3. Click the **Signing & Capabilities** tab
4. At the top of the tab, click **Release** (not Debug)
5. **Uncheck** "Automatically manage signing"

   > **Why turn off automatic signing?** Automatic signing always selects a Development profile, regardless of build mode. For Release builds, you must manually specify the Ad Hoc profile so Xcode embeds the correct certificate and device list.

6. **Team:** select `S92JD9F2MV`
7. **Bundle Identifier:** confirm it is `com.niramoy.healthapp`
8. **Provisioning Profile:** click the dropdown → select `Niramoy AdHoc Prod`
9. **Signing Certificate:** confirm it shows `Apple Distribution: ...`
10. Confirm no red errors are shown ✅

#### Every Time You Want to Install a Build

**Step 5 — Build the IPA**
```bash
fvm flutter build ipa --flavor prod -t lib/main_prod.dart
```

The output file will be at:
```
build/ios/ipa/Runner.ipa
```

**Step 6 — Install on the Device**

**Option A — Apple Configurator 2** (recommended, free on Mac App Store)
```
1. Download "Apple Configurator 2" from the Mac App Store (free)
2. Plug the target iPhone via USB cable
3. Open Apple Configurator 2
4. The device appears in the window
5. Drag and drop build/ios/ipa/Runner.ipa onto the device icon
6. Apple Configurator installs it immediately ✅
```

**Option B — AirDrop**
```
1. AirDrop the Runner.ipa file to the target iPhone
2. The iPhone shows a prompt: "Would you like to install Runner?"
3. Tap Install ✅
```

#### After Installation

- The app icon appears on the Home Screen
- The app opens and runs **without your Mac connected** ✅
- The app **survives device reboot** ✅
- The app continues to work until the Distribution certificate expires (1 year)

> ⚠️ **First launch on a new device:** The user may see "Untrusted Developer." They must go to:
> **Settings → General → VPN & Device Management → [your team name] → Trust** ✅

---

## 7. TestFlight Distribution

### 7.1 What is TestFlight and Why Use It?

> *"TestFlight is Apple's beta testing service that allows developers to distribute pre-release builds of their apps, manage beta testers, and collect feedback before submitting to the App Store."*
> — [App Store Connect Help, TestFlight Overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview)

**Use TestFlight when:**
- You have more than a few testers (up to 10,000 external)
- You do not want to manage device UDIDs
- You want automatic crash reports and tester feedback
- You are preparing for App Store launch

**Key facts from Apple:**
- Builds remain available for **90 days**, then expire automatically
- Testers can access your builds on **up to 30 devices**
- Up to **100 builds** can be shared simultaneously
- Testers install the free **TestFlight app** from the App Store, then install your app through it

### 7.2 Internal vs External Testing

| | **Internal Testing** | **External Testing** |
|---|---|---|
| **Max testers** | 100 | 10,000 |
| **Who qualifies** | App Store Connect team members only (Account Holder, Admin, App Manager, Developer, Marketing roles) | Anyone with an email address or public link |
| **Apple review required** | ❌ No — available immediately | ✅ Yes — first build requires TestFlight App Review |
| **Subsequent builds** | ❌ No review | May not require full review after first approval |
| **Build expiry** | 90 days | 90 days |
| **UDID required** | ❌ No | ❌ No |

> *"Internal Testers: Up to 100 team members with Account Holder, Admin, App Manager, Developer, or Marketing roles. Can automatically distribute new builds for continuous testing."*
> — [App Store Connect Help, TestFlight Overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview)

### 7.3 Full Walkthrough — Publish to TestFlight

#### One-Time Setup

**Step 1 — Create App Record in App Store Connect**

> Per [Apple's documentation](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app), required role: Account Holder, App Manager, or Admin.

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Click **My Apps** → click the **+** button → select **New App**
3. Fill in:
   - **Platforms:** iOS
   - **Name:** Niramoy (the name shown in TestFlight and App Store)
   - **Primary Language:** English (or your preferred language)
   - **Bundle ID:** select `com.niramoy.healthapp` from the dropdown

     > The Bundle ID dropdown is populated from App IDs you registered in your developer account. If it does not appear, complete [Section 3](#3-app-id) first.

   - **SKU:** a unique internal reference (not visible to users), e.g. `niramoy-health-001`
   - **User Access:** Full Access (all team members) or Limited Access (specific members)
4. Click **Create** ✅

**Step 2 — Create App Store Provisioning Profile**
Follow [Section 5.4](#54-create-an-app-store-provisioning-profile).

**Step 3 — Configure Xcode for App Store Signing**

1. Open `ios/Runner.xcworkspace`
2. Select **Runner** target → **Signing & Capabilities** tab → **Release** configuration
3. Uncheck **Automatically manage signing**
4. **Provisioning Profile:** select `Niramoy AppStore Prod`
5. **Signing Certificate:** `Apple Distribution: ...`
6. Confirm no errors ✅

#### Every Time You Want to Upload a New Build

**Step 4 — Build the IPA**
```bash
fvm flutter build ipa --flavor prod -t lib/main_prod.dart
```

Output:
```
build/ios/ipa/Runner.ipa
```

**Step 5 — Upload the IPA to App Store Connect**

**Option A — Transporter (easiest)**

> Per [Apple's documentation](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds): *"Transporter — Simple drag-and-drop interface. View delivery progress, warnings, errors, and logs."*

1. Download **Transporter** from the Mac App Store (free)
2. Open Transporter → sign in with your Apple ID
3. Drag `build/ios/ipa/Runner.ipa` into the Transporter window
4. Click **Deliver** ✅

**Option B — Xcode Organizer**
```
Xcode → Product → Archive
→ Xcode opens the Organizer window automatically
→ Click "Distribute App"
→ Select "App Store Connect" → click Next
→ Select "Upload" → click Next
→ Leave all options at defaults → click Next
→ Review → click Upload ✅
```

**Option C — Terminal (altool)**

> Per [Apple's documentation](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds):

```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/Runner.ipa \
  --username your@apple.id \
  --password your-app-specific-password
```

> For the `--password` field, create an **app-specific password** at [appleid.apple.com](https://appleid.apple.com) → Security → App-Specific Passwords. Do not use your main Apple ID password.

**Step 6 — Wait for Processing**

After upload, go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) → your app → **TestFlight** tab.

> *"Apple must process it before appearing in App Store Connect (notification sent via email)."*
> — [Apple, Upload Builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds)

Processing typically takes **5–15 minutes**. The build status changes from "Processing" to a version number when ready.

### 7.4 Invite Internal Testers

> Required role: Account Holder, Admin, or App Manager.

1. In App Store Connect → your app → **TestFlight** tab
2. In the left sidebar, under **Internal Testing**, click the **+** next to your group (or create one)
3. Click **Add Builds** → select your processed build → click **Add**
4. Click **+** next to Testers → select team members by Apple ID
5. Click **Add** — team members receive an email invitation automatically ✅

**What the tester does:**
1. Receives email: *"You've been invited to test [App Name]"*
2. Downloads the **TestFlight** app from the App Store (free)
3. Opens TestFlight → accepts the invitation
4. Taps **Install** next to your app ✅

The app installs and works independently — no cable, no Mac needed.

### 7.5 Invite External Testers

> *"External testers are people you invite to test your app who aren't App Store Connect users. You can invite up to 10,000 external testers per app."*
> — [App Store Connect Help, Invite External Testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)

> ⚠️ The first build submitted for external testing **requires Apple TestFlight App Review**. You can submit up to 6 builds for review per 24-hour period.

**Step 1 — Create an External Testing Group**
1. App Store Connect → your app → **TestFlight** tab
2. In the sidebar, click **+** next to "External Testing"
3. Enter a group name (e.g. `Beta Testers`) → click **Create**

**Step 2 — Add a Build to the Group**
1. Select the group from the sidebar
2. Click **Add Builds**
3. Select platform and version → select your build → click **Add**
4. Fill in **"What to Test"** — describe what you want testers to focus on
5. Optionally check "Automatically notify testers"
6. Click **Submit Review**

Wait for Apple's approval (typically within 1 business day).

**Step 3 — Invite Testers by Email**
1. Select the group → click **+** next to Testers
2. Choose:
   - **Email** — type individual email addresses
   - **Import** — upload a CSV file with multiple emails
3. Click **Add** — testers receive email invitations ✅

**Step 4 — Or Share a Public Link (optional)**

> *"Public links — Share via marketing channels (social media, email, etc.) with optional enrollment criteria."*
> — [App Store Connect Help, Invite External Testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers)

1. Select the group → **Testers** tab → click **Create Public Link**
2. Choose:
   - **Open to Anyone** — anyone with the link can join
   - **Filter by Criteria** — set device type or iOS version requirements; optionally set a tester limit (1–10,000)
3. Copy and share the link ✅

> ℹ️ Testers who join via public link appear as **anonymous** in your metrics, but their usage data (sessions, crashes) is still tracked.

---

## 8. Ad Hoc vs TestFlight — Comparison

| | **Ad Hoc** | **TestFlight** |
|---|---|---|
| **Max devices** | 100 | 10,000 |
| **UDID required** | ✅ Yes — every device must be registered | ❌ No |
| **Apple review** | ❌ None | ✅ Required for external testing (first build) |
| **Build expiry** | 1 year (certificate expiry) | 90 days per build |
| **Installation method** | Direct (.ipa via cable or AirDrop) | Via TestFlight app |
| **Crash reports** | ❌ Not automatic | ✅ Automatic |
| **Tester feedback** | ❌ No built-in mechanism | ✅ Built-in feedback button in TestFlight app |
| **Adding a new tester** | Must get UDID, re-register, rebuild IPA | Send email or public link |
| **Best for** | Small, known group; device-specific testing | Wider beta testing before App Store |

**Decision guide:**

```
1–5 specific devices you control?      → Ad Hoc
More than 5 testers?                   → TestFlight
Need feedback and crash reports?       → TestFlight
Testing on a device without their UDID? → TestFlight
Preparing for App Store launch?        → TestFlight
```

---

## 9. Troubleshooting

### "Could not run app on device" in Release mode

**Cause:** The embedded provisioning profile has `get-task-allow = true`, meaning a Development (not Distribution) profile was used.

**Fix:**
1. Open `ios/Runner.xcworkspace`
2. Runner target → Signing & Capabilities → **Release** tab
3. Switch to **Manual** signing
4. Select your **Ad Hoc** provisioning profile

---

### App closes or becomes unavailable after unplugging cable

**Cause:** The app was built in Debug or Profile mode. Both modes require a live Xcode session.

**Fix:** Build in Release mode with an Ad Hoc or App Store profile. See [Section 6](#6-ad-hoc-distribution).

---

### "No matching provisioning profile found"

**Cause:** The Bundle ID in Xcode does not match the App ID in the provisioning profile, or the profile is not installed.

**Fix:**
1. Verify the Bundle ID in Xcode matches `com.niramoy.healthapp` exactly
2. Re-download the profile from [developer.apple.com](https://developer.apple.com) → Profiles
3. Double-click the `.mobileprovision` file to re-install it
4. Select it again in Xcode → Signing & Capabilities

---

### "Untrusted Developer" on first launch (Ad Hoc)

**Cause:** iOS requires the user to manually trust your certificate the first time.

**Fix (on the device):**
```
Settings → General → VPN & Device Management
→ tap your developer/team name
→ tap "Trust [team name]"
→ tap Trust in the confirmation dialog ✅
```

---

### Build stuck on "Processing" in App Store Connect

**Cause:** Apple's servers are processing the upload. This is normal.

**Fix:** Wait up to 30 minutes. If still stuck, re-upload using Transporter.

---

### "Certificate is not valid" or "Certificate has been revoked"

**Cause:** The Distribution certificate expired or was revoked.

**Fix:**
1. `Xcode → Settings → Accounts → your team → Manage Certificates`
2. Delete the invalid certificate
3. Click **+** → **Apple Distribution** to create a new one
4. Re-download and regenerate your provisioning profiles (they are tied to the old certificate)

---

*Guide based on official Apple documentation. Always refer to [developer.apple.com](https://developer.apple.com) and [appstoreconnect.apple.com](https://appstoreconnect.apple.com) for the latest information, as Apple updates its processes regularly.*
