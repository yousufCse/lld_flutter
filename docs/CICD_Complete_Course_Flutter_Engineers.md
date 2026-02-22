# CI/CD Mastery for Flutter Engineers
## The Complete Course: Beginner to Advanced (Using GitLab)
### By Your DevOps & Flutter Engineering Guide

---

# TABLE OF CONTENTS

## Part 1 — Foundations
- Module 1: What CI/CD Really Is (and Why You Should Care)
- Module 2: GitLab CI/CD Architecture & Core Concepts
- Module 3: Your First `.gitlab-ci.yml` Pipeline

## Part 2 — Flutter-Specific Pipelines
- Module 4: Flutter Analyze, Test & Build in CI
- Module 5: Code Quality Gates (Lint, Coverage, Code Metrics)
- Module 6: Building APK / IPA / Web Artifacts
- Module 7: Flavors, Environments & Build Variants in CI

## Part 3 — Intermediate
- Module 8: Caching, Artifacts & Pipeline Optimization
- Module 9: Automated Testing Strategy (Unit, Widget, Integration)
- Module 10: Code Signing (Android Keystore & iOS Certificates)
- Module 11: Automated Deployment (Play Store, TestFlight, Firebase App Distribution)

## Part 4 — Advanced
- Module 12: GitLab Runners (Shared, Specific, Docker, macOS)
- Module 13: Multi-Stage, Multi-Platform Pipelines
- Module 14: Security Scanning, Dependency Checks & SAST
- Module 15: Monorepo Strategies & Pipeline-as-Code Patterns

## Part 5 — Expert
- Module 16: Release Management (Semantic Versioning, Changelogs, Tags)
- Module 17: GitOps, Feature Flags & Rollback Strategies
- Module 18: Designing CI/CD for a Team — Best Practices & Decision Framework

---
---

# PART 1 — FOUNDATIONS

---
---

# MODULE 1: What CI/CD Really Is (and Why You Should Care)

---

## 1.1 — The Problem CI/CD Solves

Think about your current Flutter workflow. You probably do something like this:

```
1. Write code
2. Run `flutter analyze` manually
3. Run `flutter test` manually
4. Run `flutter build apk` manually
5. Send the APK to testers via Slack / Email
6. Repeat everything for iOS
7. Eventually upload to Play Store / App Store manually
8. Hope nothing broke along the way
```

Now imagine you're working in a team of 5 developers. Everyone is merging code.
Someone forgets to run tests before pushing. A broken build reaches the tester.
A release goes out with a regression nobody caught.

**CI/CD automates all of this. Every single push. Without ever forgetting a step.**

Think of it this way: you follow SOLID principles because you believe in
code quality. CI/CD is the SOLID principle for your **delivery process**.

---

## 1.2 — Definitions (Real Meaning, No Buzzwords)

### CI — Continuous Integration

Every time you (or a teammate) push code to the repository, the system
**automatically**:

```
✅ Pulls your latest code
✅ Installs dependencies (flutter pub get)
✅ Runs static analysis (flutter analyze)
✅ Runs all tests (flutter test)
✅ Reports pass/fail back to you
```

**The "Continuous" part** means: this happens on EVERY push, EVERY merge request.
Not once a week. Not before release. Every. Single. Time.

**The "Integration" part** means: your code is being verified that it integrates
correctly with the rest of the codebase. If your code breaks someone else's
tests, you find out in minutes — not days.

**Analogy:** Think of CI as a code reviewer who never sleeps, never forgets to
run the tests, and gives feedback in minutes.

### CD — Continuous Delivery vs Continuous Deployment

This is where people get confused. There are actually **two meanings** of CD:

```
Continuous Delivery:
  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌────────────────┐
  │   Push    │───▶│  Build   │───▶│  Test    │───▶│  Ready to      │
  │   Code    │    │          │    │          │    │  Deploy         │
  └──────────┘    └──────────┘    └──────────┘    │  (Manual click) │
                                                   └────────────────┘

Continuous Deployment:
  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌────────────────┐
  │   Push    │───▶│  Build   │───▶│  Test    │───▶│  Auto Deploy   │
  │   Code    │    │          │    │          │    │  to Production  │
  └──────────┘    └──────────┘    └──────────┘    └────────────────┘
```

**Continuous Delivery** = Code is always in a deployable state. A human clicks
"deploy" when ready. (Most mobile teams use this.)

**Continuous Deployment** = Code automatically goes to production after passing
all checks. No human intervention. (More common in web/backend.)

**For Flutter apps:** You'll mostly use **Continuous Delivery** because Apple and
Google require review steps. But you can automate everything UP TO the store
submission.

---

## 1.3 — The CI/CD Pipeline (The Most Important Concept)

A **pipeline** is simply a series of steps (called **stages**) that your code
goes through automatically.

```
THE PIPELINE — Your Code's Journey
====================================

          STAGE 1         STAGE 2         STAGE 3         STAGE 4
        ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
Push ──▶│ ANALYZE  │──▶│  TEST    │──▶│  BUILD   │──▶│ DEPLOY   │
        │          │   │          │   │          │   │          │
        │ lint     │   │ unit     │   │ apk      │   │ firebase │
        │ format   │   │ widget   │   │ ipa      │   │ store    │
        │ analyze  │   │ integr.  │   │ web      │   │ testflig │
        └──────────┘   └──────────┘   └──────────┘   └──────────┘
             │              │              │              │
          If FAIL ──▶ ❌ STOP (pipeline fails, you get notified)
```

**Key Rules of a Pipeline:**

1. **Stages run in order.** If Stage 1 fails, Stage 2 never runs.
2. **Fast feedback.** You want cheap/fast checks first (analyze takes seconds,
   building an IPA takes 20 minutes).
3. **Fail fast.** If your code has a lint error, why waste time building an APK?

---

## 1.4 — Key Vocabulary You Need

| Term              | What It Means                                      | Flutter Analogy                          |
|-------------------|----------------------------------------------------|-----------------------------------------|
| **Pipeline**      | The entire automated workflow from push to deploy  | Like your `build_runner` — the whole process |
| **Stage**         | A phase in the pipeline (analyze, test, build)     | Like a build step                        |
| **Job**           | A specific task within a stage                     | Like a single test file running          |
| **Runner**        | The machine that executes your jobs                | Like your laptop, but in the cloud       |
| **Artifact**      | Files produced by a job (APK, IPA, reports)        | Like the build output folder             |
| **Cache**         | Saved files between pipeline runs (pub cache)      | Like your `.dart_tool` folder            |
| **Trigger**       | What starts a pipeline (push, MR, schedule)        | Like a `setState` — something causes a reaction |
| **Environment**   | Where you deploy to (staging, production)          | Like your flavors (dev, staging, prod)   |
| **Variable**      | Secrets and config values (API keys, passwords)    | Like `--dart-define` values              |
| **YAML**          | The file format for pipeline configuration         | Like `pubspec.yaml` — you already know it! |

---

## 1.5 — CI/CD in the Context of Mobile / Flutter

CI/CD for Flutter is **different** from web/backend CI/CD. Here's why:

### Challenge 1: Two Platforms, Two Build Systems
```
Your Flutter App
       │
       ├──▶ Android ──▶ Gradle ──▶ APK/AAB ──▶ Play Store
       │
       └──▶ iOS ──▶ Xcode ──▶ IPA ──▶ App Store / TestFlight
```
Each platform has its own build toolchain, signing requirements, and store.

### Challenge 2: Code Signing
Unlike web apps, mobile apps must be **cryptographically signed**.
- Android: Keystore file + passwords
- iOS: Certificates + Provisioning Profiles + Apple Developer account

### Challenge 3: iOS Requires macOS
You **cannot** build an iOS app on Linux. This means:
- Android builds → Linux runner (cheap, fast)
- iOS builds → macOS runner (expensive, limited)

### Challenge 4: Build Times
Flutter builds are heavy:
- `flutter build apk`: 2–5 minutes
- `flutter build ipa`: 5–15 minutes

Caching and optimization become critical.

---

## 1.6 — Where GitLab Fits In

### GitLab CI/CD Architecture — The Big Picture

```
┌──────────────────────────────────────────────┐
│                  GitLab.com                    │
│                                                │
│  ┌──────────┐    ┌─────────────────────────┐  │
│  │   Your    │    │   GitLab CI/CD Engine    │  │
│  │   Repo    │───▶│                         │  │
│  │           │    │  Reads .gitlab-ci.yml   │  │
│  └──────────┘    │  Creates pipeline        │  │
│                   │  Assigns jobs to runners │  │
│                   └────────────┬────────────┘  │
│                                │                │
└────────────────────────────────┼────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │       RUNNERS            │
                    │  ┌────────┐ ┌────────┐  │
                    │  │ Linux  │ │ macOS  │  │
                    │  │ Runner │ │ Runner │  │
                    │  │(Docker)│ │(Shell) │  │
                    │  └────────┘ └────────┘  │
                    └──────────────────────────┘
```

How it works:

1. You push code to GitLab.
2. GitLab reads `.gitlab-ci.yml` from your repo.
3. GitLab creates a **pipeline** based on that file.
4. The pipeline contains **stages**, each with **jobs**.
5. GitLab assigns jobs to available **runners**.
6. Runners execute the jobs and report results back.
7. You see pass or fail in the GitLab UI and in your merge request.

---

## 1.7 — Your First Mental Model: The Factory Assembly Line

```
 RAW CODE                                            DELIVERED APP
    │                                                       ▲
    ▼                                                       │
┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
│QUALITY │  │QUALITY │  │ ASSEM- │  │QUALITY │  │ SHIP-  │
│CHECK 1 │─▶│CHECK 2 │─▶│  BLE   │─▶│CHECK 3 │─▶│ PING   │
│        │  │        │  │        │  │        │  │        │
│Analyze │  │ Test   │  │ Build  │  │Sign &  │  │Deploy  │
│Format  │  │        │  │ APK    │  │Verify  │  │to Store│
│Lint    │  │        │  │ IPA    │  │        │  │        │
└────────┘  └────────┘  └────────┘  └────────┘  └────────┘

  If ANY station finds a defect → the line STOPS → you get notified
```

---

## 1.8 — What a `.gitlab-ci.yml` Looks Like (Sneak Peek)

```yaml
# This file lives in the ROOT of your Flutter project repository

stages:
  - analyze
  - test
  - build
  - deploy

image: ghcr.io/cirruslabs/flutter:stable

cache:
  key: flutter-pub-cache
  paths:
    - .pub-cache/

before_script:
  - flutter pub get

lint:
  stage: analyze
  script:
    - flutter analyze
    - dart format --set-exit-if-changed .

unit_tests:
  stage: test
  script:
    - flutter test --coverage

build_apk:
  stage: build
  script:
    - flutter build apk --release
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
  only:
    - main

deploy_firebase:
  stage: deploy
  script:
    - firebase appdistribution:distribute
        build/app/outputs/flutter-apk/app-release.apk
        --app $FIREBASE_APP_ID
        --groups testers
  only:
    - main
  when: manual
```

---

## 1.9 — The Real-World Value

| Without CI/CD                        | With CI/CD                             |
|--------------------------------------|----------------------------------------|
| "Works on my machine"               | Works on every machine, every time     |
| Bugs found by testers days later    | Bugs caught in minutes                 |
| Manual releases take hours          | Releases take one click (or zero)      |
| Inconsistent build process          | Same process, every single time        |
| Fear of deploying on Fridays        | Confidence to deploy anytime           |
| Knowledge trapped in one person     | Process documented in `.gitlab-ci.yml` |

---

## 1.10 — Module 1 Summary & Key Takeaways

```
1. CI = Automatically verify code on every push
2. CD = Automatically prepare (or execute) deployment
3. Pipeline = Ordered stages (analyze → test → build → deploy)
4. Fail fast = Cheap checks first, expensive checks last
5. Runner = The machine that runs your jobs
6. .gitlab-ci.yml = Your pipeline definition file
7. Flutter CI/CD has unique challenges (iOS, signing, build times)
8. Continuous Delivery (manual deploy trigger) is standard for mobile
```

---
---

# MODULE 2: GitLab CI/CD Architecture & Core Concepts

---

## 2.1 — The `.gitlab-ci.yml` File: Your Pipeline's Blueprint

Everything in GitLab CI/CD starts with **one file**: `.gitlab-ci.yml`.
This file lives in the **root** of your repository.

```
my_flutter_app/
├── .gitlab-ci.yml       ← THIS FILE controls your entire CI/CD
├── pubspec.yaml
├── lib/
├── test/
├── android/
├── ios/
└── web/
```

When GitLab detects this file, CI/CD is **automatically enabled**.
This is called "Pipeline as Code" — version controlled, code-reviewed, portable.

---

## 2.2 — YAML Crash Course

### Multi-line Strings (Critical for Scripts)

```yaml
# Literal block (|): Preserves newlines — USE THIS for multi-line scripts
script: |
  echo "Step 1: Getting dependencies"
  flutter pub get
  echo "Step 2: Running analysis"
  flutter analyze

# Folded block (>): Joins lines into one — USE THIS for long single commands
script: >
  flutter build apk
  --release
  --build-number=$CI_PIPELINE_IID
  --dart-define=ENV=production
```

### Anchors and Aliases (DRY Principle for YAML)

```yaml
# Define a reusable block with &anchor_name
.flutter_setup: &flutter_setup
  before_script:
    - flutter pub get
    - flutter --version

# Reuse it with *anchor_name
unit_test:
  <<: *flutter_setup
  script:
    - flutter test

widget_test:
  <<: *flutter_setup
  script:
    - flutter test --tags=widget
```

---

## 2.3 — The Anatomy of `.gitlab-ci.yml`

```yaml
# ═══════════════════════════════════════════════════════
# GLOBAL CONFIGURATION (applies to ALL jobs)
# ═══════════════════════════════════════════════════════

# 1. DEFAULT IMAGE
image: ghcr.io/cirruslabs/flutter:stable

# 2. STAGES
stages:
  - analyze
  - test
  - build
  - deploy

# 3. GLOBAL VARIABLES
variables:
  PUB_CACHE: "$CI_PROJECT_DIR/.pub-cache"
  FLUTTER_BUILD_NUMBER: "$CI_PIPELINE_IID"

# 4. GLOBAL CACHE
cache:
  key: "$CI_COMMIT_REF_SLUG"
  paths:
    - .pub-cache/

# 5. GLOBAL BEFORE_SCRIPT
before_script:
  - flutter pub get

# ═══════════════════════════════════════════════════════
# JOB DEFINITIONS
# ═══════════════════════════════════════════════════════

analyze_code:
  stage: analyze
  script:
    - flutter analyze
    - dart format --set-exit-if-changed .
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH == "main"'

run_tests:
  stage: test
  script:
    - flutter test --coverage
  artifacts:
    paths:
      - coverage/
    expire_in: 7 days

build_android:
  stage: build
  script:
    - flutter build apk --release
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/
  only:
    - main

deploy_to_firebase:
  stage: deploy
  script:
    - firebase appdistribution:distribute ...
  when: manual
  only:
    - main
```

---

## 2.4 — Understanding Stages and Jobs

### How Stages Execute

```
Stage 1: analyze          Stage 2: test           Stage 3: build
┌─────────────────┐      ┌─────────────────┐      ┌────────────────┐
│  lint_check     │      │  unit_tests     │      │  build_apk     │
│  (Job A)        │      │  (Job C)        │      │  (Job E)       │
├─────────────────┤      ├─────────────────┤      ├────────────────┤
│  format_check   │      │  widget_tests   │      │  build_web     │
│  (Job B)        │      │  (Job D)        │      │  (Job F)       │
└─────────────────┘      └─────────────────┘      └────────────────┘

Jobs in the SAME stage run in PARALLEL.
Stages run SEQUENTIALLY.
If ANY job in a stage fails, the next stage does NOT start.
```

### Job Lifecycle

Each job runs in a **fresh, clean environment**:
- New container (if using Docker)
- No leftover files from previous jobs (unless you use cache/artifacts)
- Like running `flutter clean` before every operation.

---

## 2.5 — Runners: The Machines That Do the Work

```
┌─────────────────────────────┐  ┌──────────────────────────────┐
│    SHARED RUNNERS            │  │    SELF-HOSTED RUNNERS        │
│                              │  │                               │
│  Provided by GitLab          │  │  YOUR machines                │
│  Free tier: 400 min/mo       │  │  Linux, macOS, Windows        │
│  Linux only                  │  │  No time limits               │
│  Good for Android/Web        │  │  REQUIRED for iOS builds      │
│                              │  │                               │
│  Best for:                   │  │  Best for:                    │
│  - Learning                  │  │  - iOS builds (needs macOS)   │
│  - Small projects            │  │  - Heavy CI usage teams       │
└─────────────────────────────┘  └──────────────────────────────┘
```

### Tags: How Jobs Find the Right Runner

```yaml
build_ios:
  tags:
    - macos
    - xcode-15
  script:
    - flutter build ipa --release

build_android:
  tags:
    - docker
    - linux
  script:
    - flutter build apk --release
```

---

## 2.6 — Variables and Secrets

### Predefined Variables (GitLab provides these automatically)

```
CI_COMMIT_SHA            → Full commit hash
CI_COMMIT_SHORT_SHA      → Short hash
CI_COMMIT_BRANCH         → Branch name
CI_COMMIT_TAG            → Tag name
CI_PIPELINE_IID          → Pipeline ID within project (1,2,3..)
CI_MERGE_REQUEST_IID     → MR number
CI_PROJECT_DIR           → Path where repo is cloned
GITLAB_USER_LOGIN        → Who triggered the pipeline
```

### Secret Variables (Defined in GitLab UI — NEVER in code!)

```
GitLab UI → Settings → CI/CD → Variables

Key:    PLAY_STORE_JSON_KEY
Value:  {"type": "service_account"...}
☑ Protect variable
☑ Mask variable
```

**CRITICAL:** Never put secrets in `.gitlab-ci.yml`.

---

## 2.7 — Pipeline Triggers

```
1. PUSH              → Push to any branch
2. MERGE REQUEST     → Open/update a merge request
3. TAG               → Create a git tag (v1.0.0)
4. SCHEDULE          → Cron-like schedule (nightly builds)
5. API               → External trigger via REST API
6. MANUAL            → Click "Run Pipeline" in GitLab UI
```

### Controlling When Jobs Run with Rules

```yaml
build_apk:
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: always
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: always
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
      when: always
    - when: never
```

---

## 2.8 — Artifacts vs Cache

```
        ARTIFACTS                           CACHE
─────────────────────────────   ─────────────────────────────────
Pass files BETWEEN jobs         Speed up jobs ACROSS pipelines
in the SAME pipeline

Use for: APK, IPA, test         Use for: .pub-cache/,
reports, coverage reports       .gradle/, Pods/

Uploaded to GitLab server       Stored on the runner machine
Downloadable from UI            Not downloadable from UI

Guaranteed availability         Best-effort (may be evicted)
```

---

## 2.9 — Module 2 Summary

```
1. .gitlab-ci.yml is your single source of truth for CI/CD
2. Stages run sequentially; jobs within stages run parallel
3. Each job runs in a CLEAN environment (Docker or Shell)
4. Runners are machines; tags route jobs to correct runners
5. Variables: predefined (CI_*), custom (YAML), secret (UI)
6. NEVER put secrets in .gitlab-ci.yml
7. Artifacts pass files between jobs; cache speeds up across pipelines
8. Use 'rules:' (not 'only/except') — it's the modern approach
```

---
---

# MODULE 3: Your First `.gitlab-ci.yml` Pipeline

---

## 3.1 — Step 1: The Absolute Minimum Pipeline

```yaml
# .gitlab-ci.yml — Version 1 (Absolute Minimum)
image: ghcr.io/cirruslabs/flutter:stable

verify:
  script:
    - flutter --version
    - flutter pub get
    - flutter analyze
```

That's it. **5 lines.** Push this and watch it run in GitLab.

---

## 3.2 — Step 2: Adding Stages

```yaml
# .gitlab-ci.yml — Version 2
image: ghcr.io/cirruslabs/flutter:stable

stages:
  - analyze
  - test

before_script:
  - flutter pub get

lint:
  stage: analyze
  script:
    - flutter analyze
    - dart format --set-exit-if-changed .

unit_test:
  stage: test
  script:
    - flutter test
```

---

## 3.3 — Step 3: Adding Cache

```yaml
# .gitlab-ci.yml — Version 3
image: ghcr.io/cirruslabs/flutter:stable

stages:
  - analyze
  - test

variables:
  PUB_CACHE: "$CI_PROJECT_DIR/.pub-cache"

cache:
  key:
    files:
      - pubspec.lock
  paths:
    - $PUB_CACHE
    - .dart_tool/

before_script:
  - export PATH="$PATH:$PUB_CACHE/bin"
  - flutter pub get

lint:
  stage: analyze
  script:
    - flutter analyze
    - dart format --set-exit-if-changed .

unit_test:
  stage: test
  script:
    - flutter test
```

---

## 3.4 — Step 4: Build Stage with Artifacts

```yaml
# .gitlab-ci.yml — Version 4 (Analyze → Test → Build)
image: ghcr.io/cirruslabs/flutter:stable

stages:
  - analyze
  - test
  - build

variables:
  PUB_CACHE: "$CI_PROJECT_DIR/.pub-cache"

cache:
  key:
    files:
      - pubspec.lock
  paths:
    - $PUB_CACHE
    - .dart_tool/

before_script:
  - export PATH="$PATH:$PUB_CACHE/bin"
  - flutter pub get

lint:
  stage: analyze
  script:
    - flutter analyze
    - dart format --set-exit-if-changed .

unit_test:
  stage: test
  script:
    - flutter test --coverage
  coverage: '/lines\.+: (\d+\.\d+)%/'
  artifacts:
    paths:
      - coverage/lcov.info
    expire_in: 7 days

build_apk:
  stage: build
  script:
    - flutter build apk --release --build-number=$CI_PIPELINE_IID
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
    expire_in: 30 days
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 3.5 — Step 5: Smart Rules (The Complete Beginner Pipeline)

```yaml
# .gitlab-ci.yml — Version 5 (Production-Ready Beginner)
image: ghcr.io/cirruslabs/flutter:stable

stages:
  - analyze
  - test
  - build

variables:
  PUB_CACHE: "$CI_PROJECT_DIR/.pub-cache"

cache:
  key:
    files:
      - pubspec.lock
  paths:
    - $PUB_CACHE
    - .dart_tool/

before_script:
  - export PATH="$PATH:$PUB_CACHE/bin"
  - flutter pub get

lint:
  stage: analyze
  script:
    - flutter analyze --fatal-infos
    - dart format --set-exit-if-changed .

unit_test:
  stage: test
  script:
    - flutter test --coverage
  coverage: '/lines\.+: (\d+\.\d+)%/'
  artifacts:
    paths:
      - coverage/
    expire_in: 7 days
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH == "main"'

build_debug_apk:
  stage: build
  script:
    - flutter build apk --debug
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-debug.apk
    expire_in: 3 days
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

build_release_apk:
  stage: build
  script:
    - flutter build apk --release --build-number=$CI_PIPELINE_IID
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
    expire_in: 30 days
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

### Pipeline Behavior Summary

```
Trigger                  │ Analyze │ Test    │ Build
─────────────────────────┼─────────┼─────────┼──────────────
Push to feature/xyz      │ ✅ lint │ ❌      │ ❌
Open/Update MR           │ ✅ lint │ ✅ test │ ✅ debug APK
Push to main             │ ✅ lint │ ✅ test │ ✅ release APK
Tag v1.0.0               │ ✅ lint │ ❌      │ ✅ prod APK
```

---

## 3.6 — Common First-Timer Mistakes

```yaml
# ❌ WRONG — Indentation
lint:
script:
  - flutter analyze

# ✅ CORRECT
lint:
  script:
    - flutter analyze
```

```yaml
# ❌ WRONG — Stage not defined
stages:
  - test
lint:
  stage: analyze    # "analyze" not in stages list!

# ✅ CORRECT
stages:
  - analyze
  - test
lint:
  stage: analyze
```

```yaml
# ❌ WRONG — No Flutter in image
image: ubuntu:latest

# ✅ CORRECT
image: ghcr.io/cirruslabs/flutter:stable
```

### Validating Before Pushing

```
GitLab → Build → Pipeline editor → Validate
```

---

## 3.7 — Module 3 Summary

```
1. Start minimal (5 lines), then grow incrementally
2. Use stages to separate analyze → test → build
3. Cache pubspec.lock-keyed dependencies for speed
4. Use artifacts to save and share build outputs
5. Use 'rules:' to control WHEN each job runs
6. Build debug for MRs, release for main
7. Use $CI_PIPELINE_IID as auto-incrementing build number
8. Validate YAML in Pipeline Editor before pushing
```

---
---

# PART 2 — FLUTTER-SPECIFIC PIPELINES

---
---

# MODULE 4: Flutter Analyze, Test & Build in CI

---

## 4.1 — Flutter Analyze in CI (Deep Dive)

### Severity Levels and CI Flags

```yaml
# Basic — fails only on errors
- flutter analyze

# Strict — fails on errors AND warnings
- flutter analyze --fatal-warnings

# Strictest — fails on errors, warnings, AND infos
- flutter analyze --fatal-infos
```

### Configuring `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    unused_import: warning
    dead_code: warning
    missing_return: error

  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "lib/generated/**"

  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    - prefer_const_constructors
    - avoid_print
    - always_use_package_imports
    - unawaited_futures
```

---

## 4.2 — Flutter Test in CI (Deep Dive)

### Using Tags for CI

```dart
// test/unit/auth_test.dart
@Tags(['unit', 'smoke', 'fast'])
import 'package:test/test.dart';
```

```yaml
smoke_tests:
  script:
    - flutter test --tags smoke
  rules:
    - when: always

full_tests:
  script:
    - flutter test --tags "unit || widget"
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH == "main"'

integration_tests:
  script:
    - flutter test --tags integration
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
```

### Coverage with Cobertura (for GitLab MR diffs)

```yaml
test_coverage:
  script:
    - flutter test --coverage
    - dart pub global activate cobertura
    - dart pub global run cobertura:converter
        --input coverage/lcov.info
        --output coverage/cobertura.xml
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura.xml
```

---

## 4.3 — Flutter Build in CI

### Build Number Strategy

```yaml
build_apk:
  script:
    - flutter build apk
        --release
        --build-name=1.2.0
        --build-number=$CI_PIPELINE_IID
```

### Dart Defines for Environment Config

```yaml
build_staging:
  script:
    - flutter build apk --release
        --dart-define=ENV=$APP_ENV
        --dart-define=API_URL=$API_BASE_URL
```

```dart
class AppConfig {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const String apiUrl = String.fromEnvironment('API_URL');
}
```

---

## 4.4 — Module 4 Summary

```
1. flutter analyze: Use --fatal-warnings minimum in CI
2. dart format --set-exit-if-changed: Enforces consistent style
3. Use test tags to run different suites at different stages
4. Cobertura format enables line-level coverage in MR diffs
5. Use $CI_PIPELINE_IID for auto-incrementing build numbers
6. Pass environment config via --dart-define
7. NEVER hardcode secrets — use CI variables
```

---
---

# MODULE 5: Code Quality Gates

---

## 5.1 — What Is a Quality Gate?

A quality gate is a checkpoint that enforces minimum standards. If code doesn't
meet the standard, the pipeline fails, and the code can't be merged.

```
  ┌──────────┐   ┌───────────┐   ┌──────────┐   ┌───────────┐
  │ Format   │──▶│ Analysis  │──▶│ Tests    │──▶│  Coverage │──▶ MERGE
  │ Check    │   │ Check     │   │ Pass     │   │  >= 80%   │
  └──────────┘   └───────────┘   └──────────┘   └───────────┘
       │               │              │               │
  Fail? ❌        Fail? ❌       Fail? ❌        Fail? ❌
  Can't merge!   Can't merge!   Can't merge!   Can't merge!
```

---

## 5.2 — Coverage Threshold Gate

```yaml
test_coverage:
  script:
    - flutter test --coverage
    - |
      COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 \
        | grep "lines" | grep -oP '[\d.]+(?=%)')
      echo "Coverage: ${COVERAGE}%"
      MINIMUM=80
      if (( $(echo "$COVERAGE < $MINIMUM" | bc -l) )); then
        echo "❌ Coverage ${COVERAGE}% < ${MINIMUM}%"
        exit 1
      fi
  coverage: '/Coverage: (\d+\.\d+)%/'
```

---

## 5.3 — Enforcing Gates in GitLab

```
GitLab → Settings → Repository → Protected Branches
  Branch: main
  Allowed to push: No one (force merge requests!)

GitLab → Settings → Merge Requests
  ✅ Pipelines must succeed
  ✅ All discussions must be resolved
  ✅ Require approval from code owners
```

---

## 5.4 — Quality Gate Adoption Strategy

```
Phase 1 (Week 1-2):  Format + analyze (errors only) + tests
Phase 2 (Week 3-4):  analyze --fatal-warnings + coverage reporting
Phase 3 (Month 2):   Coverage threshold 60% + protected branches
Phase 4 (Month 3+):  Coverage 80% + code metrics + dependency scanning
```

---
---

# MODULE 6: Building APK / IPA / Web Artifacts

---

## 6.1 — Understanding Build Artifacts in Mobile CI/CD

An **artifact** in CI/CD is any file produced by your pipeline that has value
beyond the job that created it. For Flutter, the most important artifacts are:

```
┌──────────────────────────────────────────────────────────────┐
│                    FLUTTER BUILD ARTIFACTS                     │
│                                                               │
│  Android:                                                     │
│  ├── APK (Android Package)         → Testing / Direct install │
│  ├── AAB (Android App Bundle)      → Play Store upload        │
│  └── Mapping files (obfuscation)   → Crash report decoding    │
│                                                               │
│  iOS:                                                         │
│  ├── IPA (iOS App Archive)         → TestFlight / Ad-hoc      │
│  ├── dSYM (Debug Symbols)          → Crash report decoding    │
│  └── ExportOptions.plist           → Export configuration      │
│                                                               │
│  Web:                                                         │
│  └── build/web/ folder             → Deploy to any web server │
│                                                               │
│  Reports:                                                     │
│  ├── coverage/lcov.info            → Code coverage data       │
│  ├── test-results.xml              → JUnit test results       │
│  └── analysis-report.json          → Code quality metrics     │
└──────────────────────────────────────────────────────────────┘
```

---

## 6.2 — Android Builds: APK vs AAB

### APK (Android Package Kit)

```yaml
# Debug APK — for internal testing, no signing needed
build_apk_debug:
  stage: build
  script:
    - flutter build apk --debug
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-debug.apk
    expire_in: 3 days

# Release APK — optimized, signed
build_apk_release:
  stage: build
  script:
    - flutter build apk --release
        --build-number=$CI_PIPELINE_IID
        --build-name=$APP_VERSION
        --obfuscate
        --split-debug-info=build/debug-info
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
      - build/debug-info/          # Keep for crash report decoding
    expire_in: 30 days

# Split APKs — separate APK per ABI (smaller downloads)
build_apk_split:
  stage: build
  script:
    - flutter build apk --release --split-per-abi
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
      - build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
      - build/app/outputs/flutter-apk/app-x86_64-release.apk
    expire_in: 30 days
```

### AAB (Android App Bundle) — Required for Play Store

```yaml
build_aab:
  stage: build
  script:
    - flutter build appbundle --release
        --build-number=$CI_PIPELINE_IID
        --build-name=$APP_VERSION
        --obfuscate
        --split-debug-info=build/debug-info
  artifacts:
    paths:
      - build/app/outputs/bundle/release/app-release.aab
      - build/debug-info/
    expire_in: 90 days
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
```

### APK vs AAB Decision

```
┌────────────────────┬──────────────────────────────────────────┐
│ APK                │ AAB                                       │
├────────────────────┼──────────────────────────────────────────┤
│ Direct install     │ Play Store only                           │
│ Firebase App Dist  │ Google generates optimized APKs per device│
│ Internal testing   │ Smaller download size for users           │
│ Ad-hoc sharing     │ REQUIRED for new Play Store apps          │
│ CI testing         │ Dynamic feature modules supported         │
└────────────────────┴──────────────────────────────────────────┘

Recommendation:
  MR pipelines   → APK (debug)     — fast, easy to test
  main branch    → APK (release)   — for Firebase App Distribution
  release tags   → AAB (release)   — for Play Store
```

---

## 6.3 — iOS Builds: The IPA

iOS builds are more complex because they require macOS and code signing.

```yaml
build_ios:
  stage: build
  tags:
    - macos                    # MUST run on macOS runner
  script:
    # Install CocoaPods dependencies
    - cd ios && pod install && cd ..

    # Build the IPA
    - flutter build ipa --release
        --build-number=$CI_PIPELINE_IID
        --build-name=$APP_VERSION
        --export-options-plist=ios/ExportOptions.plist
        --obfuscate
        --split-debug-info=build/debug-info

  artifacts:
    paths:
      - build/ios/ipa/*.ipa
      - build/debug-info/
    expire_in: 30 days
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
```

### ExportOptions.plist

This file tells Xcode how to export the IPA:

```xml
<!-- ios/ExportOptions.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>    <!-- or "ad-hoc" or "development" -->

    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>

    <key>uploadSymbols</key>
    <true/>

    <key>provisioningProfiles</key>
    <dict>
        <key>com.yourcompany.yourapp</key>
        <string>Your Provisioning Profile Name</string>
    </dict>
</dict>
</plist>
```

### Export Methods Explained

```
┌────────────────┬──────────────────────────────────────────────┐
│ Method         │ Use Case                                      │
├────────────────┼──────────────────────────────────────────────┤
│ development    │ Install on registered devices only            │
│ ad-hoc         │ Install on registered devices (up to 100)     │
│ app-store      │ Upload to App Store Connect / TestFlight      │
│ enterprise     │ Internal distribution (Enterprise account)    │
└────────────────┴──────────────────────────────────────────────┘
```

---

## 6.4 — Web Builds

```yaml
build_web:
  stage: build
  script:
    - flutter build web --release
        --base-href="/"
        --dart-define=ENV=production
        --web-renderer=canvaskit    # Better quality
    # OR
    # --web-renderer=html           # Better compatibility

  artifacts:
    paths:
      - build/web/
    expire_in: 14 days
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# Deploy web to GitLab Pages (free hosting!)
pages:
  stage: deploy
  script:
    - cp -r build/web public
  artifacts:
    paths:
      - public
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

### Web Renderer Decision

```
CanvasKit:
  ✅ Pixel-perfect rendering (identical to mobile)
  ✅ Better for complex UIs, custom painting
  ❌ Larger initial download (~2MB WASM file)
  ❌ Slower first load

HTML renderer:
  ✅ Smaller download
  ✅ Better SEO
  ✅ Better text rendering
  ❌ Slight visual differences from mobile
```

---

## 6.5 — Obfuscation and Debug Symbols

When building release apps, always obfuscate and keep debug symbols:

```yaml
build_release:
  script:
    - flutter build apk --release
        --obfuscate
        --split-debug-info=build/debug-info
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
      - build/debug-info/
```

**Why?**
- `--obfuscate`: Renames classes/methods to make reverse engineering harder
- `--split-debug-info`: Saves symbol mapping files so crash reports are readable

Without debug info, your crash reports look like:
```
#0    a.b.c (package:a/b.dart:42)
```

With debug info, they look like:
```
#0    AuthService.login (package:app/services/auth_service.dart:42)
```

---

## 6.6 — Artifact Management Strategy

```yaml
# Artifact Retention Policy
#
# Debug builds:    3 days   (just for MR testing)
# Release builds:  30 days  (for internal distribution)
# Production:      90 days  (for store submissions + rollback)
# Debug symbols:   180 days (for crash report decoding)
# Test reports:    7 days   (for review then discard)

artifacts:
  expire_in: 30 days    # Default for most jobs
```

---

## 6.7 — The Complete Multi-Platform Build Pipeline

```yaml
# =============================================================
# Multi-Platform Build Pipeline
# =============================================================

image: ghcr.io/cirruslabs/flutter:stable

stages:
  - analyze
  - test
  - build

variables:
  PUB_CACHE: "$CI_PROJECT_DIR/.pub-cache"
  APP_VERSION: "1.2.0"

cache:
  key:
    files:
      - pubspec.lock
  paths:
    - $PUB_CACHE
    - .dart_tool/

before_script:
  - export PATH="$PATH:$PUB_CACHE/bin"
  - flutter pub get

# ─── Analyze ───────────────────────────────────────────
lint:
  stage: analyze
  script:
    - flutter analyze --fatal-warnings
    - dart format --set-exit-if-changed .

# ─── Test ──────────────────────────────────────────────
test:
  stage: test
  script:
    - flutter test --coverage
  coverage: '/lines\.+: (\d+\.\d+)%/'
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH == "main"'

# ─── Android Debug (MRs) ──────────────────────────────
build_android_debug:
  stage: build
  script:
    - flutter build apk --debug
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-debug.apk
    expire_in: 3 days
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

# ─── Android Release (main) ───────────────────────────
build_android_release:
  stage: build
  script:
    - flutter build apk --release
        --build-number=$CI_PIPELINE_IID
        --build-name=$APP_VERSION
        --obfuscate
        --split-debug-info=build/debug-info
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
      - build/debug-info/
    expire_in: 30 days
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# ─── Android AAB (tags only) ──────────────────────────
build_android_aab:
  stage: build
  script:
    - flutter build appbundle --release
        --build-number=$CI_PIPELINE_IID
        --build-name=$APP_VERSION
        --obfuscate
        --split-debug-info=build/debug-info
  artifacts:
    paths:
      - build/app/outputs/bundle/release/app-release.aab
      - build/debug-info/
    expire_in: 90 days
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'

# ─── iOS (tags only, macOS runner) ────────────────────
build_ios:
  stage: build
  tags:
    - macos
  before_script:
    - flutter pub get
    - cd ios && pod install && cd ..
  script:
    - flutter build ipa --release
        --build-number=$CI_PIPELINE_IID
        --build-name=$APP_VERSION
        --export-options-plist=ios/ExportOptions.plist
  artifacts:
    paths:
      - build/ios/ipa/*.ipa
    expire_in: 90 days
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'

# ─── Web (main branch) ────────────────────────────────
build_web:
  stage: build
  script:
    - flutter build web --release
  artifacts:
    paths:
      - build/web/
    expire_in: 14 days
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 6.8 — Module 6 Summary

```
1. APK for testing/distribution, AAB for Play Store
2. iOS builds REQUIRE macOS runners — use tags to route
3. Always use --obfuscate and --split-debug-info for releases
4. Keep debug symbols longer than build artifacts (for crash decoding)
5. ExportOptions.plist controls iOS export method
6. Web has two renderers: canvaskit (quality) vs html (compatibility)
7. GitLab Pages gives you free web hosting for Flutter web
8. Set artifact expiry policies to manage storage costs
```

---
---

# MODULE 7: Flavors, Environments & Build Variants in CI

---

## 7.1 — Why Flavors and Environments?

As a senior engineer, you know apps need multiple environments:

```
┌────────────────────────────────────────────────────────────┐
│                     YOUR FLUTTER APP                        │
│                                                             │
│   Development          Staging            Production        │
│   ┌──────────┐        ┌──────────┐       ┌──────────┐     │
│   │ dev API  │        │ stg API  │       │ prod API │     │
│   │ debug    │        │ release  │       │ release  │     │
│   │ logging  │        │ limited  │       │ no logs  │     │
│   │ enabled  │        │ logging  │       │ analytics│     │
│   │ mock pay │        │ sandbox  │       │ real pay │     │
│   └──────────┘        └──────────┘       └──────────┘     │
│                                                             │
│   App ID:              App ID:            App ID:           │
│   com.app.dev          com.app.stg        com.app           │
│   Name: "App Dev"      Name: "App STG"    Name: "App"       │
└────────────────────────────────────────────────────────────┘
```

---

## 7.2 — Method 1: Dart Defines (Simplest Approach)

```yaml
# In .gitlab-ci.yml
build_dev:
  script:
    - flutter build apk --release
        --dart-define=ENV=development
        --dart-define=API_URL=https://dev-api.example.com
        --dart-define=APP_NAME="My App Dev"

build_staging:
  script:
    - flutter build apk --release
        --dart-define=ENV=staging
        --dart-define=API_URL=https://staging-api.example.com
        --dart-define=APP_NAME="My App Staging"

build_production:
  script:
    - flutter build apk --release
        --dart-define=ENV=production
        --dart-define=API_URL=https://api.example.com
        --dart-define=APP_NAME="My App"
```

### Using `--dart-define-from-file`

```yaml
# Create env files dynamically from CI variables
.build_with_env:
  before_script:
    - flutter pub get
    - |
      cat > /tmp/env.json << EOF
      {
        "ENV": "$APP_ENV",
        "API_URL": "$API_URL",
        "SENTRY_DSN": "$SENTRY_DSN",
        "APP_NAME": "$APP_NAME"
      }
      EOF

build_staging:
  extends: .build_with_env
  variables:
    APP_ENV: staging
    API_URL: $STAGING_API_URL     # From GitLab CI variables
    APP_NAME: "My App Staging"
  script:
    - flutter build apk --release
        --dart-define-from-file=/tmp/env.json
```

---

## 7.3 — Method 2: Android Flavors + iOS Schemes (Recommended for Complex Apps)

### Android Flavor Configuration

```groovy
// android/app/build.gradle
android {
    flavorDimensions "environment"

    productFlavors {
        development {
            dimension "environment"
            applicationIdSuffix ".dev"
            resValue "string", "app_name", "My App Dev"
            versionNameSuffix "-dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".stg"
            resValue "string", "app_name", "My App STG"
            versionNameSuffix "-stg"
        }
        production {
            dimension "environment"
            resValue "string", "app_name", "My App"
        }
    }
}
```

### CI Pipeline with Flavors

```yaml
# ─── Template for flavor builds ──────────────────────
.flutter_build_android:
  stage: build
  before_script:
    - flutter pub get
  artifacts:
    expire_in: 30 days

# ─── Development ─────────────────────────────────────
build_android_dev:
  extends: .flutter_build_android
  script:
    - flutter build apk --release --flavor development
        --build-number=$CI_PIPELINE_IID
        --dart-define=ENV=development
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-development-release.apk
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

# ─── Staging ─────────────────────────────────────────
build_android_staging:
  extends: .flutter_build_android
  script:
    - flutter build apk --release --flavor staging
        --build-number=$CI_PIPELINE_IID
        --dart-define=ENV=staging
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-staging-release.apk
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# ─── Production ──────────────────────────────────────
build_android_production:
  extends: .flutter_build_android
  script:
    - flutter build appbundle --release --flavor production
        --build-number=$CI_PIPELINE_IID
        --dart-define=ENV=production
        --obfuscate
        --split-debug-info=build/debug-info
  artifacts:
    paths:
      - build/app/outputs/bundle/productionRelease/app-production-release.aab
      - build/debug-info/
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
```

---

## 7.4 — Method 3: Entry Point Per Environment

```
lib/
├── main_development.dart
├── main_staging.dart
├── main_production.dart
├── app.dart
└── config/
    └── app_config.dart
```

```dart
// lib/main_development.dart
void main() {
  AppConfig.init(Environment.development);
  runApp(const MyApp());
}
```

```yaml
# CI Pipeline
build_dev:
  script:
    - flutter build apk --release
        --target=lib/main_development.dart
        --flavor development

build_prod:
  script:
    - flutter build apk --release
        --target=lib/main_production.dart
        --flavor production
```

---

## 7.5 — Per-Environment Firebase Configuration

```yaml
# Different google-services.json per flavor
build_staging:
  script:
    # Copy staging Firebase config
    - cp firebase/staging/google-services.json
        android/app/src/staging/google-services.json
    - cp firebase/staging/GoogleService-Info.plist
        ios/Runner/GoogleService-Info.plist
    - flutter build apk --release --flavor staging

build_production:
  script:
    - cp firebase/production/google-services.json
        android/app/src/production/google-services.json
    - cp firebase/production/GoogleService-Info.plist
        ios/Runner/GoogleService-Info.plist
    - flutter build apk --release --flavor production
```

---

## 7.6 — DRY Pipeline with `extends` and Hidden Jobs

```yaml
# Hidden jobs (start with .) are templates, not executed
.base_build:
  stage: build
  before_script:
    - flutter pub get
  artifacts:
    expire_in: 30 days

.android_build:
  extends: .base_build
  image: ghcr.io/cirruslabs/flutter:stable

.ios_build:
  extends: .base_build
  tags:
    - macos
  before_script:
    - flutter pub get
    - cd ios && pod install && cd ..

# Concrete jobs extend templates
build_android_staging:
  extends: .android_build
  script:
    - flutter build apk --release --flavor staging
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

build_ios_staging:
  extends: .ios_build
  script:
    - flutter build ipa --release --flavor staging
        --export-options-plist=ios/ExportOptions-staging.plist
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 7.7 — Module 7 Summary

```
1. Three methods: dart-define (simple), flavors (full), entry points (flexible)
2. Use dart-define-from-file for cleaner environment configuration
3. Android flavors = productFlavors in build.gradle
4. iOS schemes = separate configurations in Xcode
5. Use CI variables for secrets, dart-define for non-secret config
6. Use hidden jobs (.job_name) as templates with extends
7. Each flavor needs its own Firebase config files
8. Convention: MR→dev, main→staging, tags→production
```

---
---

# PART 3 — INTERMEDIATE

---
---

# MODULE 8: Caching, Artifacts & Pipeline Optimization

---

## 8.1 — Why Optimization Matters

Typical Flutter pipeline without optimization:

```
lint:     2 min (pub get: 45s + analyze: 15s + format: 5s)
test:     3 min (pub get: 45s + test: 2m)
build:    5 min (pub get: 45s + gradle download: 1m + build: 3m)
                                                    ─────────
Total:    10 minutes  ×  20 pipelines/day = 200 minutes/day
          At GitLab's rate: ~$8/day on shared runners
```

With optimization:

```
lint:     30s  (cached pub get: 3s + analyze: 15s + format: 5s)
test:     1.5m (cached pub get: 3s + test: 1.5m)
build:    3m   (cached pub get: 3s + cached gradle: 0s + build: 3m)
                                                    ─────────
Total:    5 minutes   ×  20 pipelines/day = 100 minutes/day
          50% reduction in time AND cost
```

---

## 8.2 — Advanced Caching Strategies

### Layer 1: Pub Cache

```yaml
variables:
  PUB_CACHE: "$CI_PROJECT_DIR/.pub-cache"

cache:
  key:
    files:
      - pubspec.lock
  paths:
    - $PUB_CACHE
    - .dart_tool/
```

### Layer 2: Gradle Cache (Android)

```yaml
variables:
  GRADLE_USER_HOME: "$CI_PROJECT_DIR/.gradle"

cache:
  key:
    files:
      - pubspec.lock
      - android/build.gradle
  paths:
    - $PUB_CACHE
    - .dart_tool/
    - $GRADLE_USER_HOME/caches/
    - $GRADLE_USER_HOME/wrapper/
```

### Layer 3: CocoaPods Cache (iOS)

```yaml
build_ios:
  tags:
    - macos
  variables:
    CP_HOME_DIR: "$CI_PROJECT_DIR/.cocoapods"
  cache:
    key:
      files:
        - ios/Podfile.lock
    paths:
      - $CP_HOME_DIR
      - ios/Pods/
```

### Cache Policy Optimization

```yaml
# Job that only READS cache (faster — no upload step)
lint:
  cache:
    key:
      files:
        - pubspec.lock
    paths:
      - $PUB_CACHE
    policy: pull              # Only download, never upload

# Job that WRITES cache (run this first or on a schedule)
install_deps:
  stage: .pre
  cache:
    key:
      files:
        - pubspec.lock
    paths:
      - $PUB_CACHE
      - .dart_tool/
    policy: push              # Only upload, don't download first
  script:
    - flutter pub get
```

---

## 8.3 — Pipeline Structure Optimization

### Parallel Jobs

```yaml
# These run simultaneously (same stage):
stages:
  - analyze
  - test
  - build

# Stage: analyze — both run in parallel
lint:
  stage: analyze
  script:
    - flutter analyze

format:
  stage: analyze
  script:
    - dart format --set-exit-if-changed .
```

### Conditional Builds with `changes:`

```yaml
# Only build Android if Android-related files changed
build_android:
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      changes:
        - lib/**/*
        - android/**/*
        - pubspec.*

# Only build iOS if iOS-related files changed
build_ios:
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      changes:
        - lib/**/*
        - ios/**/*
        - pubspec.*

# Only build web if web-related files changed
build_web:
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      changes:
        - lib/**/*
        - web/**/*
        - pubspec.*
```

### DAG (Directed Acyclic Graph) — Break Stage Barriers

```yaml
# Without needs: jobs wait for ALL jobs in previous stage
# With needs: jobs start as soon as their dependencies finish

build_android:
  stage: build
  needs: ["unit_test"]          # Start as soon as unit_test passes
  script:
    - flutter build apk --release

deploy_android:
  stage: deploy
  needs: ["build_android"]       # Don't wait for build_ios!
  script:
    - firebase appdistribution:distribute ...

build_ios:
  stage: build
  needs: ["unit_test"]
  tags:
    - macos
  script:
    - flutter build ipa --release

deploy_ios:
  stage: deploy
  needs: ["build_ios"]           # Don't wait for deploy_android!
  script:
    - xcrun altool --upload-app ...
```

```
WITHOUT needs:                   WITH needs (DAG):
                                 
analyze ──▶ test ──▶ build ──▶   analyze ──▶ test ─┬─▶ build_android ──▶ deploy_android
                     (wait for   ─                  │
                     ALL builds) ─                  └─▶ build_ios ──▶ deploy_ios
                     ──▶ deploy
                     (wait for   Parallel paths! Much faster!
                     ALL deploys)
```

---

## 8.4 — Interruptible Pipelines

When you push new commits quickly, old pipelines are wasted:

```yaml
# Cancel old pipelines when new commits are pushed
workflow:
  auto_cancel:
    on_new_commit: interruptible

lint:
  interruptible: true    # Can be cancelled
  script:
    - flutter analyze

deploy:
  interruptible: false   # NEVER cancel a deployment mid-way
  script:
    - firebase appdistribution:distribute ...
```

---

## 8.5 — Module 8 Summary

```
1. Cache pub, Gradle, and CocoaPods dependencies separately
2. Use cache key tied to lock files for precise invalidation
3. Use policy: pull on read-only jobs for speed
4. Use 'changes:' to skip builds when platform files haven't changed
5. Use 'needs:' (DAG) to break stage barriers and parallelize
6. Mark jobs as interruptible to cancel stale pipelines
7. Optimize order: cheapest/fastest stages first
8. 50%+ time reduction is realistic with proper optimization
```

---
---

# MODULE 9: Automated Testing Strategy

---

## 9.1 — The Testing Pyramid in CI

```
                           /\
                          /  \         Integration/E2E Tests
                         / 5% \        Run: before release (tags)
                        /──────\       Time: 10-30 min
                       /  Widget \     Run: on MRs + main
                      /   Tests   \    Time: 1-3 min
                     /    25%      \
                    /────────────────\
                   /    Unit Tests    \  Run: every push
                  /       70%         \ Time: 30s-2min
                 /────────────────────/
```

---

## 9.2 — Unit Tests in CI

```yaml
unit_tests:
  stage: test
  script:
    - flutter test test/unit/ --coverage --tags unit
  coverage: '/lines\.+: (\d+\.\d+)%/'
  artifacts:
    reports:
      junit: test-results.xml
  rules:
    - when: always    # Run on EVERY push
```

---

## 9.3 — Widget Tests in CI

```yaml
widget_tests:
  stage: test
  script:
    - flutter test test/widget/ --tags widget
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 9.4 — Integration Tests in CI

Integration tests require a running device/emulator:

```yaml
integration_tests:
  stage: test
  tags:
    - macos                       # Need emulator support
  script:
    # Start iOS simulator
    - xcrun simctl boot "iPhone 15"

    # Run integration tests
    - flutter test integration_test/
        --device-id=$(xcrun simctl list devices booted -j
          | jq -r '.devices[][] | select(.state=="Booted") | .udid')

  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
  allow_failure: true             # Flaky by nature
  retry:
    max: 2
```

### Android Emulator Alternative

```yaml
integration_tests_android:
  stage: test
  image: ghcr.io/cirruslabs/android-sdk:34
  script:
    # Create and start emulator
    - sdkmanager "system-images;android-34;google_apis;x86_64"
    - avdmanager create avd -n test -k "system-images;android-34;google_apis;x86_64"
    - emulator -avd test -no-window -no-audio &
    - adb wait-for-device

    # Run tests
    - flutter test integration_test/
  tags:
    - docker-kvm                  # Needs KVM for emulator acceleration
```

---

## 9.5 — Golden Tests in CI

Golden (screenshot) tests compare rendered widgets against reference images:

```yaml
golden_tests:
  stage: test
  script:
    - flutter test --tags golden --update-goldens=false
  artifacts:
    when: on_failure              # Only save on failure!
    paths:
      - test/**/failures/*.png    # Shows actual vs expected
    expire_in: 7 days
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

# Separate job to update goldens (manual trigger)
update_goldens:
  stage: test
  script:
    - flutter test --tags golden --update-goldens
    - git add test/**/goldens/
    - git commit -m "chore: update golden files"
    - git push
  when: manual
```

---

## 9.6 — Test Reports in GitLab

```yaml
test:
  script:
    - flutter test --machine > machine_output.json
    # Convert to JUnit XML format
    - dart run junitreport --input machine_output.json --output test-report.xml
  artifacts:
    reports:
      junit: test-report.xml     # GitLab shows results in MR!
```

GitLab MR will show:
```
Test Summary:
  142 passed, 0 failed, 3 new
  
  New tests:
  ✅ AuthService - login returns user on valid credentials
  ✅ AuthService - login throws on invalid credentials
  ✅ ProfileWidget - displays user name
```

---

## 9.7 — Module 9 Summary

```
1. Follow the testing pyramid: 70% unit, 25% widget, 5% integration
2. Unit tests on every push, widget tests on MRs, integration before release
3. Use JUnit reports for GitLab MR test summaries
4. Golden tests catch UI regressions visually
5. Integration tests need real devices/emulators — use macOS runners
6. Use retry for inherently flaky integration tests
7. Save failure artifacts only (when: on_failure) to save storage
```

---
---

# MODULE 10: Code Signing (Android Keystore & iOS Certificates)

---

## 10.1 — Why Code Signing Matters

```
Without signing:
  ❌ Users can't install your app
  ❌ Stores reject your upload
  ❌ Users get "untrusted developer" warnings

With signing:
  ✅ Cryptographic proof you built this app
  ✅ Guaranteed the app hasn't been tampered with
  ✅ Stores accept your upload
```

---

## 10.2 — Android Code Signing in CI

### Step 1: Create Your Keystore (one-time, local)

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -alias upload
```

### Step 2: Store Keystore in GitLab CI Variables

```
GitLab → Settings → CI/CD → Variables

1. ANDROID_KEYSTORE (Type: File)
   Value: [upload the .jks file]

2. ANDROID_KEYSTORE_PASSWORD (Type: Variable, Masked)
   Value: your_keystore_password

3. ANDROID_KEY_ALIAS (Type: Variable)
   Value: upload

4. ANDROID_KEY_PASSWORD (Type: Variable, Masked)
   Value: your_key_password
```

### Step 3: Configure Gradle

```groovy
// android/app/build.gradle
android {
    signingConfigs {
        release {
            storeFile file(System.getenv("ANDROID_KEYSTORE") ?: "../upload-keystore.jks")
            storePassword System.getenv("ANDROID_KEYSTORE_PASSWORD") ?: ""
            keyAlias System.getenv("ANDROID_KEY_ALIAS") ?: "upload"
            keyPassword System.getenv("ANDROID_KEY_PASSWORD") ?: ""
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Step 4: CI Job

```yaml
build_signed_apk:
  stage: build
  script:
    - flutter build apk --release
        --build-number=$CI_PIPELINE_IID
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
```

The Gradle config reads the environment variables that GitLab injects automatically.

---

## 10.3 — iOS Code Signing in CI

iOS signing is more complex. You need:

```
1. Distribution Certificate (.p12)   → Proves YOUR identity
2. Provisioning Profile (.mobileprovision) → Links cert + app ID + devices
3. Keychain setup                      → macOS stores certs in keychains
```

### Step 1: Store in GitLab CI Variables

```
APPLE_CERTIFICATE_P12 (Type: File)        → Your .p12 file
APPLE_CERTIFICATE_PASSWORD (Masked)       → Password for .p12
PROVISIONING_PROFILE (Type: File)         → Your .mobileprovision
KEYCHAIN_PASSWORD (Masked)                → A random password for temp keychain
```

### Step 2: CI Job

```yaml
build_signed_ipa:
  stage: build
  tags:
    - macos
  script:
    # Create temporary keychain
    - security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
    - security default-keychain -s build.keychain
    - security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
    - security set-keychain-settings -t 3600 -u build.keychain

    # Import certificate
    - security import "$APPLE_CERTIFICATE_P12" \
        -k build.keychain \
        -P "$APPLE_CERTIFICATE_PASSWORD" \
        -T /usr/bin/codesign
    - security set-key-partition-list -S apple-tool:,apple: \
        -s -k "$KEYCHAIN_PASSWORD" build.keychain

    # Install provisioning profile
    - mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
    - cp "$PROVISIONING_PROFILE" ~/Library/MobileDevice/Provisioning\ Profiles/

    # Build
    - flutter build ipa --release
        --build-number=$CI_PIPELINE_IID
        --export-options-plist=ios/ExportOptions.plist

  after_script:
    # ALWAYS clean up the keychain
    - security delete-keychain build.keychain

  artifacts:
    paths:
      - build/ios/ipa/*.ipa
```

---

## 10.4 — Using Fastlane Match (Recommended for Teams)

Fastlane Match stores certificates in a Git repo or cloud storage, making
team signing seamless:

```yaml
build_ios_with_match:
  tags:
    - macos
  variables:
    MATCH_GIT_URL: $MATCH_REPO_URL
    MATCH_PASSWORD: $MATCH_ENCRYPTION_PASSWORD
    FASTLANE_USER: $APPLE_ID
  script:
    - cd ios
    - bundle exec fastlane match appstore --readonly
    - cd ..
    - flutter build ipa --release
        --export-options-plist=ios/ExportOptions.plist
```

---

## 10.5 — Module 10 Summary

```
1. Android signing: keystore file + passwords in CI variables
2. Configure Gradle to read from environment variables
3. iOS signing: certificate (.p12) + provisioning profile + temp keychain
4. ALWAYS clean up keychains in after_script
5. Use File type variables for binary files (keystore, certificates)
6. Mask password variables to hide from logs
7. Protect variables to limit to protected branches
8. Consider Fastlane Match for team iOS signing
```

---
---

# MODULE 11: Automated Deployment

---

## 11.1 — Deployment Targets for Flutter

```
┌────────────────────────────────────────────────────────────┐
│                  DEPLOYMENT TARGETS                          │
│                                                             │
│  Testing:                                                   │
│  ├── Firebase App Distribution  → Android + iOS testers     │
│  ├── TestFlight                 → iOS testers               │
│  └── Internal track (Play)     → Android testers            │
│                                                             │
│  Production:                                                │
│  ├── Google Play Store          → Android users             │
│  ├── Apple App Store            → iOS users                 │
│  └── Web hosting (Pages, S3)   → Web users                 │
└────────────────────────────────────────────────────────────┘
```

---

## 11.2 — Firebase App Distribution

```yaml
deploy_android_firebase:
  stage: deploy
  image: ghcr.io/cirruslabs/flutter:stable
  needs: ["build_android_release"]
  script:
    - npm install -g firebase-tools
    - firebase appdistribution:distribute
        build/app/outputs/flutter-apk/app-release.apk
        --app "$FIREBASE_ANDROID_APP_ID"
        --groups "internal-testers"
        --release-notes "Build $CI_PIPELINE_IID from $CI_COMMIT_SHORT_SHA"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: manual                # Click to deploy

deploy_ios_firebase:
  stage: deploy
  tags:
    - macos
  needs: ["build_ios"]
  script:
    - npm install -g firebase-tools
    - firebase appdistribution:distribute
        build/ios/ipa/Runner.ipa
        --app "$FIREBASE_IOS_APP_ID"
        --groups "internal-testers"
        --release-notes "Build $CI_PIPELINE_IID"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: manual
```

---

## 11.3 — Google Play Store Deployment

```yaml
deploy_play_store:
  stage: deploy
  needs: ["build_android_aab"]
  image: ruby:3.2
  script:
    - gem install fastlane
    - |
      cat > /tmp/play-store-key.json << EOF
      $PLAY_STORE_SERVICE_ACCOUNT_JSON
      EOF
    - fastlane supply
        --aab build/app/outputs/bundle/release/app-release.aab
        --json_key /tmp/play-store-key.json
        --package_name com.yourcompany.yourapp
        --track internal           # internal → alpha → beta → production
        --release_status draft
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
      when: manual
```

### Play Store Tracks

```
internal  →  closed testing  →  open testing  →  production
(fastest)     (alpha)            (beta)           (requires review)

You can promote between tracks without rebuilding!
```

---

## 11.4 — TestFlight (iOS) Deployment

```yaml
deploy_testflight:
  stage: deploy
  tags:
    - macos
  needs: ["build_ios"]
  script:
    - xcrun altool --upload-app
        --type ios
        --file build/ios/ipa/Runner.ipa
        --apiKey "$APP_STORE_API_KEY_ID"
        --apiIssuer "$APP_STORE_API_ISSUER_ID"
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
      when: manual
```

### Using App Store Connect API Key

```
GitLab Variables:
  APP_STORE_API_KEY_ID       → Key ID from App Store Connect
  APP_STORE_API_ISSUER_ID    → Issuer ID
  APP_STORE_API_KEY_FILE     → (File type) AuthKey_XXXXX.p8
```

---

## 11.5 — Web Deployment

### GitLab Pages (Free)

```yaml
pages:
  stage: deploy
  needs: ["build_web"]
  script:
    - cp -r build/web public
  artifacts:
    paths:
      - public
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

### Firebase Hosting

```yaml
deploy_web_firebase:
  stage: deploy
  needs: ["build_web"]
  script:
    - npm install -g firebase-tools
    - firebase deploy --only hosting --token "$FIREBASE_TOKEN"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 11.6 — Deployment Environments in GitLab

```yaml
deploy_staging:
  stage: deploy
  environment:
    name: staging
    url: https://staging.yourapp.com
  script:
    - firebase deploy --only hosting:staging

deploy_production:
  stage: deploy
  environment:
    name: production
    url: https://yourapp.com
  script:
    - firebase deploy --only hosting:production
  when: manual
```

GitLab tracks deployment history per environment:

```
Deployments → Environments:
  staging:     v1.2.3 (deployed 2 hours ago by Ahmed)
  production:  v1.2.2 (deployed 3 days ago by Sarah)
```

---

## 11.7 — Module 11 Summary

```
1. Firebase App Distribution: easiest for both Android + iOS testing
2. Play Store: use Fastlane supply with service account JSON
3. TestFlight: use xcrun altool with App Store Connect API key
4. Web: GitLab Pages (free) or Firebase Hosting
5. Use 'when: manual' for production deploys (Continuous Delivery)
6. Use 'needs:' to connect deploy jobs to specific build jobs
7. Use GitLab environments to track deployment history
8. Play Store tracks: internal → closed → open → production
```

---
---

# PART 4 — ADVANCED

---
---

# MODULE 12: GitLab Runners (Deep Dive)

---

## 12.1 — Runner Architecture

```
┌──────────────────────────────────────────────────────┐
│                    GITLAB.COM                          │
│                                                       │
│  Pipeline Engine ──▶ "I need a runner with tag: macos"│
│                                                       │
└──────────────────────┬────────────────────────────────┘
                       │
         ┌─────────────┼─────────────────┐
         │             │                 │
    ┌────▼────┐  ┌─────▼─────┐  ┌───────▼───────┐
    │ Shared  │  │ Group     │  │ Project-      │
    │ Runner  │  │ Runner    │  │ specific      │
    │         │  │           │  │ Runner        │
    │ Anyone  │  │ Shared in │  │ Only THIS     │
    │ can use │  │ your group│  │ project       │
    └─────────┘  └───────────┘  └───────────────┘
```

---

## 12.2 — Setting Up a Self-Hosted macOS Runner

This is essential for iOS builds:

```bash
# Step 1: Install GitLab Runner on macOS
brew install gitlab-runner

# Step 2: Register the runner
gitlab-runner register \
  --url https://gitlab.com/ \
  --registration-token YOUR_PROJECT_TOKEN \
  --executor shell \
  --description "macOS Builder" \
  --tag-list "macos,xcode-15,ios" \
  --run-untagged=false

# Step 3: Install as a service
gitlab-runner install
gitlab-runner start

# Step 4: Verify
gitlab-runner verify
```

### macOS Runner Prerequisites

```bash
# Install on the macOS runner machine:
xcode-select --install
brew install flutter
brew install cocoapods
sudo gem install fastlane

# Accept Xcode license
sudo xcodebuild -license accept
```

---

## 12.3 — Docker Runner for Android

```bash
# Register a Docker runner
gitlab-runner register \
  --url https://gitlab.com/ \
  --registration-token YOUR_TOKEN \
  --executor docker \
  --docker-image ghcr.io/cirruslabs/flutter:stable \
  --description "Linux Docker Builder" \
  --tag-list "docker,linux,android"
```

### Runner Configuration (`config.toml`)

```toml
[[runners]]
  name = "Linux Docker Builder"
  executor = "docker"
  [runners.docker]
    image = "ghcr.io/cirruslabs/flutter:stable"
    privileged = false
    volumes = [
      "/cache",
      "/var/run/docker.sock:/var/run/docker.sock"
    ]
    shm_size = 0
    # Resource limits
    cpus = "4"
    memory = "8g"
```

---

## 12.4 — Runner Fleet Strategy

```
Recommended Setup for Flutter Teams:
─────────────────────────────────────

│ Runner        │ Type    │ Executor │ Tags          │ Purpose          │
├───────────────┼─────────┼──────────┼───────────────┼──────────────────┤
│ Shared        │ GitLab  │ Docker   │ (none needed) │ Lint, test       │
│ Linux Docker  │ Self    │ Docker   │ docker,linux  │ Android builds   │
│ macOS Shell   │ Self    │ Shell    │ macos,ios     │ iOS builds       │
│ macOS Shell 2 │ Self    │ Shell    │ macos,ios     │ Parallel iOS     │
```

---

## 12.5 — Module 12 Summary

```
1. Shared runners: free, easy, Linux only, limited minutes
2. Self-hosted: unlimited, any OS, you maintain them
3. macOS runners: REQUIRED for iOS, use shell executor
4. Docker runners: RECOMMENDED for Android/web, clean environments
5. Tags route jobs to correct runners
6. Register runners via gitlab-runner register
7. config.toml controls runner behavior and resource limits
8. Plan your runner fleet based on team size and build volume
```

---
---

# MODULE 13: Multi-Stage, Multi-Platform Pipelines

---

## 13.1 — The Complete Flutter Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRODUCTION PIPELINE                            │
│                                                                  │
│  .pre         analyze       test        build          deploy   │
│  ┌─────┐    ┌────────┐   ┌──────┐   ┌───────────┐   ┌───────┐ │
│  │deps │───▶│lint    │──▶│unit  │──▶│android_apk│──▶│firebase│ │
│  │     │    │format  │   │widget│   │android_aab│   │play   │ │
│  └─────┘    └────────┘   └──────┘   │ios_ipa    │   │testfl │ │
│                                      │web        │   │pages  │ │
│                                      └───────────┘   └───────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## 13.2 — Using `include` for Modular Pipelines

Split your pipeline across multiple files:

```
.gitlab/
├── ci/
│   ├── analyze.yml
│   ├── test.yml
│   ├── build-android.yml
│   ├── build-ios.yml
│   ├── build-web.yml
│   └── deploy.yml
└── .gitlab-ci.yml        ← Main file includes others
```

```yaml
# .gitlab-ci.yml (root)
include:
  - local: '.gitlab/ci/analyze.yml'
  - local: '.gitlab/ci/test.yml'
  - local: '.gitlab/ci/build-android.yml'
  - local: '.gitlab/ci/build-ios.yml'
  - local: '.gitlab/ci/build-web.yml'
  - local: '.gitlab/ci/deploy.yml'

stages:
  - analyze
  - test
  - build
  - deploy

image: ghcr.io/cirruslabs/flutter:stable

variables:
  PUB_CACHE: "$CI_PROJECT_DIR/.pub-cache"
```

```yaml
# .gitlab/ci/analyze.yml
lint:
  stage: analyze
  script:
    - flutter pub get
    - flutter analyze --fatal-warnings
    - dart format --set-exit-if-changed .
```

---

## 13.3 — Parent-Child Pipelines

For complex projects, trigger separate pipelines:

```yaml
# .gitlab-ci.yml
stages:
  - analyze
  - test
  - triggers

trigger_android:
  stage: triggers
  trigger:
    include: .gitlab/ci/android-pipeline.yml
    strategy: depend        # Parent waits for child
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

trigger_ios:
  stage: triggers
  trigger:
    include: .gitlab/ci/ios-pipeline.yml
    strategy: depend
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 13.4 — Module 13 Summary

```
1. Use include: local for modular pipeline files
2. Split by concern: analyze, test, build-android, build-ios, deploy
3. Parent-child pipelines for complex, multi-platform builds
4. Use needs: (DAG) to parallelize across platforms
5. strategy: depend makes parent wait for child pipeline
6. Modular pipelines = easier to maintain, review, and debug
```

---
---

# MODULE 14: Security Scanning, Dependency Checks & SAST

---

## 14.1 — Security in Your Pipeline

```
┌──────────────────────────────────────────────────────┐
│              SECURITY SCANNING LAYERS                  │
│                                                       │
│  Layer 1: Dependency Scanning                         │
│  → Known vulnerabilities in packages (pub, npm)       │
│                                                       │
│  Layer 2: SAST (Static Application Security Testing)  │
│  → Security bugs in YOUR code                         │
│                                                       │
│  Layer 3: Secret Detection                            │
│  → Accidentally committed API keys, passwords         │
│                                                       │
│  Layer 4: License Compliance                          │
│  → Ensure dependencies have compatible licenses       │
└──────────────────────────────────────────────────────┘
```

---

## 14.2 — Dependency Scanning

```yaml
dependency_scan:
  stage: analyze
  script:
    # Check for known vulnerabilities
    - dart pub global activate osv_scanner
    - osv-scanner --lockfile=pubspec.lock || true

    # Check for outdated packages
    - flutter pub outdated --json > outdated-report.json

  artifacts:
    paths:
      - outdated-report.json
    expire_in: 7 days
  allow_failure: true    # Advisory at first
```

---

## 14.3 — Secret Detection

```yaml
secret_detection:
  stage: analyze
  image: alpine:latest
  script:
    # Check for common secret patterns
    - apk add --no-cache grep
    - |
      echo "Scanning for potential secrets..."
      PATTERNS=(
        'AKIA[0-9A-Z]{16}'           # AWS Access Key
        'AIza[0-9A-Za-z\\-_]{35}'    # Google API Key
        'sk-[a-zA-Z0-9]{48}'         # OpenAI Key
        'password\s*=\s*["\047][^"]+' # Hardcoded passwords
      )
      FOUND=0
      for pattern in "${PATTERNS[@]}"; do
        if grep -rn "$pattern" lib/ --include="*.dart" 2>/dev/null; then
          echo "⚠️ Potential secret found matching: $pattern"
          FOUND=1
        fi
      done
      if [ $FOUND -eq 1 ]; then
        echo "❌ Potential secrets detected! Review the above findings."
        exit 1
      fi
      echo "✅ No secrets detected"
  allow_failure: true
```

---

## 14.4 — GitLab Built-In Security (Ultimate Tier)

If you have GitLab Ultimate:

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml
  - template: Security/License-Scanning.gitlab-ci.yml
```

These templates automatically scan your code and report findings in the MR.

---

## 14.5 — Module 14 Summary

```
1. Dependency scanning catches known vulnerabilities in packages
2. Secret detection prevents accidentally committed credentials
3. SAST finds security bugs in your code patterns
4. License scanning ensures dependency license compatibility
5. Start with allow_failure: true (advisory), then enforce
6. GitLab Ultimate has built-in templates for all scanning types
7. Custom scripts work on all GitLab tiers
```

---
---

# MODULE 15: Monorepo Strategies & Pipeline-as-Code Patterns

---

## 15.1 — Monorepo Structure for Flutter

```
my_company/
├── .gitlab-ci.yml
├── apps/
│   ├── customer_app/
│   │   ├── pubspec.yaml
│   │   ├── lib/
│   │   └── test/
│   ├── admin_app/
│   │   ├── pubspec.yaml
│   │   ├── lib/
│   │   └── test/
│   └── driver_app/
│       ├── pubspec.yaml
│       ├── lib/
│       └── test/
└── packages/
    ├── core/
    ├── ui_kit/
    ├── api_client/
    └── auth/
```

---

## 15.2 — Monorepo Pipeline with `changes:`

```yaml
# Only build/test what changed
test_customer_app:
  script:
    - cd apps/customer_app && flutter test
  rules:
    - changes:
        - apps/customer_app/**/*
        - packages/**/*              # Shared packages affect all apps

test_admin_app:
  script:
    - cd apps/admin_app && flutter test
  rules:
    - changes:
        - apps/admin_app/**/*
        - packages/**/*

test_core_package:
  script:
    - cd packages/core && flutter test
  rules:
    - changes:
        - packages/core/**/*
```

---

## 15.3 — Using Melos for Monorepo CI

```yaml
# melos.yaml
name: my_company
packages:
  - apps/**
  - packages/**

scripts:
  analyze:
    run: melos exec -- flutter analyze
  test:
    run: melos exec -- flutter test
  test:selective:
    run: melos exec --since=origin/main -- flutter test
```

```yaml
# .gitlab-ci.yml with Melos
before_script:
  - dart pub global activate melos
  - melos bootstrap

test_affected:
  stage: test
  script:
    # Only test packages that changed since main
    - melos run test:selective
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

test_all:
  stage: test
  script:
    - melos run test
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 15.4 — Reusable Pipeline Templates

Create a shared CI template repository:

```yaml
# In a shared repo: flutter-ci-templates/.gitlab-ci-templates/flutter.yml

.flutter_analyze:
  stage: analyze
  script:
    - flutter pub get
    - flutter analyze --fatal-warnings
    - dart format --set-exit-if-changed .

.flutter_test:
  stage: test
  script:
    - flutter pub get
    - flutter test --coverage
  coverage: '/lines\.+: (\d+\.\d+)%/'

.flutter_build_android:
  stage: build
  script:
    - flutter pub get
    - flutter build apk --release --build-number=$CI_PIPELINE_IID
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
    expire_in: 30 days
```

```yaml
# In your project's .gitlab-ci.yml
include:
  - project: 'my-company/flutter-ci-templates'
    ref: main
    file: '/.gitlab-ci-templates/flutter.yml'

stages:
  - analyze
  - test
  - build

analyze:
  extends: .flutter_analyze

test:
  extends: .flutter_test

build:
  extends: .flutter_build_android
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 15.5 — Module 15 Summary

```
1. Use changes: to only build/test affected apps in monorepos
2. Melos automates monorepo management and selective testing
3. Shared CI templates DRY up pipeline code across projects
4. include: project lets you import from template repositories
5. extends: inherits from template jobs
6. Package changes should trigger all dependent app tests
```

---
---

# PART 5 — EXPERT

---
---

# MODULE 16: Release Management

---

## 16.1 — Semantic Versioning (SemVer)

```
        MAJOR . MINOR . PATCH
          │       │       │
          │       │       └── Bug fixes (no new features)
          │       └────────── New features (backward compatible)
          └────────────────── Breaking changes

Examples:
  1.0.0 → 1.0.1   (bug fix)
  1.0.1 → 1.1.0   (new feature)
  1.1.0 → 2.0.0   (breaking change)
```

---

## 16.2 — Git Tag-Based Releases

```bash
# Create a release
git tag -a v1.2.0 -m "Release 1.2.0: Added user profiles"
git push origin v1.2.0

# This triggers your release pipeline:
#   tag v1.2.0 → build AAB + IPA → deploy to stores
```

```yaml
# Pipeline triggered by version tags
release_build:
  stage: build
  script:
    # Extract version from tag
    - VERSION=${CI_COMMIT_TAG#v}     # v1.2.0 → 1.2.0
    - flutter build appbundle --release
        --build-name=$VERSION
        --build-number=$CI_PIPELINE_IID
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
```

---

## 16.3 — Automated Changelog Generation

```yaml
generate_changelog:
  stage: .pre
  script:
    - |
      echo "# Changelog for $CI_COMMIT_TAG" > CHANGELOG.md
      echo "" >> CHANGELOG.md
      echo "## Changes since last release:" >> CHANGELOG.md
      echo "" >> CHANGELOG.md
      # Get commits since last tag
      PREV_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")
      if [ -n "$PREV_TAG" ]; then
        git log $PREV_TAG..HEAD --pretty=format:"- %s (%h)" >> CHANGELOG.md
      else
        git log --pretty=format:"- %s (%h)" >> CHANGELOG.md
      fi
  artifacts:
    paths:
      - CHANGELOG.md
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
```

### Conventional Commits (Recommended)

Use structured commit messages for better changelogs:

```
feat: add user profile screen
fix: resolve login timeout issue
docs: update API documentation
chore: upgrade dependencies
refactor: simplify auth flow
test: add unit tests for cart service
ci: add iOS build to pipeline

Breaking changes:
feat!: redesign navigation to use GoRouter
```

---

## 16.4 — GitLab Releases

```yaml
create_release:
  stage: deploy
  image: registry.gitlab.com/gitlab-org/release-cli:latest
  script:
    - echo "Creating release for $CI_COMMIT_TAG"
  release:
    tag_name: $CI_COMMIT_TAG
    name: "Release $CI_COMMIT_TAG"
    description: './CHANGELOG.md'
    assets:
      links:
        - name: "Android APK"
          url: "https://gitlab.com/.../-/jobs/$BUILD_JOB_ID/artifacts/download"
        - name: "Web App"
          url: "https://yourapp.gitlab.io"
  rules:
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
```

---

## 16.5 — Complete Release Pipeline

```yaml
# Triggered by: git tag -a v1.2.0 -m "Release 1.2.0"

stages:
  - prepare
  - analyze
  - test
  - build
  - deploy
  - release

generate_changelog:
  stage: prepare
  script:
    - # ... generate changelog ...
  artifacts:
    paths:
      - CHANGELOG.md

lint:
  stage: analyze
  script:
    - flutter analyze --fatal-warnings

test:
  stage: test
  script:
    - flutter test

build_aab:
  stage: build
  script:
    - VERSION=${CI_COMMIT_TAG#v}
    - flutter build appbundle --release
        --build-name=$VERSION
        --build-number=$CI_PIPELINE_IID

build_ipa:
  stage: build
  tags:
    - macos
  script:
    - VERSION=${CI_COMMIT_TAG#v}
    - flutter build ipa --release
        --build-name=$VERSION
        --build-number=$CI_PIPELINE_IID
        --export-options-plist=ios/ExportOptions.plist

deploy_play_store:
  stage: deploy
  needs: ["build_aab"]
  script:
    - fastlane supply --aab ... --track internal
  when: manual

deploy_testflight:
  stage: deploy
  needs: ["build_ipa"]
  tags:
    - macos
  script:
    - xcrun altool --upload-app ...
  when: manual

create_gitlab_release:
  stage: release
  needs: ["deploy_play_store", "deploy_testflight"]
  release:
    tag_name: $CI_COMMIT_TAG
    description: './CHANGELOG.md'
```

---

## 16.6 — Module 16 Summary

```
1. Use Semantic Versioning (MAJOR.MINOR.PATCH) consistently
2. Git tags trigger release pipelines
3. Use conventional commits for automated changelogs
4. GitLab Releases attach artifacts and changelogs to tags
5. Extract version from tag: VERSION=${CI_COMMIT_TAG#v}
6. Release pipeline: prepare → analyze → test → build → deploy → release
7. Always manual gate on production deployments
```

---
---

# MODULE 17: GitOps, Feature Flags & Rollback Strategies

---

## 17.1 — GitOps for Flutter

**GitOps principle:** Git is the single source of truth for EVERYTHING —
code, configuration, infrastructure, and deployments.

```
┌─────────────────────────────────────────────────────┐
│                     GITOPS FLOW                      │
│                                                      │
│  Developer ──▶ Git Push ──▶ Pipeline ──▶ Deploy      │
│                                                      │
│  Want to deploy v1.2.0?     → git tag v1.2.0        │
│  Want to rollback?          → git revert + push     │
│  Want to change config?     → edit YAML + push      │
│  Want to audit deployments? → git log               │
│                                                      │
│  Everything is tracked. Everything is reversible.    │
└─────────────────────────────────────────────────────┘
```

---

## 17.2 — Feature Flags

Feature flags let you deploy code without activating it:

```dart
// In your Flutter app
class FeatureFlags {
  static bool get newCheckout =>
    RemoteConfig.getBool('feature_new_checkout');

  static bool get darkMode =>
    RemoteConfig.getBool('feature_dark_mode');
}

// Usage
if (FeatureFlags.newCheckout) {
  return NewCheckoutScreen();
} else {
  return OldCheckoutScreen();
}
```

### Benefits for CI/CD:
```
1. Deploy to production with feature OFF
2. Enable for 5% of users (canary)
3. Monitor crash rates and metrics
4. Gradually roll out to 100%
5. If problems → disable flag instantly (no redeploy!)
```

### Feature Flag Providers:
```
- Firebase Remote Config (free, popular for Flutter)
- LaunchDarkly (enterprise)
- Unleash (open source)
- ConfigCat
```

---

## 17.3 — Rollback Strategies

### Strategy 1: Git Revert (Simplest)

```bash
# Find the bad commit
git log --oneline

# Revert it
git revert abc123d
git push origin main
# Pipeline runs → new build deployed → problem fixed
```

### Strategy 2: Redeploy Previous Tag

```bash
# Rerun the pipeline for the previous good tag
# GitLab UI → CI/CD → Pipelines → Find v1.1.0 pipeline → Retry
```

### Strategy 3: Play Store / TestFlight Rollback

```
Google Play Console:
  Releases → Select track → "Halt rollout" or
  Release new version with previous APK

App Store Connect:
  Remove current version from sale →
  Previous version becomes active
```

### Strategy 4: Feature Flag Kill Switch

```
Firebase Remote Config:
  feature_broken_thing: false    ← Instant disable, no deploy needed
```

---

## 17.4 — Canary Deployments for Mobile

```
Traditional:
  v1.1.0 (100% users) ──▶ v1.2.0 (100% users)
  Risk: If v1.2.0 is buggy, ALL users affected

Canary:
  v1.1.0 (100%) ──▶ v1.2.0 (5%) ──▶ v1.2.0 (25%) ──▶ v1.2.0 (100%)
  Risk: If v1.2.0 is buggy, only 5% affected, then rollback
```

Google Play Store supports staged rollouts natively:

```yaml
deploy_canary:
  script:
    - fastlane supply
        --aab app-release.aab
        --track production
        --rollout 0.05               # 5% of users
  when: manual

deploy_full:
  script:
    - fastlane supply
        --track production
        --rollout 1.0                # 100% of users
  when: manual
  needs: ["deploy_canary"]
```

---

## 17.5 — Module 17 Summary

```
1. GitOps: Git is the single source of truth for everything
2. Feature flags: deploy code without activating it
3. Rollback options: git revert, redeploy tag, store rollback, feature flag
4. Canary deployments: staged rollout to 5% → 25% → 100%
5. Play Store supports staged rollouts natively
6. Feature flags enable instant rollback without redeployment
7. Always have a rollback plan BEFORE deploying
```

---
---

# MODULE 18: Designing CI/CD for a Team — Best Practices & Decision Framework

---

## 18.1 — The Decision Framework

When designing CI/CD for your team, answer these questions:

```
┌───────────────────────────────────────────────────────────────┐
│              CI/CD DESIGN DECISION FRAMEWORK                   │
│                                                                │
│  1. TEAM SIZE                                                  │
│     Solo / 2-3 / 4-10 / 10+                                   │
│                                                                │
│  2. PLATFORMS                                                  │
│     Android only / iOS only / Both / Both + Web                │
│                                                                │
│  3. RELEASE CADENCE                                            │
│     Weekly / Bi-weekly / Monthly / On-demand                   │
│                                                                │
│  4. ENVIRONMENTS                                               │
│     Dev only / Dev + Staging / Dev + Staging + Prod            │
│                                                                │
│  5. BUDGET                                                     │
│     Free tier / Small ($50-200/mo) / Medium ($200-1000/mo)     │
│                                                                │
│  6. iOS BUILDS                                                 │
│     Not needed / Occasional / Every pipeline                   │
│                                                                │
│  7. SECURITY REQUIREMENTS                                      │
│     Basic / Moderate / Strict (HIPAA, SOC2)                    │
└───────────────────────────────────────────────────────────────┘
```

---

## 18.2 — Starter Template (Solo / Small Team)

```yaml
# For: 1-3 developers, Android + Web, monthly releases
image: ghcr.io/cirruslabs/flutter:stable

stages:
  - check
  - build

cache:
  key:
    files:
      - pubspec.lock
  paths:
    - .pub-cache/

before_script:
  - export PUB_CACHE="$CI_PROJECT_DIR/.pub-cache"
  - flutter pub get

check:
  stage: check
  script:
    - flutter analyze --fatal-warnings
    - dart format --set-exit-if-changed .
    - flutter test --coverage
  coverage: '/lines\.+: (\d+\.\d+)%/'

build:
  stage: build
  script:
    - flutter build apk --release --build-number=$CI_PIPELINE_IID
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
    expire_in: 14 days
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

---

## 18.3 — Standard Template (Medium Team)

```yaml
# For: 4-10 developers, Android + iOS + Web, bi-weekly releases

include:
  - local: '.gitlab/ci/analyze.yml'
  - local: '.gitlab/ci/test.yml'
  - local: '.gitlab/ci/build.yml'
  - local: '.gitlab/ci/deploy.yml'

stages:
  - analyze
  - test
  - build
  - deploy

workflow:
  auto_cancel:
    on_new_commit: interruptible

variables:
  PUB_CACHE: "$CI_PROJECT_DIR/.pub-cache"
```

---

## 18.4 — Enterprise Template (Large Team)

```yaml
# For: 10+ developers, all platforms, weekly releases, strict security

include:
  - project: 'company/ci-templates'
    ref: main
    file: '/flutter/pipeline.yml'
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml

stages:
  - prepare
  - analyze
  - security
  - test
  - build
  - deploy-staging
  - verify-staging
  - deploy-production
  - release

workflow:
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH == "main"'
    - if: '$CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/'
```

---

## 18.5 — Best Practices Checklist

```
PIPELINE DESIGN
  ✅ Fail fast: cheapest checks first (format → analyze → test → build)
  ✅ Build once, deploy many: same artifact to staging then production
  ✅ Pipeline as code: .gitlab-ci.yml reviewed like app code
  ✅ Modular: split into include files for maintainability
  ✅ Interruptible: cancel stale pipelines on new pushes

SECURITY
  ✅ Never commit secrets to the repository
  ✅ Use masked + protected variables for all credentials
  ✅ Use File type variables for keystores and certificates
  ✅ Clean up keychains and temporary files in after_script
  ✅ Scan dependencies for known vulnerabilities

EFFICIENCY
  ✅ Cache pub, Gradle, and CocoaPods dependencies
  ✅ Use cache keys tied to lock files
  ✅ Use 'changes:' to skip unnecessary builds
  ✅ Use 'needs:' (DAG) for parallel execution
  ✅ Set artifact expiry to manage storage

QUALITY
  ✅ Enforce formatting (dart format --set-exit-if-changed)
  ✅ Enforce analysis (flutter analyze --fatal-warnings minimum)
  ✅ Require pipeline success for merging
  ✅ Protected branches (no direct push to main)
  ✅ Coverage reporting (aim for 80%+)

DEPLOYMENT
  ✅ Manual gate for production deployments
  ✅ Use GitLab environments to track deployment history
  ✅ Staged rollouts for production (5% → 25% → 100%)
  ✅ Always have a rollback plan
  ✅ Use feature flags for safe deployments

TEAM
  ✅ Document your CI/CD setup in the project README
  ✅ Onboard new developers with pipeline walkthrough
  ✅ Monitor pipeline duration and optimize regularly
  ✅ Review CI/CD configuration in code reviews
  ✅ Use shared templates across projects for consistency
```

---

## 18.6 — Pipeline Maturity Model

```
LEVEL 1 — BASIC (Week 1-2)
  ├── .gitlab-ci.yml exists
  ├── flutter analyze runs on push
  ├── flutter test runs on MRs
  └── APK builds on main branch

LEVEL 2 — STANDARDIZED (Month 1)
  ├── All Level 1 items
  ├── Format enforcement
  ├── Coverage reporting
  ├── Pipeline must succeed for merge
  ├── Protected branches
  └── Cache optimization

LEVEL 3 — AUTOMATED (Month 2-3)
  ├── All Level 2 items
  ├── Automated code signing
  ├── Firebase App Distribution deployment
  ├── Multiple flavors/environments
  ├── Test reports in MRs
  └── Coverage threshold enforcement

LEVEL 4 — OPTIMIZED (Month 3-6)
  ├── All Level 3 items
  ├── Multi-platform builds (Android + iOS + Web)
  ├── Modular pipeline (include files)
  ├── DAG pipeline (needs)
  ├── Self-hosted runners (macOS for iOS)
  └── Store deployment automation

LEVEL 5 — EXPERT (Month 6+)
  ├── All Level 4 items
  ├── Security scanning (SAST, dependencies, secrets)
  ├── Shared CI templates across projects
  ├── Canary deployments with staged rollouts
  ├── Feature flag integration
  ├── Automated changelog and GitLab releases
  └── Monitoring and pipeline analytics
```

---

## 18.7 — Troubleshooting Guide

### Common Pipeline Failures

```
PROBLEM: "flutter: command not found"
CAUSE:   Wrong Docker image
FIX:     image: ghcr.io/cirruslabs/flutter:stable

PROBLEM: "No space left on device"
CAUSE:   Runner disk full (large cache + artifacts)
FIX:     Clean up old artifacts, reduce cache, add disk space

PROBLEM: "Certificate not found" (iOS)
CAUSE:   Keychain not set up correctly
FIX:     Check security create-keychain + import steps

PROBLEM: Pipeline runs twice on MR
CAUSE:   Both push and MR triggers firing
FIX:     Use workflow:rules to limit trigger types

PROBLEM: Cache not working
CAUSE:   Cache key mismatch or runner storage full
FIX:     Verify key matches, clear cache in GitLab UI

PROBLEM: Artifact not found in deploy job
CAUSE:   Different stages, artifacts not passed
FIX:     Check artifacts: paths in build job, use needs:

PROBLEM: "Gradle build daemon disappeared unexpectedly"
CAUSE:   Out of memory
FIX:     Add org.gradle.jvmargs=-Xmx4g to gradle.properties

PROBLEM: Pipeline stuck on "pending"
CAUSE:   No runner available with matching tags
FIX:     Check runner registration, verify tags match
```

---

## 18.8 — Cost Optimization Strategies

```
┌─────────────────────────────────────────────────────────────┐
│                  COST OPTIMIZATION                           │
│                                                              │
│  1. Run expensive jobs only when needed                      │
│     - iOS builds only on tags (not every push)               │
│     - Integration tests only before release                  │
│                                                              │
│  2. Use shared runners for cheap jobs                        │
│     - Lint, format, unit tests → shared Linux runner         │
│     - iOS builds → self-hosted macOS only                    │
│                                                              │
│  3. Cancel redundant pipelines                               │
│     - interruptible: true on non-deploy jobs                 │
│                                                              │
│  4. Cache aggressively                                       │
│     - pub cache, Gradle, CocoaPods                           │
│     - Cache key based on lock files                          │
│                                                              │
│  5. Skip unchanged platforms                                 │
│     - changes: to detect affected files                      │
│                                                              │
│  6. Optimize Docker images                                   │
│     - Use slim Flutter images where possible                 │
│     - Pre-bake dependencies in custom images                 │
│                                                              │
│  Free tier (400 min/month) is enough for:                    │
│  - Solo developer                                            │
│  - ~20 pipelines/day (if optimized to ~5 min each)          │
└─────────────────────────────────────────────────────────────┘
```

---

## 18.9 — Module 18 Summary & Course Conclusion

```
1. Design CI/CD based on team size, platforms, and release cadence
2. Start at Level 1 and progress gradually
3. Use the decision framework to make informed choices
4. Follow the best practices checklist for every project
5. Troubleshoot methodically using the common failures guide
6. Optimize costs by running expensive jobs only when needed
7. Document everything — your .gitlab-ci.yml IS the documentation
```

---

## COURSE CONCLUSION

```
┌──────────────────────────────────────────────────────────────┐
│                                                               │
│  Congratulations! You've completed the full course.           │
│                                                               │
│  You now understand:                                          │
│                                                               │
│  ✅ CI/CD fundamentals (pipeline, stages, jobs, runners)     │
│  ✅ GitLab CI/CD architecture and YAML syntax                │
│  ✅ Flutter-specific pipelines (analyze, test, build)        │
│  ✅ Quality gates (format, lint, coverage, metrics)          │
│  ✅ Multi-platform builds (Android, iOS, Web)                │
│  ✅ Flavors and environment management                       │
│  ✅ Pipeline optimization (cache, DAG, conditional builds)   │
│  ✅ Automated testing strategy                               │
│  ✅ Code signing for both platforms                          │
│  ✅ Automated deployment to stores                           │
│  ✅ Runner management (shared, self-hosted, macOS)           │
│  ✅ Modular pipeline architecture                            │
│  ✅ Security scanning                                        │
│  ✅ Monorepo strategies                                      │
│  ✅ Release management with SemVer and changelogs            │
│  ✅ GitOps, feature flags, and rollback strategies           │
│  ✅ Team pipeline design and decision frameworks             │
│                                                               │
│  Next Steps:                                                  │
│  1. Add a basic pipeline to one of your projects              │
│  2. Follow the maturity model (Level 1 → 2 → 3 → ...)       │
│  3. Each week, add one new capability                         │
│  4. Share what you learn with your team                       │
│                                                               │
│  The best CI/CD pipeline is one that your team actually uses. │
│  Start simple. Iterate. Improve.                              │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```
