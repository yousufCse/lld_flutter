# Section 18: Agile, Scrum & Methodology

---

**Q:** What is the Agile Manifesto? Summarise its 4 values and 12 principles.

**A:**
The Agile Manifesto (2001) is a set of guiding values and principles for software development that prioritises flexibility, collaboration, and delivering working software over rigid processes.

### The 4 Core Values

| We value MORE               | Over                          |
|-----------------------------|-------------------------------|
| Individuals and interactions | Processes and tools           |
| Working software            | Comprehensive documentation   |
| Customer collaboration      | Contract negotiation          |
| Responding to change        | Following a plan              |

> Both sides have value — Agile simply prioritises the left side.

### The 12 Principles (summarised)

1. **Customer satisfaction** — Deliver valuable software early and continuously.
2. **Welcome change** — Even late in development; change gives competitive advantage.
3. **Frequent delivery** — Ship working software in short cycles (weeks, not months).
4. **Collaboration** — Business and developers must work together daily.
5. **Motivated individuals** — Give teams what they need and trust them.
6. **Face-to-face communication** — The most efficient way to convey information.
7. **Working software** — The primary measure of progress.
8. **Sustainable pace** — Teams should maintain a constant, indefinite pace.
9. **Technical excellence** — Good design and craftsmanship enhance agility.
10. **Simplicity** — Maximise the amount of work NOT done.
11. **Self-organising teams** — Best architectures and designs emerge from them.
12. **Regular reflection** — Teams regularly reflect and adjust their behaviour.

**Example:**
> A Flutter team ships a new feature every two weeks to real users (Principle 3), collects feedback, and adjusts the backlog (Value: Responding to Change). They don't wait six months to release a "perfect" version.

**Why it matters:** Interviewers want to see that you understand *why* your team works the way it does — not just the mechanics of standups and sprints.

**Common mistake:** Candidates memorise the values as a list but can't explain what "Individuals over processes" means in practice (e.g., a developer raising a concern directly with a designer instead of filing a formal change request).

---

**Q:** What is the difference between Waterfall and Agile? When is each appropriate?

**A:**
Both are software development methodologies but with fundamentally different philosophies.

```
WATERFALL (Sequential)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Requirements → Design → Implementation → Testing → Deployment → Maintenance
     ↓              ↓            ↓             ↓           ↓
  (done)         (done)       (done)        (done)      (done)

Each phase is COMPLETE before the next begins.
No going back without significant cost.


AGILE (Iterative)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sprint 1        Sprint 2        Sprint 3
┌──────────┐   ┌──────────┐   ┌──────────┐
│Plan      │   │Plan      │   │Plan      │
│Build     │ → │Build     │ → │Build     │ → ...
│Test      │   │Test      │   │Test      │
│Review    │   │Review    │   │Review    │
└──────────┘   └──────────┘   └──────────┘
Each sprint delivers WORKING SOFTWARE.
Requirements can change between sprints.
```

### Key Differences

| Aspect           | Waterfall                      | Agile                              |
|------------------|--------------------------------|------------------------------------|
| Structure        | Linear, sequential             | Iterative, incremental             |
| Flexibility      | Low — changes are expensive    | High — change is expected          |
| Customer role    | Involved at start and end      | Involved throughout                |
| Testing          | At the end                     | Continuous                         |
| Delivery         | Once at the end                | Every sprint                       |
| Documentation    | Heavy upfront                  | Lightweight, just enough           |
| Best for         | Fixed, known requirements      | Evolving, unclear requirements     |
| Risk             | Risk is discovered late        | Risk is discovered early           |

### When to use Waterfall
- Requirements are **fully known and fixed** (e.g., building a bridge control system)
- Regulatory or compliance-heavy projects (aerospace, medical devices)
- Short projects with clear scope and no expected changes
- Projects where client availability is limited after sign-off

### When to use Agile
- Requirements are **uncertain or evolving** (most mobile apps)
- Startups building MVPs and iterating on user feedback
- Products that need frequent releases (e.g., a Flutter app on the Play Store)
- Teams co-located or in continuous contact with the customer

**Example:**
> A Flutter e-commerce app uses Agile — the client constantly changes priorities based on user analytics. Waterfall would be appropriate for building the ATM firmware that connects to the app, where requirements are fixed and regulated.

**Why it matters:** Shows you understand methodology trade-offs, not just "Agile is always better."

**Common mistake:** Saying "Waterfall is bad, Agile is always better." In reality, hybrid models (e.g., Wagile) exist, and some domains genuinely need Waterfall's predictability.

---

**Q:** Explain the Scrum framework — roles, artifacts, and ceremonies.

**A:**
Scrum is an Agile framework for delivering complex products in short, fixed cycles called **sprints**.

```
SCRUM FRAMEWORK OVERVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ROLES                  ARTIFACTS               CEREMONIES
  ─────                  ─────────               ──────────
  Product Owner   ──→    Product Backlog    ──→   Sprint Planning
  Scrum Master    ──→    Sprint Backlog     ──→   Daily Standup
  Dev Team        ──→    Increment          ──→   Sprint Review
                                            ──→   Sprint Retrospective


  SPRINT CYCLE (2 weeks example)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Day 1                                           Day 14
  │                                                    │
  ▼                                                    ▼
  [Sprint Planning] ──→ [Daily Standups x13] ──→ [Review] ──→ [Retro]
        ↑                                               │
        └──────────── Next Sprint ◄────────────────────┘
```

---

### ROLES

#### 1. Product Owner (PO)
- Owns the **Product Backlog** — decides what gets built and in what priority
- Represents the **customer/business** to the team
- Writes and clarifies user stories
- Accepts or rejects completed work
- **One person** — not a committee

#### 2. Scrum Master (SM)
- **Servant-leader** — not a manager or project manager
- Removes impediments blocking the team
- Coaches the team on Scrum practices
- Protects the team from external interference
- Facilitates Scrum ceremonies

#### 3. Development Team
- Cross-functional — designers, developers, QA (all roles needed to ship)
- **Self-organising** — decides HOW to do the work
- Typically 3–9 people
- Collectively responsible for delivering the sprint goal

---

### ARTIFACTS

#### 1. Product Backlog
- A prioritised list of **everything** the product might need
- Owned and managed by the Product Owner
- Items at the top are refined, detailed, and ready to pick up
- Items at the bottom are vague and high-level (epics)
- Never "done" — evolves throughout the product's life

```
PRODUCT BACKLOG (priority order)
┌─────────────────────────────────────────────────┐
│ 1. [Story] As a user, I want to log in with     │  ← Refined, ready
│    Google so that I don't need a password       │
│ 2. [Story] Push notifications for order status  │  ← Refined
│ 3. [Epic]  Offline mode support                 │  ← Needs breakdown
│ 4. [Idea]  AI-powered product recommendations  │  ← Vague, future
└─────────────────────────────────────────────────┘
```

#### 2. Sprint Backlog
- Subset of the Product Backlog **selected for this sprint**
- Includes the sprint goal and the tasks needed to achieve it
- **Owned by the Dev Team** — they can add/remove tasks during the sprint
- Visible on the sprint board (To Do → In Progress → Done)

#### 3. Increment
- The sum of **all completed backlog items** during a sprint
- Must be in a **potentially shippable state** at the end of every sprint
- Must meet the team's **Definition of Done**
- You don't have to release it, but it must be releasable

---

### CEREMONIES

#### 1. Sprint Planning
- **When:** Start of each sprint
- **Who:** Entire Scrum team
- **What:** PO presents top backlog items → team selects what they can commit to → team breaks items into tasks
- **Output:** Sprint Goal + Sprint Backlog

#### 2. Daily Standup (Daily Scrum)
- **When:** Every day, same time, 15 minutes max
- **Who:** Dev team (SM optional, PO optional)
- **What:** Each person answers 3 questions:
  1. What did I do yesterday?
  2. What will I do today?
  3. Any blockers?
- **Output:** Shared awareness + flagged impediments

#### 3. Sprint Review
- **When:** End of sprint
- **Who:** Scrum team + stakeholders
- **What:** Team **demos** the completed increment to stakeholders
- **Output:** Feedback, updated backlog, stakeholder alignment

#### 4. Sprint Retrospective
- **When:** After Sprint Review, before next Sprint Planning
- **Who:** Scrum team only (no stakeholders)
- **What:** Team reflects on their **process**:
  - What went well?
  - What didn't go well?
  - What will we improve?
- **Output:** Action items for process improvement

**Example:**
> In a Flutter team, the Sprint Review demo shows the new "Track Order" screen to the client. The client says the map is confusing — this feedback becomes a new backlog item. In the Retrospective, the team notes that QA always starts too late; they agree to write test cases during development, not after.

**Why it matters:** Scrum is the most widely used Agile framework. Interviewers expect you to know all roles, artifacts, and ceremonies — and understand their purpose, not just their names.

**Common mistake:** Confusing Sprint Review (showing *what* was built) with Sprint Retrospective (improving *how* the team works). These serve completely different purposes.

---

**Q:** What is a Sprint? What is its typical duration? What happens when the sprint goal is not met?

**A:**
A **Sprint** is a fixed-length, time-boxed iteration (typically 1–4 weeks) during which the Scrum team creates a potentially shippable product Increment.

```
SPRINT STRUCTURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 ┌─────────────────────────────────────────────┐
 │              SPRINT (2 weeks)               │
 │                                             │
 │  Day 1       Days 2–13         Day 14       │
 │  ┌──────┐   ┌──────────┐   ┌──────────┐    │
 │  │Sprint│   │  Daily   │   │ Review + │    │
 │  │Plann-│   │Standups  │   │  Retro   │    │
 │  │ ing  │   │+ Dev work│   │          │    │
 │  └──────┘   └──────────┘   └──────────┘    │
 │                                             │
 │  Sprint Goal: "Complete user auth flow"     │
 └─────────────────────────────────────────────┘
```

### Key Sprint Rules
- **Fixed duration** — sprints don't extend to finish incomplete work
- **Sprint goal** — a short objective that gives the sprint focus and direction
- **No changes** that would endanger the sprint goal once it's started (PO can clarify, not add scope)
- Sprints are **consecutive** — no gaps between them

### Typical Duration
| Duration | Best for                                              |
|----------|-------------------------------------------------------|
| 1 week   | Fast feedback cycles, unstable requirements           |
| 2 weeks  | **Most common** — good balance of speed and planning  |
| 3 weeks  | Moderate complexity, larger teams                     |
| 4 weeks  | Complex features requiring longer development cycles  |

### What happens when the sprint goal is NOT met?

The sprint **ends on time regardless** — the time-box is never extended. Here's what happens:

1. **Incomplete items** are returned to the Product Backlog (not automatically carried forward)
2. The **Sprint Review** still happens — team demos what *was* completed
3. The **Sprint Retrospective** is especially important — the team identifies why the goal wasn't met
4. The PO **re-prioritises** returned items for the next sprint
5. Velocity data is updated — this sprint's velocity reflects what was actually completed

> **A sprint is NOT cancelled** because the goal wasn't met. Cancellation is rare and only done by the PO when the sprint goal becomes obsolete (e.g., market changes, company pivot).

**Example:**
> The sprint goal was "implement push notifications." By Day 14, the team completed 6 of 8 stories. The 2 incomplete stories (deep-link handling, notification settings screen) are returned to the backlog. The retro reveals the team underestimated the APNs certificate setup. In the next sprint planning, those 2 stories are re-estimated with the new knowledge.

**Why it matters:** Interviewers want to see you understand that Scrum is about **discipline and learning**, not just hitting targets. Handling failure gracefully is a sign of a mature team.

**Common mistake:** Saying "we just carry the stories over to the next sprint automatically." This bypasses re-prioritisation — the PO may decide something else is now more important.

---

**Q:** What is Kanban? How does it differ from Scrum? What are WIP limits? When should you use Kanban?

**A:**
**Kanban** is a visual workflow management method focused on continuous delivery, not time-boxed sprints. It comes from Toyota's manufacturing system and means "visual card" in Japanese.

```
KANBAN BOARD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌───────────┬────────────────┬────────────────┬─────────┐
│  BACKLOG  │   IN PROGRESS  │   IN REVIEW    │  DONE   │
│           │   (WIP: max 3) │   (WIP: max 2) │         │
├───────────┼────────────────┼────────────────┼─────────┤
│ [Story A] │ [Story C] 👤   │ [Story E] 👤   │[StoryG] │
│ [Story B] │ [Story D] 👤   │ [Story F] 👤   │[StoryH] │
│ [Story I] │ [Story J] 👤   │                │[StoryK] │
│ [Story L] │                │                │         │
└───────────┴────────────────┴────────────────┴─────────┘
                ↑ WIP LIMIT REACHED (3/3) — no new work
                  until a card moves to In Review
```

### WIP (Work In Progress) Limits
- A **maximum number of items** allowed in a column at any time
- Forces the team to **finish before starting** something new
- Surfaces bottlenecks — if "In Review" is always at capacity, QA is the bottleneck
- Reduces context switching and multitasking

### Scrum vs Kanban

| Aspect             | Scrum                          | Kanban                          |
|--------------------|--------------------------------|---------------------------------|
| Cadence            | Fixed sprints (1–4 weeks)      | Continuous flow, no sprints     |
| Roles              | PO, SM, Dev Team (mandatory)   | No prescribed roles             |
| Ceremonies         | Sprint planning, standups, etc.| No mandatory ceremonies         |
| WIP limits         | Implicit (sprint capacity)     | Explicit per-column limits      |
| Commitment         | Sprint commitment               | No formal commitment            |
| Change             | No change mid-sprint           | Change any time                 |
| Planning           | Sprint planning session         | Continuous, pull-based          |
| Metrics            | Velocity, burndown              | Cycle time, throughput, CFD     |
| Releases           | End of sprint                   | Any time a card is done         |
| Best for           | Feature development teams       | Support, maintenance, ops teams |

### When to use Kanban
- **Support/maintenance teams** with unpredictable incoming work (bug fixes, hotfixes)
- **Ops or DevOps teams** where work arrives continuously and urgently
- Teams with no fixed release cycle
- Small teams who find Scrum ceremonies too heavyweight
- As a **visualisation layer** on top of Scrum (Scrumban)

**Example:**
> A Flutter team uses Scrum for feature development (new screens, new APIs). Separately, the bug-fix and support team uses Kanban — bugs arrive unpredictably, and a sprint model would mean waiting until the next sprint to fix a production crash.

**Why it matters:** Shows you understand there's no single "best" methodology — the right choice depends on the type of work.

**Common mistake:** Treating Kanban and Scrum as competitors. Many mature teams use **Scrumban** — sprint structure from Scrum with WIP limits and continuous flow from Kanban.

---

**Q:** What are story points? Why do teams prefer them over hours?

**A:**
**Story points** are a unit of measure for the **relative effort, complexity, and uncertainty** of a user story — not the time it will take.

They are abstract, relative numbers — typically using the **Fibonacci sequence** (1, 2, 3, 5, 8, 13, 21) because the gaps between numbers reflect increasing uncertainty as complexity grows.

```
STORY POINTS vs HOURS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Story A: "Add a logout button"           → 1 point
  Story B: "Implement JWT auth flow"        → 5 points
  Story C: "Build offline sync for orders" → 13 points

  Story B is NOT 5x the HOURS of Story A.
  It is 5x MORE COMPLEX/UNCERTAIN/EFFORTFUL.

  Hours estimate:                          Point estimate:
  Dev 1: "That's 3 hours"                  "That's a 5"
  Dev 2: "No way, 8 hours"                 (Team agrees via Planning Poker)
  Dev 3: "Depends — 2–10 hours"
  → Argument about time                    → Conversation about complexity
```

### Why teams prefer story points over hours

| Reason                         | Explanation                                                                          |
|--------------------------------|--------------------------------------------------------------------------------------|
| **Avoids false precision**     | Hours imply certainty that doesn't exist in software                                 |
| **Team-relative, not personal**| A 5-point story takes the same "effort" regardless of who does it (at team scale)    |
| **Accounts for uncertainty**   | Points capture complexity + risk, not just time                                      |
| **Removes pressure**           | Hours become commitments; points are estimates that enable learning                  |
| **Enables velocity tracking**  | Teams measure how many points they complete per sprint, enabling future planning     |
| **Faster to estimate**         | Planning Poker with points converges faster than estimating in hours                 |

### Planning Poker
A common estimation technique where each team member simultaneously reveals a card with their point estimate. Outliers discuss their reasoning, and the team re-votes until there's consensus.

**Example:**
> Story: "Implement biometric login in Flutter using local_auth"
> - Dev 1 plays 5 (knows the plugin well)
> - Dev 2 plays 13 (hasn't used biometrics on iOS before, thinks it's risky)
> - After discussion: team agrees on 8 — moderate complexity + iOS uncertainty

**Why it matters:** Story points reflect team maturity. Interviewers want to see you understand the *purpose* of estimation — building shared understanding and enabling planning, not generating hour-by-hour schedules.

**Common mistake:** Saying "story points are just hours in disguise" or trying to convert them (e.g., "1 point = 4 hours"). The moment you do that, you lose all the benefits.

---

**Q:** What is a user story? Explain the format, acceptance criteria, and Definition of Done.

**A:**
A **user story** is a short, simple description of a feature told from the perspective of the person who wants it. It captures **who wants it, what they want, and why**.

### User Story Format
```
"As a [type of user],
 I want [some goal]
 so that [some reason/benefit]."
```

### Real Examples
```
As a shopper,
I want to filter products by price range
so that I only see items I can afford.

As a logged-in user,
I want to receive a push notification when my order ships
so that I know when to expect my delivery.

As an admin,
I want to export order data as a CSV
so that I can analyse sales in Excel.
```

### Acceptance Criteria (AC)
Acceptance Criteria are the **specific conditions** that must be met for the story to be considered complete. They are written by the PO (with team input) and define the boundaries of the story.

```
Story: "As a user, I want to log in with my Google account"

Acceptance Criteria:
  ✅ Given I am on the login screen,
     When I tap "Sign in with Google",
     Then the Google OAuth flow should open

  ✅ Given I successfully authenticate with Google,
     When I return to the app,
     Then I should be logged in and see the home screen

  ✅ Given Google sign-in fails or is cancelled,
     When I return to the app,
     Then I should remain on the login screen with an error message

  ✅ The user's name and profile picture should appear in the app header
```

> ACs often use **Given/When/Then** format (Gherkin syntax) to make them testable.

### Definition of Done (DoD)
The DoD is a **team-wide checklist** that every story must satisfy before it can be marked "Done." It applies to ALL stories, unlike ACs which are story-specific.

```
DEFINITION OF DONE (example Flutter team)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ☐ Code is written and peer-reviewed (PR approved)
  ☐ Unit tests written and passing (≥80% coverage)
  ☐ Widget tests written for new UI components
  ☐ No lint errors (flutter analyze passes)
  ☐ Feature works on both iOS and Android
  ☐ Accessibility labels added (semantics)
  ☐ No hardcoded strings (i18n keys used)
  ☐ Code merged to main branch
  ☐ Product Owner has accepted the story
  ☐ No known bugs introduced
```

**Example:**
> A story passes all its Acceptance Criteria (the Google login works) but the code has no tests and wasn't reviewed. According to the DoD, it is **not Done**. The team cannot count it in the sprint velocity.

**Why it matters:** ACs and DoD are quality gates. Interviewers check whether you ship working, tested, maintainable code — not just "it works on my machine."

**Common mistake:** Confusing Acceptance Criteria (story-specific, written by PO) with Definition of Done (team-wide, applies to every story). They serve different purposes.

---

**Q:** What is backlog refinement (grooming)? What happens and who is involved?

**A:**
**Backlog refinement** (formerly called grooming) is an ongoing activity where the Scrum team reviews, clarifies, estimates, and prioritises items in the Product Backlog to ensure they are ready for future sprints.

It is **not a formal Scrum ceremony** — it's a continuous process, though many teams schedule a regular refinement session (typically mid-sprint).

```
BACKLOG REFINEMENT FLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Product Backlog (before refinement):
  ┌─────────────────────────────────────────┐
  │ [Vague Epic] Improve app performance    │
  │ [Vague Story] Add notifications         │
  │ [No AC] User profile editing            │
  └─────────────────────────────────────────┘
           │
           ▼  (Refinement session)
  ┌─────────────────────────────────────────────────────┐
  │ [Story 3pt] As a user, I want to edit my display    │
  │ name — AC: name updates immediately in header,      │
  │ validated max 50 chars, error shown on API failure  │
  │                                                     │
  │ [Story 5pt] As a user, I want push notifications    │
  │ for order status — AC: iOS + Android, opt-in flow,  │
  │ deep link to order screen                           │
  │                                                     │
  │ [Epic → split into 4 stories] App performance       │
  └─────────────────────────────────────────────────────┘
  Stories are now clear, estimated, and READY.
```

### What happens in refinement

1. **Clarification** — Team asks questions about vague stories; PO answers
2. **Splitting** — Large stories (epics) are broken into smaller, sprint-sized stories
3. **Estimation** — Team estimates stories using story points (Planning Poker)
4. **Acceptance Criteria written** — PO adds or refines ACs with team input
5. **Prioritisation** — PO re-orders the backlog based on business value
6. **Definition of Ready check** — Is this story ready to be pulled into a sprint?

### Who is involved
- **Product Owner** — leads the session, clarifies requirements, updates priorities
- **Development Team** — estimates effort, raises technical concerns, suggests splits
- **Scrum Master** — facilitates, timekeeps, ensures the process runs smoothly
- (Optional) Designers, architects, or stakeholders for specific stories

### Recommended time investment
Scrum Guide suggests no more than **10% of the team's capacity** per sprint. For a 2-week sprint, that's roughly **4–8 hours** of refinement total.

**Example:**
> Mid-sprint (Day 7 of a 2-week sprint), the team holds a 90-minute refinement session. The PO presents 8 backlog items for the next sprint. The team points out that "implement Stripe payments" is too large — it gets split into: (1) add payment method screen, (2) Stripe SDK integration, (3) payment confirmation + error handling. Each is estimated separately.

**Why it matters:** Refinement is what makes Sprint Planning fast and effective. Without it, Sprint Planning becomes a long, painful discovery session. Interviewers want to see you understand that good sprints start with a well-refined backlog.

**Common mistake:** Thinking refinement only happens in one big session before each sprint. In practice, it should be a **continuous, lightweight activity** — the PO and tech lead might refine items informally throughout the sprint.

---

**Q:** What is sprint velocity? How is it used for planning?

**A:**
**Sprint velocity** is the total number of story points a team completes in a single sprint. It is measured after each sprint and used to predict future capacity.

```
VELOCITY OVER SPRINTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sprint:   S1    S2    S3    S4    S5    S6
Points:   24    28    22    30    26    28

          ↑                       ↑
      (New team,              (All points
      learning Scrum)          completed)

Average velocity = (24+28+22+30+26+28) / 6 = 26.3 ≈ 26 points/sprint
```

### How velocity is used

**1. Sprint Planning Capacity**
> If the team's average velocity is 26 points, the team should pull approximately 26 points of work into the next sprint — no more.

**2. Release Forecasting**
```
Product Backlog remaining: 120 story points
Average velocity:           26 points/sprint

Estimated sprints to completion: 120 / 26 ≈ 5 sprints
At 2 weeks/sprint = ~10 weeks to release
```

**3. Spotting trends**
- Velocity dropping? Possible causes: tech debt, team changes, unclear requirements
- Velocity spiking? Possible causes: inflation of estimates, overwork (unsustainable)
- Consistent velocity? Healthy, predictable team

### Important caveats
- Velocity is **team-specific** — never compare velocity across different teams
- Don't use velocity as a performance metric — it leads to inflated estimates
- Velocity fluctuates; use a **rolling average** (last 3–5 sprints) for planning
- Velocity only counts **Done** stories (meeting DoD) — partial work = 0 points

**Example:**
> The PO asks: "Can we launch the Flutter app in 3 months?" The SM pulls up the last 5 sprints: average velocity is 30 points. The remaining backlog is 180 points. 180 / 30 = 6 sprints × 2 weeks = 12 weeks ≈ 3 months. With buffer for unknowns, the realistic answer is "3–4 months."

**Why it matters:** Velocity enables data-driven planning. Interviewers want to see you understand it as a forecasting tool — not a target to hit or a way to rank developer productivity.

**Common mistake:** Saying "we need to increase velocity every sprint." A team gaming velocity (over-pointing stories) doesn't deliver more — they just have misleading numbers.

---

**Q:** What is the Daily Standup? What is its purpose, and what do you say?

**A:**
The **Daily Standup** (Daily Scrum) is a 15-minute, time-boxed event held every day at the same time. Its purpose is to **synchronise the team**, surface blockers, and create a shared plan for the next 24 hours.

It is for the **development team** — not a status report to managers.

### The 3 Questions
Each team member answers:
1. **What did I do yesterday** that helped the team move toward the sprint goal?
2. **What will I do today** to help the team move toward the sprint goal?
3. **Do I have any blockers** or impediments?

```
GOOD vs BAD STANDUP ANSWERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ BAD (vague, no sprint goal reference):
"Yesterday I worked on the app. Today I'll keep working on it.
 No blockers."

✅ GOOD (specific, goal-oriented, actionable):
"Yesterday I finished the product detail screen widget tests —
 PROD-47 is now in review. Today I'm starting the cart
 screen UI (PROD-52). I'm blocked on the cart API schema —
 I need 30 minutes with Sarah after standup to clarify
 the discount field structure."
```

### Common Standup Anti-patterns

| Anti-pattern                | Problem                                               |
|-----------------------------|-------------------------------------------------------|
| Deep problem-solving        | Kills the 15-minute limit; take it offline            |
| Status report to the SM/PO  | It's a team sync, not a reporting session             |
| Skipping blockers           | Pride or fear — blockers fester and slow the team     |
| Repeating the Jira board    | "I'm working on PROD-47" with no context adds nothing |
| Absent team members         | Breaks synchronisation; join remotely if needed       |

### Format tips
- **Stand up** (if in-person) — keeps it short
- Talk to **each other**, not to the Scrum Master
- If discussion is needed: "Let's take that offline" — schedule a follow-up
- The SM removes blockers **after** standup, not during

**Example:**
> "Yesterday I completed the Firebase Auth integration for Google Sign-In on Android — it's merged. Today I'm working on iOS Sign-In and the edge case where the user denies permissions. No blockers from my side, but I noticed the loading state on the auth screen is missing — I'll sync with the designer at 10am."

**Why it matters:** Interviewers check that you understand standup as a **team coordination tool**, not a management check-in. Teams that do standups poorly waste 15 minutes a day with no benefit.

**Common mistake:** Treating standup as "tell the manager what you did." The Scrum Master is not your boss — they're there to help, not judge. Transparency about blockers is a strength, not a weakness.

---

**Q:** What is the difference between a Sprint Review and a Sprint Retrospective?

**A:**
These are two separate ceremonies that happen at the end of every sprint. They serve completely different purposes.

```
END OF SPRINT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sprint ends
     │
     ├──→ SPRINT REVIEW (inspect the PRODUCT)
     │         Who: Scrum Team + Stakeholders
     │         What: Demo working software
     │         Focus: "Did we build the RIGHT thing?"
     │         Output: Updated backlog, stakeholder feedback
     │
     └──→ SPRINT RETROSPECTIVE (inspect the PROCESS)
               Who: Scrum Team only
               What: Reflect on how you worked
               Focus: "Did we build the thing RIGHT?"
               Output: Process improvements for next sprint
```

### Sprint Review

| Aspect      | Detail                                                    |
|-------------|-----------------------------------------------------------|
| Purpose     | Inspect the Increment and get stakeholder feedback        |
| Who attends | Scrum Team + stakeholders, customers, management          |
| Focus       | The **product** — what was built, what works, what's next |
| Duration    | Up to 4 hours for a 4-week sprint (1–2hr for 2-week)      |
| Output      | Feedback, backlog updates, adapted roadmap                |
| Tone        | Collaborative, demo-driven, forward-looking               |

The PO explains what's done and what's not. The Dev Team demos the work. Stakeholders give feedback. The PO updates the backlog accordingly.

### Sprint Retrospective

| Aspect      | Detail                                                    |
|-------------|-----------------------------------------------------------|
| Purpose     | Improve the team's **process**, tools, and relationships  |
| Who attends | Scrum Team only (no stakeholders, no managers ideally)    |
| Focus       | **How** the team works — communication, workflow, tooling |
| Duration    | Up to 3 hours for a 4-week sprint (45–90min for 2-week)   |
| Output      | 1–3 concrete, actionable improvement items                |
| Tone        | Honest, safe, blame-free                                  |

Common retro formats:
- **Start / Stop / Continue** — What should we start doing, stop doing, keep doing?
- **4Ls** — Liked, Learned, Lacked, Longed for
- **Mad / Sad / Glad**

**Example:**
> **Sprint Review:** The Flutter team demos the new checkout screen to the Product team and client. The client notices the "Apply Coupon" field is missing — the PO adds it to the backlog.
>
> **Sprint Retrospective (next day, team only):** The team discusses why testing always happens last-minute. They agree to pair each developer with a QA engineer from Day 1 of each story. This becomes the retro action item.

**Why it matters:** The distinction is fundamental. One is about the product (external), one is about the people and process (internal). Mixing them up signals you haven't worked in a real Scrum team.

**Common mistake:** Saying the retro is "where we complain about the sprint." It should produce **specific, actionable improvements** — not a venting session. Retros without action items are wasted time.

---

**Q:** What is technical debt? How do you manage it in a sprint-based team?

**A:**
**Technical debt** is the accumulated cost of shortcuts, workarounds, poor design decisions, and deferred improvements in a codebase. Like financial debt, it accrues "interest" — the longer you leave it, the harder and more expensive it becomes to fix.

```
TECHNICAL DEBT TYPES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Deliberate + Reckless:   "We don't have time for design."
Deliberate + Prudent:    "Ship now, refactor after launch."  ← Manageable
Inadvertent + Reckless:  "What's layered architecture?"
Inadvertent + Prudent:   "Now we know better — let's fix it." ← Healthy learning

(Ward Cunningham's debt quadrant)
```

### Common sources in Flutter projects
- Hardcoded values instead of constants or environment configs
- Business logic in widgets instead of ViewModels/BLoCs
- No unit tests written under deadline pressure
- Deprecated packages never updated
- Copy-pasted code instead of shared widgets
- No error handling (bare `catch` blocks)
- Magic numbers with no explanation

### How to manage technical debt in a sprint-based team

**1. Make it visible — create debt stories in the backlog**
```
[Tech Debt] Refactor authentication flow to use BLoC pattern
[Tech Debt] Update firebase_auth to v5 and fix breaking changes
[Tech Debt] Add widget tests for checkout flow (0% coverage)
```

**2. Allocate a percentage of each sprint to tech debt**
> A common rule: **20% of sprint capacity** (roughly 1 day per week) is reserved for debt reduction.
```
Sprint capacity: 30 points
Feature stories: 24 points (80%)
Tech debt stories: 6 points (20%)
```

**3. The Boy Scout Rule — leave code cleaner than you found it**
> When working on a feature, do small refactors in scope. Don't create a mountain of debt by always taking shortcuts.

**4. Definition of Done as a debt prevention tool**
> Requiring tests, code review, and lint checks in the DoD prevents new debt from entering the codebase.

**5. Dedicated "hardening sprints" for severe debt**
> Occasionally, after a major release, a team spends an entire sprint purely on refactoring, upgrading dependencies, and improving test coverage.

**Example:**
> A Flutter team shipped an MVP under pressure. All state was in StatefulWidgets, no tests existed, and Firebase calls were made directly from the UI. After launch, they allocated 1 story per sprint to introduce BLoC gradually — starting with the auth flow, then the cart, then the product listing. Within 3 months, the codebase was maintainable without a full rewrite.

**Why it matters:** Every experienced engineer deals with tech debt. Interviewers want to see you have a pragmatic, structured approach — not "we never write bad code" or "we ignore it."

**Common mistake:** Treating tech debt as purely negative. Deliberate, prudent debt (shipping faster to hit a market window, with a plan to fix it) is a valid business decision. The mistake is accumulating debt without acknowledging or planning to repay it.

---

**Q:** How do you handle changing requirements mid-sprint?

**A:**
Changing requirements mid-sprint is a common real-world challenge. Scrum has a clear stance: **protect the sprint** — but be practical about genuine business emergencies.

```
DECISION TREE: Change request arrives mid-sprint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Change request arrives
        │
        ▼
Is it a production-breaking bug or critical security issue?
        │
   YES ──┤──→ Handle immediately outside normal sprint flow
        │
       NO
        │
        ▼
Does it affect the current sprint goal?
        │
   NO ──┤──→ Add to Product Backlog → prioritise for next sprint
        │     (PO owns this decision)
       YES
        │
        ▼
How significant is the change?
        │
  SMALL ┤──→ PO discusses with SM + team → swap for an item
        │     of equal size (remove something, add the change)
        │
  LARGE ┤──→ PO considers cancelling the sprint
              (rare! Only if the sprint goal is now obsolete)
```

### Scrum's position
- The **sprint goal is sacred** — work inside the sprint should serve the goal
- The **PO cannot add new scope mid-sprint** without negotiating with the team
- The **team can push back** and explain the impact on committed work
- New items go to the backlog and are prioritised for the **next sprint**

### Practical approaches

**1. Swap, don't add**
> If something urgent comes in, the PO works with the team to remove an equal-sized item from the sprint backlog to make room. No sprint overloading.

**2. Keep a small buffer**
> Some teams deliberately under-commit (e.g., plan for 80% of velocity) to absorb small changes without disrupting the sprint goal.

**3. Kanban for emergencies**
> Hotfixes and critical bugs often bypass the sprint process and go on a fast-lane lane on the board.

**4. Communicate transparently**
> If a change mid-sprint will delay delivery, the team communicates this in the Sprint Review — not silently adds scope and misses the goal.

**Example (real Flutter scenario):**
> Mid-sprint, the PO asks to add Apple Sign-In because Google Play Store threatened to reject the app update. The team evaluates: it's ~5 points of work. The SM facilitates a conversation. The team agrees to drop the "Profile Photo Upload" story (3 points) and de-scope the optional "remember me" checkbox (2 points) to make room. The sprint goal ("complete auth flows") still holds.

**Why it matters:** This tests your maturity. Interviewers want to see you can balance process discipline with business pragmatism — neither "we never change mid-sprint" (rigid) nor "sure, add anything" (chaotic).

**Common mistake:** Just saying "add it to the backlog" for every change. Sometimes changes are genuinely urgent and the team needs a structured way to accommodate them without blowing up the sprint.

---

**Q:** How do you use Jira? Explain epics, stories, tasks, subtasks, and the board.

**A:**
**Jira** is the most widely used project management tool in Agile teams. It maps directly to Scrum and Kanban concepts.

```
JIRA HIERARCHY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  INITIATIVE (optional, strategic goal)
       │
       ▼
  EPIC  (large feature or theme — spans multiple sprints)
  e.g. "User Authentication"
       │
       ├──→ STORY (user-facing feature — fits in a sprint)
       │    e.g. "As a user, I want to log in with Google"
       │         │
       │         ├──→ TASK (technical work item)
       │         │    e.g. "Integrate google_sign_in package"
       │         │
       │         └──→ SUBTASK (breakdown of a task)
       │              e.g. "Handle sign-in error states"
       │
       └──→ BUG  (defect — same level as a story)
            e.g. "Login button not responding on iOS 17"
```

### Jira Issue Types in Practice

| Type     | Who creates it | Size             | Example                                         |
|----------|---------------|------------------|-------------------------------------------------|
| Epic     | PO            | Many sprints     | "Checkout & Payment Flow"                       |
| Story    | PO            | 1–5 days         | "As a user, I want to pay with Apple Pay"       |
| Task     | Dev Team      | Half day–2 days  | "Integrate Stripe Apple Pay SDK"                |
| Subtask  | Dev Team      | Hours            | "Write unit tests for payment validation"       |
| Bug      | Anyone        | Varies           | "Total price doesn't update when coupon applied"|

### Jira Board (Scrum Board)

```
SPRINT BOARD VIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TO DO          │  IN PROGRESS   │  IN REVIEW     │  DONE
───────────────┼────────────────┼────────────────┼────────────
PROJ-42        │  PROJ-38       │  PROJ-35       │  PROJ-31
Apple Pay      │  Cart UI       │  Login Screen  │  Splash Screen
5 pts          │  3 pts 👤Ali   │  2 pts 👤Sara  │  2 pts
               │                │                │
PROJ-43        │  PROJ-39       │                │  PROJ-32
Order History  │  API Service   │                │  Onboarding
8 pts          │  5 pts 👤Omar  │                │  5 pts
```

### Key Jira features used in daily work
- **Backlog view** — prioritised list of all stories; drag to re-order
- **Sprint board** — Kanban-style board for current sprint
- **Burndown chart** — visualises remaining work vs time remaining in sprint
- **Roadmap** — timeline view of epics across sprints
- **Filters / JQL** — query issues (e.g., `project = APP AND sprint = "Sprint 5" AND assignee = currentUser()`)
- **Labels and components** — tag issues (e.g., "ios-only", "performance", "accessibility")
- **Linking issues** — "PROJ-43 is blocked by PROJ-38"

**Example:**
> A Flutter team's Epic is "Push Notifications." It contains 4 stories: (1) notification permissions flow, (2) Firebase Messaging integration, (3) deep-link handling, (4) notification settings screen. Each story has tasks and subtasks. The SM uses the burndown chart in sprint planning to confirm the team is on track to deliver stories 1 and 2 this sprint.

**Why it matters:** Jira is a tool you'll use every day. Interviewers want to see you can work efficiently with it — not just that you've heard of it.

**Common mistake:** Creating tasks or subtasks without linking them to a parent story or epic. This creates "orphaned" work that doesn't appear in burndown charts and makes sprint progress invisible.

---

**Q:** What is the Definition of Ready vs Definition of Done? What does each mean?

**A:**
These are two quality gates that bracket the lifecycle of a user story — one before it enters a sprint, one before it leaves.

```
USER STORY LIFECYCLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Product       [DEFINITION         Sprint         [DEFINITION
 Backlog  ──→  OF READY]    ──→   Backlog   ──→  OF DONE]    ──→  Released
              "Can we start         Dev
               this story?"        work          "Can we ship
                                                 this story?"
```

### Definition of Ready (DoR)

The DoR is a checklist that a backlog item must satisfy **before** the team pulls it into a sprint. It ensures the team has everything they need to start work without being blocked from Day 1.

```
DEFINITION OF READY (example)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ☐ User story is written in "As a / I want / So that" format
  ☐ Acceptance criteria are written and agreed upon
  ☐ Story is estimated (story points assigned)
  ☐ Dependencies are identified and resolved (or planned)
  ☐ UI/UX designs are available (Figma link attached)
  ☐ API contract is defined (endpoints, payloads documented)
  ☐ Story fits within one sprint (not too large)
  ☐ PO has confirmed the story is correctly prioritised
```

### Definition of Done (DoD)

The DoD is a checklist that a story must satisfy **before** it is marked Done and counted in the sprint velocity. It ensures consistent quality across all delivered work.

```
DEFINITION OF DONE (example Flutter team)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ☐ Code written and peer-reviewed (PR approved by ≥1 dev)
  ☐ Acceptance criteria verified and accepted by PO
  ☐ Unit and widget tests written and passing
  ☐ flutter analyze reports zero issues
  ☐ Feature tested on physical iOS and Android devices
  ☐ No regressions in existing tests
  ☐ Code merged to main/develop branch
  ☐ Jira ticket updated and moved to Done column
  ☐ Relevant documentation updated (if applicable)
```

### Side-by-side comparison

| Aspect        | Definition of Ready                     | Definition of Done                       |
|---------------|-----------------------------------------|------------------------------------------|
| When applied  | Before a story enters the sprint        | Before a story is marked complete        |
| Purpose       | Ensures work can START without blockers | Ensures work is truly FINISHED           |
| Owned by      | Product Owner + team collaboratively    | Development team (agreed in retro)       |
| Focus         | Clarity, dependencies, estimates        | Quality, testing, review, acceptance     |
| Consequence   | Story is NOT pulled into sprint         | Story is NOT counted as Done (no points) |

**Example:**
> A story "Integrate Apple Pay" arrives at Sprint Planning. It fails the DoR check — no Figma designs exist and the payment API contract isn't finalised. The SM flags it: "This isn't ready." The PO moves it back to the backlog for refinement. A story that *was* ready goes into the sprint instead. → This prevents a blocked story from wasting sprint capacity.

**Why it matters:** DoR and DoD are signs of a disciplined, quality-focused team. Interviewers want to see you prevent both "starting things before you're ready" and "shipping things before they're really done."

**Common mistake:** Having a DoD but no DoR. Teams often define "done" carefully but pull poorly-defined stories into sprints and then discover blockers on Day 1. Both gates are necessary.

---

**Q:** How do you estimate tasks when requirements are unclear?

**A:**
Unclear requirements are the norm in product development — not the exception. The goal is to make a **useful enough estimate** to enable planning, while making the uncertainty visible, not pretending it doesn't exist.

```
ESTIMATION UNDER UNCERTAINTY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clear requirements        Unclear requirements
      │                         │
      ▼                         ▼
 Precise estimate          Range estimate
  e.g. "3 points"          e.g. "8–13 points"
                           or "spike needed"

CONE OF UNCERTAINTY:
Early in project:  estimate could be 4x off in either direction
                   ████████████████████
After design:       ██████████
After refinement:    ████████
After spike:          ██████
During development:    ████
```

### Techniques for estimating unclear work

**1. Spike (Research Story)**
When a story is too uncertain to estimate, create a **spike** — a time-boxed investigation story with a fixed duration (e.g., 1 day, 4 hours) to explore the unknown.
```
[Spike] Investigate biometric authentication options on Flutter
  Time-box: 1 day
  Goal: Determine feasibility of local_auth on older Android devices,
        document API surface, recommend approach
  Output: Technical findings → enables accurate estimation of real story
```

**2. Estimate the range, not a point**
Use T-shirt sizing (S/M/L/XL) or explicitly give a range: "This is somewhere between 5 and 13 points — we need to clarify the offline sync requirement before we can narrow it down."

**3. Break it down until something is estimable**
A story that's hard to estimate is often too large or too vague. Split it:
```
Vague: "Improve app performance"  → impossible to estimate
Better: 
  [Story] Profile and fix slow rendering on product list screen
  [Story] Implement pagination to reduce initial data load
  [Story] Add image caching with cached_network_image
  Each is now independently estimable.
```

**4. Use analogies to past work**
> "This login flow is similar to the registration flow we built in Sprint 3. That was 8 points. This is slightly simpler — I'd say 5 points."

**5. Assume and document**
Explicitly state your assumptions:
> "I'm estimating this as 5 points *assuming* the API already supports filtering. If we need to add filtering on the backend too, this becomes 13 points."

**6. Three-point estimation (for higher-stakes items)**
```
Optimistic estimate (O):   2 points (everything goes well)
Pessimistic estimate (P):  13 points (API changes, tricky edge cases)
Most likely estimate (M):  5 points

PERT formula: (O + 4M + P) / 6 = (2 + 20 + 13) / 6 = 5.8 ≈ 6 points
```

**Example (Flutter context):**
> The story is "Integrate third-party video player with DRM support." No one on the team has done DRM before. Instead of guessing, the team creates a spike: "Investigate DRM options in Flutter (Widevine + FairPlay) — 2-day time-box." After the spike, the engineer has enough information to estimate the real story accurately at 13 points with documented risks.

**Why it matters:** Estimation under uncertainty is a daily reality. Interviewers want to see that you don't either refuse to estimate ("it's too unclear") or pretend certainty you don't have ("it's 5 points, easy"). The mature answer is structured, transparent, and iterative.

**Common mistake:** Padding estimates wildly "just in case." This inflates sprint plans and erodes trust in the estimation process. The right approach is to surface uncertainty explicitly — through spikes, assumptions, or ranges — rather than hiding it inside a big number.

---

*End of Section 18: Agile, Scrum & Methodology*
