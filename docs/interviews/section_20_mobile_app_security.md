# Section 20: Mobile & App Security

---

**Q:** What is the OWASP Mobile Top 10 and what does each item mean?

**A:** The OWASP Mobile Top 10 is the industry-standard list of the most critical security risks in mobile applications. Every mobile security conversation starts here.

```
┌─────────────────────────────────────────────────────────────────┐
│                    OWASP MOBILE TOP 10                          │
├────┬────────────────────────────────┬───────────────────────────┤
│ M1 │ Improper Credential Usage      │ Hardcoded credentials,    │
│    │                                │ weak passwords, tokens in │
│    │                                │ source code               │
├────┼────────────────────────────────┼───────────────────────────┤
│ M2 │ Inadequate Supply Chain        │ Using vulnerable 3rd-     │
│    │ Security                       │ party SDKs/packages       │
├────┼────────────────────────────────┼───────────────────────────┤
│ M3 │ Insecure Authentication /      │ Weak login, missing MFA,  │
│    │ Authorization                  │ broken session management │
├────┼────────────────────────────────┼───────────────────────────┤
│ M4 │ Insufficient Input/Output      │ No validation, trusting   │
│    │ Validation                     │ user input blindly        │
├────┼────────────────────────────────┼───────────────────────────┤
│ M5 │ Insecure Communication         │ No TLS, self-signed certs,│
│    │                                │ no certificate pinning    │
├────┼────────────────────────────────┼───────────────────────────┤
│ M6 │ Inadequate Privacy Controls    │ Collecting more data than │
│    │                                │ needed, leaking PII       │
├────┼────────────────────────────────┼───────────────────────────┤
│ M7 │ Insufficient Binary            │ No obfuscation, easy to   │
│    │ Protections                    │ reverse-engineer the app  │
├────┼────────────────────────────────┼───────────────────────────┤
│ M8 │ Security Misconfiguration      │ Debug mode in prod,       │
│    │                                │ overly permissive configs │
├────┼────────────────────────────────┼───────────────────────────┤
│ M9 │ Insecure Data Storage          │ Tokens/PII stored in      │
│    │                                │ plaintext, SharedPrefs    │
├────┼────────────────────────────────┼───────────────────────────┤
│M10 │ Insufficient Cryptography      │ Weak algorithms (MD5),    │
│    │                                │ hardcoded keys, bad IV    │
└────┴────────────────────────────────┴───────────────────────────┘
```

**Quick breakdown of each:**

- **M1 – Improper Credential Usage:** Hardcoding API keys, passwords, or tokens in source code. They get extracted via reverse engineering instantly.
- **M2 – Inadequate Supply Chain Security:** Using a pub.dev package that hasn't been audited. A malicious or outdated dependency can compromise your whole app.
- **M3 – Insecure Authentication/Authorization:** Weak login flows, no token expiry, missing role checks on the backend.
- **M4 – Insufficient Input/Output Validation:** Trusting data from the user or server without sanitizing it — leads to injection attacks or crashes.
- **M5 – Insecure Communication:** Sending data over HTTP instead of HTTPS, or not validating the server's certificate.
- **M6 – Inadequate Privacy Controls:** Collecting device IDs, location, or contacts unnecessarily. Logging PII to analytics.
- **M7 – Insufficient Binary Protections:** No obfuscation means an attacker can decompile the app, read logic, extract keys, and find vulnerabilities.
- **M8 – Security Misconfiguration:** Leaving debug flags on, exposing internal endpoints, overly broad Android permissions in the manifest.
- **M9 – Insecure Data Storage:** Storing auth tokens in SharedPreferences (unencrypted). Anyone with ADB access or root can read it.
- **M10 – Insufficient Cryptography:** Using outdated algorithms like MD5 or DES, hardcoding encryption keys in code, using predictable IVs.

**Example:**
```dart
// M1 example — NEVER do this:
const apiKey = 'sk-abc123secretkey'; // Hardcoded in source = extractable

// M9 example — NEVER do this:
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', token); // Stored in plaintext XML on disk
```

**Why it matters:** Interviewers use this to gauge whether you have a security mindset. They want to know you understand *why* each risk exists, not just that you've memorized the list.

**Common mistake:** Candidates memorize the names but can't explain the real-world impact or how it applies to Flutter specifically. Always tie each item back to a concrete Flutter/mobile example.

---

**Q:** Why is SharedPreferences NOT secure for storing tokens? How do you use Flutter Secure Storage instead?

**A:** `SharedPreferences` stores data as a plain XML file (Android) or plist file (iOS) on the device's filesystem. On a rooted/jailbroken device — or even via ADB on a debug build — this file can be read by anyone without any encryption. Tokens stored here are fully exposed.

```
ANDROID — SharedPreferences storage path:
/data/data/com.your.app/shared_prefs/FlutterSharedPreferences.xml

Contents look like this (plaintext, fully readable):
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <string name="auth_token">eyJhbGciOiJIUzI1NiJ9...</string>
</map>
```

`flutter_secure_storage` solves this by using platform-native secure storage:
- **Android:** Android Keystore system (hardware-backed encryption)
- **iOS:** Keychain Services (hardware-backed secure enclave on modern devices)

```dart
// pubspec.yaml
// flutter_secure_storage: ^9.0.0

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // Uses EncryptedSharedPreferences
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      // Only accessible after first unlock — blocks extraction if device is off
    ),
  );

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  // WRITE
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  // READ
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  // DELETE (on logout — always do this!)
  static Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    // Or nuke everything:
    // await _storage.deleteAll();
  }
}
```

```
STORAGE COMPARISON:
┌──────────────────────┬─────────────────┬─────────────────────────┐
│                      │ SharedPrefs     │ Flutter Secure Storage  │
├──────────────────────┼─────────────────┼─────────────────────────┤
│ Encryption           │ None            │ AES-256 / Keychain      │
│ Root accessible      │ YES             │ Much harder             │
│ ADB readable (debug) │ YES             │ NO                      │
│ Backup included      │ YES (dangerous) │ Excluded from backups   │
│ Use for tokens       │ NEVER           │ YES                     │
│ Use for UI prefs     │ YES             │ Overkill                │
└──────────────────────┴─────────────────┴─────────────────────────┘
```

**Why it matters:** Token theft is the most common mobile attack vector. Storing tokens insecurely is OWASP M9. Interviewers expect you to know this is a non-negotiable.

**Common mistake:** Saying "but it's fine if the device isn't rooted." The security posture of your users' devices is not in your control. Always assume the worst-case device environment.

---

**Q:** What is certificate pinning, why does it matter, and how do you implement it in Flutter with Dio?

**A:** Certificate pinning is the practice of hardcoding (or "pinning") the expected server certificate — or its public key hash — inside your app. Even if an attacker installs a rogue certificate on the device (as in a MITM attack), the app will reject any TLS connection that doesn't match the pinned value.

```
WITHOUT PINNING — MITM is possible:
┌──────────┐    ┌──────────────────┐    ┌──────────┐
│  App     │───▶│ Attacker's Proxy │───▶│  Server  │
│          │◀───│ (Fake Cert OK!)  │◀───│          │
└──────────┘    └──────────────────┘    └──────────┘
  App trusts any cert signed by a trusted CA → MITM succeeds

WITH CERTIFICATE PINNING:
┌──────────┐    ┌──────────────────┐    ┌──────────┐
│  App     │───▶│ Attacker's Proxy │    │  Server  │
│ [PIN:    │◀───│ (Wrong cert hash)│    │          │
│ abc123]  │    └──────────────────┘    └──────────┘
  App rejects connection — hash doesn't match pin → MITM fails
```

**How to implement with Dio:**

**Step 1: Get your certificate's SHA-256 public key hash**
```bash
# From terminal:
openssl s_client -connect api.yourserver.com:443 | \
  openssl x509 -pubkey -noout | \
  openssl pkey -pubin -outform der | \
  openssl dgst -sha256 -binary | \
  base64
# Output: something like "ABC123.../xyz=="  ← this is your pin
```

**Step 2: Implement pinning in Flutter with Dio**
```dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class SecureApiClient {
  static Dio createPinnedClient() {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.yourserver.com'));

    // Override the HttpClient with our custom security callback
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      client.badCertificateCallback = (cert, host, port) => false;
      // ↑ Reject ALL bad certs by default

      return client;
    };

    (dio.httpClientAdapter as IOHttpClientAdapter).validateCertificate =
        (cert, host, port) {
      if (cert == null) return false;

      // The SHA-256 hash of the server's public key (get this from openssl)
      const pinnedSha256 = 'AAAAAABBBBBBCCCCCC1234567890abcdef==';

      // Convert cert's DER-encoded public key to SHA-256 hash
      final certPublicKeyHash = _getSha256Hash(cert.der);

      return certPublicKeyHash == pinnedSha256;
    };

    return dio;
  }

  static String _getSha256Hash(List<int> derBytes) {
    // Use crypto package
    // import 'package:crypto/crypto.dart';
    // final digest = sha256.convert(derBytes);
    // return base64Encode(digest.bytes);
    throw UnimplementedError('Implement with crypto package');
  }
}
```

**Alternative — using a bundled .cer file (simpler approach):**
```dart
import 'package:flutter/services.dart';

Future<Dio> createPinnedDio() async {
  // Add your server's .cer file to assets/certs/server.cer
  final sslCert = await rootBundle.load('assets/certs/server.cer');

  final securityContext = SecurityContext(withTrustedRoots: false);
  // withTrustedRoots: false means we ONLY trust our pinned cert
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

  final httpClient = HttpClient(context: securityContext);

  final dio = Dio();
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
      () => httpClient;

  return dio;
}
```

**Important caveats:**
- Pins can expire with certificate rotation — always pin 2+ certs (current + backup)
- Dynamic pinning (fetching pins from a trusted CDN) is more maintainable
- Certificate pinning is bypassable with tools like Frida on rooted devices — it raises the bar, not an absolute guarantee

**Why it matters:** This is a mid-to-senior level security topic. Interviewers use it to distinguish developers who understand transport security beyond just "use HTTPS."

**Common mistake:** Confusing certificate pinning with certificate validation. All HTTPS already validates certs against trusted CAs. Pinning goes further by refusing to accept *any* CA-signed cert that isn't specifically the one you've pinned.

---

**Q:** What is the difference between access tokens and refresh tokens? Where should you store them and how do you handle expiry?

**A:** These are two separate tokens that work together to balance security and user experience.

```
TOKEN LIFECYCLE:
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ACCESS TOKEN                    REFRESH TOKEN                  │
│  ─────────────                   ──────────────                 │
│  Short-lived (15 min – 1 hour)   Long-lived (7–30 days)         │
│  Sent with every API request      Used only to get new          │
│  Stateless (JWT) — no DB lookup   access tokens                 │
│  If leaked → short exposure       Stored server-side (DB)       │
│  window                           If leaked → DANGER (longer    │
│                                   exposure window)              │
└─────────────────────────────────────────────────────────────────┘

TOKEN REFRESH FLOW:
                        ┌───────────────────────────────────┐
     App                │           Auth Server             │
      │                 │                                   │
      │──── Login ─────▶│                                   │
      │◀─ access_token ─│                                   │
      │◀─ refresh_token─│                                   │
      │                 │                                   │
      │ [15 min later]  │                                   │
      │                 │                                   │
      │── API request ─▶│ ← 401 Unauthorized                │
      │                 │   (access token expired)          │
      │                 │                                   │
      │── POST /refresh ────── refresh_token ──────────────▶│
      │◀────────────── new access_token ────────────────────│
      │                 │                                   │
      │── Retry API ───▶│ ← 200 OK                          │
```

**Where to store each:**
```
┌───────────────────┬─────────────────────────┬───────────────────┐
│ Token             │ Storage                 │ Reason            │
├───────────────────┼─────────────────────────┼───────────────────┤
│ Access Token      │ Memory (app state)      │ Short-lived, no   │
│                   │ OR Secure Storage       │ need to persist   │
├───────────────────┼─────────────────────────┼───────────────────┤
│ Refresh Token     │ Flutter Secure Storage  │ Long-lived, MUST  │
│                   │ (Keychain / Keystore)   │ be encrypted      │
├───────────────────┼─────────────────────────┼───────────────────┤
│ NEVER store in    │ SharedPreferences       │ Unencrypted disk  │
│                   │ Hardcoded in code       │ Source exposure   │
│                   │ URL params / logs       │ Log exposure      │
└───────────────────┴─────────────────────────┴───────────────────┘
```

**Implementing auto-refresh with Dio Interceptors:**
```dart
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorage _storage;

  AuthInterceptor(this._dio, this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Access token expired — try to refresh
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry the original request with the new token
        final newToken = await _storage.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

        final retryResponse = await _dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } else {
        // Refresh token also invalid → force logout
        await _storage.clearTokens();
        // Navigate to login screen
      }
    }
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await _storage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
```

**Why it matters:** Token handling is the backbone of mobile auth. This question tests whether you understand both the security model and the practical implementation of seamless token refresh without spamming the user with login prompts.

**Common mistake:** Storing the access token in SharedPreferences "because it expires quickly anyway." Even 15-minute tokens are valuable for an attacker. More importantly, the *refresh* token is the real crown jewel — many candidates forget to highlight that it needs the most protection.

---

**Q:** Explain the OAuth 2.0 Authorization Code + PKCE flow for mobile apps.

**A:** OAuth 2.0 is an authorization framework that lets users grant your app access to their data on another service (e.g., "Sign in with Google") without sharing their password with your app. For mobile, the Authorization Code flow with **PKCE** (Proof Key for Code Exchange) is the correct and secure variant.

**Why PKCE?** The original Authorization Code flow was designed for server-side apps that can keep a `client_secret` confidential. Mobile apps can't keep secrets (they can be decompiled). PKCE replaces the `client_secret` with a cryptographic challenge that can't be intercepted.

```
AUTHORIZATION CODE + PKCE FLOW:

App                   Browser/OS            Auth Server         Your Backend
 │                        │                      │                    │
 │ 1. Generate            │                      │                    │
 │    code_verifier       │                      │                    │
 │    (random 43-128      │                      │                    │
 │    char string)        │                      │                    │
 │                        │                      │                    │
 │ 2. Hash it:            │                      │                    │
 │  code_challenge =      │                      │                    │
 │  BASE64URL(SHA256       │                      │                    │
 │  (code_verifier))      │                      │                    │
 │                        │                      │                    │
 │ 3. Open browser ──────▶│                      │                    │
 │    with:               │──── GET /authorize ─▶│                    │
 │    client_id           │     code_challenge    │                    │
 │    redirect_uri        │     code_challenge_   │                    │
 │    code_challenge      │     method=S256       │                    │
 │    scope               │                      │                    │
 │                        │   User logs in ───▶  │                    │
 │                        │   User consents ───▶ │                    │
 │                        │                      │                    │
 │ 4. Redirect back ◀─────│◀─── redirect_uri ────│                    │
 │    with: code          │     ?code=AUTH_CODE   │                    │
 │                        │                      │                    │
 │ 5. Exchange code ───────────────────────────────── POST /token ───▶│
 │    + code_verifier     │                      │    code            │
 │    (plain text —       │                      │    code_verifier   │
 │    server verifies     │                      │    ← server hashes │
 │    against challenge)  │                      │    verifier and    │
 │                        │                      │    checks against  │
 │                        │                      │    saved challenge │
 │◀── access_token ────────────────────────────────────────────────────
 │    refresh_token       │                      │                    │
```

**Flutter implementation using `flutter_appauth`:**
```dart
import 'package:flutter_appauth/flutter_appauth.dart';

class OAuthService {
  static const _appAuth = FlutterAppAuth();

  static const _clientId = 'your_client_id';
  static const _redirectUrl = 'com.yourapp://callback';
  static const _discoveryUrl =
      'https://accounts.google.com/.well-known/openid-configuration';
  static const _scopes = ['openid', 'profile', 'email'];

  static Future<AuthorizationTokenResponse?> signIn() async {
    try {
      // flutter_appauth handles PKCE automatically
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          discoveryUrl: _discoveryUrl,
          scopes: _scopes,
          // PKCE is enabled by default in flutter_appauth
          preferEphemeralSession: true, // No shared browser cookies
        ),
      );

      if (result != null) {
        // Securely store tokens
        await TokenStorage.saveTokens(
          accessToken: result.accessToken!,
          refreshToken: result.refreshToken!,
        );
      }

      return result;
    } catch (e) {
      // Handle cancellation or error
      return null;
    }
  }

  static Future<TokenResponse?> refreshToken(String refreshToken) async {
    return await _appAuth.token(
      TokenRequest(
        _clientId,
        _redirectUrl,
        discoveryUrl: _discoveryUrl,
        refreshToken: refreshToken,
        scopes: _scopes,
      ),
    );
  }
}
```

**Key PKCE concepts:**
```
code_verifier  = cryptographically random string (43-128 chars)
code_challenge = BASE64URL(SHA256(code_verifier))

Why it's secure:
- Attacker intercepts the auth code from the redirect URI
- They try to exchange it for tokens
- But they don't have the code_verifier (it was only in the app's memory)
- Auth server verifies: SHA256(submitted_verifier) == saved_challenge
- If it doesn't match → exchange REJECTED
```

**Why it matters:** OAuth + PKCE is the correct pattern for mobile auth. An interviewer asking this is probing whether you know *why* PKCE exists (no client secret in mobile) and whether you'd implement it correctly vs naively implementing just the code flow.

**Common mistake:** Saying mobile apps should use the Implicit Flow (now deprecated) or not knowing why PKCE replaces the `client_secret`. Also, forgetting to use `preferEphemeralSession: true` which prevents session leakage between users on shared devices.

---

**Q:** What is a JWT? Explain its structure, how to verify it, and what NOT to store in the payload.

**A:** A JWT (JSON Web Token) is a compact, self-contained token used to represent claims between two parties. It allows stateless authentication — the server doesn't need a database lookup to validate it (the signature proves authenticity).

```
JWT STRUCTURE:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
.eyJzdWIiOiJ1c2VyXzEyMyIsInJvbGUiOiJhZG1pbiIsImV4cCI6MTcwMDAwMDAwMH0
.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c

    │                          │                    │
  HEADER                   PAYLOAD             SIGNATURE
(Base64URL)              (Base64URL)           (Base64URL)

HEADER (decoded):
{
  "alg": "HS256",   ← signing algorithm
  "typ": "JWT"
}

PAYLOAD (decoded):
{
  "sub": "user_123",         ← subject (user ID)
  "role": "admin",
  "exp": 1700000000,         ← expiration timestamp
  "iat": 1699990000          ← issued at
}

SIGNATURE:
HMAC-SHA256(
  base64url(header) + "." + base64url(payload),
  secret_key
)
```

**CRITICAL: JWTs are encoded, NOT encrypted.**
```
Base64URL is trivially reversible:

eyJzdWIiOiJ1c2VyXzEyMyIsInJvbGUiOiJhZG1pbiJ9
                    ↓
            base64 decode
                    ↓
{"sub":"user_123","role":"admin"}   ← ANYONE CAN READ THIS
```

**What NOT to store in JWT payload:**
```
❌ Passwords or password hashes
❌ Credit card numbers
❌ Social Security numbers
❌ PII (email, phone) — unless explicitly necessary
❌ Private keys or secrets
❌ Medical records

✅ Safe to store:
✅ User ID (sub)
✅ Roles / permissions
✅ Expiration time (exp)
✅ Non-sensitive preference flags
```

**How to verify a JWT in Flutter (client-side — for expiry only):**
```dart
import 'dart:convert';

class JwtUtils {
  /// Decodes the payload — does NOT verify signature
  /// Client-side JWT inspection is for UX only (e.g., checking expiry)
  /// NEVER trust client-side JWT validation for security decisions
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // JWT uses Base64URL — standard Base64 decoder needs padding
      String payload = parts[1];
      // Add padding if necessary
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Check if token is expired (client-side — for UX only)
  static bool isExpired(String token) {
    final payload = decodePayload(token);
    if (payload == null) return true;

    final exp = payload['exp'] as int?;
    if (exp == null) return false;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryDate);
  }
}

// Usage — to proactively refresh before a request:
Future<void> makeApiCall() async {
  final token = await TokenStorage.getAccessToken();

  if (token != null && JwtUtils.isExpired(token)) {
    await refreshTokens(); // Refresh proactively
  }

  // Proceed with API call...
}
```

**Real signature verification happens ONLY on the server:**
```
Server-side verification:
1. Split token → header.payload.signature
2. Recalculate: HMAC-SHA256(header.payload, secret_key)
3. Compare with provided signature
4. If match → token is authentic and untampered
5. Check exp, iss, aud claims
```

**Why it matters:** JWTs are everywhere. The interviewer is checking whether you understand the difference between encoded and encrypted, and whether you know that client-side JWT reading is for convenience only — never for security decisions.

**Common mistake:** Saying "the payload is secure because it's encoded in Base64." Base64 is not encryption — it's trivially reversible. The security of JWT comes entirely from the signature, not the encoding of the payload.

---

**Q:** What is a Man-in-the-Middle (MITM) attack and how do you prevent it in a Flutter app?

**A:** A MITM attack occurs when an attacker secretly intercepts and potentially alters communication between two parties (your app and your server) without either party knowing.

```
MITM ATTACK SCENARIO:

NORMAL:
┌──────────┐  HTTPS  ┌──────────┐
│  Flutter │────────▶│  Server  │
│   App    │◀────────│          │
└──────────┘         └──────────┘
   Encrypted, direct connection

MITM:
┌──────────┐  HTTP/  ┌──────────────┐  HTTPS  ┌──────────┐
│  Flutter │ HTTPS  ▶│   Attacker   │────────▶│  Server  │
│   App    │◀────────│  (Proxy)     │◀────────│          │
└──────────┘         └──────────────┘         └──────────┘
  App thinks it's talking to server,
  attacker sees and can modify ALL traffic

HOW ATTACKER SETS IT UP:
1. Victim connects to attacker's WiFi hotspot
2. Attacker installs their CA certificate on victim's device
   (common in corporate MDM, or social engineering)
3. Attacker's proxy intercepts TLS traffic using their cert
4. Normal TLS validation passes (attacker's CA is trusted!)
5. All traffic is visible to attacker in plaintext
```

**Prevention layers in Flutter:**

```dart
// LAYER 1: Use HTTPS everywhere (non-negotiable baseline)
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.yourserver.com', // NEVER http://
));

// LAYER 2: Certificate Pinning (see previous question)
// Rejects any certificate that doesn't match your pin

// LAYER 3: Reject HTTP in debug builds (Network Security Config - Android)
// android/app/src/main/res/xml/network_security_config.xml:
/*
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">api.yourserver.com</domain>
    </domain-config>
    <!-- Optionally add certificate pinning here too -->
</network-security-config>
*/

// LAYER 4: Validate server responses — don't blindly trust response data
// LAYER 5: Add request signing (HMAC) for critical endpoints
String signRequest(String body, String secretKey) {
  // import 'package:crypto/crypto.dart';
  final hmac = Hmac(sha256, utf8.encode(secretKey));
  final digest = hmac.convert(utf8.encode(body));
  return digest.toString();
}
```

**On iOS — App Transport Security (ATS):**
```xml
<!-- ios/Runner/Info.plist -->
<!-- ATS is enabled by default — NEVER add this unless absolutely necessary: -->
<!-- <key>NSAllowsArbitraryLoads</key><true/> -->
<!-- If you need an exception, be specific: -->
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <false/>
</dict>
```

**MITM Prevention Checklist:**
```
✅ HTTPS for all network calls
✅ Certificate pinning for sensitive endpoints
✅ Network Security Config (Android) — cleartext blocked
✅ App Transport Security (iOS) — defaults to HTTPS
✅ Never log request bodies or auth headers
✅ Token stored securely (not in memory logs)
✅ Short-lived access tokens (reduces window of exposure)
```

**Why it matters:** This is a practical security question. Interviewers want to hear defense-in-depth thinking — not just "use HTTPS" but the multiple layers that work together.

**Common mistake:** Stopping at "use HTTPS." HTTPS can be bypassed on devices where attackers have installed their own CA certificate. Certificate pinning is the defense against that specific attack vector.

---

**Q:** What is app obfuscation and how do you enable it in Flutter?

**A:** Obfuscation is the process of transforming your compiled code so that it's difficult to read and understand when reverse-engineered. It renames classes, methods, and variables to meaningless identifiers, making it much harder for an attacker to understand your app's logic or extract hardcoded values.

```
WITHOUT OBFUSCATION (decompiled):
class AuthService {
  String refreshToken = "stored_token";
  
  Future<User> loginWithCredentials(String email, String password) {
    // Attacker can read your entire authentication logic
    final apiKey = "sk-prod-abc123secret"; // Fully readable!
  }
}

WITH OBFUSCATION (decompiled):
class a {
  String b = "stored_token";
  
  Future<c> d(String e, String f) {
    final g = "sk-prod-abc123secret"; // Key still visible but logic is opaque
  }
}
```

**How to enable in Flutter:**

```bash
# Android release build with obfuscation:
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/debug_info/android

# Android App Bundle (recommended for Play Store):
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/debug_info/android

# iOS release build with obfuscation:
flutter build ipa --release \
  --obfuscate \
  --split-debug-info=build/debug_info/ios
```

**What `--split-debug-info` does:**
```
Without it: Debug symbols stay in the binary → easier to decompile
With it:    Debug symbols are written to a separate file you keep privately
            Binary is stripped → harder to reverse-engineer

The debug info folder is critical — keep it safe!
You need it to de-obfuscate crash stack traces from Firebase Crashlytics.
```

**Re-symbolicating crash reports:**
```bash
# When you get an obfuscated stack trace from Crashlytics:
flutter symbolize \
  --input=obfuscated_stack_trace.txt \
  --debug-info=build/debug_info/android/app.android-arm64.symbols

# This translates: a.b(a.dart:1) → AuthService.login(auth_service.dart:42)
```

**ProGuard/R8 for Android (additional Java/Kotlin obfuscation):**
```
# android/app/build.gradle
buildTypes {
    release {
        minifyEnabled true           // Enable R8/ProGuard
        shrinkResources true         // Remove unused resources
        proguardFiles getDefaultProguardFile('proguard-android.txt'),
                      'proguard-rules.pro'
    }
}
```

**What obfuscation does NOT do:**
```
❌ Does NOT encrypt your code
❌ Does NOT prevent reverse engineering (determined attackers can still do it)
❌ Does NOT hide hardcoded strings/secrets (use --dart-define or backend proxy)
❌ Does NOT protect against runtime attacks (Frida, etc.)

✅ DOES raise the effort bar significantly
✅ DOES make automated scanning tools less effective
✅ DOES hide proprietary business logic from casual inspection
✅ DOES make it harder to clone your app
```

**Why it matters:** Obfuscation is a basic hygiene requirement (OWASP M7). An interviewer asking this wants to confirm you know both *how* to enable it and *what its limitations are* — not just that it's a magic security fix.

**Common mistake:** Thinking obfuscation makes the app secure. It's a deterrent, not a lock. Secrets hardcoded in the binary are still extractable with tools like `strings` regardless of obfuscation.

---

**Q:** What is root detection and jailbreak detection? How would you implement basic detection in Flutter?

**A:** Root detection (Android) and jailbreak detection (iOS) are techniques to identify whether the device running your app has been modified to bypass the operating system's security sandbox. On rooted/jailbroken devices, many security controls (file system isolation, app sandboxing, certificate pinning) can be bypassed.

```
WHY ROOTED/JAILBROKEN DEVICES ARE HIGHER RISK:
┌─────────────────────────────────────────────────────────────────┐
│ Normal Device                  │ Rooted/Jailbroken Device       │
├────────────────────────────────┼────────────────────────────────┤
│ App sandboxed → can't read     │ Root shell → read ANY file     │
│ other apps' data               │ including Keychain (iOS)       │
│                                │                                │
│ Can't hook/modify running apps │ Frida can hook your app,       │
│                                │ bypass certificate pinning,    │
│                                │ extract tokens from memory     │
│                                │                                │
│ Play Protect / App Store       │ Can install unsigned apps,     │
│ vetting applies                │ malware runs with root access  │
└────────────────────────────────┴────────────────────────────────┘
```

**Basic detection using `flutter_jailbreak_detection` package:**
```dart
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class DeviceSecurityChecker {
  static Future<bool> isDeviceCompromised() async {
    try {
      // Returns true if jailbroken (iOS) or rooted (Android)
      final isJailbroken = await FlutterJailbreakDetection.jailbroken;
      
      // Returns true if developer mode is enabled (Android)
      final isDeveloperMode = await FlutterJailbreakDetection.developerMode;

      return isJailbroken || isDeveloperMode;
    } catch (e) {
      // If detection itself fails, assume compromised
      return true;
    }
  }
}

// In your app startup (e.g., SplashScreen or main.dart):
Future<void> _checkDeviceSecurity() async {
  final isCompromised = await DeviceSecurityChecker.isDeviceCompromised();
  if (isCompromised) {
    // Option 1: Block completely
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Security Alert'),
        content: const Text(
          'This app cannot run on rooted or jailbroken devices.',
        ),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    // Option 2: Restrict sensitive features only (less aggressive)
    // _enableRestrictedMode();
  }
}
```

**Manual detection signals (Android):**
```dart
import 'dart:io';

class AndroidRootDetector {
  static Future<bool> hasRootIndicators() async {
    if (!Platform.isAndroid) return false;

    // Check 1: Common su binary locations
    const suPaths = [
      '/system/bin/su',
      '/system/xbin/su',
      '/sbin/su',
      '/su/bin/su',
      '/data/local/xbin/su',
      '/data/local/bin/su',
    ];

    for (final path in suPaths) {
      if (await File(path).exists()) return true;
    }

    // Check 2: Known root management apps
    const rootApps = [
      'com.topjohnwu.magisk',
      'com.koushikdutta.superuser',
      'com.noshufou.android.su',
    ];

    // Use platform channel to check installed packages
    // (requires native Android code — beyond this example's scope)

    return false;
  }
}
```

**Important caveats:**
```
Detection is never 100% reliable:
- Magisk (popular rooting tool) specifically hides itself from detection
- Root detection can be bypassed with Frida hooks
- Some legitimate apps (enterprise MDM) may trigger false positives

Best practice:
- Use detection as one layer of defense, not the only layer
- Google Play Integrity API (replaces SafetyNet) is more reliable than manual detection
- Consider what action to take carefully — blocking entirely can frustrate legitimate users
  (some security researchers, pen testers may have valid reasons)
```

**Why it matters:** This topic shows security depth and pragmatism. Interviewers want to hear that you know detection exists, how to implement it, *and* that you understand its limitations.

**Common mistake:** Claiming root detection is a complete security solution, or not knowing that tools like Magisk can bypass most detection methods. The goal is to raise the effort required for an attack, not to make it impossible.

---

**Q:** Why is logging sensitive data dangerous and how do you prevent it in Flutter?

**A:** Logs from mobile apps are more accessible than most developers assume. On Android, any app with `READ_LOGS` permission (or ADB access on debug builds) can read all system logs. On iOS, device logs are accessible via Xcode or device syslog. Crash analytics tools (Firebase Crashlytics, Sentry) also send logs to third-party servers.

```
HOW LOGS LEAK SENSITIVE DATA:

Developer writes:
  debugPrint('Login response: ${response.data}');
  // response.data contains: {"access_token": "eyJhbG...", "email": "user@company.com"}

Where this ends up:
┌─────────────────────────────────────────────────────────────┐
│ 1. Android Logcat (adb logcat) — visible to any ADB session │
│ 2. Firebase Crashlytics — uploaded to Google servers        │
│ 3. Sentry / Datadog — uploaded to third-party servers       │
│ 4. Device bugreports — shareable by users (e.g., to support)│
│ 5. On rooted device — readable by malicious apps            │
└─────────────────────────────────────────────────────────────┘
```

**Flutter-specific logging pitfalls:**
```dart
// ❌ DANGEROUS — ALL of these log sensitive data:
print('Token: $accessToken');
debugPrint('User: ${user.email}, Password: ${user.password}');
developer.log('API Key: $apiKey');

// These also leak data indirectly:
dio.interceptors.add(LogInterceptor(responseBody: true)); // ❌ Logs full response!
```

**Safe logging pattern:**
```dart
import 'package:flutter/foundation.dart';

class AppLogger {
  // Only log in debug mode — never in release
  static void debug(String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[DEBUG] $message');
    }
  }

  // Structured logging with automatic redaction
  static void apiCall({
    required String endpoint,
    required int statusCode,
    Map<String, dynamic>? headers,
  }) {
    if (!kDebugMode) return;

    // Redact sensitive headers before logging
    final safeHeaders = _redactHeaders(headers ?? {});
    debugPrint('[API] $endpoint → $statusCode | headers: $safeHeaders');
  }

  static Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    const sensitiveKeys = {'authorization', 'x-api-key', 'cookie', 'set-cookie'};
    return {
      for (final entry in headers.entries)
        entry.key: sensitiveKeys.contains(entry.key.toLowerCase())
            ? '[REDACTED]'
            : entry.value,
    };
  }

  // Safe Dio logger configuration:
  static LogInterceptor safeDioLogger() {
    return LogInterceptor(
      request: kDebugMode,
      requestBody: false,     // Never log request bodies (may contain passwords)
      responseBody: false,    // Never log response bodies (may contain tokens)
      requestHeader: false,   // Never log headers (auth tokens)
      responseHeader: false,
      error: true,            // OK to log error status codes
    );
  }
}
```

**Using `kReleaseMode` / `kDebugMode` guards:**
```dart
import 'package:flutter/foundation.dart';

// kDebugMode: true in debug builds only
// kReleaseMode: true in release builds only
// kProfileMode: true in profile builds only

void setupCrashlytics() {
  if (kReleaseMode) {
    // Only enable crash reporting in production
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
}

// Configure Crashlytics to NOT log sensitive keys:
void logSafeError(dynamic error, StackTrace stack) {
  FirebaseCrashlytics.instance.recordError(
    error,
    stack,
    // Do NOT include sensitive custom keys:
    // information: ['token=$token'],  ← NEVER do this
    information: ['screen=checkout', 'action=payment_submit'],
  );
}
```

**Why it matters:** Log-based data leakage is OWASP M6 (Inadequate Privacy Controls). It's one of the most common ways PII and tokens end up in the wrong hands — and it's entirely preventable with discipline.

**Common mistake:** Using `debugPrint` thinking it's safe because it "only shows in debug mode." In Flutter, `debugPrint` outputs to stdout, which ends up in device logs that are NOT limited to debug builds by default. Always wrap it in `if (kDebugMode)`.

---

**Q:** What is SQL injection in a mobile context and how do you prevent it?

**A:** SQL injection in mobile typically occurs when your app queries a **local SQLite database** (via `sqflite` or `drift`) by building query strings through string concatenation with user input. The attacker crafts input that modifies the SQL statement's logic.

```
VULNERABLE QUERY:

User types into search field: ' OR '1'='1

Your code:
  String query = "SELECT * FROM users WHERE email = '$userInput'";

Actual SQL executed:
  SELECT * FROM users WHERE email = '' OR '1'='1'
                                        └─────────┘
                                     Always true!
                                 Returns ALL user records

More destructive input: '; DROP TABLE users; --
  SELECT * FROM users WHERE email = ''; DROP TABLE users; --'
  → Deletes your entire users table!
```

**Prevention in Flutter with sqflite — use parameterized queries:**
```dart
import 'package:sqflite/sqflite.dart';

class UserRepository {
  final Database _db;

  UserRepository(this._db);

  // ❌ VULNERABLE — Never do this:
  Future<List<Map<String, dynamic>>> searchUsersUnsafe(String email) async {
    // String interpolation = SQL injection risk!
    return await _db.rawQuery(
      "SELECT * FROM users WHERE email = '$email'",
    );
  }

  // ✅ SAFE — Use parameterized queries (? placeholders):
  Future<List<Map<String, dynamic>>> searchUsersSafe(String email) async {
    // The ? placeholder is safely escaped by sqflite
    return await _db.rawQuery(
      'SELECT * FROM users WHERE email = ?',
      [email], // ← Input is passed separately, never interpolated into SQL
    );
  }

  // ✅ Even better — use sqflite's helper methods:
  Future<List<Map<String, dynamic>>> getUserByEmail(String email) async {
    return await _db.query(
      'users',               // table
      where: 'email = ?',    // parameterized where clause
      whereArgs: [email],    // safely bound values
    );
  }

  // ✅ INSERT with parameters:
  Future<int> insertUser(String email, String name) async {
    return await _db.insert(
      'users',
      {'email': email, 'name': name}, // Map form — auto-escaped
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ UPDATE with parameters:
  Future<int> updateUserName(int userId, String newName) async {
    return await _db.update(
      'users',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
```

**Input validation as additional defense:**
```dart
class InputValidator {
  // Validate before even hitting the database
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static String sanitizeSearchQuery(String input) {
    // Remove characters that have no place in search
    return input.replaceAll(RegExp(r"[';\"\\]"), '').trim();
  }

  static bool isValidId(String id) {
    // IDs should be numeric only
    return RegExp(r'^\d+$').hasMatch(id);
  }
}
```

**Why injection risks exist beyond local SQLite:**
```
Mobile injection attack surfaces:
┌──────────────────────────────────────────────────────────────┐
│ LOCAL DB (sqflite/drift) → SQL injection via raw queries     │
│ Remote API → Injection if backend doesn't parameterize       │
│ Deep links → Parameter injection via crafted URLs            │
│ File paths → Path traversal via "../../../etc/passwd"        │
│ WebViews → JavaScript injection if evaluating user input     │
└──────────────────────────────────────────────────────────────┘
```

**Why it matters:** OWASP M4 (Insufficient Input/Output Validation). Even if your backend is secure, a local database is an attack surface. This question tests whether you understand that parameterized queries aren't just a server-side concern.

**Common mistake:** Saying "I just use an ORM so I'm safe." ORMs like `drift` are safe by default for standard queries, but if you ever drop down to raw SQL queries, you're back to manual parameterization. Blanket ORM safety is a false assumption.

---

**Q:** What is deep link hijacking and how do you secure deep links in Flutter?

**A:** Deep link hijacking occurs when a malicious app on the same device registers the same URL scheme or domain association that your app uses, intercepting navigation that was intended for your app — potentially capturing auth codes, reset tokens, or sensitive parameters.

```
DEEP LINK HIJACKING ATTACK:

Normal deep link flow:
  User clicks: myapp://reset?token=abc123
  OS routes → Your app opens → Handles token

Hijacking:
  Malicious app ALSO registers: myapp://reset
  User clicks link → OS shows "Open with..." dialog
                              ┌─────────────────┐
                              │ Your App        │
                              │ Malicious App ← │ User accidentally picks this
                              └─────────────────┘
  Malicious app captures: token=abc123 → account takeover!

More dangerous scenario:
  OAuth redirect: myapp://callback?code=AUTH_CODE
  Malicious app registers same scheme → captures auth code
  → exchanges it for tokens → full account access
```

**Types of deep links and their security:**
```
┌─────────────────┬──────────────────────────────────────────────┐
│ Custom URI      │ myapp://path                                  │
│ Scheme          │ LOW SECURITY — any app can register any       │
│                 │ scheme. Easy to hijack.                       │
├─────────────────┼──────────────────────────────────────────────┤
│ App Links       │ https://yourapp.com/path                      │
│ (Android) /     │ HIGH SECURITY — requires a                    │
│ Universal Links │ .well-known/assetlinks.json (Android) or      │
│ (iOS)           │ apple-app-site-association (iOS) file hosted  │
│                 │ on YOUR domain. Malicious app cannot register │
│                 │ your domain.                                  │
└─────────────────┴──────────────────────────────────────────────┘
```

**Secure deep links with App Links (Android):**

**Step 1: Host a verification file**
```json
// https://yourapp.com/.well-known/assetlinks.json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.yourcompany.yourapp",
    "sha256_cert_fingerprints": [
      "AA:BB:CC:DD:..."  // Your app's signing certificate fingerprint
    ]
  }
}]
```

**Step 2: Declare in AndroidManifest.xml**
```xml
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <!-- Use HTTPS + your domain, not a custom scheme -->
  <data android:scheme="https"
        android:host="yourapp.com"
        android:pathPrefix="/reset" />
</intent-filter>
```

**Flutter implementation with `go_router` and `app_links`:**
```dart
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();

  void initialize(BuildContext context) {
    // Handle deep links when app is already running
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri, context);
    });
  }

  void _handleDeepLink(Uri uri, BuildContext context) {
    // ALWAYS validate the incoming deep link:

    // 1. Verify the host is what you expect
    if (uri.host != 'yourapp.com') {
      debugPrint('Rejected unexpected host: ${uri.host}');
      return;
    }

    // 2. Only handle known paths
    final allowedPaths = ['/reset', '/verify', '/callback'];
    if (!allowedPaths.contains(uri.path)) {
      debugPrint('Rejected unknown path: ${uri.path}');
      return;
    }

    // 3. Validate parameters — don't trust deep link params blindly
    switch (uri.path) {
      case '/callback':
        final code = uri.queryParameters['code'];
        final state = uri.queryParameters['state'];
        if (code == null || state == null) return;
        // Verify 'state' matches what YOU generated (CSRF protection)
        if (!_isValidOAuthState(state)) return;
        _handleOAuthCallback(code, context);
        break;

      case '/reset':
        final token = uri.queryParameters['token'];
        if (token == null || token.length < 32) return; // Basic validation
        context.go('/password-reset', extra: {'token': token});
        break;
    }
  }

  bool _isValidOAuthState(String state) {
    // Retrieve the state you stored before initiating the OAuth flow
    // Compare against stored state to prevent CSRF
    final storedState = _getStoredOAuthState();
    return state == storedState;
  }
}
```

**Why it matters:** Deep link hijacking is especially dangerous during OAuth flows — an intercepted auth code leads to complete account takeover. This tests whether you understand that secure deep linking requires verification at the OS level, not just application logic.

**Common mistake:** Using custom URL schemes (`myapp://`) for OAuth redirects. This is explicitly unsafe — PKCE + App Links/Universal Links is the correct approach. Also, not validating the `state` parameter in OAuth callbacks, which opens the door to CSRF attacks via crafted deep links.

---

**Q:** How do you handle biometric authentication in Flutter?

**A:** Biometric authentication (Face ID, Touch ID, fingerprint) is handled in Flutter via the `local_auth` package, which uses the device's built-in biometric hardware and the OS-level secure enclave. Critically, Flutter never has access to the biometric data itself — it only receives a pass/fail result from the OS.

```
BIOMETRIC AUTH FLOW:
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  Flutter App                                                    │
│      │                                                          │
│      │ 1. Request biometric auth                               │
│      ▼                                                          │
│  local_auth plugin                                              │
│      │                                                          │
│      │ 2. Platform channel call                                 │
│      ▼                                                          │
│  OS Biometric Framework                                         │
│  (BiometricPrompt / LocalAuthentication)                        │
│      │                                                          │
│      │ 3. Secure hardware verification                          │
│      ▼                                                          │
│  Secure Enclave / TEE                                           │
│  (Fingerprint/Face data never leaves this boundary)             │
│      │                                                          │
│      │ 4. Returns: success / failure / error                    │
│      ▼                                                          │
│  Flutter App receives boolean result only                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Full implementation:**
```dart
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';

class BiometricAuthService {
  static final _localAuth = LocalAuthentication();

  /// Check if biometrics are available and enrolled
  static Future<BiometricStatus> checkBiometricStatus() async {
    try {
      // Check if hardware is available
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!isAvailable || !isDeviceSupported) {
        return BiometricStatus.notAvailable;
      }

      // Check what biometrics are enrolled
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        return BiometricStatus.notEnrolled;
      }

      return BiometricStatus.available;
    } catch (_) {
      return BiometricStatus.notAvailable;
    }
  }

  /// Perform biometric authentication
  static Future<AuthResult> authenticate({
    String reason = 'Authenticate to access your account',
  }) async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,   // false = allow PIN fallback if biometric fails
          stickyAuth: true,       // Keep prompt open if user switches apps briefly
          sensitiveTransaction: true, // Shows stronger messaging on Android
          useErrorDialogs: true,  // Show built-in error dialogs
        ),
      );

      return authenticated ? AuthResult.success : AuthResult.failed;
    } on PlatformException catch (e) {
      switch (e.code) {
        case auth_error.notAvailable:
          return AuthResult.notAvailable;
        case auth_error.notEnrolled:
          return AuthResult.notEnrolled;
        case auth_error.lockedOut:
          return AuthResult.lockedOut;
        case auth_error.permanentlyLockedOut:
          return AuthResult.permanentlyLockedOut;
        case auth_error.passcodeNotSet:
          return AuthResult.passcodeNotSet;
        default:
          return AuthResult.error;
      }
    }
  }

  /// Stop any ongoing authentication (e.g., on screen dismiss)
  static Future<void> cancelAuthentication() async {
    await _localAuth.stopAuthentication();
  }
}

enum BiometricStatus { available, notAvailable, notEnrolled }

enum AuthResult {
  success,
  failed,
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
  passcodeNotSet,
  error,
}

// Usage in a screen:
Future<void> _handleBiometricLogin() async {
  final status = await BiometricAuthService.checkBiometricStatus();

  if (status != BiometricStatus.available) {
    // Fall back to PIN/password login
    _showPinLoginDialog();
    return;
  }

  final result = await BiometricAuthService.authenticate(
    reason: 'Login to MyApp',
  );

  switch (result) {
    case AuthResult.success:
      // Biometric verified — now retrieve stored token and log in
      final token = await TokenStorage.getAccessToken();
      await _loginWithToken(token!);
      break;
    case AuthResult.lockedOut:
      _showMessage('Too many attempts. Try again in 30 seconds.');
      break;
    case AuthResult.permanentlyLockedOut:
      _showMessage('Biometrics locked. Please use your PIN.');
      _showPinLoginDialog();
      break;
    default:
      _showMessage('Authentication failed. Please try again.');
  }
}
```

**Required platform setup:**

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<!-- Legacy (API < 28): -->
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

```xml
<!-- ios/Runner/Info.plist -->
<key>NSFaceIDUsageDescription</key>
<string>Use Face ID to securely log in to MyApp</string>
```

**Security consideration:**
```
Biometrics as UX, not authentication:
- Biometrics don't replace your auth token
- They protect ACCESS to a stored token
- Flow: Biometric success → retrieve token from Keychain → use token

This is correct — the token is the credential, biometrics is the gate.
```

**Why it matters:** Biometric auth is a user expectation in modern apps. Interviewers check whether you understand that biometrics gate access to credentials (tokens), rather than replacing them — and whether you handle the full set of error states gracefully.

**Common mistake:** Treating biometric success as the authentication itself, bypassing token-based auth. If someone disables biometrics on the OS level, they should NOT gain access. The token is the real credential; biometrics just protect access to it.

---

**Q:** Why should you never hardcode API keys in Flutter? What are the secure alternatives?

**A:** Hardcoded API keys in Flutter source code end up compiled into the application binary. Any determined attacker can extract them using tools like `strings`, decompilers, or by inspecting the compiled binary. This is true even with obfuscation — string values are often still readable.

```
HOW EASY IT IS TO EXTRACT HARDCODED KEYS:

Your code:
  const apiKey = 'sk-live-abc123secretproductionkey';

In the compiled APK:
  $ strings app.apk | grep 'sk-live'
  sk-live-abc123secretproductionkey    ← Found in seconds

Even with obfuscation:
  $ grep -r "sk-live" /extracted_apk/
  → Still findable because the string VALUE isn't obfuscated,
    only the variable name is
```

**Option 1: `--dart-define` (Build-time injection)**
```dart
// In your code — value comes from build environment:
const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');

// At build time:
flutter build apk --dart-define=API_KEY=your_actual_key

// In CI/CD (GitHub Actions example):
// - run: flutter build apk --dart-define=API_KEY=${{ secrets.API_KEY }}

// For local development — create a Makefile or script:
// flutter run --dart-define=API_KEY=dev_key_here
```

**But `--dart-define` has a limitation:**
```
The value IS still in the binary — just not visible in source code.
A determined attacker with binary analysis tools can still find it.

Rule of thumb:
  --dart-define is fine for:
    ✅ Environment-specific config (staging vs prod endpoints)
    ✅ Non-critical keys with limited blast radius
    ✅ Keys where rate-limiting and monitoring exist

  NOT sufficient for:
    ❌ Payment processor keys (Stripe secret key)
    ❌ Database credentials
    ❌ Keys with no rate limiting or monitoring
```

**Option 2: Backend Proxy (Most Secure)**
```
ARCHITECTURE — Backend Proxy:

┌──────────┐        ┌─────────────────┐        ┌──────────────┐
│  Flutter │ ──────▶│  Your Backend   │ ──────▶│  Third-Party │
│   App    │ HTTP   │  (API Proxy)    │ HTTP + │  API (OpenAI,│
│          │ (auth  │                 │  Key   │  Stripe, etc)│
│          │  token)│  Key never      │        │              │
└──────────┘        │  leaves server  │        └──────────────┘
                    └─────────────────┘

Flutter app never sees the API key.
Your backend authenticates the user's request first,
then calls the third-party API on their behalf.
```

```dart
// Flutter app calls YOUR backend (authenticated):
class AiService {
  final Dio _dio;

  AiService(this._dio);

  Future<String> generateText(String prompt) async {
    // Call your own backend — NOT OpenAI directly
    final response = await _dio.post(
      '/api/ai/generate',      // Your backend endpoint
      data: {'prompt': prompt},
      // Auth token included via interceptor — user is authenticated
    );
    return response.data['text'];
  }
}

// Your backend (Node.js/Python/etc) — key lives here:
// app.post('/api/ai/generate', authenticate, async (req, res) => {
//   const openai = new OpenAI({ apiKey: process.env.OPENAI_KEY }); // Env var!
//   const result = await openai.chat.completions.create({...});
//   res.json({ text: result.choices[0].message.content });
// });
```

**Option 3: Remote Config (for non-sensitive config)**
```dart
// Firebase Remote Config — useful for feature flags and non-sensitive config
// NOT for secret API keys (they travel over the network and can be intercepted)
import 'package:firebase_remote_config/firebase_remote_config.dart';

final remoteConfig = FirebaseRemoteConfig.instance;
await remoteConfig.fetchAndActivate();
final featureEnabled = remoteConfig.getBool('new_feature_enabled');
```

**Decision tree:**
```
Is the key sensitive (payment, high-privilege)?
  └─ YES → Backend proxy. No exceptions.
  └─ NO → Is it acceptable if the key leaks?
            └─ YES (rate-limited, low risk) → --dart-define is acceptable
            └─ NO → Still use backend proxy
```

**Why it matters:** API key exposure is OWASP M1 (Improper Credential Usage). Interviewers ask this to separate developers who've thought about production security from those who haven't.

**Common mistake:** Thinking `.env` files solve this. In Flutter, `.env` files still get bundled into the build unless you use them as input to `--dart-define`. They're NOT automatically excluded from the binary just because they're in a separate file.

---

**Q:** What is the difference between encryption at rest and encryption in transit?

**A:** These are two distinct attack surfaces that require separate encryption strategies. A complete security posture requires both.

```
ENCRYPTION IN TRANSIT vs AT REST:

IN TRANSIT — Data moving over a network:
┌──────────┐ ──── Internet ──── ┌──────────┐
│  Device  │ ════ TLS/HTTPS ═══ │  Server  │
│          │ (encrypted pipe)   │          │
└──────────┘                    └──────────┘
  Protects against: MITM attacks, network sniffing
  Even if someone intercepts the packets, they see ciphertext

AT REST — Data stored somewhere:
┌──────────────────────────────────────────────────────────────┐
│ Device Storage      │ Server Database   │ Backup / S3        │
│ ─────────────       │ ───────────────   │ ─────────────      │
│ Keychain (iOS)      │ Encrypted columns │ S3 SSE-S3          │
│ Android Keystore    │ Full-disk encrypt │ AES-256 at rest    │
│ SQLCipher (SQLite)  │ (RDS encryption)  │                    │
│                     │                   │                    │
│ Protects if device  │ Protects if       │ Protects if        │
│ is stolen or        │ DB backup is      │ storage is         │
│ accessed via ADB    │ stolen            │ compromised        │
└──────────────────────────────────────────────────────────────┘

BOTH are needed:
  Only in transit → Data on stolen device is exposed
  Only at rest   → Data is intercepted during transmission
```

**Flutter implementation — Encryption in Transit:**
```dart
// 1. Use HTTPS always (Dio + HTTPS base URL)
final dio = Dio(BaseOptions(baseUrl: 'https://api.yourserver.com'));

// 2. Certificate pinning (prevents MITM even on compromised networks)
// (See certificate pinning question above)

// 3. Block cleartext traffic (Android)
// android/app/src/main/AndroidManifest.xml:
// android:usesCleartextTraffic="false"
// OR via Network Security Config
```

**Flutter implementation — Encryption at Rest:**
```dart
// 1. Tokens / credentials → Flutter Secure Storage (Keychain/Keystore)
await FlutterSecureStorage().write(key: 'token', value: accessToken);

// 2. Sensitive local database → SQLCipher (encrypted SQLite)
// Use drift with SQLCipher:
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';

LazyDatabase _openDatabase() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'app.db'));

    return SqfliteQueryExecutor.inDatabaseFolder(
      path: 'encrypted_app.db',
      // Use sqlcipher_flutter_libs for encryption:
      // encrypt: true,
      // password: await _getDatabaseKey(), // From Keychain/Keystore
    );
  });
}

// 3. Files / documents → Encrypt before saving
import 'package:encrypt/encrypt.dart';

class FileEncryptionService {
  static Future<void> saveEncryptedFile(
    String filePath,
    Uint8List data,
  ) async {
    // Retrieve key from secure storage
    final keyStr = await FlutterSecureStorage().read(key: 'file_encryption_key');
    final key = Key.fromBase64(keyStr!);
    final iv = IV.fromSecureRandom(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encryptBytes(data, iv: iv);

    // Save IV + encrypted data together
    final fileContent = Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);
    await File(filePath).writeAsBytes(fileContent);
  }
}
```

**Summary table:**
```
┌──────────────────┬────────────────────────────────┬─────────────────────────┐
│                  │ Encryption In Transit           │ Encryption At Rest      │
├──────────────────┼────────────────────────────────┼─────────────────────────┤
│ Protects from    │ Network eavesdropping, MITM     │ Device theft, data      │
│                  │                                 │ breach, ADB access      │
├──────────────────┼────────────────────────────────┼─────────────────────────┤
│ Technology       │ TLS 1.2/1.3, HTTPS             │ AES-256, Keychain,      │
│                  │ Certificate pinning             │ Keystore, SQLCipher     │
├──────────────────┼────────────────────────────────┼─────────────────────────┤
│ Flutter tools    │ Dio + HTTPS, pinning,           │ flutter_secure_storage, │
│                  │ ATS/Network Security Config     │ SQLCipher, encrypt pkg  │
├──────────────────┼────────────────────────────────┼─────────────────────────┤
│ When it matters  │ Data being sent/received        │ Data sitting on device  │
│                  │                                 │ or server storage       │
└──────────────────┴────────────────────────────────┴─────────────────────────┘
```

**Why it matters:** This is a foundational security concept. Interviewers use it to check whether you think about security holistically across the full data lifecycle — not just "we use HTTPS" but also what happens to data once it arrives and is stored.

**Common mistake:** Only addressing transit encryption and assuming "that's enough." A company that uses HTTPS but stores all tokens in plaintext SharedPreferences has solved half the problem and left the other half wide open. Defense-in-depth means securing data everywhere it lives.

---

*End of Section 20: Mobile & App Security*

---

> **Study tip:** For every security topic in this section, be prepared to explain the *threat model* (what attack does this defend against?), the *Flutter-specific implementation*, and the *limitations* of each defense. Interviewers at senior level don't just want to know what you do — they want to know why, and what its failure modes are.
