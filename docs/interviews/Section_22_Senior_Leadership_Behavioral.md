# Section 22: Senior Engineer Leadership & Behavioral

---

## PART A: TECHNICAL LEADERSHIP

---

**Q:** How do you conduct a code review? What specifically do you look for?

**A:** A code review is not just a bug hunt — it's a quality gate, a teaching moment, and a shared ownership signal. I approach reviews in layers, from high-level architecture down to style.

**My review checklist (in priority order):**

```
LAYER 1 — Architecture & Design
├── Does this change belong where it's placed?
├── Does it introduce circular dependencies?
├── Is the responsibility correctly split (SRP)?
└── Will this scale when the data doubles?

LAYER 2 — Correctness
├── Are edge cases handled (null, empty, boundary)?
├── Are async operations awaited properly?
├── Are errors caught and communicated to the user?
└── Do streams get closed / disposed?

LAYER 3 — Flutter/Dart Specifics
├── Is setState() minimal — not rebuilding the whole tree?
├── Are heavy operations off the UI thread (compute/isolate)?
├── Are const constructors used where possible?
├── Are keys used correctly for list items?
└── Are BuildContext usages safe across async gaps?

LAYER 4 — Testability
├── Can this logic be tested without the UI?
├── Are dependencies injected (not hardcoded)?
└── Are side effects isolated?

LAYER 5 — Readability & Maintainability
├── Is naming clear and intention-revealing?
├── Is there dead code or unnecessary comments?
└── Are magic numbers replaced with named constants?
```

**In practice — what I actually write in comments:**

```dart
// ❌ Code under review:
void loadUsers() async {
  setState(() { _loading = true; });
  final users = await userRepository.getAll();
  setState(() { 
    _users = users; 
    _loading = false; 
  });
}

// ✅ My review comment:
// Consider: if getAll() throws, _loading stays true forever.
// Wrap in try/catch and reset _loading in a finally block.
// Also: if this widget is disposed before await completes,
// setState() will throw. Guard with `if (mounted)`.

// Fixed version:
void loadUsers() async {
  setState(() { _loading = true; });
  try {
    final users = await userRepository.getAll();
    if (mounted) {
      setState(() { _users = users; });
    }
  } catch (e) {
    if (mounted) {
      setState(() { _error = e.toString(); });
    }
  } finally {
    if (mounted) {
      setState(() { _loading = false; });
    }
  }
}
```

**Tone matters.** I ask questions, not commands:
- ✅ "What happens here if the list is empty?"
- ✅ "Could we extract this into a separate widget to keep build() readable?"
- ❌ "This is wrong." (no explanation)
- ❌ "Why did you do it this way?" (sounds accusatory)

**Why it matters:** The interviewer is evaluating whether you can raise the quality bar without damaging team morale. Senior engineers review for systems-level thinking, not just syntax.

**Common mistake:** Candidates say "I check for bugs and style." That's junior-level. You must show architectural awareness, Flutter-specific pitfalls, and the ability to leave constructive, educational feedback.

---

**Q:** How do you mentor junior or mid-level Flutter developers?

**A:** Mentorship is about building independence, not dependency. My approach is deliberate and tailored to the individual's current level.

**Framework I follow:**

```
ASSESS → PAIR → GUIDE → DELEGATE → REVIEW → REPEAT

1. ASSESS:   Understand their gap (concepts? patterns? tooling?)
2. PAIR:     Sit with them on a real task (not a toy problem)
3. GUIDE:    Ask leading questions instead of giving answers
4. DELEGATE: Give them a real, scoped task with clear success criteria
5. REVIEW:   Review together — explain the WHY, not just the WHAT
6. REPEAT:   Increase complexity each cycle
```

**Concrete techniques I use:**

```dart
// Instead of fixing their code for them, I ask:
// "What does this Bloc state represent when the list is loading?"
// "What's the difference between StreamBuilder and FutureBuilder here?"
// "If this widget rebuilds 60 times per second, what cost does this have?"

// For mid-level devs, I assign architecture ownership:
// "You own the authentication flow — design the states, 
//  propose the folder structure, and present it to the team."
```

**Things I do concretely:**
- Weekly 1:1s with a specific technical topic each week
- Pair program on their hardest task of the week (not mine)
- Share annotated PRs explaining the reasoning behind my suggestions
- Recommend specific Flutter resources tied to their current task
- Give them a feature to own end-to-end — including testing and deployment

**What I avoid:**
- Doing the work for them (removes the learning)
- Overwhelming them with everything at once
- Only mentoring through code review (not enough context-sharing)

**Why it matters:** Senior engineers multiply the team's output. Interviewers want to see that you invest in others, not just your own code.

**Common mistake:** Candidates say "I answer their questions when they come to me." That's reactive, not mentorship. Real mentorship is proactive, structured, and has measurable outcomes.

---

**Q:** How do you handle a technical disagreement with a teammate or architect?

**A:** Disagreements handled well are healthy — they surface better solutions. The goal is not to win the argument, but to reach the best technical decision for the product.

**My process:**

```
STEP 1: Understand their position fully first
  → "Help me understand the reasoning behind this approach."
  → Listen without interrupting. You might be missing context.

STEP 2: Articulate your concern clearly, with evidence
  → Not: "I don't like it."
  → Yes: "My concern is X. Here's a scenario where it breaks: Y."

STEP 3: Propose a concrete alternative or experiment
  → "What if we tried Z? We could spike it in a day and compare."

STEP 4: Use objective criteria to evaluate
  → Performance benchmarks, maintainability, test coverage, 
    Flutter/Dart best practices documentation

STEP 5: Defer or escalate appropriately
  → If it's reversible and low-risk → defer to them and revisit
  → If it's a significant architectural risk → escalate calmly
    with documented concerns (ADR or written proposal)
```

**Example — real scenario:**

```
Disagreement: Architect wanted to use GetX for state management.
My concern: GetX mixes routing, DI, and state management — 
            violates separation of concerns, harder to test.

What I did:
1. Listened — understood they wanted simplicity for the team
2. Wrote a 1-page comparison: GetX vs BLoC vs Riverpod
3. Proposed a 2-day spike: implement the login flow in both
4. Brought metrics: test coverage, lines of code, readability score
5. Team voted on the evidence — we went with Riverpod

Key: I never made it personal. It was always about the code.
```

**Why it matters:** Interviewers want to see emotional intelligence alongside technical depth. Can you push back without creating conflict?

**Common mistake:** Saying "I always defer to the architect" (no backbone) or "I make my case until they agree" (no collaboration). Neither is senior behavior.

---

**Q:** How do you introduce a new library or technology to your team?

**A:** New technology adoption is a risk management exercise, not just an excitement exercise. I follow a structured evaluation and introduction process.

**My adoption framework:**

```
PHASE 1 — EVALUATE (solo, before pitching)
├── Does it solve a real problem we have today?
├── Is it actively maintained? (GitHub activity, pub.dev score)
├── Is it compatible with our Flutter/Dart version?
├── What's the bundle size impact?
├── Does it have good test coverage?
└── Is there an escape hatch if we need to remove it?

PHASE 2 — SPIKE (small, bounded proof of concept)
├── Implement ONE real feature using the library
├── Document learnings, gotchas, limitations
└── Measure: did it actually improve things?

PHASE 3 — PROPOSAL (structured, written)
├── Write a short technical proposal or ADR
├── Pros, cons, alternatives considered
├── Migration path if we adopt
└── Present to the team — invite honest pushback

PHASE 4 — PHASED ROLLOUT
├── Introduce in one non-critical module first
├── Collect team feedback — is it intuitive?
├── Run a knowledge-sharing session / workshop
└── Document patterns in the team wiki
```

**Example:**

```dart
// Introducing go_router to replace Navigator 1.0

// SPIKE: Implemented the auth flow with go_router
// Discovered: redirect logic is much cleaner than nested Navigators
// Concern: Shell routes needed for bottom nav — tested it, worked well

// ADR written:
// Problem: Deep link handling was fragile with Navigator 1.0
// Solution: go_router with typed routes (go_router_builder)
// Tradeoff: Learning curve ~2 days per developer
// Decision: Adopt in new features, migrate old routes incrementally

// Knowledge session: 1-hour live coding session recorded for async team
```

**Why it matters:** Interviewers want to see that you don't chase trends — you adopt technology deliberately, with respect for team capacity and production risk.

**Common mistake:** "I just introduced it and documented it in the README." No evaluation criteria, no team involvement, no phased rollout — that's how you create resentment and fragile codebases.

---

**Q:** How do you manage and pay down technical debt?

**A:** Technical debt is not inherently bad — it's borrowed time that must be repaid deliberately. The problem is invisible, untracked, or indefinitely deferred debt.

**My approach:**

```
STEP 1: MAKE IT VISIBLE
  → Maintain a tech debt register (Jira label, Notion doc, or ADR)
  → Tag debt at creation: "// TODO(tech-debt): This is a workaround
    for [reason]. Tracked in TICKET-123."
  → Never let debt be invisible

STEP 2: CATEGORIZE BY RISK
  ┌─────────────┬──────────────────────────────────────┐
  │ Category    │ Action                               │
  ├─────────────┼──────────────────────────────────────┤
  │ Critical    │ Fix now — blocks features or causes  │
  │             │ production risk                      │
  ├─────────────┼──────────────────────────────────────┤
  │ High        │ Schedule in next sprint               │
  ├─────────────┼──────────────────────────────────────┤
  │ Medium      │ Address when touching related code   │
  ├─────────────┼──────────────────────────────────────┤
  │ Low         │ Batch into quarterly cleanup sprint  │
  └─────────────┴──────────────────────────────────────┘

STEP 3: BUDGET TIME CONSISTENTLY
  → Negotiate 20% of sprint capacity for debt (the "boy scout rule")
  → Never let it become 0% — that's how debt compounds

STEP 4: PAY IT DOWN INCREMENTALLY
  → The "boy scout rule": leave every file slightly better than you found it
  → Refactor while you're already in the file for a feature
  → Don't rewrite everything at once — that's high-risk
```

**Example — Flutter specific:**

```dart
// DEBT: setState() used everywhere, no separation of concerns
// MIGRATION STRATEGY (incremental, not big bang):

// Week 1: Extract business logic from the worst offender widget
// Week 2: Add a Cubit for that screen, keep the same UI
// Week 3: Add unit tests for the Cubit (now possible — wasn't before)
// Week 4: Move to next worst offender screen

// Not: "We're spending 2 months rewriting the whole app in Riverpod"
// That's how rewrites fail and never ship.
```

**Why it matters:** Interviewers want to see that you balance pragmatism with long-term health. They're testing whether you can influence non-technical stakeholders to invest in quality.

**Common mistake:** "We do a cleanup sprint once a year." That's too late and too disruptive. Or "I push back on all shortcuts" — that's unrealistic and ignores business realities.

---

**Q:** How do you balance speed of delivery vs code quality?

**A:** This is a false dichotomy when managed well. In the short term, cutting quality increases speed. In the medium term, it destroys it. The real skill is knowing when to make the tradeoff consciously — and making it visible.

**My mental model:**

```
QUALITY SPECTRUM:

Low Quality ◄──────────────────────────► High Quality
"Ship anything"                          "Ship nothing"
     ↑                                        ↑
  Dangerous                              Also dangerous

TARGET: Rightmost point that still ships on schedule
        with acceptable production risk
```

**My framework for each tradeoff decision:**

```
QUESTION 1: What is the cost of delay?
  → Is this a competitive feature? Time-sensitive launch?
  → If yes: accept more debt, document it, pay it back next sprint

QUESTION 2: What is the production risk of the shortcut?
  → Could this crash the app for users?
  → Could it corrupt data?
  → If yes: quality is non-negotiable regardless of timeline

QUESTION 3: Is the debt visible and tracked?
  → The shortcut is only acceptable if it's written down
  → Untracked debt = permanent debt

QUESTION 4: Will we actually pay it back?
  → If there's no plan to pay it back → it's not a tradeoff, it's neglect
```

**Concrete example:**

```dart
// Scenario: PM wants the login feature in 3 days, not 5.
// Clean version needs: BLoC, full unit tests, error state handling

// Acceptable shortcut (documented):
// → Use setState for now (simpler, faster)
// → Handle only happy path, add TODO for error states
// → File ticket: "Refactor login to Cubit + add error states"
//    Scheduled for next sprint.

// NOT acceptable shortcut:
// → No null checks on API response
// → No user feedback on failure
// → These could crash the app in production
```

**Why it matters:** Interviewers are testing whether you understand business context and whether you can negotiate quality standards intelligently — not just say "quality always wins."

**Common mistake:** "I always prioritize quality." That sounds noble but ignores reality. Or "Whatever the PM says goes." That shows no technical ownership or judgment.

---

**Q:** How do you make architectural decisions? How do you document them?

**A:** Architectural decisions are expensive to reverse and hard to communicate months later. I make them systematically and document them permanently using Architecture Decision Records (ADRs).

**My decision-making process:**

```
PROCESS:

1. DEFINE THE PROBLEM CLEARLY
   → What exact problem are we solving?
   → What happens if we do nothing?

2. LIST THE OPTIONS (at least 3)
   → Option A: [approach]
   → Option B: [approach]
   → Option C: [approach — including "do nothing"]

3. EVALUATE AGAINST CRITERIA
   Criteria examples:
   ├── Testability
   ├── Performance characteristics
   ├── Team familiarity / learning curve
   ├── Community support / maintenance
   ├── Bundle size impact
   └── Reversibility (can we undo this in 6 months?)

4. DECIDE + DOCUMENT
   → Write an ADR (Architecture Decision Record)
   → Commit it to the repo — it's part of the codebase

5. COMMUNICATE
   → Share with team before implementation
   → Collect async feedback — 48 hour window
```

**ADR Template I use:**

```markdown
# ADR-007: State Management — Riverpod over BLoC

## Date: 2024-03-15
## Status: Accepted

## Context
Our app has grown to 30+ screens. BLoC's boilerplate 
is slowing development. New team members struggle with 
the event/state ceremony for simple operations.

## Options Considered
1. Stay with BLoC — familiar, but verbose
2. Migrate to Riverpod — lighter, testable, compile-safe
3. Migrate to GetX — simplest, but mixes concerns

## Decision
Adopt Riverpod for all new features. Migrate existing 
screens incrementally over 2 quarters.

## Rationale
- Riverpod is compile-safe (no string-based providers)
- Easier to unit test (no BuildContext needed)
- Better DI story than BLoC
- GetX rejected: poor separation of concerns

## Consequences
- Learning curve: ~1 week per developer
- Migration risk: Medium (phased rollout mitigates)
- Positive: Expect 30% reduction in state boilerplate

## Revisit Condition
If team velocity does not improve after 1 quarter.
```

**Why it matters:** Interviewers want evidence that your decisions are deliberate and repeatable, not instinctive. ADRs show intellectual honesty — you document tradeoffs, not just the winner.

**Common mistake:** "I just discuss it with the team and we decide." No documentation = that context disappears when people leave. Future engineers can't understand why the decision was made.

---

**Q:** A new developer joined — how do you onboard them to a large Flutter codebase?

**A:** Onboarding done wrong costs weeks of productivity and creates anxiety. Done well, a new developer makes their first real contribution within the first week.

**My onboarding plan (Day 1 → Week 4):**

```
DAY 1: Orientation
├── Dev environment setup checklist (nothing verbal — written docs)
├── Run the app locally — confirm it works end to end
├── Tour the repo structure — explain the "why" of each folder
└── Introduce to the team 1:1 (not just in a group)

DAYS 2-3: Architecture Deep Dive
├── Walk through one complete user journey (e.g., Login → Home)
├── Show: UI layer → ViewModel/Cubit → Repository → Data Source
├── Explain: State management pattern, DI setup, routing
└── Share: Architecture Decision Records (ADRs) for context

WEEK 1: First Real Task
├── Assign a small, scoped, low-risk bug or UI polish task
├── Ensure it touches multiple layers (not just one file)
├── Pair with them on the first PR
└── Their PR gets reviewed kindly but thoroughly

WEEK 2-3: Widening Scope
├── Assign a full small feature (design → code → test → PR)
├── Introduce testing conventions
├── Attend planning meetings — expose them to the "why"
└── Identify their strength — play to it early

WEEK 4: Autonomy Check
├── Can they find answers without asking for help?
├── Can they open a PR that passes review with minimal comments?
└── Ask for their feedback on the onboarding — improve the docs
```

**Critical onboarding artifacts I maintain:**

```
/docs
  ├── ONBOARDING.md         ← step-by-step setup guide
  ├── ARCHITECTURE.md       ← layer diagram + naming conventions
  ├── STATE_MANAGEMENT.md  ← how we use Riverpod/BLoC
  ├── TESTING.md           ← how to write and run tests
  ├── RELEASE.md           ← how to build and deploy
  └── adr/                 ← all Architecture Decision Records
```

**Why it matters:** This question tests whether you think about the team system, not just your own code. Strong engineers reduce the cost of team growth.

**Common mistake:** "I point them to the README and answer their questions." A README alone is not an onboarding plan. No structure means days of confusion and lost productivity.

---

**Q:** How do you review a PR from a senior developer with more experience than you?

**A:** Experience does not make code correct. Your job in a PR review is to serve the codebase and the users — not to defer out of social discomfort.

**My approach:**

```
MINDSET:
  Code review is not a status contest.
  A PR from the most senior person on the team 
  still goes through the same quality gate.
  Your job is to ask good questions, not to prove yourself.
```

**What I do in practice:**

```
1. REVIEW THE CODE, NOT THE AUTHOR
   → Same checklist applies regardless of seniority
   → If something is unclear to you, it will be unclear 
     to the next person who reads it

2. ASK QUESTIONS, NOT ACCUSATIONS
   ✅ "I haven't seen this pattern before — could you 
      walk me through the reasoning?"
   ✅ "What happens here if the stream emits an error?"
   ✅ "Would it be worth adding a test for this edge case?"
   ❌ "This is wrong."
   ❌ "Why didn't you use X instead?"

3. SEPARATE BLOCKING FROM NON-BLOCKING
   → Blocking: bugs, security issues, architectural violations
   → Non-blocking (nit): naming, style, personal preference
   → Label them clearly: "Nit:", "Blocking:", "Question:"

4. BE WILLING TO BE WRONG
   → They may have context you don't
   → "I might be missing context here, but..." opens dialogue
   → If they explain the reasoning and it holds up — approve + learn

5. IF YOU'RE STILL CONCERNED:
   → "I want to flag this — could we discuss it in the thread 
     or briefly sync?" 
   → Never just silently approve something that concerns you
```

**Example comment I might leave:**

```dart
// Senior dev's code:
final result = await apiClient.fetchUser(id);
return result!;  // null assertion

// My comment:
// Question: Is there a guarantee from the API that this 
// is never null? If the user is deleted server-side between 
// the ID being stored and this call, this would throw.
// Could we handle the null case explicitly here?
// (Happy to discuss if I'm missing context on the API contract)
```

**Why it matters:** This is a culture and courage question. Interviewers want to see that you maintain standards under social pressure while staying respectful and curious.

**Common mistake:** "I'd just approve it — they know better than me." That's abdication of responsibility. Or "I'd push back hard." That's arrogance. The answer is curiosity + clarity + courage.

---

## PART B: BEHAVIORAL QUESTIONS (STAR Format)

---

**Q:** Tell me about yourself — senior-level framing.

**A:** This is your opening pitch. It should communicate: your depth, your impact, your trajectory, and your motivation for this role. Not a CV recitation.

**Structure:**

```
FORMULA:
[Current role + scope] → [Key technical depth] → 
[Measurable impact] → [What drives you] → 
[Why this next step]

Keep it to 90 seconds. Every sentence should earn its place.
```

**Example answer:**

```
"I'm a Flutter engineer with [X] years of experience, 
most recently at [Company] where I led the mobile team 
building a fintech app used by over 200,000 users.

On the technical side, I've gone deep on state management 
architecture — migrating a 40-screen app from setState chaos 
to a clean BLoC/Repository pattern, which reduced crash rates 
by 40% and cut our release cycle from 3 weeks to 1 week.

I've also mentored 3 junior developers over the past year, 
two of whom are now mid-level engineers shipping features 
independently.

What drives me is building systems that are reliable at 
scale and building teams that can maintain them.

I'm looking for a senior role where I can own larger 
architectural decisions, work on harder problems, and 
continue growing as a technical leader — which is exactly 
what this role offers."
```

**Why it matters:** The interviewer is checking: Are you senior in your thinking, not just your title? Do you communicate clearly? Do you understand your own impact?

**What NOT to say:**
- Reading your CV chronologically ("I started at Company A, then moved to B...")
- Focusing only on technologies ("I know Flutter, Dart, Firebase, REST APIs...")
- Being vague ("I've worked on various mobile projects")
- Starting with "So, um..." — no hesitation, you've prepared this

---

**Q:** What is your biggest technical achievement?

**A:** Use STAR. Pick something that is specific, measurable, and shows architectural or leadership thinking — not just that you wrote good code.

**STAR breakdown:**

```
SITUATION: What was the context and the challenge?
TASK:      What were you specifically responsible for?
ACTION:    What did YOU decide and build?
RESULT:    What was the measurable outcome?
```

**Example answer:**

```
SITUATION:
"Our Flutter app was crashing for 15% of users on Android 
on the checkout screen. The team had tried to debug it 
for two weeks without root-causing it."

TASK:
"I was assigned as the technical lead to diagnose and fix 
it before our peak sale season, which was 3 weeks away."

ACTION:
"I started by adding structured crash logging with 
Firebase Crashlytics — we had minimal signal before.
I traced the crash to a race condition in our payment 
widget: multiple setState() calls firing simultaneously 
from parallel async calls, corrupting the widget state.

I redesigned the checkout flow using a BLoC with 
atomic state transitions — only one state active at a 
time, all events queued. I also added integration tests 
for the entire checkout flow — we had zero before.

I shipped this behind a feature flag, rolled out to 5% 
of users first, monitored for 24 hours, then full rollout."

RESULT:
"Crash rate dropped from 15% to 0.3% within 48 hours. 
The feature flag strategy meant zero risk to the launch. 
The integration tests caught two other async bugs before 
they reached production. This became our standard pattern 
for all payment flows."
```

**Why it matters:** Interviewers are evaluating: Can you identify root causes (not symptoms)? Did you solve it systematically? Did you prevent recurrence? Did you lead others through it?

**What NOT to say:**
- "I rewrote the whole app" (no metrics, sounds reckless)
- "We implemented a new architecture" (vague, no personal ownership)
- "I fixed a really complex bug" (no specifics = not memorable)
- Picking something too small: "I optimized a widget's rebuild"

---

**Q:** Describe a time you led a project from scratch to production.

**A:** This demonstrates end-to-end ownership — planning, technical decisions, team coordination, and delivery.

**STAR Example:**

```
SITUATION:
"Our company decided to launch a standalone Flutter app 
for our B2B clients — separate from the consumer app. 
Timeline: 4 months, team of 4 engineers including myself."

TASK:
"I was the tech lead. My responsibilities: architecture 
decisions, sprint planning, code review, and making sure 
we hit the deadline with a stable product."

ACTION:
"Week 1-2: Architecture spike.
 I evaluated our options — share code with the consumer 
 app via packages, or build standalone. We chose 
 a monorepo with shared packages for networking, models, 
 and design tokens — separate UI and business logic.

Week 3: Scaffolded the project:
 → go_router for routing (typed routes)
 → Riverpod for state management
 → Dio + Retrofit for networking
 → flutter_test + mocktail for testing

Ongoing: Weekly architecture reviews with the team. 
 I wrote the ADRs for every major decision.
 I ran daily 15-min stand-ups focused on blockers.
 I did code review within 24 hours — never a bottleneck.

Week 14: We hit a scope creep risk — PM added 3 features 
 with 2 weeks left. I negotiated: we ship 2 features 
 now, 1 in v1.1. Made the case with a clear risk chart.
 PM agreed.

Week 16: Shipped to production."

RESULT:
"Delivered on time, 2 days before the deadline. 
Crash-free rate: 99.6% in the first month. 
The shared package architecture saved us 6 weeks of 
duplicate work. The app onboarded 3 enterprise clients 
in the first month."
```

**Why it matters:** This tests project management, technical judgment, stakeholder management, and team leadership simultaneously.

**What NOT to say:**
- "The team built X" — use "I" for your contributions and "we" for shared work, but be clear about YOUR role
- "Everything went smoothly" — no project is perfect; show how you handled friction
- Listing technologies without explaining decisions

---

**Q:** Tell me about a time you fixed a critical production bug.

**A:** This shows your debugging process, your communication under pressure, and your ability to prevent recurrence.

**STAR Example:**

```
SITUATION:
"Three hours after a major release, our analytics showed 
the app's home screen was blank for 30% of Android users. 
No crash — the screen just loaded empty."

TASK:
"I was the on-call engineer. I had to diagnose, fix, 
and deploy a hotfix — ideally within 2 hours."

ACTION:
"First 15 minutes: Triage.
 → Checked Crashlytics — no crashes, so it wasn't a null error
 → Checked our feature flags — one new flag was active
 → Compared affected users: 100% on Android, 0% on iOS
 
First 30 minutes: Reproduced locally.
 → Built the release APK (not debug — critical difference)
 → Reproduced on an Android emulator with the new flag on
 → The home screen's FutureBuilder was returning an empty 
   list instead of showing a loading state

Root cause:
 → A new platform channel call we added for Android-specific 
   analytics was throwing a PlatformException in release mode
   (ProGuard was stripping the method name).
 → This exception was swallowed silently in a catch block 
   that returned an empty list instead of rethrowing.

Fix:
 1. Removed the ProGuard rule that was stripping the method
 2. Changed the catch block to log + rethrow the error
 3. Added a visible error state to the FutureBuilder
    (instead of silently showing nothing)

Deployed hotfix behind a feature flag — validated on 
5% traffic, then full rollout."

RESULT:
"Total time: 1 hour 40 minutes from detection to fix.
Affected users: impact window was 3 hours.
Post-mortem: I wrote a checklist — release builds must 
be manually smoke-tested on Android before every deploy. 
We also added a staging environment with ProGuard enabled."
```

**Why it matters:** Interviewers are assessing: Are you calm under pressure? Is your debugging systematic? Do you prevent recurrence, not just fix symptoms?

**What NOT to say:**
- "I just reverted the release" (valid sometimes, but shows no root cause analysis)
- "The team fixed it together" (where is YOUR contribution?)
- Focusing only on the fix without the investigation process

---

**Q:** Describe a time you disagreed with your manager and how you handled it.

**A:** This tests your professional courage and your ability to influence without authority.

**STAR Example:**

```
SITUATION:
"My manager wanted us to ship a new feature without any 
automated tests because we were behind schedule. The feature 
involved payment processing — high risk, complex state."

TASK:
"I disagreed with this decision and believed it was 
a significant production risk. I needed to make my case 
professionally without damaging the relationship."

ACTION:
"I didn't push back in the stand-up meeting.
I asked my manager for a 20-minute 1:1.

In that meeting, I:
1. Acknowledged the business pressure first
   'I understand we're behind and the deadline matters.'

2. Stated my concern with evidence, not emotion:
   'Payment flows are our highest-crash area historically.
   Without tests, we have no safety net if we push a bug 
   to production. Our last payment bug cost us 3 days of 
   hotfixes and 2 client escalations.'

3. Proposed a middle path:
   'What if we scope to just integration tests for the 
   happy path and the main error case? That's 4 hours of 
   work and gives us a meaningful safety net.'

My manager listened and agreed to the proposal.
We wrote the tests. They caught a bug in the error state 
before we shipped."

RESULT:
"We shipped on time. The tests caught one real bug.
My manager later mentioned in my review that this 
was an example of good technical judgment."
```

**Why it matters:** Interviewers are checking: Can you hold a professional position under social pressure? Can you influence upward? Are you a pushover or a bulldozer?

**What NOT to say:**
- "I just did what my manager said" (no backbone)
- "I pushed back until they changed their mind" (no nuance)
- "I went above their head to their manager" (nuclear option — inappropriate for this situation)
- "I've never disagreed with my manager" (not credible)

---

**Q:** Tell me about a time you improved the performance of an app.

**A:** This tests technical depth in profiling, root cause analysis, and measurable impact.

**STAR Example:**

```
SITUATION:
"Our app's main feed screen had a noticeable jank — 
frames were dropping to around 30fps during scroll. 
Users were complaining in app reviews about 'lag'."

TASK:
"I volunteered to investigate and fix the scroll 
performance as a dedicated 1-week effort."

ACTION:
"Step 1: Measure first, don't guess.
 → Used Flutter DevTools Performance tab
 → Identified: build phase taking 18ms+ per frame 
   (budget is 16ms for 60fps)
 → Identified: raster phase spikes on image cells

Step 2: Root cause analysis.

 CAUSE 1: Unbounded widget rebuilds
 → The entire feed rebuilt on every scroll event
 → Root: A ChangeNotifier at the top of the tree 
   notified all listeners including the feed

 CAUSE 2: Image loading on the main thread
 → Using Image.network() with no caching
 → Every scroll up re-decoded the same images

 CAUSE 3: Heavy card widgets
 → Each card had 12 widgets in its subtree
 → None used const constructors

Step 3: Fixes applied.
 → Replaced ChangeNotifier with Riverpod select() 
   to limit rebuilds to only the changed fields
 → Added cached_network_image with a 100MB disk cache
 → Added const constructors throughout card widgets
 → Wrapped card in RepaintBoundary to isolate raster layer
 → Moved non-visible items out of the tree with 
   ListView.builder (was Column + SingleChildScrollView)"

RESULT:
"Frame rate improved from 30fps to stable 58-60fps.
Build time per frame dropped from 18ms to 4ms.
App store rating improved from 3.8 to 4.3 in the 
following month (correlated with the update release)."
```

**Why it matters:** This is a technical depth question disguised as a behavioral one. Interviewers want to see that you measure before you optimize, identify root causes, and quantify results.

**What NOT to say:**
- "I optimized some widgets" (too vague — no process, no metrics)
- "I rewrote the screen" (no root cause analysis shown)
- "It got much faster" (no numbers = not credible)

---

**Q:** Describe a time a project failed — what happened and what did you learn?

**A:** This is a vulnerability and growth question. The right answer shows self-awareness and systems thinking — not self-flagellation.

**STAR Example:**

```
SITUATION:
"We were building an offline-first sync engine for our 
Flutter app. I designed and led the implementation. 
After 6 weeks, we had to roll back the feature in 
production because data sync conflicts were corrupting 
user records."

TASK:
"I was the technical lead responsible for the design 
and the delivery. The failure was, ultimately, mine to own."

ACTION (what happened and why it failed):
"The architecture had a flaw I didn't anticipate at design:
 → We used a last-write-wins conflict resolution strategy
 → We didn't account for clock drift between devices
 → In multi-device scenarios, older data was overwriting newer data

What I did wrong:
1. I didn't stress-test multi-device sync during development.
   We only tested on a single device.
2. I didn't involve a developer with sync experience in 
   the design review. I was overconfident.
3. We had no rollback plan — I should have built it 
   behind a feature flag from day one.

When we discovered the issue in production:
→ I immediately owned it in the post-mortem
→ I rolled back the sync engine within 2 hours
→ I ran a data recovery script for affected users
→ I wrote a detailed post-mortem — no blame, full root cause"

RESULT (what I learned):
"1. Never ship sync logic without multi-device, 
   multi-timezone stress testing.
2. Feature flags are not optional for high-risk changes.
3. Seek external review for architecture decisions 
   outside your experience. Hubris is expensive.

The feature shipped successfully 8 weeks later using 
CRDTs (Conflict-free Replicated Data Types) for 
conflict resolution. I brought in an expert consultant 
for 3 days to validate the new design before we built it."
```

**Why it matters:** Interviewers are not looking for perfection — they're looking for intellectual honesty, accountability, and whether you learned from the failure at a systems level.

**What NOT to say:**
- "I can't think of a project that failed" (not credible at senior level)
- Blaming others: "The PM changed requirements mid-project"
- A trivial failure: "I once misspelled a variable name"
- Excessive self-criticism without lessons: "I felt terrible about it"

---

**Q:** How do you stay up to date with Flutter and the Dart ecosystem?

**A:** This tests your engineering discipline and intellectual curiosity. Give a specific, honest, structured answer — not a list of generic sources.

**A structured answer:**

```
MY LEARNING SYSTEM:

TIER 1: Primary Sources (weekly)
├── Flutter release notes & changelogs
│   (flutter.dev/docs/release/release-notes)
├── Dart language changelog (dart.dev/guides/whats-new)
├── pub.dev — watch key packages for updates
└── Flutter GitHub repo — track issues & PRs for 
    upcoming features

TIER 2: Community Signals (2-3x per week)
├── Flutter Discord (#flutter-dev, #dart)
├── r/FlutterDev on Reddit — surface new patterns
├── Twitter/X: Felix Angelov, Remi Rousselet, 
    Chris Sells, Filip Hracek
└── Flutter Weekly newsletter

TIER 3: Deeper Learning (monthly)
├── Flutter & Dart Conference talks (YouTube)
├── Read source code of major packages 
    (riverpod, go_router, drift)
├── Build small experiments with new APIs
└── Write about what I learn — forces true understanding
```

**Specific recent examples I'd cite:**

```
"Recently I've been following:
- Flutter 3.x Impeller renderer adoption on Android
- Dart 3 pattern matching and sealed classes 
  (game-changer for state modeling)
- flutter_hooks maturation for non-BLoC patterns
- The new DevTools extensions API

I also read the Dart/Flutter design docs on GitHub — 
understanding WHY a decision was made is more valuable 
than just knowing WHAT was decided."
```

**Why it matters:** Technology moves fast. Interviewers want to see that you have a system for staying current — not that you casually "follow Flutter news."

**What NOT to say:**
- "I read Medium articles" (too passive and low-signal)
- "I use whatever the latest stable version is" (reactive, not proactive)
- "I follow official docs" (insufficient on its own)
- Listing 10 sources without any specificity — name names and articles

---

**Q:** Why do you want this Senior Flutter role?

**A:** This must be honest, specific to the company, and show career intentionality — not just "I need a job."

**Framework:**

```
STRUCTURE:
1. What excites you about THIS company / product / domain?
2. What specific technical challenges does this role offer 
   that matches where you want to grow?
3. What do you bring that makes you a strong fit?

RESEARCH REQUIRED BEFORE THE INTERVIEW:
→ Read the company's engineering blog
→ Look at their app — what are they building?
→ Check their GitHub — what stack do they use?
→ LinkedIn: what does the team look like?
```

**Example answer (template — customize for your target role):**

```
"Three reasons this role stands out to me:

First, the product itself. I've used [Product] for 
[X time]. The [specific feature] is technically 
impressive — the real-time sync with offline support 
is the kind of hard problem I want to work on. 
I've built sync engines before and I know how complex 
they are at scale.

Second, the scale of the engineering challenge. 
At my current role, I've been building features for 
a 50,000-user app. This role is working on a product 
with [5M users / cross-platform / performance-critical] 
— that's a genuine step up in complexity and I'm ready for it.

Third, the team. I read [Specific engineering blog post 
or conference talk from their team]. The approach to 
[architecture / testing / release engineering] aligns 
closely with how I think about software. I want to be 
in a room where I'm learning as much as I'm contributing."
```

**Why it matters:** Interviewers are evaluating genuine interest vs. spray-and-pray job applications. They want to hire someone who chose them deliberately.

**What NOT to say:**
- "I've always wanted to work at a company like this"
- "The salary is great" (even if true)
- "I'm looking for a senior title" (title-chasing is a red flag)
- Generic: "I want to grow and be challenged" (every candidate says this)

---

**Q:** Where do you see yourself in 3-5 years?

**A:** This tests career intentionality and whether your trajectory fits the company's direction. Don't overclaim and don't underclaim.

**Framework:**

```
CALIBRATE YOUR ANSWER:
→ Don't claim you want to be a CTO if this is a 10-person startup 
  (sounds unrealistic or like you're just passing through)
→ Don't say "I just want to keep coding" if the role has a 
  leadership growth path (undersells yourself)
→ Align your answer with the realistic growth at THIS company
```

**Example answer:**

```
"In 3-5 years, I see myself in one of two directions — 
both of which I think are available here.

The first is a Staff or Principal Engineer path: 
being a technical authority who shapes how the whole 
engineering organization approaches mobile at scale — 
architectural standards, platform decisions, cross-team 
technical strategy.

The second is a technical leadership path — managing a 
team of engineers, not just individual-contributing. 
I've been mentoring developers for 2 years now and I 
find genuine satisfaction in it. I'd want to continue 
building that skill intentionally.

Both of those directions require what I'm looking for 
in this role: working on harder problems, with better 
engineers, in a domain I'm genuinely excited about.

I'm not in a hurry to chase a title. I want to earn 
the next level by delivering outsized impact first."
```

**Why it matters:** Interviewers want to see that you have ambition with self-awareness, and that your trajectory is a match for what the company can offer. They're also checking for flight risk — will you leave in 6 months?

**What NOT to say:**
- "I want to start my own startup" (signals you're using them as a launchpad)
- "I'd love to be in management" (if you're interviewing for an IC role — raises concerns)
- "I'm not sure" (lack of self-awareness)
- A rigid, overspecified answer: "I want to be a VP of Engineering" (may not fit the company's structure)

---

**Q:** What is your greatest technical weakness?

**A:** This is a honesty and growth mindset test. The interviewer knows you have weaknesses — they want to see if you're self-aware about them and actively working to improve.

**Framework:**

```
RULES:
1. Pick a REAL weakness — not a "weakness that's secretly a strength"
   ("I work too hard" = instant red flag)
2. It must be technical — not a soft skill weakness
3. Show self-awareness: you know it's a weakness
4. Show a plan: you are actively addressing it
5. Calibrate: don't pick something that disqualifies you 
   for the core job
```

**Example answers:**

```
OPTION A — Backend depth:
"My weakness is backend systems. I understand REST APIs 
and GraphQL at a consumer level, but I've never designed 
a backend architecture from scratch. I know what contracts 
I need, but I can't have a deep conversation about 
database schema design or service scaling.

I'm addressing this: I've been taking a backend course 
on Dart's shelf package and built a small REST API as 
a side project. I also pair with our backend engineers 
during architecture reviews to build that intuition."

OPTION B — CI/CD & DevOps:
"I understand CI/CD pipelines at a usage level, but 
I've never built one from scratch. I can configure 
existing GitHub Actions or Fastlane scripts, but I 
rely on DevOps engineers for the infrastructure design.

I'm fixing this: I've set up a personal project with 
a full pipeline — automated testing, code coverage, 
and deployment to Firebase App Distribution. 
It's exposed me to how much I was taking for granted."

OPTION C — Web/Desktop Flutter:
"I've built exclusively for iOS and Android. Flutter Web 
and Desktop are areas I haven't shipped production code in.
I'm aware the rendering and performance considerations 
are different — but I don't have battle-tested experience there.

I'm learning: I've been porting one of my side projects 
to Flutter Web and discovering the constraints firsthand."
```

**Why it matters:** This is a maturity test. Weak candidates either deny having weaknesses or pick fake ones. Strong candidates show accurate self-assessment and a growth plan.

**What NOT to say:**
- "I'm a perfectionist" or "I work too hard" (clichés that reveal nothing)
- "I don't really have any major weaknesses" (arrogance or lack of self-awareness)
- A core-job weakness: "I'm not great at state management" (disqualifying)
- A weakness with no growth plan: "I'm weak at testing but it's fine"

---

*End of Section 22: Senior Engineer Leadership & Behavioral*
