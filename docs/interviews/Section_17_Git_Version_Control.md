# Section 17: Git & Version Control

---

**Q:** What do `git init`, `git clone`, `git status`, `git add`, `git commit`, `git push`, and `git pull` each do?

**A:**
These are the core Git commands every developer uses daily. Here's what each one does:

- **`git init`** — Initialises a new, empty Git repository in the current directory. Creates a hidden `.git/` folder that stores all version history and config.
- **`git clone <url>`** — Downloads a full copy of a remote repository (history and all) to your local machine.
- **`git status`** — Shows the current state of your working directory: which files are modified, staged, or untracked.
- **`git add <file>` / `git add .`** — Stages changes. Moves files from "working directory" into the "staging area" (index), ready to be committed.
- **`git commit -m "message"`** — Saves a snapshot of all staged changes to your local repository history.
- **`git push <remote> <branch>`** — Uploads your local commits to the remote repository (e.g. GitHub).
- **`git pull`** — Downloads and immediately merges remote changes into your current branch. It is shorthand for `git fetch` + `git merge`.

```
Working Directory  →  git add  →  Staging Area  →  git commit  →  Local Repo  →  git push  →  Remote Repo
Remote Repo        →  git pull  →  Local Repo + Working Directory (fetch + merge combined)
```

**Example:**
```bash
git init                          # Start new repo
git clone https://github.com/org/flutter-app.git  # Copy remote repo

git status                        # See what changed
git add lib/main.dart             # Stage one file
git add .                         # Stage everything
git commit -m "feat: add login screen"
git push origin main              # Upload to GitHub
git pull origin main              # Get latest from GitHub
```

**Why it matters:** The interviewer is checking that you understand the full Git lifecycle — working directory → staging → local history → remote — and are not just cargo-culting commands.

**Common mistake:** Confusing `git add .` (stages all changes) with `git commit` (saves staged changes). Candidates sometimes say "commit saves all changes" — it only saves what was staged first.

---

**Q:** How do you create, switch to, and delete a branch in Git?

**A:**
Branches let you work on features or fixes in isolation without touching `main`.

- **Create:** `git branch <name>` creates a branch but keeps you on the current one.
- **Create + Switch:** `git checkout -b <name>` (classic) or `git switch -c <name>` (modern, preferred).
- **Switch:** `git checkout <name>` or `git switch <name>`.
- **Delete (merged):** `git branch -d <name>` — safe delete; Git blocks deletion if the branch has unmerged changes.
- **Delete (force):** `git branch -D <name>` — force delete regardless.
- **Delete remote branch:** `git push origin --delete <name>`.

```
main ──────●──────●──────●
                   \
feature/login       ●──────●  (git switch -c feature/login)
```

**Example:**
```bash
# Create and switch to a new feature branch
git switch -c feature/onboarding

# Do your work, commit...
git add .
git commit -m "feat: add onboarding flow"

# Switch back to main
git switch main

# Delete the branch after merging
git branch -d feature/onboarding

# Delete from remote too
git push origin --delete feature/onboarding
```

**Why it matters:** Daily workflow skill. The interviewer wants to know you work with branches confidently and keep `main` clean.

**Common mistake:** Using `git checkout -b` is fine, but candidates who don't know `git switch` (introduced in Git 2.23) may appear out of date. Also, forgetting to delete remote branches after merging is a common bad habit.

---

**Q:** What is the difference between `git merge` and `git rebase`? When do you use each?

**A:**
Both integrate changes from one branch into another, but they do it differently.

**`git merge`** creates a new "merge commit" that ties together both branch histories. The original commit history of both branches is preserved exactly.

**`git rebase`** re-applies your commits on top of the target branch, one by one, as if you had started your branch from the latest commit. It rewrites commit history — your branch's commits get new SHA hashes.

```
--- MERGE ---
main:    A──B──C──────M   (M = merge commit)
              \      /
feature:       D──E

--- REBASE ---
main:    A──B──C
                \
feature:         D'──E'   (D and E replayed on top of C, new hashes)
```

| | Merge | Rebase |
|---|---|---|
| History | Preserves exact history | Linear, clean history |
| Merge commit | Yes | No |
| Safe for shared branches | Yes | No (rewrites history) |
| Best for | `main`, `develop`, shared branches | Feature branches before PR |

**When to use merge:** Integrating a completed feature back into `main` or `develop`. Especially on shared branches where others have pulled the branch.

**When to use rebase:** Before opening a pull request, to replay your feature branch on top of the latest `main` and keep a clean linear history. **Never rebase a branch that others are working on.**

**Example:**
```bash
# Merge: bring feature into main
git switch main
git merge feature/login

# Rebase: update feature branch before PR
git switch feature/login
git rebase main
# Resolve any conflicts, then:
git rebase --continue
```

**Why it matters:** This is one of the most common Git interview questions. The interviewer is testing whether you understand trade-offs and won't blindly rebase shared branches and break teammates' histories.

**Common mistake:** Saying "rebase is always better because it's cleaner." Rebasing a shared/public branch is destructive — it rewrites SHA hashes and forces everyone else to reset their local copies.

---

**Q:** What causes a merge conflict, and how do you resolve one step by step?

**A:**
A merge conflict happens when two branches modify the **same lines** of the same file, and Git cannot automatically determine which version to keep. Git marks the conflicting sections and pauses the merge.

**Step-by-step resolution:**

1. Attempt the merge: `git merge feature/login`
2. Git reports conflicts: `CONFLICT (content): Merge conflict in lib/auth/login_page.dart`
3. Open the file — Git marks the conflict like this:

```
<<<<<<< HEAD
  // current branch version
  final title = 'Login';
=======
  // incoming branch version
  final title = 'Sign In';
>>>>>>> feature/login
```

4. Edit the file to resolve: delete the markers, keep the correct version (or combine both).
5. Stage the resolved file: `git add lib/auth/login_page.dart`
6. Complete the merge: `git commit`

**Example:**
```bash
git switch main
git merge feature/login
# Git says: Automatic merge failed; fix conflicts

# Open conflicted file in VS Code
code lib/auth/login_page.dart
# Manually resolve, then:

git add lib/auth/login_page.dart
git commit -m "merge: resolve conflict in login_page title"

# Or to abort and go back to pre-merge state:
git merge --abort
```

**Why it matters:** Conflicts are inevitable on real teams. The interviewer wants to know you stay calm, understand the markers, and resolve conflicts deliberately — not just pick one side blindly.

**Common mistake:** Deleting the conflict markers without actually reading both versions. This is how bugs get silently introduced during merges.

---

**Q:** What is the difference between `git fetch` and `git pull`?

**A:**
- **`git fetch`** downloads remote changes (commits, branches, tags) into your local repo but does **not** touch your working directory or current branch. It updates your remote-tracking references (e.g. `origin/main`) only.
- **`git pull`** = `git fetch` + `git merge`. It downloads changes AND immediately merges them into your current branch.

```
git fetch:
  Remote Repo → Local Repo (remote-tracking refs only)
  Working directory: UNCHANGED

git pull:
  Remote Repo → Local Repo → Working Directory (fetch + merge)
```

**When to prefer `git fetch`:**
- When you want to inspect what changed remotely before merging: `git fetch origin` then `git log HEAD..origin/main`
- When you want more control: fetch first, then rebase instead of merge: `git fetch origin` then `git rebase origin/main`

**Example:**
```bash
# Fetch only — see what's new without affecting your work
git fetch origin
git log HEAD..origin/main --oneline  # Preview incoming commits

# Then merge manually
git merge origin/main

# vs. pull (fetch + merge in one shot)
git pull origin main
```

**Why it matters:** Understanding this distinction shows you're deliberate about how changes enter your working state. Blindly using `git pull` can cause surprise merges — `git fetch` first gives you visibility.

**Common mistake:** Saying they're the same thing. Or saying `git fetch` is "just a safer pull" without explaining that it doesn't modify your working directory at all.

---

**Q:** What does `git stash` do, and how do you apply stashed changes?

**A:**
`git stash` temporarily shelves your uncommitted changes (both staged and unstaged) so your working directory is clean. This is useful when you need to quickly switch branches without committing half-done work.

Think of it as a clipboard for your in-progress changes.

**Common stash commands:**

| Command | What it does |
|---|---|
| `git stash` | Stash current changes |
| `git stash push -m "message"` | Stash with a label |
| `git stash list` | Show all stashes |
| `git stash pop` | Apply latest stash and remove it from the stash list |
| `git stash apply stash@{1}` | Apply a specific stash but keep it in the list |
| `git stash drop stash@{0}` | Delete a specific stash |
| `git stash clear` | Delete all stashes |

**Example:**
```bash
# Mid-feature work, urgent bug comes in on main
git stash push -m "WIP: onboarding UI"

# Switch to main, fix the bug
git switch main
git switch -c hotfix/crash-on-startup
# ... fix, commit, merge ...

# Come back to your feature
git switch feature/onboarding
git stash pop   # Restore your WIP changes
```

**Why it matters:** Shows you can manage context-switching efficiently without polluting your history with "WIP" commits.

**Common mistake:** Forgetting stashes exist and wondering where changes went after `git stash`. Always `git stash list` before panicking about missing work.

---

**Q:** What is `git cherry-pick`? When would you use it?

**A:**
`git cherry-pick <commit-hash>` takes a specific commit from any branch and applies it to your current branch. It creates a **new commit** with the same changes but a different SHA.

```
main:    A──B──C
              ↑ cherry-pick C onto hotfix

hotfix:  A──B──C'  (C' has same changes as C, new hash)
```

**Common use cases:**
1. A bug fix was committed to `develop` but needs to go to the current `release` branch immediately.
2. A colleague's commit on their branch has a fix you need now, without merging their entire branch.
3. Recovering a useful commit that was accidentally removed from a branch.

**Example:**
```bash
# Find the commit hash
git log develop --oneline
# abc1234 fix: null crash on empty user profile

# Apply just that commit to release branch
git switch release/1.2
git cherry-pick abc1234

# Cherry-pick a range of commits
git cherry-pick abc1234^..def5678
```

**Why it matters:** Cherry-pick is a surgical tool for selective change propagation. The interviewer is checking that you know it exists and when it's the right choice versus a full merge.

**Common mistake:** Overusing cherry-pick. If you find yourself cherry-picking the same commit multiple times across many branches, it's a signal that your branching strategy needs rethinking.

---

**Q:** What is the difference between `git reset --soft`, `--mixed`, and `--hard`?

**A:**
`git reset` moves the `HEAD` pointer (and current branch) backwards to a previous commit. The three modes differ in what happens to your staged changes and working directory files.

```
Commit History:   A──B──C  (HEAD is at C)
After reset to B: A──B      (C is undone, but WHERE did C's changes go?)

--soft:   C's changes → Staging Area  (committed → staged)
--mixed:  C's changes → Working Dir   (committed → unstaged) [DEFAULT]
--hard:   C's changes → DELETED       (committed → gone)
```

| Mode | Staged Area | Working Directory | Use case |
|---|---|---|---|
| `--soft` | Changes kept staged | Unchanged | Undo commit, keep changes ready to re-commit |
| `--mixed` | Changes unstaged | Unchanged | Undo commit + unstage, keep files as-is |
| `--hard` | Cleared | Reverted to target commit | Completely discard changes |

**Example:**
```bash
# Undo last commit but keep changes staged (ready to recommit)
git reset --soft HEAD~1

# Undo last commit and unstage changes (files still modified)
git reset --mixed HEAD~1   # same as: git reset HEAD~1

# Completely wipe the last commit AND all its changes — DANGEROUS
git reset --hard HEAD~1

# Go back 3 commits, discard everything
git reset --hard HEAD~3

# Reset to a specific commit
git reset --hard abc1234
```

**Why it matters:** A high-stakes command — `--hard` deletes work permanently. The interviewer is testing that you understand the consequences before you run it.

**Common mistake:** Using `--hard` when `--soft` or `--mixed` was intended. Also, resetting commits that have already been pushed to a shared remote — this rewrites public history and breaks other developers' branches.

---

**Q:** What is `git revert` and how does it differ from `git reset`?

**A:**
`git revert <commit>` creates a **new commit** that undoes the changes introduced by the specified commit. It does not touch commit history — it adds to it.

`git reset` moves `HEAD` backwards, effectively erasing commits from history.

```
git reset:
  A──B──C──D    →    A──B──C     (D is removed from history)

git revert D:
  A──B──C──D──D'  (D' is a new commit that reverses D's changes)
```

| | `git reset` | `git revert` |
|---|---|---|
| Modifies history | Yes | No |
| Safe for shared branches | No | Yes |
| Creates new commit | No | Yes |
| Use when | Local-only commits | Already pushed commits |

**When to prefer `git revert`:**
- The bad commit has already been pushed to `main` or a shared branch.
- You need an audit trail showing that a change was undone.
- You are working in a regulated environment where history must be preserved.

**Example:**
```bash
# Revert a specific commit (creates undo commit)
git revert abc1234

# Revert the last commit
git revert HEAD

# Revert without auto-committing (lets you edit the revert message)
git revert --no-commit abc1234
git commit -m "revert: undo broken payment integration"
```

**Why it matters:** This is a safety question. Using `git reset` on a shared branch is a common way to cause chaos for teammates. Interviewers want to know you use `git revert` in collaborative contexts.

**Common mistake:** Using `git reset --hard` to undo a pushed commit, then force-pushing. This rewrites public history and forces all teammates to reset their local branches.

---

**Q:** How do you use `git log` and `git blame` for debugging and understanding history?

**A:**

**`git log`** shows commit history. Its real power is in its filtering options:

```bash
git log                          # Full history
git log --oneline                # Compact: one line per commit
git log --oneline --graph        # ASCII graph of branch/merge history
git log --author="Karim"        # Commits by a specific author
git log --since="2 weeks ago"   # Commits in a time range
git log -- lib/auth/login.dart  # Commits that touched a specific file
git log -p lib/auth/login.dart  # Show the actual diff per commit for a file
git log --grep="fix: null"      # Search commit messages
git log main..feature/login     # Commits in feature not in main
```

**`git blame <file>`** shows who last modified each line of a file, and in which commit. This is the tool you use when you find a suspicious line and want to know who wrote it and why.

```bash
git blame lib/auth/login_page.dart
# Output:
# abc1234 (Karim Ahmed 2024-01-15) final title = 'Login';
# def5678 (Sara Noor  2024-01-18) final subtitle = 'Welcome back';
```

**Example — finding when a bug was introduced:**
```bash
# Find commits that touched the broken file
git log --oneline -- lib/services/auth_service.dart

# See exact changes in a suspicious commit
git show abc1234

# Find who changed a specific line
git blame lib/services/auth_service.dart | grep "refreshToken"
```

**Why it matters:** These are debugging tools. Interviewers want to know you can navigate project history efficiently — not just write new code, but understand existing code and trace problems back to their origin.

**Common mistake:** Only knowing `git log` without its filter flags, or never having used `git blame`. In real investigations, `git log --` on a file and `git blame` are far more useful than scrolling through raw history.

---

**Q:** What is `.gitignore`, and what are common Flutter-specific entries?

**A:**
`.gitignore` is a plain text file at the root of your repo that tells Git which files and directories to **never track**. Files listed here won't appear in `git status` and won't be committed.

**Why it matters for Flutter:**
Flutter projects generate a large number of files that are either machine-generated, platform-specific build artifacts, or local developer settings. Committing these pollutes the repo, causes unnecessary conflicts, and exposes secrets.

**Common Flutter `.gitignore` entries:**

```gitignore
# Build outputs — regenerated by `flutter build`
build/

# Dart tool cache — local package resolution
.dart_tool/

# Flutter generated files — regenerated by `flutter pub run build_runner`
*.g.dart
*.freezed.dart
*.gr.dart

# IntelliJ / Android Studio local settings
.idea/
*.iml

# VS Code local settings
.vscode/

# Android local files
android/local.properties
android/.gradle/
android/key.properties        # ⚠️ IMPORTANT: signing keys — never commit

# iOS local files
ios/Pods/
ios/.symlinks/

# macOS
.DS_Store

# Environment / secrets
.env
*.env.local
google-services.json          # ⚠️ IMPORTANT: Firebase config — handle carefully
GoogleService-Info.plist      # ⚠️ IMPORTANT: Firebase iOS config

# Flutter/Dart pubspec lock (some teams commit this, some don't)
# pubspec.lock  — usually committed for apps, gitignored for packages
```

**Example:**
```bash
# Check if a file is being ignored
git check-ignore -v android/local.properties

# After adding .gitignore, stop tracking an already-committed file
git rm --cached android/local.properties
git commit -m "chore: untrack local.properties"
```

**Why it matters:** Security (secrets), repo cleanliness, and avoiding meaningless merge conflicts in generated files. The interviewer is checking that you understand what belongs in version control and what doesn't.

**Common mistake:** Committing `android/key.properties` (signing keys) or `.env` files with API keys. Also forgetting to `git rm --cached` files that were already committed before being added to `.gitignore`.

---

**Q:** Compare Git Flow, GitHub Flow, and Trunk-Based Development as branching strategies.

**A:**
These are team agreements on how branches are named, created, and merged. The right one depends on team size, deployment frequency, and release model.

```
GIT FLOW:
main ─────────────────────────────────────────► (production)
         ↑ release               ↑ hotfix
develop ──────────────────────────────────────► (integration)
     feature/A ─────►
              feature/B ──────────►

GITHUB FLOW:
main ──────────────────────────────────────────► (always deployable)
   feature/A ──────► PR → merge → deploy
   feature/B ──────────────► PR → merge → deploy

TRUNK-BASED:
main ─────────────────────────────────────────► (continuous deploy)
  short-lived branch (hours/1-2 days max) → PR → merge
```

| | Git Flow | GitHub Flow | Trunk-Based |
|---|---|---|---|
| Branches | main, develop, feature, release, hotfix | main + short-lived features | main + very short-lived branches (or direct commits) |
| Release model | Scheduled / versioned releases | Continuous deployment | Continuous deployment |
| Complexity | High | Low | Low-Medium |
| Team size | Medium-Large | Any | Any (requires CI/CD maturity) |
| Best for | Mobile apps with versioned releases (Flutter apps in app stores) | Web services, frequent deploys | High-velocity teams, microservices |

**Flutter context:** Git Flow is popular for Flutter app teams because App Store / Play Store releases have versioned numbers and review cycles. GitHub Flow suits teams with fast CI/CD pipelines. Trunk-Based requires feature flags to merge unfinished features safely.

**Example — Git Flow in practice:**
```bash
# New feature
git switch -c feature/dark-mode develop

# Release prep
git switch -c release/1.2.0 develop
# bump version, final fixes
git merge release/1.2.0 --into main
git merge release/1.2.0 --into develop

# Hotfix
git switch -c hotfix/crash-fix main
git merge hotfix/crash-fix --into main
git merge hotfix/crash-fix --into develop
```

**Why it matters:** The interviewer wants to know you've worked on a team with a defined branching strategy and can articulate trade-offs — not just know what branches are.

**Common mistake:** Saying "we just used Git Flow" without being able to explain the purpose of `develop` vs `main` or how hotfixes are handled. Another mistake: recommending Git Flow for a fast-moving startup where it would add unnecessary overhead.

---

**Q:** What are Conventional Commits? What format do they use and why do teams adopt them?

**A:**
Conventional Commits is a specification for writing structured, machine-readable commit messages. It creates an explicit, standardised commit history that tools can parse automatically.

**Format:**
```
<type>[optional scope]: <short description>

[optional body]

[optional footer(s)]
```

**Common types:**

| Type | Meaning |
|---|---|
| `feat` | A new feature (triggers MINOR version bump in SemVer) |
| `fix` | A bug fix (triggers PATCH version bump) |
| `chore` | Maintenance, dependency updates, no production code change |
| `docs` | Documentation only |
| `style` | Formatting, whitespace, no logic change |
| `refactor` | Code restructure, no feature or fix |
| `test` | Adding or fixing tests |
| `perf` | Performance improvement |
| `ci` | CI/CD configuration changes |
| `build` | Changes to build system or dependencies |
| `BREAKING CHANGE` | In footer or `!` after type — triggers MAJOR version bump |

**Example:**
```bash
# Feature commit
git commit -m "feat(auth): add biometric login support"

# Bug fix with scope
git commit -m "fix(cart): prevent duplicate item on rapid tap"

# Breaking change
git commit -m "feat!: remove deprecated v1 API endpoints

BREAKING CHANGE: /api/v1/* routes no longer exist. Migrate to /api/v2/*."

# Chore
git commit -m "chore: upgrade flutter to 3.19.0"

# With body
git commit -m "fix(profile): handle null avatar URL

Users with no profile photo were crashing on the profile screen.
Resolves #248"
```

**Why teams adopt it:**
1. Auto-generate `CHANGELOG.md` from commit history.
2. Trigger automatic semantic version bumps (tools: `semantic-release`, `standard-version`).
3. Consistent, readable history at a glance.
4. Easier code reviews — type immediately signals intent.

**Why it matters:** Shows professionalism and familiarity with mature engineering team practices. Interviewers from larger teams will specifically ask about this.

**Common mistake:** Writing `fix: fixed the bug` — too vague. Or misusing `chore` for actual bug fixes to avoid a version bump. The description should complete the sentence: "If applied, this commit will... `fix(cart): prevent duplicate item on rapid tap`."

---

**Q:** What are best practices for Pull Requests and Code Reviews — both as the author and the reviewer?

**A:**
Pull Requests (PRs) / Merge Requests are the main quality gate in team development. Done well, they improve code quality and spread knowledge. Done poorly, they become rubber-stamping bottlenecks.

**As the PR Author:**

1. **Keep PRs small and focused** — one concern per PR. Large PRs don't get reviewed properly.
2. **Write a clear description** — what changed, why, how to test it, and screenshots for UI changes.
3. **Link to the issue/ticket** — e.g., `Closes #248`.
4. **Self-review before requesting review** — read your own diff first.
5. **Respond to every comment** — either fix it, or explain why you disagree (professionally).
6. **Don't merge your own PR** — unless explicitly allowed by your team's process.
7. **Rebase or update your branch** before final merge to reduce conflicts.

**As the Reviewer:**

1. **Review the intent first** — does the PR solve the right problem?
2. **Check for correctness** — edge cases, null safety, error handling.
3. **Look for readability and maintainability** — can a newcomer understand this?
4. **Be kind and specific** — suggest, don't demand. Say "consider extracting this to a method" not "this is bad."
5. **Use comment labels when your team agrees on them:**
   - `nit:` minor style preference, non-blocking
   - `suggestion:` take or leave
   - `blocker:` must fix before merging
6. **Don't nitpick style manually** — let linters/formatters handle it (dart format, flutter analyze).
7. **Approve promptly** — unreviewed PRs block teammates.

**Example PR description template:**
```markdown
## What
Adds biometric (Face ID / Fingerprint) login as an alternative to password.

## Why
Reduces login friction for returning users. Addresses #187.

## How to test
1. Install on a device with biometrics enabled
2. Log in once with password
3. On next launch, biometric prompt should appear

## Screenshots
[Before] [After]

## Checklist
- [x] Unit tests added
- [x] No new lint warnings
- [x] Tested on iOS and Android
```

**Why it matters:** Code reviews are a daily activity on real teams. The interviewer is checking your collaboration maturity — whether you give and receive feedback professionally.

**Common mistake:** Writing PRs that are 2,000+ lines of diff with a description of "various improvements." Or as a reviewer, approving everything without reading — known as "LGTM culture."

---

**Q:** How do you handle a hotfix on production while feature branches are in progress?

**A:**
This is a standard Git Flow scenario. Production has a critical bug, but your `develop` branch has half-finished features that aren't release-ready. You must fix production without taking those features along.

**Step-by-step:**

```
main (production) ──●──────────────────────►
                     \                ↑
hotfix/crash-fix      ●──fix commit──►  (merged to main AND develop)
                     
develop ──────────────────────────────────►
         feature/A ────────►
                  feature/B ──────►
```

1. Branch `hotfix/` directly from `main` (not `develop`).
2. Apply the minimal fix — only what's needed to resolve the production issue.
3. Merge the hotfix into **both** `main` AND `develop` so the fix isn't lost in the next release.
4. Tag `main` with the new patch version.
5. Deploy from `main`.

**Example:**
```bash
# 1. Branch from production
git switch main
git switch -c hotfix/null-crash-on-checkout

# 2. Fix the bug, commit
git commit -m "fix(checkout): guard against null user session"

# 3. Merge into main
git switch main
git merge hotfix/null-crash-on-checkout
git tag -a v1.2.1 -m "Hotfix: null crash on checkout"
git push origin main --tags

# 4. ALSO merge into develop to carry the fix forward
git switch develop
git merge hotfix/null-crash-on-checkout
git push origin develop

# 5. Delete hotfix branch
git branch -d hotfix/null-crash-on-checkout
git push origin --delete hotfix/null-crash-on-checkout
```

**Why it matters:** This tests real-world branching discipline. Many candidates freeze at this question because they only think linearly. The key insight is: **always branch hotfixes from `main`, never from `develop`.**

**Common mistake:** Branching the hotfix from `develop` — this risks deploying unfinished features from active feature branches. Or forgetting to back-merge the fix into `develop`, so it disappears in the next release.

---

**Q:** What is a detached HEAD state? How does it happen and how do you recover from it?

**A:**
Normally, `HEAD` points to a branch name (e.g., `main`), which in turn points to the latest commit on that branch. In **detached HEAD** state, `HEAD` points directly to a commit SHA instead of a branch. This means any new commits you make are not on any branch and can be lost by garbage collection.

```
Normal:   HEAD → main → commit C
Detached: HEAD → commit B  (not attached to any branch)
```

**How it happens:**
- `git checkout <commit-hash>` — checking out a specific commit
- `git checkout <tag>` — checking out a tag
- `git rebase` operations internally create a detached HEAD temporarily

**How to recover:**

```bash
# Git warns you:
# HEAD detached at abc1234

# Option 1: If you made commits you want to keep — create a branch
git switch -c feature/my-experiment

# Option 2: If you just want to get back to main without keeping changes
git switch main
# (any commits made in detached HEAD are now orphaned — recoverable via git reflog for ~30 days)

# If you made commits in detached HEAD and then switched away, use reflog to find them:
git reflog
# HEAD@{1}: commit: important work I did
git switch -c recovered-work abc1234  # abc1234 = the orphaned commit
```

**Example:**
```bash
# You accidentally ended up here
git log --oneline
# abc1234 (HEAD) some old commit
# def5678 main was here

git status
# HEAD detached at abc1234

# Save your work if you made commits
git switch -c temp/exploration

# Or just return to main
git switch main
```

**Why it matters:** It's easy to panic when Git says "detached HEAD." The interviewer is checking whether you understand Git's pointer model well enough to navigate this calmly.

**Common mistake:** Making important commits in detached HEAD state and then switching branches — believing the commits are lost forever. They're in `git reflog` for ~30 days. Another mistake: not knowing what detached HEAD means at all.

---

**Q:** What does it mean to "squash" commits? When and why would you do it?

**A:**
Squashing means combining multiple commits into a single commit. It's used to clean up messy "work-in-progress" commit history before merging into a main branch.

```
Before squash:
feature/login:  A──WIP──fix typo──add test──fix test──more tweaks──B(done)

After squash:
feature/login:  A──────────────────────────────────────────────────B(done)
```

**How to squash:**

**Method 1 — Interactive rebase (manual control):**
```bash
# Squash last 4 commits
git rebase -i HEAD~4

# In the editor that opens:
# pick abc1234 feat: initial login form
# squash def5678 WIP: half done
# squash ghi9012 fix typo
# squash jkl3456 finally working

# 'squash' (or 's') folds a commit into the one above it
# You then write one clean commit message for the result
```

**Method 2 — Squash merge via GitHub/GitLab:**
When merging a PR, select "Squash and Merge." All commits from the feature branch become one commit on `main`. Simple and requires no terminal work.

**Method 3 — Reset and recommit:**
```bash
git reset --soft HEAD~4    # Unstage all 4 commits, keep changes staged
git commit -m "feat(auth): complete login screen with validation"
```

**When to squash:**
- Before merging a feature branch to keep `main`'s history clean and meaningful.
- When you have commits like "fix", "fix fix", "please work", "ok now it works".

**When NOT to squash:**
- When each commit is meaningful on its own (atomic, well-described commits don't need squashing).
- On `main` or `develop` directly — squash before merging, not after.

**Why it matters:** History hygiene. The interviewer is checking that you care about `git log` being a useful tool, not just a commit dumping ground.

**Common mistake:** Squashing commits that have already been pushed and shared with others — this rewrites history and causes conflicts. Squash only local/feature branch commits before they merge.

---

**Q:** How do you undo the last commit without losing your changes?

**A:**
Use `git reset --soft HEAD~1` or `git reset --mixed HEAD~1`. Both undo the commit but keep your file changes — the difference is where the changes land.

```
git reset --soft HEAD~1
→ Changes go back to STAGING AREA (still staged, ready to re-commit)

git reset --mixed HEAD~1  (default, same as git reset HEAD~1)
→ Changes go back to WORKING DIRECTORY (unstaged, files still modified)
```

**Example:**
```bash
# You committed too soon — wrong message or missed a file

# Option 1: Keep changes staged (just re-commit with a better message)
git reset --soft HEAD~1
git add lib/missing_file.dart   # add the file you forgot
git commit -m "feat: correct commit message"

# Option 2: Unstage changes (review before re-staging)
git reset HEAD~1
# Same as: git reset --mixed HEAD~1
git status   # shows all changes as unstaged

# Option 3: Amend (if you just want to fix the commit message or add a file)
git commit --amend -m "fix: corrected commit message"
# or
git add lib/forgot_this.dart
git commit --amend --no-edit   # adds the file to the last commit
```

**⚠️ Important:** If you've already pushed the commit, `git reset` rewrites local history. You'd need `git push --force-with-lease` to update remote — which is dangerous on shared branches.

**Why it matters:** A practical daily-use scenario. Interviewers want to know you can handle common mistakes without panicking or using `--hard` unnecessarily.

**Common mistake:** Using `git reset --hard HEAD~1` when the intent was just to fix a commit message — this permanently deletes all changes from that commit. Always default to `--soft` or `--mixed` unless you explicitly want to discard changes.

---

**Q:** How do you find which commit introduced a bug using `git bisect`?

**A:**
`git bisect` performs a **binary search** through commit history to find the exact commit that introduced a bug. Instead of manually checking hundreds of commits, Git narrows it down in O(log n) steps.

```
History: A──B──C──D──E──F──G──H  (HEAD, bug present)
         ↑
         known good

git bisect:
Step 1: Test D (middle) → bug present → go left
Step 2: Test B (middle of A-D) → no bug → go right  
Step 3: Test C → bug present → C is the first bad commit!
```

**Step-by-step:**

```bash
# 1. Start bisect mode
git bisect start

# 2. Mark the current state as bad (bug exists)
git bisect bad HEAD

# 3. Mark a known-good commit (before the bug)
git bisect good v1.1.0
# Or a specific commit hash:
git bisect good abc1234

# Git now checks out a commit in the middle.
# 4. Test the app — does the bug exist?
#    If YES:
git bisect bad
#    If NO:
git bisect good

# Git checks out the next midpoint. Repeat until:
# "abc1234 is the first bad commit"

# 5. Inspect the culprit
git show abc1234

# 6. Exit bisect mode (returns to HEAD)
git bisect reset
```

**Automated bisect (if you have a test script):**
```bash
git bisect start
git bisect bad HEAD
git bisect good v1.1.0
git bisect run flutter test test/auth_test.dart
# Git runs the test script automatically at each step
# Exit code 0 = good, non-zero = bad
```

**Why it matters:** This is a senior-level debugging skill. On a project with hundreds of commits, manually checking each one is impractical. Bisect finds the culprit in ~7 steps for 100 commits, ~10 steps for 1,000.

**Common mistake:** Not knowing this command exists and saying "I'd just go through the commits manually." Or forgetting to run `git bisect reset` at the end, leaving the repo in bisect mode.

---
