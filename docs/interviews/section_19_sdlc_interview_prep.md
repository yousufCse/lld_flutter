# Section 19: SDLC & Software Engineering Process

---

**Q:** What is SDLC? What are its phases?

**A:** SDLC (Software Development Lifecycle) is a structured process that defines how software is planned, built, tested, deployed, and maintained. It gives teams a repeatable framework to deliver quality software predictably.

The standard phases are:

```
+---------------------------+
|  1. Planning              |  ← Define scope, resources, timeline, feasibility
+---------------------------+
|  2. Requirement Analysis  |  ← Gather functional & non-functional requirements
+---------------------------+
|  3. System Design         |  ← High-level architecture + low-level design
+---------------------------+
|  4. Development           |  ← Coding, code review, version control
+---------------------------+
|  5. Testing               |  ← Unit → Integration → System → UAT
+---------------------------+
|  6. Deployment            |  ← Staging → Production rollout
+---------------------------+
|  7. Maintenance           |  ← Bug fixes, hotfixes, versioning, monitoring
+---------------------------+
```

These phases can be executed in different models:
- **Waterfall** — sequential, each phase must finish before the next starts
- **Agile** — iterative sprints, phases overlap and repeat continuously
- **Spiral** — risk-driven, combines iterative with Waterfall
- **V-Model** — testing phase mirrors each development phase

In modern Flutter development teams, Agile (Scrum or Kanban) is the dominant approach, but understanding Waterfall is still important for client contracts, regulated industries, or large enterprise projects.

**Example:**

```
Waterfall (sequential):
Plan → Design → Code → Test → Deploy → Maintain

Agile (iterative sprint):
Sprint 1: [Plan → Code → Test → Review] → Increment
Sprint 2: [Plan → Code → Test → Review] → Increment
Sprint 3: [Plan → Code → Test → Review] → Release
```

**Why it matters:** The interviewer is checking whether you understand that software delivery is a structured discipline, not just writing code. Senior engineers are expected to navigate all phases, not just implementation.

**Common mistake:** Candidates describe SDLC as only about coding and testing. The planning, requirement gathering, and maintenance phases are equally critical and often where projects fail.

---

**Q:** What is requirement gathering? What is the difference between functional and non-functional requirements, and how do you elicit them?

**A:** Requirement gathering is the process of understanding what a system must do (functional) and how well it must do it (non-functional) before any design or code begins. Getting this wrong is the most expensive mistake in software development — the later a misunderstood requirement is caught, the more it costs to fix.

**Functional Requirements** define *what* the system does:
- User can log in with email and password
- App sends push notifications when an order is dispatched
- Admin can export reports as PDF

**Non-Functional Requirements (NFRs)** define *how well* the system performs:
- App must launch in under 2 seconds on mid-range Android devices
- System must handle 10,000 concurrent users
- All sensitive data must be encrypted at rest (AES-256)
- App must be WCAG 2.1 AA accessible

```
Functional        →  WHAT the system does
Non-Functional    →  HOW WELL it does it (performance, security,
                     scalability, reliability, usability)
```

**Elicitation techniques:**
- **Interviews** — one-on-one with stakeholders to uncover needs
- **Workshops** — group sessions to resolve conflicts and align
- **User story mapping** — visualise user journeys end-to-end
- **Prototyping** — show, don't tell; wireframes spark hidden requirements
- **Document analysis** — review existing systems, contracts, or workflows
- **Observation** — watch actual users to find unstated pain points

**Example:**

```dart
// Functional: User can search products by name
// Story: "As a shopper, I want to search products so I can find
//         what I need quickly."

// Non-Functional: Search results must load in < 500ms
// Constraint: App must work offline (cached last 50 results)

// Bad requirement (vague): "App should be fast"
// Good requirement (testable): "Product list must render within
//   300ms on a Pixel 4 running Android 12"
```

**Why it matters:** Interviewers want to see that you understand requirements as a two-dimensional concern — capability AND quality. Engineers who only think functionally ship technically correct but practically unusable software.

**Common mistake:** Candidates ignore NFRs entirely or treat them as "nice to haves." In reality, NFRs like performance and security are often harder to retrofit than features.

---

**Q:** What is system design? What is the difference between high-level design (HLD) and low-level design (LLD)?

**A:** System design is the phase where requirements get translated into architecture and technical specifications before coding starts. Skipping it leads to structural debt that is expensive to unwind later.

**High-Level Design (HLD)** — the *what* of architecture:
- Overall system architecture (e.g., client-server, microservices, monolith)
- Major components and how they communicate
- Technology stack choices
- Data flow diagrams
- Third-party integrations
- Deployment topology (cloud provider, CDN, load balancer)

**Low-Level Design (LLD)** — the *how* of implementation:
- Class diagrams and relationships
- Database schema with field types and indexes
- API contracts (endpoints, request/response shapes)
- State management design (e.g., how BLoC events map to states)
- Algorithm choices for critical paths
- Error handling strategy

```
HLD (Big Picture):
+----------+        REST API        +-------------+
| Flutter  | --------------------> |  Backend    |
|  Client  | <-------------------- |  Server     |
+----------+                       +------+------+
                                          |
                               +----------+----------+
                               | PostgreSQL   Redis  |
                               +---------------------+

LLD (Detail for one feature — Auth):
LoginPage
  └── LoginBloc
        ├── Event: LoginSubmitted(email, password)
        ├── State: LoginLoading / LoginSuccess / LoginFailure
        └── calls AuthRepository.login()
              └── calls AuthApiService.post('/auth/login')
                    └── returns AuthToken model
```

**Example:**

```dart
// LLD: API contract defined before coding starts

// POST /auth/login
// Request:
// {
//   "email": "user@example.com",
//   "password": "secret123"
// }

// Response 200:
// {
//   "access_token": "eyJ...",
//   "refresh_token": "abc...",
//   "expires_in": 3600
// }

// Response 401:
// { "error": "invalid_credentials" }

// This contract lets mobile and backend teams work in parallel
// without blocking each other.
```

**Why it matters:** Senior engineers are expected to contribute to design, not just implement tickets. HLD/LLD skills show you can think at a system level, communicate across teams, and catch structural problems before they become code problems.

**Common mistake:** Candidates conflate HLD and LLD or describe design as just "choosing a framework." Interviewers want to hear about trade-offs: why microservices vs. monolith, why this database, what happens when service X is down.

---

**Q:** What does good development practice look like during the development phase?

**A:** The development phase is where requirements and design become working software. Good practice here is what separates maintainable production codebases from legacy nightmares.

**Key practices:**

1. **Version control discipline** — meaningful commit messages, short-lived branches, regular merges to main to avoid divergence
2. **SOLID principles** — each class has one reason to change, dependencies are injected not hardcoded
3. **Clean architecture** — UI layer never talks directly to data layer; business logic lives in a dedicated domain layer
4. **Feature flags** — new features deployable but disabled in production, allowing safe testing with real traffic
5. **No magic numbers** — constants are named and documented
6. **Consistent error handling** — never silently swallow exceptions
7. **Write code for your future self** — code is read 10x more than it's written

```
Clean Layer Separation (Flutter):

Presentation Layer  (Widgets, BLoC, ViewModels)
        ↓
Domain Layer        (UseCases, Entities, Repository interfaces)
        ↓
Data Layer          (Repository implementations, API clients,
                     local DB adapters)
```

**Example:**

```dart
// BAD: UI layer talks directly to HTTP client
class ProductListPage extends StatelessWidget {
  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('https://api.example.com/products'));
    // parse and render...
  }
}

// GOOD: UI delegates to BLoC, which delegates to UseCase
class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductListBloc(
        getProductsUseCase: context.read<GetProductsUseCase>(),
      )..add(LoadProductsEvent()),
      child: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          if (state is ProductListLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (_, i) => ProductTile(product: state.products[i]),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
```

**Why it matters:** The interviewer is checking whether you understand that development is a collaborative, long-term activity — not a solo sprint to feature completion. Good practices protect the team from themselves over time.

**Common mistake:** Candidates list practices as buzzwords (SOLID, DRY, KISS) without being able to demonstrate them in code or explain when to break the rules pragmatically.

---

**Q:** What is the purpose of code review? What do you look for, and what are the best practices?

**A:** Code review is a collaborative quality gate where peers examine changes before they are merged. Its purpose is not just catching bugs — it's knowledge sharing, enforcing consistency, and preventing architectural drift.

**What to look for:**

- **Correctness** — Does it solve the stated problem? Edge cases handled?
- **Readability** — Can a new team member understand this in 6 months?
- **Architecture** — Is it in the right layer? Does it introduce coupling?
- **Performance** — Any obvious inefficiencies? Unnecessary rebuilds in Flutter?
- **Security** — Is sensitive data exposed? Are inputs validated?
- **Test coverage** — Is the new logic tested?
- **Consistency** — Does it match team conventions (naming, structure)?

**Best practices:**

- Reviews should be small and focused — large PRs are unreviewed PRs
- Comment with context, not just criticism: *"This will rebuild on every state change because it's inside BlocBuilder — consider `buildWhen`"*
- Distinguish blocking issues from suggestions (use labels: `blocker`, `nit`, `suggestion`)
- Author should respond to every comment — silence is not agreement
- Reviewer is also responsible for what gets merged
- Automate what can be automated (linting, formatting, static analysis) so humans focus on logic and architecture

**Example:**

```dart
// PR diff — reviewer spots a performance issue

// Submitted code:
BlocBuilder<CartBloc, CartState>(
  builder: (context, state) {
    return Text('Items: ${state.items.length}');
    // ⚠️ Rebuilds on EVERY CartState change, even unrelated ones
  },
)

// Reviewer comment:
// "Suggestion: Add buildWhen to limit rebuilds to only when
//  item count changes. This component doesn't care about
//  CartLoading or CartError states."

// Fixed code:
BlocBuilder<CartBloc, CartState>(
  buildWhen: (prev, curr) => prev.items.length != curr.items.length,
  builder: (context, state) {
    return Text('Items: ${state.items.length}');
  },
)
```

**Why it matters:** The interviewer is evaluating whether you can give and receive feedback professionally, spot issues beyond surface-level syntax, and understand that code quality is a team responsibility.

**Common mistake:** Candidates say code review is about "checking for bugs." The best code reviews prevent architectural problems, spread knowledge, and mentor junior developers — bug catching is a side effect.

---

**Q:** What are the testing phases? Explain unit, integration, system, and UAT testing.

**A:** Testing is not a single activity — it's a layered discipline where each phase validates a different scope of the system.

```
Testing Pyramid:

         /\
        /  \   UAT          ← Fewest, most expensive, real users
       /----\
      / System\             ← Full end-to-end system behaviour
     /----------\
    / Integration\          ← Multiple components working together
   /--------------\
  /   Unit Tests   \        ← Many, fast, isolated logic
 /------------------\
```

**Unit Testing**
- Tests a single function, method, or class in isolation
- All dependencies are mocked or stubbed
- Fast (milliseconds), run on every commit
- Validates: business logic, edge cases, error handling

**Integration Testing**
- Tests multiple components working together
- Example: BLoC + Repository + mocked API
- Validates: data flows correctly between layers

**System Testing**
- Tests the complete assembled system end-to-end
- Includes external dependencies (real DB, real API in staging)
- Validates: the full user journey works top to bottom

**UAT (User Acceptance Testing)**
- Conducted by real users or business stakeholders (not developers)
- Tests against real-world business scenarios
- Validates: the software solves the original business problem
- Failure here means requirements were misunderstood, not just bugs

**Example:**

```dart
// Unit Test — tests CartBloc in isolation
void main() {
  group('CartBloc', () {
    late CartBloc bloc;
    late MockCartRepository mockRepo;

    setUp(() {
      mockRepo = MockCartRepository();
      bloc = CartBloc(cartRepository: mockRepo);
    });

    test('emits CartLoaded when AddItemEvent is added', () async {
      final item = CartItem(id: '1', name: 'Shoes', price: 99.99);
      when(() => mockRepo.addItem(item)).thenAnswer((_) async => [item]);

      bloc.add(AddItemEvent(item: item));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CartLoading>(),
          isA<CartLoaded>().having(
            (s) => s.items.length,
            'items length',
            1,
          ),
        ]),
      );
    });
  });
}

// Integration Test — tests widget + BLoC together
// (uses flutter_test with real BLoC but mocked repo)
testWidgets('CartPage shows item after adding', (tester) async {
  await tester.pumpWidget(
    BlocProvider(
      create: (_) => CartBloc(cartRepository: MockCartRepository()),
      child: const MaterialApp(home: CartPage()),
    ),
  );
  await tester.tap(find.byKey(const Key('add_shoes_button')));
  await tester.pumpAndSettle();
  expect(find.text('Shoes'), findsOneWidget);
});
```

**Why it matters:** Interviewers want to confirm you understand testing as a strategy, not a checkbox. Senior engineers design systems that are testable, choose the right test type for each problem, and can articulate trade-offs between test speed and confidence.

**Common mistake:** Candidates say "we just do unit tests." Skipping integration and system tests leaves entire categories of bugs undetected — the most dangerous bugs are at boundaries between components.

---

**Q:** What is the deployment process? What is the difference between staging and production, and what belongs on a deployment checklist?

**A:** Deployment is the controlled process of moving code from development into the hands of users. The goal is to do it reliably, repeatably, and with the ability to roll back if something goes wrong.

**Staging vs Production:**

```
Environments:

+---------------+     Promote     +---------------+
|   Staging     | --------------> |  Production   |
+---------------+                 +---------------+
| - Mirror of   |                 | - Real users  |
|   production  |                 | - Real data   |
| - Test data   |                 | - Revenue     |
| - Internal    |                 | - SLAs apply  |
|   users only  |                 |               |
| - Safe to     |                 | - Every change|
|   break       |                 |   has impact  |
+---------------+                 +---------------+
```

Staging is where you validate that what worked in development also works in a production-like environment. It catches environment-specific bugs (config differences, infrastructure issues, third-party API behaviours).

**Deployment Checklist:**

Pre-deploy:
- [ ] All tests passing (unit, integration, E2E)
- [ ] Feature flags configured correctly
- [ ] Database migrations reviewed and tested in staging
- [ ] API versioning confirmed — no breaking changes without deprecation
- [ ] Environment variables/secrets updated in production config
- [ ] Rollback plan documented
- [ ] Change window communicated to stakeholders

Deploy:
- [ ] Blue-green or canary rollout if supported
- [ ] Monitor error rates during rollout
- [ ] Confirm health check endpoints return 200

Post-deploy:
- [ ] Smoke test critical user paths in production
- [ ] Check error monitoring (Crashlytics, Sentry) for new issues
- [ ] Verify analytics events firing correctly
- [ ] Confirm no spike in crash rate or latency

**Example (Flutter mobile deployment):**

```
Mobile Release Checklist:
[ ] Version number bumped (pubspec.yaml)
[ ] Build number incremented
[ ] Release notes written
[ ] App signed with production keystore (Android)
    / distribution certificate (iOS)
[ ] ProGuard/obfuscation rules verified
[ ] Deep links tested in production environment
[ ] Push notification certificates valid
[ ] Play Store / App Store review checklist satisfied
[ ] Staged rollout configured (10% → 50% → 100%)
[ ] Crash monitoring alert thresholds set
```

**Why it matters:** Deployment is where bugs become customer problems. The interviewer is assessing whether you treat deployment as a disciplined process or a cowboy activity.

**Common mistake:** Candidates describe deployment as "pushing to the store." Senior engineers talk about staged rollouts, rollback procedures, monitoring, and separating the deploy from the release (feature flags).

---

**Q:** What does maintenance look like? How do you handle bug tracking, hotfixes, and versioning?

**A:** Maintenance is the longest phase of the SDLC — most software spends more of its life being maintained than being built. Good maintenance practices are what keep software sustainable.

**Bug Tracking:**
- All bugs live in a tracking system (Jira, Linear, GitHub Issues)
- Each bug has: severity, reproduction steps, expected vs. actual behaviour, affected version, environment
- Severity levels: P0 (critical/down), P1 (high/major feature broken), P2 (medium), P3 (low/cosmetic)

**Hotfixes:**
- A hotfix is an emergency patch applied directly to a release branch, bypassing the normal sprint cycle
- Flow: create `hotfix/` branch from the release tag → fix → test → merge to main AND to the release branch

```
Git flow with hotfix:

main ──────────────────────────────────── (v2.1.0)
           \                          /
          release/2.0 ──────────────── (v2.0.1 hotfix)
                              \      /
                            hotfix/crash-on-login
```

**Versioning:**
Semantic Versioning (SemVer): `MAJOR.MINOR.PATCH`
- MAJOR: Breaking change (remove API, change app structure)
- MINOR: New feature, backward compatible
- PATCH: Bug fix, no new functionality

```
1.0.0 → initial release
1.0.1 → bug fix (crash on null user name)
1.1.0 → new feature (dark mode)
2.0.0 → breaking change (new login flow, old tokens invalid)
```

**Example:**

```yaml
# pubspec.yaml — Flutter versioning
# Format: MAJOR.MINOR.PATCH+BUILD_NUMBER
# Build number must always increment for store submissions

version: 2.1.3+47
#        │ │ │  └─ build number (store submission counter)
#        │ │ └──── patch (bug fixes)
#        │ └────── minor (new features)
#        └──────── major (breaking changes)
```

**Why it matters:** Maintenance discipline reveals how a team operates under pressure. The interviewer is checking whether you have systems for tracking and resolving issues — or whether bugs fall into a black hole.

**Common mistake:** Candidates treat versioning as just a number to increment. Semantic versioning is a communication tool — it tells users, CI systems, and dependency managers what kind of change happened.

---

**Q:** How do you handle a production bug? Walk through the step-by-step process.

**A:** Production bugs require calm, systematic action — not panic commits. The goal is to restore service first, understand the cause second, and prevent recurrence third.

```
Production Bug Response Flow:

1. DETECT
   └── Crash alert (Crashlytics) / User report / Monitoring spike

2. TRIAGE
   └── Assess severity: Is the app down? Feature broken? Visual glitch?
       └── P0: All hands now  |  P1: Same day  |  P2: Next sprint

3. REPRODUCE
   └── Can you reproduce locally? On staging? Only in production?
   └── What version introduced it? (git bisect / release notes)

4. ISOLATE
   └── Is it client-side (Flutter) or server-side (API)?
   └── Is it affecting all users or a subset?
   └── Is it related to a recent deployment?

5. MITIGATE (stop the bleeding)
   └── Feature flag OFF to disable broken feature
   └── Rollback to last stable release if critical
   └── Communicate status to stakeholders

6. FIX
   └── Write a failing test that proves the bug
   └── Fix the bug
   └── Confirm test now passes

7. DEPLOY
   └── Hotfix branch → staging → production
   └── Monitor for regression

8. POST-MORTEM
   └── What happened? Why? What failed to catch it?
   └── What changes to process/tests prevent recurrence?
   └── No blame — system improvement focus
```

**Example:**

```dart
// Step 6: Write the failing test FIRST (proves the bug exists)

// Bug: App crashes when user.address is null on profile page
// Stacktrace: Null check operator used on a null value
//             profile_page.dart:47

// Failing test:
test('ProfileViewModel handles null address without crash', () {
  final user = User(id: '1', name: 'Alice', address: null);
  final vm = ProfileViewModel(user: user);

  // This should not throw
  expect(() => vm.displayAddress, returnsNormally);
  expect(vm.displayAddress, equals('Address not provided'));
});

// Fix:
class ProfileViewModel {
  final User user;
  ProfileViewModel(this.user);

  String get displayAddress =>
      user.address ?? 'Address not provided';
  //              ^^
  //              Was: user.address!  ← this crashed
}
```

**Why it matters:** The interviewer is evaluating your composure and process under pressure. Senior engineers have a repeatable system — they don't randomly poke at code until it stops crashing.

**Common mistake:** Candidates jump straight to "I'd fix the code." The most important steps are triage and mitigation — stop the user impact first. Also, skipping the post-mortem means the same bug pattern will return.

---

**Q:** What is risk management in a software project? How do you identify and mitigate risks?

**A:** Risk management is the proactive identification of things that could go wrong before they do — and having a plan ready. It is not pessimism; it is engineering maturity.

**Risk identification sources:**
- Technical complexity (new libraries, unfamiliar architecture)
- External dependencies (third-party APIs, vendor SDKs)
- Team capacity (resource availability, skill gaps)
- Unclear requirements (ambiguous scope, changing stakeholders)
- Timeline pressure (compressed delivery, regulatory deadlines)
- Infrastructure/environment (cloud provider limits, device fragmentation)

**Risk assessment framework:**

```
Risk Matrix:

           Probability
           Low     High
          +-------+-------+
Impact    |  LOW  |MEDIUM |
High      +-------+-------+
          |MEDIUM | HIGH  |
Impact    +-------+-------+
Low
```

For each risk: `Risk Score = Probability × Impact`

**Mitigation strategies:**
- **Avoid** — change the plan to eliminate the risk
- **Reduce** — take action to lower probability or impact (spike, POC)
- **Transfer** — shift responsibility (insurance, SLA with vendor)
- **Accept** — acknowledge the risk, monitor it, have a contingency

**Example:**

```
Flutter Project Risk Register (example):

+---------------------------+---------+--------+----------+----------------------------+
| Risk                      | Prob.   | Impact | Score    | Mitigation                 |
+---------------------------+---------+--------+----------+----------------------------+
| Payment SDK breaks on     | Medium  | High   | HIGH     | Pin SDK version. Add        |
| iOS 17 update             |         |        |          | integration tests for       |
|                           |         |        |          | payment flow.               |
+---------------------------+---------+--------+----------+----------------------------+
| Backend team delivers     | High    | High   | CRITICAL | Use mock server for mobile  |
| API 2 weeks late          |         |        |          | development. Agree on       |
|                           |         |        |          | contract first.             |
+---------------------------+---------+--------+----------+----------------------------+
| Lead dev unavailable      | Low     | High   | MEDIUM   | Pair programming to spread  |
| for 2 weeks               |         |        |          | knowledge. Document          |
|                           |         |        |          | architecture decisions.     |
+---------------------------+---------+--------+----------+----------------------------+
```

**Why it matters:** Risk management is a mark of engineering seniority. The interviewer wants to see that you can think beyond "write the code" to "what could prevent this from succeeding."

**Common mistake:** Candidates describe risk management as "having a backup plan." That is the accept strategy. Strong engineers identify risks early enough to eliminate or reduce them before they become crises.

---

**Q:** What should you document in a software project, and what should you NOT over-document?

**A:** Good documentation accelerates teams; bad documentation wastes time and becomes a liability when it goes stale. The rule is: document the *why*, automate the *what*.

**What TO document:**

| Document Type | What it captures | Example |
|---|---|---|
| **README** | How to set up, run, and contribute to the project | Prerequisites, env setup, run commands |
| **API Docs** | Endpoints, request/response contracts, auth | OpenAPI/Swagger spec, Postman collections |
| **Architecture Decision Records (ADR)** | *Why* a technical decision was made | "Why we chose BLoC over Provider" |
| **Runbook** | How to operate the system in production | How to roll back, how to scale, alert responses |
| **Onboarding Guide** | How a new developer joins the team | Tools, access, first-week tasks |

**Architecture Decision Records (ADRs)** deserve special mention. They capture:
- **Context** — What was the situation?
- **Decision** — What did we decide?
- **Rationale** — Why this option over alternatives?
- **Consequences** — What are the trade-offs we accepted?

**What NOT to over-document:**
- Implementation details that are obvious from clean code
- Auto-generated code (let the generator regenerate the docs)
- Processes that change frequently (document outcome, not every step)
- Inline comments that just restate what the code says

**Example:**

```dart
// ❌ OVER-DOCUMENTED — comment restates the code
// Increment the counter by 1
counter++;

// ❌ OVER-DOCUMENTED — obvious from clean code
// This function returns the full name of the user
String getFullName() => '${user.firstName} ${user.lastName}';

// ✅ GOOD DOCUMENTATION — captures WHY, not WHAT
// We cache this for 5 minutes instead of 30 because product
// confirmed that price changes must be reflected within 5 min
// to avoid checkout price surprises. See ADR-012.
static const priceCacheDuration = Duration(minutes: 5);
```

```markdown
# ADR-012: Price Cache Duration

## Context
Product team reported user complaints about checkout prices
differing from browse prices. Investigation showed a 30-min
cache was causing the discrepancy.

## Decision
Reduce price cache TTL from 30 minutes to 5 minutes.

## Rationale
- 5 minutes balances API load with user experience accuracy
- Product confirmed prices rarely change more than once per hour
- Rejected 0-minute (no cache) due to API rate limit constraints

## Consequences
- ~6x more price API calls during peak hours
- Server team must confirm API can handle increased load
```

**Why it matters:** The interviewer is checking whether you see documentation as a tool to enable your team — not a bureaucratic overhead. They also want to know if you understand the maintenance cost of over-documenting.

**Common mistake:** Candidates say "document everything" or "I prefer clean code over comments." Both extremes fail. The best engineers document decisions and context, leaving the code itself to express the implementation.

---

**Q:** What is a spike? When do you use it?

**A:** A spike is a time-boxed investigation or experiment to answer a specific technical question or reduce uncertainty before committing to building a feature. The output of a spike is knowledge — not production code (though proof-of-concept code may be produced and discarded).

The term comes from Extreme Programming (XP) — like driving a spike through a piece of wood to test resistance before planning construction.

**When to use a spike:**
- A technology is unfamiliar and you don't know how long integration will take
- A performance claim needs validation before architecture decisions are made
- Multiple architectural approaches exist and you need evidence to choose
- A third-party API or SDK has unknown behaviours
- A requirement is too ambiguous to estimate

**Key characteristics:**
- Strictly time-boxed (1–3 days maximum, agreed upfront)
- Has a clear question it must answer
- Output is a decision, recommendation, or estimate — not a feature
- Code produced is throwaway unless explicitly decided otherwise
- Reported back to the team with findings

**Example:**

```
Scenario:
Sprint planning — team is debating whether to use
flutter_map or Google Maps SDK for an offline mapping
feature. Nobody has used either for offline tiles before.

❌ BAD approach:
Estimate the whole feature and pick a library based on
gut feel. Find out 2 weeks in that offline tiles aren't
supported in flutter_map without a paid plugin.

✅ GOOD approach:
Create a spike: "Can we render offline map tiles in
Flutter without a paid SDK? — 2 day investigation."

Spike question:
"Which mapping library supports offline tile caching
with our existing architecture, and what is the
integration complexity?"

Spike output (after 2 days):
"flutter_map supports offline tiles via mbtiles plugin.
Proof of concept is working. Estimated full integration:
5 story points. Recommend flutter_map over Google Maps
SDK for this feature due to licensing costs."
```

```dart
// Spike POC code — clearly marked, not production quality
// This is throwaway code to validate the approach
void main() async {
  // Quick POC: Can we cache map tiles locally?
  final tileProvider = MbTilesTileProvider(
    mbTilesPath: 'assets/maps/city.mbtiles',
  );
  // Result: Works. File size acceptable. 
  // API is clean. Proceeding with full implementation.
  print('Offline tiles: VIABLE');
}
```

**Why it matters:** Spikes are how senior engineers manage technical uncertainty responsibly. The interviewer wants to see that you don't just guess at unknowns or commit to large features without de-risking them first.

**Common mistake:** Candidates describe a spike as "doing research." A spike has a specific question, a time-box, and a definitive output that informs a decision. Open-ended research is not a spike.

---

**Q:** What is the difference between a bug, a defect, and a feature request?

**A:** These three terms are often used interchangeably but they have precise meanings in software engineering. Using them correctly matters in issue tracking, sprint planning, and stakeholder communication.

```
+------------------+--------------------------------------------------+
| Term             | Definition                                       |
+------------------+--------------------------------------------------+
| Bug              | Unexpected behaviour that deviates from the      |
|                  | intended/specified behaviour. Found during        |
|                  | development, testing, or production use.          |
+------------------+--------------------------------------------------+
| Defect           | A bug that has been *verified and documented*     |
|                  | in the issue tracker. A bug becomes a defect      |
|                  | once it is formally logged and confirmed.         |
|                  | In many teams, bug = defect (interchangeable).    |
+------------------+--------------------------------------------------+
| Feature Request  | A request for new functionality that was never    |
|                  | part of the original requirements. The system     |
|                  | is working as designed — the design just doesn't  |
|                  | include this capability yet.                      |
+------------------+--------------------------------------------------+
```

**The key distinction — "as designed" vs "broken":**
- Bug/Defect: The login button does nothing when tapped (broken — it should work)
- Feature Request: Add "Login with Google" button (new capability — never designed)
- Grey area: The app works but is very hard to use — is that a UX defect or a feature request? (Answer: discuss with product; usability issues can be either)

**Example:**

```
Reported issue: "App doesn't show a loading indicator while
fetching search results."

Is this a bug or a feature request?

Analysis:
- If the spec/designs included a loading indicator → BUG
  (the feature is broken/incomplete)
- If designs never mentioned loading state → FEATURE REQUEST
  (new UX enhancement requested)
- If acceptance criteria in the story mentioned loading state → BUG
  (it was a defined requirement that wasn't implemented)

Why it matters in practice:
- Bugs → go into current sprint backlog with priority
- Feature requests → go through product review, prioritisation,
  and scoping before being added to a sprint
```

**Why it matters:** The interviewer is testing whether you understand scope control. Mislabelling feature requests as bugs bypasses product prioritisation, inflates sprint work, and creates scope creep. It is a common source of team conflict.

**Common mistake:** Candidates say "a defect is just a more formal word for a bug." That is partially right, but the more important distinction is bug/defect vs. feature request — and being able to make that call confidently with stakeholders.

---

**Q:** How do you ensure quality throughout the SDLC — not just at the testing phase?

**A:** Quality is not a phase — it is a discipline embedded at every stage of the lifecycle. Teams that treat testing as the only quality gate ship software full of surprises.

**Quality activities at each phase:**

```
+---------------------+------------------------------------------+
| Phase               | Quality Activity                         |
+---------------------+------------------------------------------+
| Requirements        | Review for ambiguity, testability,       |
|                     | conflicting constraints. Define          |
|                     | acceptance criteria per story.           |
+---------------------+------------------------------------------+
| Design              | Design review — check for security,      |
|                     | scalability, separation of concerns.     |
|                     | Document architecture decisions.         |
+---------------------+------------------------------------------+
| Development         | TDD / writing tests alongside code.      |
|                     | Static analysis (dart analyze, linting). |
|                     | Code review — every PR reviewed.         |
|                     | No merge to main without passing CI.     |
+---------------------+------------------------------------------+
| Testing             | Unit, integration, system, UAT.          |
|                     | Regression suite for known bugs.         |
|                     | Performance and security testing.        |
+---------------------+------------------------------------------+
| Deployment          | Staged rollout. Smoke tests post-deploy. |
|                     | Monitoring and alerting configured.      |
+---------------------+------------------------------------------+
| Maintenance         | Post-mortems. Bug pattern analysis.      |
|                     | Technical debt reduction sprints.        |
+---------------------+------------------------------------------+
```

**Quality tools in Flutter:**

```yaml
# analysis_options.yaml — enforced on every commit via CI
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    missing_required_param: error
    dead_code: warning
    
linter:
  rules:
    - avoid_print              # no print() in production
    - prefer_const_constructors
    - always_declare_return_types
    - avoid_dynamic            # no dynamic types without justification
```

```dart
// CI pipeline enforces quality gates:
// 1. dart format --set-exit-if-changed .    (formatting)
// 2. dart analyze                           (static analysis)
// 3. flutter test --coverage               (tests + coverage)
// 4. lcov --check-full-integrity coverage  (min coverage %)
// Merge blocked if any step fails
```

**Why it matters:** This is a seniority question. Junior developers think quality = QA team testing. Senior engineers build quality into every stage. The interviewer wants to see a systems-thinking approach to quality.

**Common mistake:** Candidates describe quality as the testing team's job. In modern teams, especially with Flutter development, the developer owns quality from the first line of code. Testers find what developers miss, not vice versa.

---

**Q:** What is Shift-Left testing? Why is it important?

**A:** Shift-Left testing means moving testing activities earlier (to the "left") in the development timeline — starting to test from requirements and design rather than waiting until a feature is "finished."

```
Traditional (Shift-Right):
Plan → Design → Code → Code → Code → [TEST] → Deploy

Shift-Left:
Plan     → [TEST: review reqs]
Design   → [TEST: review design, write test cases]  
Code     → [TEST: TDD, unit tests written WITH the code]
Complete → [TEST: integration + system tests]
Deploy   → [TEST: smoke tests, monitoring]

Result: Bugs found earlier = cheaper to fix
```

**Why bugs cost more the later they are found:**

```
Cost to fix a bug:

Requirements phase:   $1
Design phase:         $5
Development phase:    $10
Testing phase:        $25
Production:           $100+

(Based on IBM Systems Sciences Institute study — widely cited
in software engineering)
```

**Shift-Left practices:**
- Writing acceptance criteria before starting development
- Test-Driven Development (TDD) — test written before the code
- Static analysis and linting in CI on every commit
- Security scanning in the pipeline (not just at release)
- Developers testing their own code before handing off to QA
- Definition of Done includes passing tests, not just "it works"

**Example:**

```dart
// TDD in Flutter — Shift-Left in action

// Step 1: WRITE THE TEST before writing the feature
// (the feature does not exist yet — this test FAILS)
test('formatPrice returns correct currency string', () {
  expect(formatPrice(9.99), equals('\$9.99'));
  expect(formatPrice(1000.0), equals('\$1,000.00'));
  expect(formatPrice(0.0), equals('\$0.00'));
  expect(formatPrice(-5.0), equals('-\$5.00'));
});

// Step 2: WRITE THE MINIMUM CODE to make the test pass
String formatPrice(double amount) {
  final formatter = NumberFormat.currency(symbol: '\$');
  return formatter.format(amount);
}

// Step 3: REFACTOR if needed, test stays green
// The test is now the specification — not documentation
```

**Why it matters:** Shift-Left is a core principle of modern DevOps and agile engineering. The interviewer is checking whether you understand that catching bugs early is an economic and quality imperative — not just good practice.

**Common mistake:** Candidates confuse Shift-Left with "just write unit tests." Shift-Left starts at requirements — involving QA in story refinement, writing acceptance criteria as test cases, and making the Definition of Done include quality gates.

---

**Q:** What is DevOps culture? How does it relate to SDLC?

**A:** DevOps is a cultural and organisational philosophy that breaks down the silos between software Development (Dev) and IT Operations (Ops). It is not a tool or a job title — it is a set of practices that make the entire SDLC faster, more reliable, and more collaborative.

**Before DevOps:**
```
Dev team:   "Here is the code — it works on my machine."
                    ↓  (throws code over the wall)
Ops team:   "This breaks everything in production — not our problem."
Result:     Slow releases, blame culture, fragile deployments
```

**With DevOps:**
```
Dev + Ops work together across the SDLC:

Code → Build → Test → Release → Deploy → Operate → Monitor
 ↑                                                      |
 └──────────────── Fast Feedback Loop ──────────────────┘
```

**Core DevOps principles:**

- **Continuous Integration (CI)** — developers merge code frequently; automated build and tests run on every commit
- **Continuous Delivery (CD)** — every successful build is deployable to production at any time
- **Infrastructure as Code (IaC)** — infrastructure managed via code (Terraform, Ansible), not manual configuration
- **Monitoring and observability** — systems emit metrics, logs, and traces; team is alerted before users notice problems
- **Blameless post-mortems** — failures are system problems, not people problems
- **CALMS** — Culture, Automation, Lean, Measurement, Sharing

**How DevOps extends SDLC:**

```
SDLC Phase      DevOps Practice
-----------     -----------------------------------------------
Planning        Backlog includes operational work (infra, alerts)
Development     CI pipeline: lint → test → build on every commit
Testing         Automated test gates in pipeline, no manual step
Deployment      CD pipeline: automated deploy to staging/prod
Maintenance     Real-time monitoring, auto-scaling, alerting
```

**Example (Flutter + DevOps CI/CD pipeline):**

```yaml
# .github/workflows/flutter_ci.yml
name: Flutter CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.0'

      # CI gate 1: Code formatting
      - name: Check formatting
        run: dart format --set-exit-if-changed .

      # CI gate 2: Static analysis
      - name: Analyze code
        run: flutter analyze

      # CI gate 3: Tests with coverage
      - name: Run tests
        run: flutter test --coverage

      # CI gate 4: Coverage threshold
      - name: Check coverage
        run: |
          lcov --summary coverage/lcov.info
          # Fail if coverage drops below 80%

  build:
    needs: quality
    runs-on: ubuntu-latest
    steps:
      - name: Build Android APK
        run: flutter build apk --release

      # CD: Auto-deploy to Firebase App Distribution (staging)
      - name: Deploy to staging
        run: firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk
          --app ${{ secrets.FIREBASE_APP_ID }}
          --groups "internal-testers"
```

**Why it matters:** DevOps is now the default operating model for modern software teams. Interviewers want to know that you can work effectively in a CI/CD environment, contribute to pipeline health, and take ownership of your code beyond "it works locally."

**Common mistake:** Candidates say "DevOps is about Docker and Kubernetes." Those are tools that support DevOps practices. The culture — shared responsibility, fast feedback, automation-first, and collaboration — is DevOps. The tools are just enablers.

---
