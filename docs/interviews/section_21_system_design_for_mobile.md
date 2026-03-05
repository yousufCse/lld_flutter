# Section 21: System Design for Mobile

---

**Q:** How do you approach a system design question in a Flutter/mobile context?

**A:** System design interviews test your ability to think like an architect — not just write code. Use this five-step framework every time:

```
┌─────────────────────────────────────────────────────────────────┐
│              SYSTEM DESIGN FRAMEWORK (5 Steps)                  │
├─────────────────────────────────────────────────────────────────┤
│  1. CLARIFY REQUIREMENTS                                        │
│     ├── Functional:  What must the app do?                      │
│     └── Non-functional: Offline? Scale? Latency? Platform?      │
│                                                                 │
│  2. ESTIMATE SCALE                                              │
│     ├── DAU / MAU?  How many concurrent users?                  │
│     ├── Data volume: How many messages/photos per day?          │
│     └── Device constraints: RAM, battery, bandwidth            │
│                                                                 │
│  3. HIGH-LEVEL DESIGN                                           │
│     ├── Draw components: Client, API, DB, Cache, CDN            │
│     ├── Define data flow end-to-end                             │
│     └── Choose architecture pattern (Clean, MVVM, BLoC)        │
│                                                                 │
│  4. DEEP DIVE                                                   │
│     ├── Pick the hardest/most interesting component             │
│     ├── API contracts, DB schemas, state management             │
│     └── Edge cases: offline, race conditions, failures         │
│                                                                 │
│  5. TRADE-OFFS                                                  │
│     ├── Why this choice over alternatives?                      │
│     └── What would you change with more time/resources?        │
└─────────────────────────────────────────────────────────────────┘
```

**Applied to Flutter specifically — always address:**
- **State management** choice and why (BLoC, Riverpod, etc.)
- **Local persistence** (Hive, Drift, SharedPreferences)
- **Networking layer** (Dio, http, WebSocket)
- **Offline behaviour** — what happens with no connection?
- **Error states** — loading, empty, error, success (LEES pattern)
- **Navigation** — GoRouter or Navigator 2.0 for deep links
- **Testing** — is the design testable?

**Example:**

```
Interviewer: "Design a Flutter food delivery app."

You: "Before I start — a few questions:
  - Are we targeting iOS and Android both?
  - Expected scale — 10K or 10M orders per day?
  - Does it need to work offline?
  - Do we own the backend or integrate with an existing API?

OK, so with those assumptions:
  - Functional: Browse restaurants, add to cart, place order, 
    track delivery in real time.
  - Non-functional: Real-time tracking requires WebSocket or SSE.
    Offline menu browsing requires local caching.

High-level architecture:
  Flutter App → REST API (menu/orders) + WebSocket (live tracking)
             → PostgreSQL + Redis cache
             → Firebase Cloud Messaging (push notifications)

For Flutter-side, I'd use:
  - Clean Architecture + BLoC
  - Dio for HTTP, web_socket_channel for tracking
  - Hive for offline menu caching
  - GoRouter for deep linking to order status screens"
```

**Why it matters:** The interviewer is checking if you can structure thinking under pressure, ask good clarifying questions, and make reasoned architectural decisions — not just dump buzzwords.

**Common mistake:** Jumping straight into code or implementation details before establishing requirements and scope. Candidates often forget the mobile-specific constraints: offline behaviour, battery usage, memory limits, and platform differences.

---

**Q:** Design a real-time chat application in Flutter. Cover architecture, transport choice, state management, and local storage.

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│                   REAL-TIME CHAT — ARCHITECTURE                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Flutter App                                                    │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │  UI Layer       ChatScreen, MessageBubble, InputBar      │  │
│   │      │                                                   │  │
│   │  BLoC Layer     ChatBloc, MessageEvent, MessageState     │  │
│   │      │                                                   │  │
│   │  Repository     ChatRepository (interface)               │  │
│   │      │                    │                              │  │
│   │  Remote DS      WebSocket  │   Local DS   Drift/Hive     │  │
│   └──────────────────────────────────────────────────────────┘  │
│          │                                                       │
│   WebSocket Server (e.g., Node.js + Socket.io or Go)            │
│          │                                                       │
│   PostgreSQL (messages) + Redis (presence/pub-sub)              │
└──────────────────────────────────────────────────────────────────┘
```

**Transport comparison:**

```
┌─────────────┬──────────────────────┬──────────────────────────────┐
│  Method     │  Pros                │  Cons                        │
├─────────────┼──────────────────────┼──────────────────────────────┤
│  Polling    │  Simple, works       │  Wastes battery/bandwidth,   │
│  (HTTP GET  │  everywhere          │  high latency (1-30s delay)  │
│  on timer)  │                      │                              │
├─────────────┼──────────────────────┼──────────────────────────────┤
│  SSE        │  Server push,        │  One-way only (server→client)│
│  (Server-   │  auto-reconnect,     │  Not ideal for chat (need    │
│  Sent       │  works over HTTP     │  bidirectional)              │
│  Events)    │                      │                              │
├─────────────┼──────────────────────┼──────────────────────────────┤
│  WebSocket  │  Bidirectional,      │  Stateful connection, needs  │
│  ✅ BEST    │  low latency,        │  reconnect logic, proxy      │
│  FOR CHAT   │  efficient (one      │  issues possible             │
│             │  persistent conn)    │                              │
└─────────────┴──────────────────────┴──────────────────────────────┘
```

**Example:**

```dart
// --- WebSocket Service ---
class ChatWebSocketService {
  WebSocketChannel? _channel;
  final _messageController = StreamController<ChatMessage>.broadcast();

  Stream<ChatMessage> get messages => _messageController.stream;

  void connect(String userId, String token) {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://api.example.com/ws?token=$token'),
    );

    _channel!.stream.listen(
      (data) {
        final message = ChatMessage.fromJson(jsonDecode(data));
        _messageController.add(message);
      },
      onDone: _reconnect,
      onError: (_) => _reconnect(),
    );
  }

  void sendMessage(ChatMessage message) {
    _channel?.sink.add(jsonEncode(message.toJson()));
  }

  void _reconnect() {
    // Exponential backoff reconnect
    Future.delayed(const Duration(seconds: 3), connect);
  }

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
  }
}

// --- ChatBloc ---
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;
  StreamSubscription? _wsSubscription;

  ChatBloc(this._repository) : super(ChatInitial()) {
    on<ConnectToChat>(_onConnect);
    on<SendMessage>(_onSend);
    on<MessageReceived>(_onReceived);
    on<LoadLocalMessages>(_onLoadLocal);
  }

  Future<void> _onConnect(ConnectToChat event, Emitter<ChatState> emit) async {
    // 1. Load cached messages immediately (optimistic UX)
    final cached = await _repository.getLocalMessages(event.roomId);
    emit(ChatLoaded(messages: cached));

    // 2. Connect WebSocket and stream new messages
    _wsSubscription = _repository.messageStream.listen(
      (msg) => add(MessageReceived(msg)),
    );
    await _repository.connect(event.roomId);
  }

  Future<void> _onSend(SendMessage event, Emitter<ChatState> emit) async {
    final optimisticMsg = event.message.copyWith(
      status: MessageStatus.sending,
      localId: uuid.v4(),
    );

    // Show immediately (optimistic update)
    final current = (state as ChatLoaded).messages;
    emit(ChatLoaded(messages: [optimisticMsg, ...current]));

    try {
      await _repository.sendMessage(event.message);
      // Update status to sent on success
    } catch (_) {
      // Update status to failed — allow retry
    }
  }
}

// --- Local Storage with Drift ---
// Messages table caches last N messages per room.
// On reconnect, sync from server fills gaps using cursor/timestamp.
```

**Message sync strategy:**
```
App opens → Load local messages (instant display)
         → Fetch missed messages since last_seen_id from REST
         → Connect WebSocket for live updates
         → Save all incoming messages to local DB
```

**Why it matters:** Tests architectural depth: transport protocol knowledge, optimistic UI patterns, offline-to-online sync, and real-time state management.

**Common mistake:** Choosing polling "because it's simpler" without acknowledging its battery and latency cost — or designing a WebSocket system without reconnection logic. Also: not mentioning optimistic UI updates (showing sent message immediately before server confirms).

---

**Q:** Design an offline-first news feed in Flutter.

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│                 OFFLINE-FIRST NEWS FEED DESIGN                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  User opens app                                                  │
│       │                                                          │
│       ▼                                                          │
│  Local DB (Drift) ──► Render articles immediately               │
│       │                                                          │
│       ▼                                                          │
│  Check connectivity ──► Online? ──► Fetch from API              │
│                                          │                       │
│                                          ▼                       │
│                                   Merge + Deduplicate            │
│                                          │                       │
│                                          ▼                       │
│                                   Save to Local DB              │
│                                          │                       │
│                                          ▼                       │
│                                   Update UI (stream)            │
└──────────────────────────────────────────────────────────────────┘
```

**Three core problems to solve:**

**1. Local DB (Drift — type-safe SQLite for Flutter)**
```dart
// Article entity in Drift
class Articles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get publishedAt => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get cachedAt => dateTime()();  // for cache eviction
}
```

**2. Sync Strategy — "Stale While Revalidate"**
```dart
class NewsRepository {
  final NewsLocalDataSource _local;
  final NewsRemoteDataSource _remote;
  final ConnectivityService _connectivity;

  // Returns stream: emits local data first, then refreshed data
  Stream<List<Article>> getNewsFeed() async* {
    // Step 1: Emit local immediately
    final local = await _local.getArticles();
    yield local;

    // Step 2: If online, fetch fresh data
    if (await _connectivity.isConnected) {
      try {
        final remote = await _remote.fetchLatestArticles(
          since: local.isNotEmpty ? local.first.publishedAt : null,
        );

        // Step 3: Upsert (insert or update) to local DB
        await _local.upsertArticles(remote);

        // Step 4: Emit merged result
        yield await _local.getArticles();
      } catch (e) {
        // Stay with local data — no error flash for offline reads
      }
    }
  }

  // Background sync (WorkManager / background_fetch)
  Future<void> backgroundSync() async {
    if (!await _connectivity.isConnected) return;
    final articles = await _remote.fetchLatestArticles();
    await _local.upsertArticles(articles);
    await _local.evictOldCache(keepDays: 7);
  }
}
```

**3. Conflict Resolution**

For a read-only news feed, conflicts are minimal — server data always wins. But for user state (read/bookmarked):

```
Strategy: Last-Write-Wins with timestamp

Local action: User bookmarks article while offline
  → Store with local timestamp + sync_status = PENDING

On reconnect:
  → Push pending actions to server
  → Server applies if server_timestamp > client_timestamp
  → Pull server state and overwrite local

For truly bidirectional data (e.g., draft articles):
  → Use CRDTs or manual merge UI ("which version do you want to keep?")
```

**Cache eviction:**
```dart
// Delete articles older than 7 days that aren't bookmarked
Future<void> evictOldCache({int keepDays = 7}) {
  final cutoff = DateTime.now().subtract(Duration(days: keepDays));
  return (delete(articles)
    ..where((a) => a.cachedAt.isSmallerThanValue(cutoff) 
                 & a.isBookmarked.equals(false)))
    .go();
}
```

**Why it matters:** Offline-first is a key differentiator in production mobile apps. Interviewers want to see you can design for unreliable networks and think about data freshness, eviction, and user experience during sync.

**Common mistake:** Designing the happy path only (fetch → display). Forgetting: What does the user see on first launch with no data? What happens mid-sync if connectivity drops? What happens if local and remote have conflicting timestamps?

---

**Q:** Design an authentication system in Flutter — login flow, token storage, refresh, and logout.

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│                  AUTH SYSTEM — COMPLETE FLOW                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  LOGIN FLOW                                                      │
│  User enters credentials                                         │
│       │                                                          │
│       ▼                                                          │
│  POST /auth/login ──► Server validates                           │
│       │                      │                                   │
│       │              Returns: access_token (short-lived, 15m)   │
│       │                       refresh_token (long-lived, 30d)   │
│       ▼                                                          │
│  Store securely:                                                 │
│    access_token  → In-memory (or flutter_secure_storage)        │
│    refresh_token → flutter_secure_storage (encrypted keychain)  │
│       │                                                          │
│  TOKEN REFRESH FLOW                                              │
│  API call returns 401                                            │
│       │                                                          │
│       ▼                                                          │
│  Dio Interceptor catches 401                                     │
│       │                                                          │
│       ▼                                                          │
│  POST /auth/refresh with refresh_token                          │
│       │                   │                                      │
│       │           Success: new access_token                      │
│       │                   │                                      │
│       ▼                   ▼                                      │
│  Retry original request   Failure: logout + redirect to login   │
│                                                                  │
│  LOGOUT FLOW                                                     │
│  POST /auth/logout (invalidate refresh_token on server)         │
│  Clear flutter_secure_storage                                    │
│  Clear in-memory state                                           │
│  Navigate to LoginScreen (clear navigation stack)               │
└──────────────────────────────────────────────────────────────────┘
```

**Example:**

```dart
// --- Secure Token Storage ---
class TokenStorage {
  final FlutterSecureStorage _storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: access),
      _storage.write(key: _refreshKey, value: refresh),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> clearAll() async {
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
    ]);
  }
}

// --- Dio Interceptor for Token Refresh ---
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final AuthRepository _authRepo;
  bool _isRefreshing = false;
  final _pendingRequests = <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Queue requests while refreshing (prevents parallel refresh storms)
    if (_isRefreshing) {
      _pendingRequests.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) throw Exception('No refresh token');

      final tokens = await _authRepo.refreshTokens(refreshToken);
      await _tokenStorage.saveTokens(
        access: tokens.accessToken,
        refresh: tokens.refreshToken,
      );

      // Retry original + queued requests
      final dio = Dio();
      for (final pending in _pendingRequests) {
        _retryRequest(dio, pending.options, pending.handler, tokens.accessToken);
      }
      _pendingRequests.clear();
      _retryRequest(dio, err.requestOptions, handler, tokens.accessToken);
    } catch (_) {
      // Refresh failed — force logout
      await _tokenStorage.clearAll();
      // Emit logout event via a global stream/BLoC
      AuthEventBus.instance.add(LoggedOutEvent());
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  void _retryRequest(Dio dio, RequestOptions options,
      ErrorInterceptorHandler handler, String newToken) {
    options.headers['Authorization'] = 'Bearer $newToken';
    dio.fetch(options).then(handler.resolve).catchError(handler.reject);
  }
}
```

**Token storage decision:**
```
DO NOT use SharedPreferences for tokens → plain text, not encrypted
DO NOT store access_token in memory only → lost on app kill

✅ USE flutter_secure_storage:
   → iOS: Keychain
   → Android: EncryptedSharedPreferences (Android Keystore)
```

**Biometric auth layer (bonus):**
```dart
// Re-authenticate with biometrics before showing sensitive screens
// local_auth package → authenticates locally, does NOT replace tokens
final didAuth = await LocalAuthentication().authenticate(
  localizedReason: 'Confirm your identity',
);
if (!didAuth) Navigator.pop(context);
```

**Why it matters:** Every production app has auth. Interviewers are checking knowledge of token lifecycle, secure storage, the refresh race condition problem (multiple simultaneous 401s triggering multiple refresh calls), and clean logout.

**Common mistake:** Storing tokens in SharedPreferences (unencrypted). Not handling the "refresh race condition" — if 3 API calls fail with 401 simultaneously, you must not fire 3 refresh requests. Queue them and retry all after one refresh succeeds.

---

**Q:** Design a photo upload feature in Flutter with chunked upload, progress tracking, retry on failure, and compression.

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│                    PHOTO UPLOAD PIPELINE                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  User picks photo                                                │
│       │                                                          │
│       ▼                                                          │
│  [1] Compress image (flutter_image_compress)                     │
│       │  Original: 8MB JPEG → Compressed: ~800KB                │
│       ▼                                                          │
│  [2] Generate upload session (POST /uploads/initiate)           │
│       │  Server returns: upload_id, chunk_size (e.g. 1MB)       │
│       ▼                                                          │
│  [3] Split file into chunks                                      │
│       │  Chunk 0: bytes 0–1MB                                   │
│       │  Chunk 1: bytes 1MB–2MB  etc.                           │
│       ▼                                                          │
│  [4] Upload chunks sequentially (or parallel, server-dependent) │
│       │  PUT /uploads/{upload_id}/chunks/{chunk_index}          │
│       │  Track progress per chunk → aggregate for progress bar  │
│       ▼                                                          │
│  [5] Finalise (POST /uploads/{upload_id}/complete)              │
│       │  Server assembles chunks, returns final media URL        │
│       ▼                                                          │
│  [6] On any chunk failure → Retry with exponential backoff      │
│       │  Already-uploaded chunks: skip (server tracks received) │
│       ▼                                                          │
│  Display uploaded photo from returned URL                        │
└──────────────────────────────────────────────────────────────────┘
```

**Example:**

```dart
// --- Step 1: Compress ---
Future<File> compressImage(File original) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    original.absolute.path,
    '${original.parent.path}/compressed_${original.uri.pathSegments.last}',
    quality: 75,          // 75% quality — good balance
    minWidth: 1920,
    minHeight: 1080,
  );
  return result!;
}

// --- Step 2 & 3: Chunked Upload ---
class ChunkedUploadService {
  static const int chunkSize = 1024 * 1024; // 1MB

  final Dio _dio;
  final _progressController = StreamController<double>.broadcast();

  Stream<double> get progress => _progressController.stream;

  Future<String> uploadPhoto(File file) async {
    final compressed = await compressImage(file);
    final bytes = await compressed.readAsBytes();
    final totalChunks = (bytes.length / chunkSize).ceil();

    // Initiate upload session
    final sessionResponse = await _dio.post('/uploads/initiate', data: {
      'filename': file.uri.pathSegments.last,
      'total_chunks': totalChunks,
      'total_size': bytes.length,
    });
    final uploadId = sessionResponse.data['upload_id'];

    // Upload each chunk with retry
    for (int i = 0; i < totalChunks; i++) {
      final start = i * chunkSize;
      final end = (start + chunkSize).clamp(0, bytes.length);
      final chunk = bytes.sublist(start, end);

      await _uploadChunkWithRetry(
        uploadId: uploadId,
        chunkIndex: i,
        chunk: chunk,
        onProgress: (sent, total) {
          final chunkProgress = sent / total;
          final overallProgress = (i + chunkProgress) / totalChunks;
          _progressController.add(overallProgress);
        },
      );
    }

    // Finalise
    final finalResponse = await _dio.post('/uploads/$uploadId/complete');
    return finalResponse.data['media_url'];
  }

  Future<void> _uploadChunkWithRetry({
    required String uploadId,
    required int chunkIndex,
    required Uint8List chunk,
    required void Function(int, int) onProgress,
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        await _dio.put(
          '/uploads/$uploadId/chunks/$chunkIndex',
          data: Stream.fromIterable([chunk]),
          options: Options(
            headers: {
              'Content-Length': chunk.length,
              'Content-Type': 'application/octet-stream',
            },
          ),
          onSendProgress: onProgress,
        );
        return; // Success — exit retry loop
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        // Exponential backoff: 1s, 2s, 4s
        await Future.delayed(Duration(seconds: 1 << attempt));
      }
    }
  }
}

// --- UI: Progress Bar ---
class UploadProgressWidget extends StatelessWidget {
  final Stream<double> progressStream;

  const UploadProgressWidget({required this.progressStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: progressStream,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0.0;
        return Column(
          children: [
            LinearProgressIndicator(value: progress),
            Text('${(progress * 100).toStringAsFixed(0)}%'),
          ],
        );
      },
    );
  }
}
```

**Why it matters:** Large file uploads are a classic "what can go wrong" scenario. Interviewers want: resilience (retry), UX (progress), efficiency (compression + chunking), and understanding of multipart vs streaming upload.

**Common mistake:** Uploading the full file in one request — fails on poor networks, no recovery possible. Forgetting to compress before upload (mobile photos are 5–12MB). Not tracking which chunks succeeded to avoid re-uploading them on retry.

---

**Q:** How do you design for scalability in a mobile app architecture?

**A:** Mobile scalability is different from server scalability. On mobile, you're scaling *code complexity* and *team size*, not request throughput. The goal is an architecture that stays maintainable as features, screens, and developers multiply.

```
┌──────────────────────────────────────────────────────────────────┐
│              SCALABILITY DIMENSIONS IN FLUTTER                   │
├─────────────────────────┬────────────────────────────────────────┤
│  Dimension              │  Solution                              │
├─────────────────────────┼────────────────────────────────────────┤
│  Code organisation      │  Feature-first folder structure        │
│  Team parallelism       │  Module boundaries, interface-driven   │
│  Build speed            │  Modular packages, lazy loading        │
│  State at scale         │  Scoped state, no global god-objects   │
│  Network at scale       │  Pagination, caching, deduplication    │
│  Performance at scale   │  Code splitting, image caching         │
└─────────────────────────┴────────────────────────────────────────┘
```

**1. Feature-first folder structure:**
```
lib/
├── core/               ← shared utilities, network, theme
│   ├── network/
│   ├── storage/
│   └── theme/
├── features/
│   ├── auth/
│   │   ├── data/       ← repositories, DTOs, data sources
│   │   ├── domain/     ← entities, use cases, repo interfaces
│   │   └── presentation/ ← BLoC, screens, widgets
│   ├── feed/
│   └── profile/
└── main.dart
```

**2. Dependency injection at scale (get_it + injectable):**
```dart
// Each feature registers its own dependencies
// No feature knows how another feature constructs its objects
@module
abstract class FeedModule {
  @lazySingleton
  FeedRepository feedRepository(
    FeedRemoteDataSource remote,
    FeedLocalDataSource local,
  ) => FeedRepositoryImpl(remote, local);
}
```

**3. Pagination — cursor-based (scales better than offset):**
```dart
// Offset pagination breaks when data changes mid-scroll
// Cursor pagination is stable
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  String? _nextCursor;
  bool _hasMore = true;

  Future<void> _onLoadMore(LoadMore event, Emitter<FeedState> emit) async {
    if (!_hasMore) return;
    final result = await _repo.getFeed(cursor: _nextCursor);
    _nextCursor = result.nextCursor;
    _hasMore = result.nextCursor != null;
    // append to existing list
  }
}
```

**4. Image caching at scale:**
```dart
// cached_network_image + custom cache manager
CachedNetworkImage(
  imageUrl: article.imageUrl,
  cacheManager: CustomCacheManager.instance,  // 7-day TTL, 200MB max
  placeholder: (_, __) => ShimmerWidget(),
  errorWidget: (_, __, ___) => PlaceholderImage(),
)
```

**5. API layer at scale — repository + datasource pattern:**
```
UI → BLoC → UseCase → Repository (interface)
                           ├── RemoteDataSource (Dio)
                           └── LocalDataSource (Drift)
```

**Why it matters:** Scalability questions expose whether you've worked on large apps or just toy projects. Interviewers check for: feature isolation, avoiding god classes, CI/build speed concerns, and whether you understand the difference between scaling an app vs scaling a server.

**Common mistake:** Describing server-side scalability (load balancing, sharding) when the question is about mobile. Also: flat folder structures (`screens/`, `models/`, `widgets/`) that become unmaintainable past ~30 screens.

---

**Q:** How do you design a plugin or SDK that other Flutter apps will use?

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│                   FLUTTER SDK/PLUGIN STRUCTURE                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  your_sdk/                                                       │
│  ├── lib/                                                        │
│  │   ├── src/              ← internal implementation (private)  │
│  │   │   ├── network/                                           │
│  │   │   ├── storage/                                           │
│  │   │   └── models/                                            │
│  │   └── your_sdk.dart     ← public API (the only export)       │
│  ├── android/              ← platform channel implementation    │
│  ├── ios/                  ← platform channel implementation    │
│  ├── example/              ← demo app showing SDK usage         │
│  └── test/                 ← unit + integration tests           │
└──────────────────────────────────────────────────────────────────┘
```

**Key design principles:**

**1. Public API surface — minimal and stable:**
```dart
// your_sdk.dart — this is ALL that consumers see
library your_sdk;

export 'src/client.dart' show YourSdkClient;
export 'src/models/event.dart' show AnalyticsEvent;
export 'src/config.dart' show SdkConfig;
// Internal classes are NEVER exported
```

**2. Initialisation pattern:**
```dart
// Consumers call once in main()
class YourSdkClient {
  static YourSdkClient? _instance;

  YourSdkClient._internal();

  static Future<YourSdkClient> initialize(SdkConfig config) async {
    _instance ??= YourSdkClient._internal();
    await _instance!._setup(config);
    return _instance!;
  }

  // Prevent calling before init
  static YourSdkClient get instance {
    assert(_instance != null,
      'YourSdkClient.initialize() must be called before accessing instance.');
    return _instance!;
  }

  Future<void> trackEvent(AnalyticsEvent event) async { ... }
}

// Consumer usage:
void main() async {
  await YourSdkClient.initialize(SdkConfig(apiKey: 'xxx'));
  runApp(MyApp());
}

// Anywhere in app:
YourSdkClient.instance.trackEvent(AnalyticsEvent('button_tapped'));
```

**3. Configuration — not hardcoded:**
```dart
class SdkConfig {
  final String apiKey;
  final Duration timeout;
  final LogLevel logLevel;
  final String? baseUrl;  // Allow override for enterprise customers

  const SdkConfig({
    required this.apiKey,
    this.timeout = const Duration(seconds: 30),
    this.logLevel = LogLevel.error,
    this.baseUrl,
  });
}
```

**4. Platform channels for native features:**
```dart
// Dart side
class _NativeChannel {
  static const _channel = MethodChannel('com.yourcompany.yoursdk/native');

  static Future<String?> getDeviceId() async {
    return await _channel.invokeMethod('getDeviceId');
  }
}

// Android side (Kotlin)
override fun onMethodCall(call: MethodCall, result: Result) {
  when (call.method) {
    "getDeviceId" -> result.success(Settings.Secure.getString(
      context.contentResolver, Settings.Secure.ANDROID_ID))
    else -> result.notImplemented()
  }
}
```

**5. Semantic versioning and changelog discipline:**
```
v1.0.0 — initial release
v1.1.0 — additive: new optional method
v2.0.0 — breaking: renamed method, changed return type
         → MUST bump major version, publish migration guide
```

**Why it matters:** SDK design is a senior-level concern. It tests API design thinking, understanding of encapsulation boundaries, versioning discipline, and native interop knowledge.

**Common mistake:** Exporting all internal classes — creates a brittle public surface you can't change later without breaking consumers. Not providing an example app, making onboarding hard. Not writing a changelog.

---

**Q:** How would you architect a Flutter app with 50+ screens and 10+ developers?

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│             LARGE-SCALE FLUTTER APP ARCHITECTURE                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Monorepo (Melos)                                                │
│  ├── packages/                                                   │
│  │   ├── core/          ← shared: theme, network, utils         │
│  │   ├── auth_feature/  ← team A owns this                      │
│  │   ├── feed_feature/  ← team B owns this                      │
│  │   ├── profile_feature/                                        │
│  │   └── design_system/ ← shared UI components                  │
│  └── apps/                                                       │
│      ├── main_app/      ← composes features                     │
│      └── driver_app/    ← different app, shares core            │
└──────────────────────────────────────────────────────────────────┘
```

**1. Modular monorepo with Melos:**
```yaml
# melos.yaml
name: my_workspace
packages:
  - packages/**
  - apps/**

scripts:
  test:all:
    run: melos exec -- flutter test
  build:all:
    run: melos exec -- flutter build apk
```

**2. Design System package — single source of truth for UI:**
```dart
// packages/design_system/lib/design_system.dart
export 'src/tokens/app_colors.dart';
export 'src/tokens/app_typography.dart';
export 'src/tokens/app_spacing.dart';
export 'src/components/ds_button.dart';
export 'src/components/ds_card.dart';
export 'src/components/ds_text_field.dart';

// All 10 teams import this — consistent UI guaranteed
// One team owns it — no duplicated Button widgets across features
```

**3. Feature-to-feature navigation without hard coupling:**
```dart
// Features communicate via abstract interfaces, not direct imports
// auth_feature does NOT import feed_feature

// In core package:
abstract class AppRouter {
  void goToFeed();
  void goToProfile(String userId);
  void goToAuth();
}

// In main_app: concrete implementation using GoRouter
class GoAppRouter implements AppRouter {
  final GoRouter _router;
  @override
  void goToFeed() => _router.go('/feed');
}

// auth_feature uses AppRouter (from core) — never imports feed_feature
class LoginBloc {
  final AppRouter _router;
  void _onLoginSuccess() => _router.goToFeed();
}
```

**4. GoRouter for 50+ screens — declarative, deep-link ready:**
```dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => HomeScreen()),
    GoRoute(
      path: '/feed',
      builder: (_, __) => FeedScreen(),
      routes: [
        GoRoute(
          path: 'article/:id',
          builder: (_, state) => ArticleScreen(
            id: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(path: '/profile/:userId', builder: (_, state) =>
      ProfileScreen(userId: state.pathParameters['userId']!)),
  ],
);
```

**5. Team conventions at scale:**
```
Each feature package must have:
  ✅ README.md with usage instructions
  ✅ Unit tests ≥ 80% coverage on domain/BLoC
  ✅ Widget tests for key screens
  ✅ No direct imports of another feature package
  ✅ All public API through interfaces in core/

CI Pipeline:
  PR → lint → test → build → code owner review → merge
  Melos runs tests only for affected packages (fast CI)
```

**Why it matters:** At 50+ screens / 10+ devs, the #1 problem isn't technical — it's *coordination*. Architecture here is about enforcing boundaries so teams can work in parallel without breaking each other.

**Common mistake:** One giant lib/ folder for everything — merge conflicts everywhere, tight coupling between features, no ownership. Also: skipping a design system and letting each developer create their own Button widget.

---

**Q:** What is API versioning? How do you handle breaking API changes in a mobile app?

**A:** API versioning is the practice of maintaining multiple API versions simultaneously so existing mobile app clients don't break when the API evolves. This is critical for mobile because you cannot force all users to update immediately.

```
┌──────────────────────────────────────────────────────────────────┐
│                    API VERSIONING STRATEGIES                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. URL versioning (most common)                                 │
│     GET /api/v1/users                                            │
│     GET /api/v2/users   ← new structure                         │
│                                                                  │
│  2. Header versioning                                            │
│     GET /api/users                                               │
│     Accept-Version: 2.0                                         │
│                                                                  │
│  3. Query param versioning                                       │
│     GET /api/users?version=2  ← least preferred (pollutes URLs) │
└──────────────────────────────────────────────────────────────────┘
```

**Flutter-side handling of breaking API changes:**

**1. Version the base URL in one place:**
```dart
class ApiConfig {
  static const String v1 = 'https://api.example.com/v1';
  static const String v2 = 'https://api.example.com/v2';

  // Bump here when migrating — one change, entire app updates
  static const String current = v2;
}
```

**2. Additive (non-breaking) changes — always safe:**
```
Non-breaking:
  ✅ Adding a new optional field to a response
  ✅ Adding a new endpoint
  ✅ Adding a new optional query parameter

Breaking (requires version bump):
  ❌ Removing a field from response
  ❌ Renaming a field
  ❌ Changing a field's data type
  ❌ Changing HTTP method (GET → POST)
```

**3. Defensive JSON parsing — don't crash on unknown fields:**
```dart
class UserProfile {
  final String id;
  final String name;
  final String? avatarUrl;  // nullable — may not exist in v1 responses
  final String? bio;        // new in v2 — old app versions handle gracefully

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',  // default if missing
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,  // null if not present — no crash
    );
  }
}
// json_serializable handles this cleanly with @JsonKey(defaultValue: ...)
```

**4. Force update strategy:**
```dart
// Server returns minimum_app_version in API response headers or a config endpoint
// App checks on launch:

Future<void> checkForceUpdate() async {
  final config = await _remoteConfig.fetchConfig();
  final minVersion = Version.parse(config.minimumAppVersion);
  final currentVersion = Version.parse(PackageInfo.version);

  if (currentVersion < minVersion) {
    // Show un-dismissable update dialog → open App Store/Play Store
    _showForceUpdateDialog();
  }
}
```

**5. Deprecation timeline:**
```
Month 0:  Launch v2 API. v1 still works.
Month 1:  Push app update defaulting to v2.
Month 3:  Log warning for v1 calls. Notify teams.
Month 6:  Sunset v1. Return 410 Gone.
          Any users on ancient app → force update screen.
```

**Why it matters:** Mobile apps live in the wild for months or years. Breaking an API without a strategy breaks the app for users who haven't updated. This tests production maturity.

**Common mistake:** Treating mobile clients like web clients — you can't just deploy a breaking API change and refresh. Also: not using defensive parsing, so adding a new required field in the server response crashes old app versions.

---

**Q:** Design push notification architecture end-to-end for a Flutter app.

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│              PUSH NOTIFICATION ARCHITECTURE                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Your Server                                                     │
│     │                                                            │
│     │  Send notification (with device token)                     │
│     ▼                                                            │
│  FCM (Firebase Cloud Messaging)  ← single interface for         │
│     │                               iOS (APNs) + Android        │
│     │                                                            │
│     ├──► APNs ──► iOS Device                                    │
│     └──► FCM Direct ──► Android Device                          │
│                                                                  │
│  Device receives notification                                    │
│     │                                                            │
│     ├── App in foreground → onMessage stream                    │
│     ├── App in background → onBackgroundMessage handler         │
│     └── App terminated → getInitialMessage on launch            │
└──────────────────────────────────────────────────────────────────┘
```

**Example — complete Flutter setup:**

```dart
// main.dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Must be top-level function (not a class method)
  // Runs in a separate isolate when app is killed
  await Firebase.initializeApp();
  await _handleNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

// NotificationService — handles all states
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 1. Request permission (iOS requires explicit, Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Get device token and send to your backend
    final token = await _fcm.getToken();
    if (token != null) await _registerTokenWithServer(token);

    // 3. Handle token refresh (tokens can change)
    _fcm.onTokenRefresh.listen(_registerTokenWithServer);

    // 4. App opened FROM notification (was terminated)
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) _handleNotificationTap(initialMessage);

    // 5. App was in background, user tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 6. App in foreground — show in-app banner
    FirebaseMessaging.onMessage.listen((message) {
      _showInAppNotification(message);
    });
  }

  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    // Deep link based on notification type
    switch (data['type']) {
      case 'chat':
        AppRouter.instance.goToChat(data['room_id']);
      case 'order':
        AppRouter.instance.goToOrder(data['order_id']);
    }
  }

  Future<void> _registerTokenWithServer(String token) async {
    // POST /devices with { token, platform, app_version }
    await _apiClient.registerDevice(DeviceToken(
      token: token,
      platform: Platform.isIOS ? 'ios' : 'android',
    ));
  }
}
```

**Server-side token management:**
```
Database: devices table
  user_id | device_token | platform | created_at | last_seen_at

When sending:
  1. Fetch all tokens for user
  2. Send via FCM batch API (up to 500 tokens per call)
  3. Handle FCM errors:
     → InvalidRegistration: delete token from DB
     → NotRegistered: delete token from DB (app uninstalled)
```

**Notification channels (Android):**
```dart
// android/app/src/main/AndroidManifest.xml and via flutter_local_notifications
// Group by type: 'chat', 'promotions', 'system'
// Users can disable individual channels in Settings
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'chat_messages',
  'Chat Messages',
  description: 'Notifications for new chat messages',
  importance: Importance.max,
);
```

**Why it matters:** Push notifications touch server, FCM, platform-specific config, deep linking, and foreground/background/terminated app states. Interviewers want to see you understand all three app states and token lifecycle management.

**Common mistake:** Handling only the foreground case. Forgetting that background handlers run in a separate Dart isolate (can't access context or non-initialized services). Not cleaning up stale/invalid tokens on the backend.

---

**Q:** Design a shopping cart feature — state, persistence, and backend sync.

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│                    SHOPPING CART DESIGN                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  User adds item                                                  │
│       │                                                          │
│       ▼                                                          │
│  CartBloc (in-memory state) ← instant UI response               │
│       │                                                          │
│       ├──► Local Persistence (Hive) ← survive app kill          │
│       │                                                          │
│       └──► Backend Sync (debounced) ← eventual consistency      │
│                   │                                              │
│                   ▼                                              │
│           POST /cart/sync                                        │
│           { items: [{product_id, qty, price_snapshot}] }        │
│                   │                                              │
│                   ▼                                              │
│           Server returns authoritative cart                      │
│           (validates prices, stock, discounts)                   │
└──────────────────────────────────────────────────────────────────┘
```

**Example:**

```dart
// --- Cart State ---
@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
    @Default(false) bool isSyncing,
    String? syncError,
  }) = _CartState;

  double get subtotal => items.fold(0, (sum, item) =>
    sum + item.price * item.quantity);
}

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String productId,
    required String name,
    required double price,    // price snapshot at add-time
    required int quantity,
    String? imageUrl,
  }) = _CartItem;
}

// --- CartBloc ---
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;
  Timer? _syncDebounce;

  CartBloc(this._repository) : super(const CartState()) {
    on<CartLoaded>(_onLoad);
    on<ItemAdded>(_onAdd);
    on<ItemRemoved>(_onRemove);
    on<QuantityChanged>(_onQuantityChange);
    on<CartSynced>(_onSynced);
  }

  Future<void> _onLoad(CartLoaded event, Emitter<CartState> emit) async {
    // Restore from local storage on app launch
    final savedItems = await _repository.loadLocal();
    emit(state.copyWith(items: savedItems));
    // Trigger sync to reconcile with server
    add(const CartSynced());
  }

  Future<void> _onAdd(ItemAdded event, Emitter<CartState> emit) async {
    final existingIndex = state.items
      .indexWhere((i) => i.productId == event.item.productId);

    List<CartItem> updated;
    if (existingIndex >= 0) {
      updated = [...state.items];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
    } else {
      updated = [...state.items, event.item];
    }

    emit(state.copyWith(items: updated));

    // Persist locally immediately
    await _repository.saveLocal(updated);

    // Debounce backend sync — don't call API on every tap
    _scheduleSyncDebounced();
  }

  void _scheduleSyncDebounced() {
    _syncDebounce?.cancel();
    _syncDebounce = Timer(const Duration(seconds: 2), () {
      add(const CartSynced());
    });
  }

  Future<void> _onSynced(CartSynced event, Emitter<CartState> emit) async {
    emit(state.copyWith(isSyncing: true));
    try {
      // Server validates: prices, stock availability, applied discounts
      final serverCart = await _repository.syncWithServer(state.items);
      await _repository.saveLocal(serverCart);
      emit(state.copyWith(items: serverCart, isSyncing: false));
    } catch (e) {
      emit(state.copyWith(isSyncing: false, syncError: e.toString()));
    }
  }
}
```

**Price validation — critical:**
```dart
// NEVER trust client-side prices at checkout
// Server ALWAYS recomputes price from its own DB

// On sync response, if server price differs from client price:
// → Update item price in local state
// → Show user: "Price changed: $9.99 → $12.99"
// This prevents price manipulation via API tampering
```

**Guest cart → logged-in cart merge:**
```
Guest adds items → stored in local Hive with guest_session_id
User logs in → POST /cart/merge { guest_session_id, user_id }
Server merges: combine quantities, dedup, apply user pricing/discounts
```

**Why it matters:** Cart is one of the most revenue-critical features. Interviewers want to see: optimistic local state (instant UI), reliable persistence (survives app kill), server-authoritative pricing (security), and the sync strategy.

**Common mistake:** Storing cart only in-memory (lost on app kill) or only on server (requires network for every change). Trusting client-side prices at checkout — this is a security vulnerability.

---

**Q:** What are the trade-offs between REST and WebSocket for live data in Flutter?

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│                  REST vs WebSocket — TRADE-OFFS                  │
├────────────────────┬─────────────────────┬───────────────────────┤
│  Dimension         │  REST               │  WebSocket            │
├────────────────────┼─────────────────────┼───────────────────────┤
│  Connection model  │  Stateless (new     │  Stateful (persistent │
│                    │  connection/request)│  TCP connection)      │
├────────────────────┼─────────────────────┼───────────────────────┤
│  Data direction    │  Client pulls       │  Bidirectional        │
├────────────────────┼─────────────────────┼───────────────────────┤
│  Latency           │  Higher (handshake  │  Lower (no per-msg    │
│                    │  per request)       │  handshake after init)│
├────────────────────┼─────────────────────┼───────────────────────┤
│  Overhead          │  HTTP headers on    │  Minimal framing      │
│                    │  every request      │  after handshake      │
├────────────────────┼─────────────────────┼───────────────────────┤
│  Caching           │  ✅ Easy (CDN,      │  ❌ Not cacheable     │
│                    │  HTTP cache headers)│                       │
├────────────────────┼─────────────────────┼───────────────────────┤
│  Scalability       │  ✅ Stateless,      │  ⚠️ Stateful—harder  │
│                    │  easy to horizontal │  to scale, needs      │
│                    │  scale             │  sticky sessions/Redis │
├────────────────────┼─────────────────────┼───────────────────────┤
│  Mobile battery    │  ✅ Good (on-demand)│  ⚠️ Persistent conn  │
│                    │                     │  keeps radio awake    │
├────────────────────┼─────────────────────┼───────────────────────┤
│  Reconnection      │  Automatic          │  Must implement       │
│                    │  (each request is   │  manually             │
│                    │  independent)       │                       │
├────────────────────┼─────────────────────┼───────────────────────┤
│  Debugging         │  ✅ Easy (cURL,     │  Harder (need WS      │
│                    │  Postman, browser)  │  client tools)        │
└────────────────────┴─────────────────────┴───────────────────────┘
```

**Decision framework:**
```
Use REST when:
  ✅ Standard CRUD operations
  ✅ Data updates are infrequent (< once per 30s)
  ✅ Caching is important
  ✅ You need standard HTTP tooling (proxies, CDN, auth middleware)

Use WebSocket when:
  ✅ Real-time bidirectional communication (chat, collaborative editing)
  ✅ High-frequency updates (live scores, trading, multiplayer game)
  ✅ Server needs to PUSH without client polling
  ✅ Sub-second latency is required

Use SSE when:
  ✅ Server push only (no client messages)
  ✅ Live dashboards, notifications, feeds
  ✅ You want auto-reconnect built in
  ✅ Works over standard HTTP (proxy friendly)
```

**Example — hybrid approach (most production apps):**
```dart
class LiveDashboardRepository {
  final Dio _dio;                           // REST for initial load
  final WebSocketChannel _ws;              // WebSocket for live updates

  // Load historical data first (REST — cacheable, reliable)
  Future<List<DataPoint>> getHistoricalData() =>
    _dio.get('/metrics/history').then((r) =>
      (r.data as List).map(DataPoint.fromJson).toList());

  // Stream live updates (WebSocket — low latency)
  Stream<DataPoint> get liveUpdates => _ws.stream
    .map((data) => DataPoint.fromJson(jsonDecode(data)));
}

// Flutter usage — combine in BLoC:
Future<void> _onConnected(Connected event, Emitter<DashboardState> emit) async {
  // Phase 1: Show historical data immediately
  final history = await _repository.getHistoricalData();
  emit(DashboardLoaded(dataPoints: history));

  // Phase 2: Append live updates
  await emit.forEach<DataPoint>(
    _repository.liveUpdates,
    onData: (point) => state.copyWith(
      dataPoints: [...state.dataPoints, point],
    ),
  );
}
```

**Why it matters:** This is a judgment question. Interviewers want to see you can choose the right tool for the job and articulate trade-offs, not just implement whatever was used on the last project.

**Common mistake:** Defaulting to WebSocket for everything "because it's real-time" — unnecessary connection overhead for data that changes every few minutes. Or, polling with a 1-second timer instead of using WebSocket for genuinely live features.

---

**Q:** How do you design error handling across an entire Flutter app — from API failure to user-visible message?

**A:**

```
┌──────────────────────────────────────────────────────────────────┐
│                  END-TO-END ERROR HANDLING FLOW                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  API Error (Dio throws DioException)                             │
│       │                                                          │
│       ▼                                                          │
│  Remote Data Source                                              │
│  → Catches DioException                                          │
│  → Maps to domain Failure (NetworkFailure, ServerFailure, etc.) │
│       │                                                          │
│       ▼                                                          │
│  Repository                                                      │
│  → Returns Either<Failure, T> (functional) or throws typed error│
│       │                                                          │
│       ▼                                                          │
│  Use Case / BLoC                                                 │
│  → Handles Failure, emits error State                           │
│       │                                                          │
│       ▼                                                          │
│  UI Layer                                                        │
│  → Reads error State                                             │
│  → Shows appropriate user-facing message (not stack trace!)     │
│       │                                                          │
│       ▼                                                          │
│  Error Reporter (Sentry/Crashlytics)                            │
│  → Logs full error + context in background                      │
└──────────────────────────────────────────────────────────────────┘
```

**Example — complete layered error handling:**

```dart
// --- 1. Domain Failures (sealed class) ---
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection.');
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({this.statusCode})
    : super('Something went wrong. Please try again.');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('Session expired. Please log in.');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String resource)
    : super('$resource not found.');
}

class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;
  const ValidationFailure(this.fieldErrors) : super('Please check your input.');
}

// --- 2. Remote Data Source — maps Dio errors ---
Future<List<Article>> fetchArticles() async {
  try {
    final response = await _dio.get('/articles');
    return (response.data as List).map(Article.fromJson).toList();
  } on DioException catch (e, stackTrace) {
    await ErrorReporter.log(e, stackTrace);  // always log
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.receiveTimeout:
        throw const NetworkFailure();
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 401: throw const UnauthorizedFailure();
          case 404: throw NotFoundFailure('Articles');
          case 422:
            final errors = e.response?.data['errors'] as Map<String, dynamic>;
            throw ValidationFailure(errors.cast<String, String>());
          default: throw ServerFailure(statusCode: e.response?.statusCode);
        }
      default:
        throw ServerFailure(statusCode: null);
    }
  }
}

// --- 3. BLoC — handles failures, emits typed error state ---
Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
  emit(const FeedLoading());
  try {
    final articles = await _repository.fetchArticles();
    emit(FeedLoaded(articles: articles));
  } on NetworkFailure catch (f) {
    emit(FeedError(message: f.message, isOffline: true));
  } on UnauthorizedFailure catch (_) {
    // Trigger global logout — propagate via event bus
    AuthEventBus.instance.add(LoggedOutEvent());
  } on Failure catch (f) {
    emit(FeedError(message: f.message));
  }
}

// --- 4. UI — user-friendly presentation ---
class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) => switch (state) {
        FeedLoading() => const LoadingIndicator(),
        FeedLoaded(:final articles) => ArticleList(articles: articles),
        FeedError(:final message, :final isOffline) => ErrorView(
          message: message,
          icon: isOffline ? Icons.wifi_off : Icons.error_outline,
          onRetry: () => context.read<FeedBloc>().add(const LoadFeed()),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

// --- 5. Global uncaught error handler ---
void main() {
  FlutterError.onError = (details) {
    ErrorReporter.logFlutterError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorReporter.log(error, stack);
    return true; // handled
  };

  runApp(MyApp());
}

// --- 6. Error Reporter ---
class ErrorReporter {
  static Future<void> log(Object error, StackTrace stack) async {
    // Sentry / Firebase Crashlytics
    await Sentry.captureException(error, stackTrace: stack);
    // Optionally: local log in debug mode
    if (kDebugMode) debugPrint('ERROR: $error\n$stack');
  }
}
```

**Error message UX principles:**
```
✅ DO:   "No internet connection. Tap to retry."
✅ DO:   "Couldn't load articles. Try again."
✅ DO:   Include a retry button where appropriate
✅ DO:   Show offline banner, not a blocking error for reads

❌ DON'T: Show raw exception messages to users
❌ DON'T: Show HTTP status codes ("Error 500")
❌ DON'T: Show stack traces
❌ DON'T: Silently fail (user doesn't know what happened)
❌ DON'T: Use generic "An error occurred" for everything
```

**Why it matters:** Error handling is where production apps differentiate from toy apps. Interviewers are checking for: separation of concerns (domain failures not tied to HTTP), typed error handling, user experience empathy, crash reporting, and global unhandled error coverage.

**Common mistake:** Catching generic `Exception` everywhere and showing a toast with `e.toString()` — which leaks internal error details. Not providing retry mechanisms. Not logging to a crash reporter. Letting `UnauthorizedException` bubble up to the UI instead of triggering global logout.

---
