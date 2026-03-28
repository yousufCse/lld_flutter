# Scrum থেকে Tech Lead
## একজন Senior Software Engineer-এর সম্পূর্ণ গাইড

> **লেখার উদ্দেশ্য:** এই বইটি একজন Software Developer-কে Scrum ও Agile-এর গভীর জ্ঞান দেবে এবং Tech Lead হওয়ার পথ দেখাবে। প্রতিটি তত্ত্ব বাস্তব project-এর উদাহরণ দিয়ে বোঝানো হয়েছে — যেন পড়েই কাজে লাগানো যায়।

> **কার জন্য:** Junior, Mid এবং Senior Software Engineer — যারা Scrum বুঝতে চান এবং Tech Lead হিসেবে নিজেকে গড়তে চান।

> **Project:** সারা বই জুড়ে **QuickMart** নামে একটি E-commerce Application-এর উদাহরণ ব্যবহার করা হয়েছে।

---

## 📚 সূচিপত্র (Table of Contents)

### ভূমিকা
- [বইটি কীভাবে পড়বেন](#ভূমিকা)

### অধ্যায় ১ — Agile কী এবং কেন?
- [১.১ Software Development-এর পুরনো সমস্যা](#১১-software-development-এর-পুরনো-সমস্যা)
- [১.২ Waterfall Model এবং এর সীমাবদ্ধতা](#১২-waterfall-model-এবং-এর-সীমাবদ্ধতা)
- [১.৩ Agile Manifesto — ৪টি মূলনীতি](#১৩-agile-manifesto--৪টি-মূলনীতি)
- [১.৪ Agile-এর ১২টি Principle](#১৪-agile-এর-১২টি-principle)
- [১.৫ Agile মানে কী নয়](#১৫-agile-মানে-কী-নয়)

### অধ্যায় ২ — Scrum Framework সম্পূর্ণ গাইড
- [২.১ Scrum কী?](#২১-scrum-কী)
- [২.২ Scrum-এর ৩টি মূল স্তম্ভ](#২২-scrum-এর-৩টি-মূল-স্তম্ভ)
- [২.৩ Scrum-এর ৫টি মূল্যবোধ](#২৩-scrum-এর-৫টি-মূল্যবোধ)
- [২.৪ Scrum Roles — ৩টি চরিত্র](#২৪-scrum-roles--৩টি-চরিত্র)
- [২.৫ Scrum Artifacts — ৩টি জিনিস](#২৫-scrum-artifacts--৩টি-জিনিস)
- [২.৬ Scrum Events — ৫টি Meeting](#২৬-scrum-events--৫টি-meeting)
- [২.৭ Definition of Done (DoD)](#২৭-definition-of-done-dod)
- [২.৮ Definition of Ready (DoR)](#২৮-definition-of-ready-dor)

### অধ্যায় ৩ — User Story, Estimation এবং Planning
- [৩.১ User Story কী এবং কীভাবে লিখবেন](#৩১-user-story-কী-এবং-কীভাবে-লিখবেন)
- [৩.২ Acceptance Criteria](#৩২-acceptance-criteria)
- [৩.৩ Story Points এবং Estimation](#৩৩-story-points-এবং-estimation)
- [৩.৪ Planning Poker](#৩৪-planning-poker)
- [৩.৫ Velocity](#৩৫-velocity)
- [৩.৬ Spike Story](#৩৬-spike-story)
- [৩.৭ Non-Functional Requirements (NFR)](#৩৭-non-functional-requirements-nfr)

### অধ্যায় ৪ — Jira দিয়ে Scrum Manage করা
- [৪.১ Jira-র Issue Hierarchy](#৪১-jira-র-issue-hierarchy)
- [৪.২ Epic তৈরি করা](#৪২-epic-তৈরি-করা)
- [৪.৩ User Story তৈরি করা](#৪৩-user-story-তৈরি-করা)
- [৪.৪ Sub-task তৈরি করা](#৪৪-sub-task-তৈরি-করা)
- [৪.৫ Bug Ticket তৈরি করা](#৪৫-bug-ticket-তৈরি-করা)
- [৪.৬ Sprint Setup করা](#৪৬-sprint-setup-করা)
- [৪.৭ Jira Board পরিচালনা করা](#৪৭-jira-board-পরিচালনা-করা)
- [৪.৮ Burndown এবং Burnup Chart](#৪৮-burndown-এবং-burnup-chart)
- [৪.৯ Backlog Refinement](#৪৯-backlog-refinement)
- [৪.১০ WIP Limit](#৪১০-wip-limit)

### অধ্যায় ৫ — Bug Triage এবং Release Management
- [৫.১ Bug Priority নির্ধারণ](#৫১-bug-priority-নির্ধারণ)
- [৫.২ Bug Triage Process](#৫২-bug-triage-process)
- [৫.৩ Release Planning](#৫৩-release-planning)

### অধ্যায় ৬ — Tech Lead হিসেবে Sprint Planning
- [৬.১ Tech Lead কে?](#৬১-tech-lead-কে)
- [৬.২ Sprint Planning-এর আগের প্রস্তুতি](#৬২-sprint-planning-এর-আগের-প্রস্তুতি)
- [৬.৩ Sprint Goal নির্ধারণ](#৬৩-sprint-goal-নির্ধারণ)
- [৬.৪ Story Breakdown করা](#৬৪-story-breakdown-করা)
- [৬.৫ Task Assignment](#৬৫-task-assignment)
- [৬.৬ Dependency Map](#৬৬-dependency-map)
- [৬.৭ Sprint চলাকালীন কাজ](#৬৭-sprint-চলাকালীন-কাজ)
- [৬.৮ Tech Lead-এর Golden Rules](#৬৮-tech-lead-এর-golden-rules)

### অধ্যায় ৭ — Architecture Decision
- [৭.১ Architecture Decision কী?](#৭১-architecture-decision-কী)
- [৭.২ Decision নেওয়ার Framework](#৭২-decision-নেওয়ার-framework)
- [৭.৩ Image Storage Decision — উদাহরণ](#৭৩-image-storage-decision--উদাহরণ)
- [৭.৪ Performance Problem সমাধান](#৭৪-performance-problem-সমাধান)
- [৭.৫ Monolith vs Microservice](#৭৫-monolith-vs-microservice)
- [৭.৬ Architecture Decision Record (ADR)](#৭৬-architecture-decision-record-adr)
- [৭.৭ Team-কে Decision বোঝানো](#৭৭-team-কে-decision-বোঝানো)

### অধ্যায় ৮ — Code Review
- [৮.১ Code Review কেন দরকার?](#৮১-code-review-কেন-দরকার)
- [৮.২ ভালো Pull Request কেমন হয়?](#৮২-ভালো-pull-request-কেমন-হয়)
- [৮.৩ Code Review Checklist](#৮৩-code-review-checklist)
- [৮.৪ Critical Issues — কী দেখবেন](#৮৪-critical-issues--কী-দেখবেন)
- [৮.৫ Comment কীভাবে লিখবেন](#৮৫-comment-কীভাবে-লিখবেন)
- [৮.৬ Code Review-এর ৩ স্তর](#৮৬-code-review-এর-৩-স্তর)
- [৮.৭ Code Review Culture তৈরি করা](#৮৭-code-review-culture-তৈরি-করা)

### অধ্যায় ৯ — Technical Debt
- [৯.১ Technical Debt কী?](#৯১-technical-debt-কী)
- [৯.২ Debt-এর ৩ ধরন](#৯২-debt-এর-৩-ধরন)
- [৯.৩ Debt Audit করা](#৯৩-debt-audit-করা)
- [৯.৪ Debt Backlog তৈরি করা](#৯৪-debt-backlog-তৈরি-করা)
- [৯.৫ PO-কে Convince করা](#৯৫-po-কে-convince-করা)
- [৯.৬ ২০% Rule](#৯৬-২০-rule)
- [৯.৭ Debt Prevention](#৯৭-debt-prevention)

### অধ্যায় ১০ — System Design Basics
- [১০.১ System Design কী?](#১০১-system-design-কী)
- [১০.২ Basic Building Blocks](#১০২-basic-building-blocks)
- [১০.৩ Key Concepts](#১০৩-key-concepts)
- [১০.৪ QuickMart-এর Full System Design](#১০৪-quickmart-এর-full-system-design)
- [১০.৫ Phase ভিত্তিক Scaling](#১০৫-phase-ভিত্তিক-scaling)

### অধ্যায় ১১ — Roadmap তৈরি করা
- [১১.১ Roadmap কী?](#১১১-roadmap-কী)
- [১১.২ Roadmap-এর ধরন](#১১২-roadmap-এর-ধরন)
- [১১.৩ Goal থেকে Feature বের করা](#১১৩-goal-থেকে-feature-বের-করা)
- [১১.৪ MoSCoW Priority Method](#১১৪-moscow-priority-method)
- [১১.৫ Quarterly Roadmap বানানো](#১১৫-quarterly-roadmap-বানানো)
- [১১.৬ Milestone এবং Risk](#১১৬-milestone-এবং-risk)
- [১১.৭ Roadmap Communicate করা](#১১৭-roadmap-communicate-করা)

### অধ্যায় ১২ — Agile + DevOps একসাথে
- [১২.১ DevOps কী?](#১২১-devops-কী)
- [১২.২ CI/CD Pipeline কী?](#১২২-cicd-pipeline-কী)
- [১২.৩ CI — Continuous Integration](#১২৩-ci--continuous-integration)
- [১২.৪ CD — Continuous Deployment](#১২৪-cd--continuous-deployment)
- [১২.৫ Environment Management](#১২৫-environment-management)
- [১২.৬ Monitoring এবং Alerting](#১২৬-monitoring-এবং-alerting)
- [১২.৭ Rollback Strategy](#১২৭-rollback-strategy)
- [১২.৮ Agile Sprint + DevOps একসাথে](#১২৮-agile-sprint--devops-একসাথে)

### অধ্যায় ১৩ — Blocker সরানো
- [১৩.১ Blocker কী?](#১৩১-blocker-কী)
- [১৩.২ Blocker-এর ধরন](#১৩২-blocker-এর-ধরন)
- [১৩.৩ Blocker সরানোর Framework](#১৩৩-blocker-সরানোর-framework)
- [১৩.৪ Real Blocker উদাহরণ](#১৩৪-real-blocker-উদাহরণ)
- [১৩.৫ Blocker vs Problem](#১৩৫-blocker-vs-problem)
- [১৩.৬ Blocker Prevention](#১৩৬-blocker-prevention)

### অধ্যায় ১৪ — Career Path
- [১৪.১ Software Field-এর সব Roles](#১৪১-software-field-এর-সব-roles)
- [১৪.২ Senior Dev থেকে Tech Lead-এর যাত্রা](#১৪২-senior-dev-থেকে-tech-lead-এর-যাত্রা)
- [১৪.৩ Certification Guide](#১৪৩-certification-guide)
- [১৪.৪ Learning Roadmap](#১৪৪-learning-roadmap)

---

## ভূমিকা

এই বইটি লেখা হয়েছে তাদের জন্য যারা Software Development-এর কাজ করেন এবং Scrum ও Agile-কে শুধু তত্ত্ব হিসেবে নয়, বাস্তব কাজে ব্যবহার করতে চান। বইটি পড়ার পর একজন Developer Scrum-এর প্রতিটি অংশ বুঝবেন, Jira-তে কাজ পরিচালনা করতে পারবেন, এবং Tech Lead হিসেবে team চালানোর দক্ষতা অর্জন করবেন।

**বইটি কীভাবে পড়বেন:**

বইটি অধ্যায় অনুযায়ী পড়া সবচেয়ে ভালো। প্রতিটি অধ্যায়ে তত্ত্ব ব্যাখ্যার পর **QuickMart** project-এর বাস্তব উদাহরণ দেওয়া হয়েছে। QuickMart হলো একটি E-commerce Application যেখানে Seller product বিক্রি করে এবং Buyer product কেনে।

প্রতিটি অধ্যায় পড়ার পর সেই বিষয়টি নিজের কাজে প্রয়োগ করুন। শুধু পড়লে জ্ঞান হবে, কিন্তু প্রয়োগ না করলে দক্ষতা আসবে না।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ১ — Agile কী এবং কেন?

## ১.১ Software Development-এর পুরনো সমস্যা

Software Development-এর শুরুর দিকে সব কাজ একটি নির্দিষ্ট পদ্ধতিতে হতো। প্রথমে সব requirement সংগ্রহ করা হতো, তারপর design করা হতো, তারপর code লেখা হতো, তারপর test করা হতো, এবং সবশেষে deliver করা হতো। এই পদ্ধতিকে **Waterfall Model** বলা হয়।

এই পদ্ধতির সবচেয়ে বড় সমস্যা ছিল:

**সমস্যা ১: দেরিতে Feedback**
Client ৬ মাস বা ১ বছর পর product দেখতেন। তখন বলতেন, "আমি আসলে এটা চাইনি।" কিন্তু তখন সব কাজ শেষ।

**সমস্যা ২: Change Handle করা কঠিন**
মাঝপথে কোনো পরিবর্তন আসলে পুরো plan ভেঙে যেত। কারণ পুরো system একটি নির্ভরশীল chain-এ তৈরি।

**সমস্যা ৩: Risk বেশি**
Project শেষে দেখা যেত অনেক কিছু কাজ করছে না বা client-এর প্রয়োজনের সাথে মিলছে না।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১.২ Waterfall Model এবং এর সীমাবদ্ধতা

Waterfall Model পানির মতো এক দিকে প্রবাহিত হয় — উপর থেকে নিচে, আর ফিরে আসে না।

```
Requirements → Design → Development → Testing → Deployment
```

**QuickMart উদাহরণ:**

QuickMart-এর Founder ২০২৪ সালের জানুয়ারিতে সব requirement দিলেন। Team ৬ মাস কাজ করলো। জুলাই মাসে product deliver করার সময় Founder বললেন, "আমি চেয়েছিলাম Seller নিজে product price বদলাতে পারবে, কিন্তু সেটা নেই।" ৬ মাসের কাজের পর এই পরিবর্তন করা অনেক কঠিন এবং ব্যয়বহুল।

**Waterfall-এর সীমাবদ্ধতা:**

| সমস্যা | ফলাফল |
|--------|--------|
| Feedback দেরিতে আসে | ভুল product তৈরি হয় |
| Change করা কঠিন | Client frustrate হন |
| Risk পরে ধরা পড়ে | Cost বাড়ে |
| Progress দেখা যায় না | Management অন্ধকারে থাকে |

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১.৩ Agile Manifesto — ৪টি মূলনীতি

২০০১ সালে ১৭ জন Software Developer মিলে **Agile Manifesto** লিখলেন। এতে বলা হলো:

**মূলনীতি ১:**
> Processes এবং Tools-এর চেয়ে **Individuals এবং Interactions** বেশি গুরুত্বপূর্ণ।

মানে: ভালো tool-এর চেয়ে ভালো মানুষ এবং তাদের যোগাযোগ বেশি কাজের।

**মূলনীতি ২:**
> Comprehensive Documentation-এর চেয়ে **Working Software** বেশি গুরুত্বপূর্ণ।

মানে: ১০০ পাতার document-এর চেয়ে একটি কাজ করা software বেশি মূল্যবান।

**মূলনীতি ৩:**
> Contract Negotiation-এর চেয়ে **Customer Collaboration** বেশি গুরুত্বপূর্ণ।

মানে: চুক্তি নিয়ে তর্ক করার চেয়ে client-এর সাথে মিলে কাজ করা ভালো।

**মূলনীতি ৪:**
> Plan অনুসরণ করার চেয়ে **Change-এ সাড়া দেওয়া** বেশি গুরুত্বপূর্ণ।

মানে: পরিবর্তনকে ভয় না পেয়ে মানিয়ে নেওয়া।

**গুরুত্বপূর্ণ:** বাম দিকের বিষয়গুলোও মূল্যবান, কিন্তু ডান দিকের বিষয়গুলো বেশি গুরুত্বপূর্ণ।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১.৪ Agile-এর ১২টি Principle

Agile Manifesto-তে ১২টি Principle আছে। এগুলো জানা দরকার কারণ এই Principle-গুলো দিয়েই বোঝা যায় কোনো একটি সিদ্ধান্ত Agile কিনা।

**Principle ১:** Customer-কে সন্তুষ্ট করতে দ্রুত এবং নিয়মিত Working Software deliver করো।

**Principle ২:** Requirement পরিবর্তনকে স্বাগত জানাও, এমনকি Development-এর শেষ দিকেও।

**Principle ৩:** Working Software নিয়মিত deliver করো — সপ্তাহ থেকে মাস, কম সময়ই ভালো।

**Principle ৪:** Business এবং Developer-রা প্রতিদিন একসাথে কাজ করবে।

**Principle ৫:** Motivated ব্যক্তিদের নিয়ে project তৈরি করো। তাদের যা দরকার দাও এবং বিশ্বাস করো।

**Principle ৬:** Information পৌঁছানোর সবচেয়ে ভালো উপায় হলো face-to-face কথা বলা।

**Principle ৭:** Working Software হলো Progress-এর প্রধান পরিমাপ।

**Principle ৮:** Agile Process টেকসই Development promote করে। সবাই indefinitely একই pace-এ কাজ করতে পারবে।

**Principle ৯:** Technical Excellence এবং ভালো Design-এ মনোযোগ দিলে Agility বাড়ে।

**Principle ১০:** Simplicity — না করা কাজের পরিমাণ maximize করা — অত্যন্ত গুরুত্বপূর্ণ।

**Principle ১১:** সেরা Architecture, Requirements এবং Design আসে Self-organizing Team থেকে।

**Principle ১২:** নিয়মিত Team reflect করবে কীভাবে আরো কার্যকর হওয়া যায় এবং সেই অনুযায়ী কাজ করবে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১.৫ Agile মানে কী নয়

Agile নিয়ে অনেক ভুল ধারণা আছে। এগুলো জানা দরকার।

**ভুল ধারণা ১: Agile মানে কোনো Plan নেই**

Agile-এ Plan থাকে, কিন্তু সেটা Flexible। Plan পরিবর্তন হতে পারে, কিন্তু কোনো Plan ছাড়া কাজ করা Agile নয়।

**ভুল ধারণা ২: Agile মানে Document লেখা লাগে না**

Documentation দরকার আছে, তবে প্রয়োজনের বেশি না। Working Software-এর চেয়ে Document বেশি গুরুত্বপূর্ণ নয়।

**ভুল ধারণা ৩: Agile মানে যখন খুশি Requirement পরিবর্তন করা যায়**

Requirement পরিবর্তন হতে পারে, কিন্তু Sprint চলাকালীন Scope পরিবর্তন করা ঠিক নয়। পরিবর্তন Backlog-এ যাবে এবং পরের Sprint-এ আসবে।

**ভুল ধারণা ৪: Agile মানে Meeting করা**

Daily Standup, Sprint Planning — এগুলো Agile-এর অংশ, কিন্তু Meeting করাই Agile নয়। কাজের Result-ই আসল।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ২ — Scrum Framework সম্পূর্ণ গাইড

## ২.১ Scrum কী?

**Scrum** হলো Agile-এর একটি Framework — মানে Agile-এর ধারণাকে বাস্তবে কীভাবে প্রয়োগ করবেন তার নির্দিষ্ট নিয়ম ও কাঠামো।

Rugby খেলায় "Scrum" মানে দল মিলে একসাথে push করা। Software Development-এও Scrum-এ দল মিলে একসাথে কাজ করে।

**Scrum-এর মূল ধারণা:**

ছোট ছোট সময়ের মধ্যে কাজ করা, প্রতিটি সময়ের শেষে কাজ করা product দেখানো, feedback নেওয়া, এবং সেই অনুযায়ী পরবর্তী কাজ সাজানো।

```
Plan → Build → Review → Adapt → Plan → Build → ...
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ২.২ Scrum-এর ৩টি মূল স্তম্ভ

Scrum তিনটি মূল স্তম্ভের উপর দাঁড়িয়ে আছে। এই তিনটি না থাকলে Scrum কাজ করে না।

**স্তম্ভ ১: Transparency (স্বচ্ছতা)**

সবকিছু সবার কাছে স্পষ্ট থাকতে হবে। কে কী কাজ করছে, কতটুকু হয়েছে, কোথায় সমস্যা আছে — এসব সবাই জানবে।

*QuickMart উদাহরণ:* Jira Board-এ সবার কাজ দেখা যাচ্ছে। রাফি কোন feature-এ কাজ করছে, মিম কোথায় আটকে আছে — সব স্পষ্ট।

**স্তম্ভ ২: Inspection (পরীক্ষা)**

নিয়মিত কাজ পরীক্ষা করতে হবে। Daily Standup-এ প্রতিদিন, Sprint Review-এ প্রতি Sprint-এ।

*QuickMart উদাহরণ:* প্রতিদিন Standup-এ দেখা হচ্ছে কাজ ঠিকমতো এগোচ্ছে কিনা। Sprint শেষে Burndown Chart দেখা হচ্ছে।

**স্তম্ভ ৩: Adaptation (পরিবর্তন)**

পরীক্ষা করে সমস্যা দেখলে পরিবর্তন করতে হবে। এটাই Agile-এর সাথে Scrum-এর সবচেয়ে বড় মিল।

*QuickMart উদাহরণ:* Sprint Review-এ Founder বললেন Search feature বেশি দরকার। পরের Sprint-এর Plan পরিবর্তন করা হলো।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ২.৩ Scrum-এর ৫টি মূল্যবোধ

Scrum-এ পাঁচটি মূল্যবোধ আছে যা Team-এর culture তৈরি করে।

**১. Commitment (প্রতিশ্রুতি):** Team তাদের goal-এর প্রতি committed থাকবে।

**২. Courage (সাহস):** কঠিন সমস্যা মোকাবেলা করার সাহস থাকবে। ভুল হলে স্বীকার করবে।

**৩. Focus (মনোযোগ):** Sprint-এর goal-এ মনোযোগ দেবে। অন্য বিষয় Sprint-এর মধ্যে আনবে না।

**৪. Openness (খোলামেলাভাব):** কাজ এবং চ্যালেঞ্জ সম্পর্কে সৎ থাকবে।

**৫. Respect (সম্মান):** Team-এর সবাই একে অপরকে সক্ষম মানুষ হিসেবে সম্মান করবে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ২.৪ Scrum Roles — ৩টি চরিত্র

Scrum-এ তিনটি Role আছে। এর বাইরে আলাদা কোনো Role নেই।

### Product Owner (PO)

**কে হন:** Client বা Business-এর প্রতিনিধি। একজনই হবেন, একাধিক নয়।

**মূল কাজ:**
- Product Backlog তৈরি ও পরিচালনা করা
- Feature-এর Priority নির্ধারণ করা
- Team-কে "কী বানাতে হবে" বলা
- Stakeholder-দের সাথে যোগাযোগ রাখা

**PO কী করেন না:**
- "কীভাবে বানাবে" বলেন না — এটা Developer-এর কাজ
- Sprint-এর মাঝে নতুন কাজ দেন না
- Team-এর কাজে মাঝে মাঝে হস্তক্ষেপ করেন না

*QuickMart উদাহরণ:* সাদিয়া QuickMart-এর PO। তিনি ঠিক করেন কোন feature আগে বানাতে হবে — Payment আগে, নাকি Seller Dashboard আগে।

### Scrum Master (SM)

**কে হন:** Team-এর Coach এবং Facilitator। এটি Management Position নয়।

**মূল কাজ:**
- Scrum ঠিকমতো follow হচ্ছে কিনা দেখা
- Team-এর সামনের বাধা সরানো
- PO এবং Development Team-এর মধ্যে সেতু হিসেবে কাজ করা
- Team-কে Scrum শেখানো

**Scrum Master কী করেন না:**
- Boss নন — কাকে কী কাজ দিতে হবে বলেন না
- Technical সিদ্ধান্ত নেন না
- Product-এর Priority ঠিক করেন না

*QuickMart উদাহরণ:* করিম QuickMart-এর Scrum Master। তিনি নিশ্চিত করেন Daily Standup ১৫ মিনিটের বেশি না হয়, Sprint Planning ঠিকমতো হয়।

### Development Team

**কে হন:** Developers, Testers, Designers — যারা product বানান।

**মূল বৈশিষ্ট্য:**
- **Self-organizing:** নিজেরাই সিদ্ধান্ত নেয় কে কী করবে
- **Cross-functional:** Team-এর ভেতরেই সব skill আছে
- **আকার:** ৩ থেকে ৯ জন

**Development Team কী করে না:**
- কাকে কী কাজ দিতে হবে বাইরে থেকে বলা নেয় না
- Sprint-এর মাঝে নতুন কাজ accept করে না

*QuickMart উদাহরণ:* রাফি, মিম, তানভীর, নীলা, এবং QA রিয়া — এরা Development Team।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ২.৫ Scrum Artifacts — ৩টি জিনিস

Scrum-এ তিনটি Artifact আছে। এগুলো হলো কাজের উপকরণ।

### Product Backlog

Product Backlog হলো সমস্ত কাজের একটি **সাজানো তালিকা**। এটি Product Owner পরিচালনা করেন।

**বৈশিষ্ট্য:**
- Priority অনুযায়ী সাজানো — সবচেয়ে গুরুত্বপূর্ণ কাজ উপরে
- সবসময় পরিবর্তনশীল — নতুন item যোগ হয়, পুরনো সরানো হয়
- কখনো শেষ হয় না — product থাকলে Backlog থাকবে

*QuickMart-এর Product Backlog উদাহরণ:*

```
১. (HIGH) User registration করতে পারবে
২. (HIGH) User login করতে পারবে
৩. (HIGH) Product add করতে পারবে
৪. (HIGH) Cart-এ product যোগ করা
৫. (HIGH) bKash দিয়ে payment করা
৬. (MEDIUM) Product search করা
৭. (MEDIUM) Seller dashboard দেখা
৮. (LOW) Wishlist তৈরি করা
৯. (LOW) Dark mode চালু করা
```

### Sprint Backlog

Sprint Backlog হলো একটি নির্দিষ্ট Sprint-এ করার কাজের তালিকা। এটি Product Backlog থেকে বেছে নেওয়া হয়।

**বৈশিষ্ট্য:**
- Development Team নিজে manage করে
- Sprint চলাকালীন Scope পরিবর্তন হয় না
- প্রতিদিন Update হয় — কাজ শেষ হলে Done হয়

### Increment

Sprint শেষে যে কাজ করা product তৈরি হয় সেটাই Increment। এটি অবশ্যই "Done" হতে হবে — অর্থাৎ ship করার মতো মানের হতে হবে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ২.৬ Scrum Events — ৫টি Meeting

Scrum-এ পাঁচটি নির্দিষ্ট Meeting আছে। প্রতিটির একটি নির্দিষ্ট উদ্দেশ্য এবং সময়সীমা আছে।

### Sprint

Sprint হলো সবকিছুর ভিত্তি। এটি একটি নির্দিষ্ট সময়ের বাক্স (Time-box), সাধারণত ১ থেকে ৪ সপ্তাহ।

**Sprint-এর নিয়ম:**
- প্রতিটি Sprint-এ একটি Goal থাকে
- Sprint চলাকালীন Scope পরিবর্তন হয় না
- Sprint শেষ হলে পরবর্তী Sprint শুরু হয়
- Sprint কখনো বাতিল করা যায় না, শুধুমাত্র PO বাতিল করতে পারেন (বিরল ক্ষেত্রে)

### Sprint Planning

**কখন:** প্রতি Sprint-এর শুরুতে

**সময়সীমা:** ২ সপ্তাহের Sprint-এ ২ ঘণ্টা, ৪ সপ্তাহের Sprint-এ ৪ ঘণ্টা

**কী হয়:**
- Sprint Goal নির্ধারণ করা হয়
- Product Backlog থেকে কাজ বেছে নেওয়া হয়
- Sprint Backlog তৈরি হয়
- Team নিশ্চিত করে তারা কাজগুলো করতে পারবে

**দুটি প্রশ্নের উত্তর হয়:**
১. এই Sprint-এ কী deliver করা হবে?
২. কীভাবে সেই কাজ করা হবে?

### Daily Scrum (Daily Standup)

**কখন:** প্রতিদিন, একই সময়ে

**সময়সীমা:** ঠিক ১৫ মিনিট

**তিনটি প্রশ্ন:**
১. গতকাল কী করলাম?
২. আজ কী করবো?
৩. কোনো বাধা (Blocker) আছে কি?

**গুরুত্বপূর্ণ নিয়ম:**
- এটি Status Meeting নয়, Coordination Meeting
- সমস্যা এখানে Solve করা হয় না — শুধু চিহ্নিত করা হয়
- Scrum Master সমস্যা Solve করার ব্যবস্থা করেন পরে
- Standing করে করা হয় যাতে দ্রুত শেষ হয়

*QuickMart-এ Daily Standup উদাহরণ:*

```
রাফি:
গতকাল: Cart API শেষ করেছি।
আজ: Unit test লিখবো।
Blocker: নেই।

মিম:
গতকাল: bKash Sandbox setup করার চেষ্টা করেছি।
আজ: একই কাজ চালিয়ে যাবো।
Blocker: bKash API-তে 403 error আসছে, সাহায্য দরকার।

Tech Lead:
"মিম, Standup শেষে ১৫ মিনিট একসাথে দেখি।"
```

### Sprint Review

**কখন:** Sprint শেষে

**সময়সীমা:** ২ সপ্তাহের Sprint-এ ২ ঘণ্টা

**কী হয়:**
- Team যা বানিয়েছে তার Demo দেওয়া হয়
- Stakeholder-রা Feedback দেন
- Product Backlog Update হতে পারে

**গুরুত্বপূর্ণ:** Sprint Review হলো Collaboration-এর জায়গা, Presentation-এর নয়। Stakeholder-দের সক্রিয় অংশগ্রহণ দরকার।

### Sprint Retrospective

**কখন:** Sprint Review-এর পরে

**সময়সীমা:** ২ সপ্তাহের Sprint-এ ১.৫ ঘণ্টা

**তিনটি বিষয় নিয়ে আলোচনা:**
- কী ভালো হলো? (Continue করবো)
- কী ভালো হলো না? (Stop করবো)
- পরবর্তীতে কী নতুন করবো? (Start করবো)

**গুরুত্বপূর্ণ:** Retrospective হলো উন্নতির জায়গা, কারো দোষ দেওয়ার জায়গা নয়।

**Retrospective-এর বিভিন্ন Format:**

*Format ১: Start / Stop / Continue*
- Start: নতুন কী শুরু করবো
- Stop: কী বন্ধ করবো
- Continue: কী চালিয়ে যাবো

*Format ২: 4Ls*
- Liked: কী ভালো লেগেছে
- Learned: কী শিখলাম
- Lacked: কী মিস করেছে
- Longed For: কী চেয়েছিলাম

*Format ৩: Mad / Sad / Glad*
- Mad: কী বিরক্ত করেছে
- Sad: কী দুঃখ দিয়েছে
- Glad: কী আনন্দ দিয়েছে

প্রতি ৩ Sprint-এ Format পরিবর্তন করলে Meeting Fresh থাকে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ২.৭ Definition of Done (DoD)

**Definition of Done** হলো Team-এর সম্মিলিত সিদ্ধান্ত — "কাজ Done মানে কী?"

এটি না থাকলে একজন বলবেন "Code লিখেছি, Done।" আরেকজন বলবেন "Test না হলে Done নয়।" এই বিভ্রান্তি দূর করতেই DoD।

*QuickMart-এর Definition of Done:*

```
একটি Story "Done" বলা যাবে যখন:
✅ Code লেখা শেষ হয়েছে
✅ Unit Test লেখা হয়েছে এবং Pass করেছে
✅ Code Review হয়েছে এবং Approve হয়েছে
✅ QA Test করেছে এবং কোনো Critical Bug নেই
✅ Acceptance Criteria পূরণ হয়েছে
✅ Documentation Update হয়েছে (যদি দরকার হয়)
✅ Staging Environment-এ Deploy হয়েছে
```

**গুরুত্বপূর্ণ:** DoD পুরো Team মিলে তৈরি করে। Tech Lead বা PO একা তৈরি করেন না।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ২.৮ Definition of Ready (DoR)

**Definition of Ready** হলো একটি Story Sprint-এ নেওয়ার আগে কী কী থাকতে হবে।

DoD যেমন "কাজ শেষ হলে কী?" তেমনি DoR হলো "কাজ শুরু করার আগে কী লাগবে?"

*QuickMart-এর Definition of Ready:*

```
একটি Story Sprint-এ নেওয়া যাবে যখন:
✅ User Story স্পষ্টভাবে লেখা আছে
✅ Acceptance Criteria লেখা আছে
✅ UI Story হলে Design/Mockup আছে
✅ Story Point দিয়ে Estimate করা হয়েছে
✅ Dependency স্পষ্ট করা হয়েছে
✅ PO Approve করেছেন
```

**কেন DoR দরকার:** DoR ছাড়া Sprint-এর মাঝে Story আটকে যায় কারণ কোনো তথ্য missing থাকে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ৩ — User Story, Estimation এবং Planning

## ৩.১ User Story কী এবং কীভাবে লিখবেন

**User Story** হলো কাজ লেখার একটি পদ্ধতি যা User-এর দৃষ্টিভঙ্গি থেকে লেখা হয়।

**Format:**
```
As a [কে], I want [কী করতে চায়], So that [কেন / কী লাভ]
```

**কেন এই Format:**
- "কে" জানলে কার জন্য বানাচ্ছি বোঝা যায়
- "কী" জানলে কাজের scope বোঝা যায়
- "কেন" জানলে business value বোঝা যায়

*QuickMart-এর User Story উদাহরণ:*

```
Story 1:
As a new user,
I want to register with my email and password,
So that I can access QuickMart.

Story 2:
As a buyer,
I want to add products to my cart,
So that I can purchase multiple items at once.

Story 3:
As a seller,
I want to upload multiple product photos,
So that buyers can see the product clearly.
```

**INVEST Criteria — ভালো User Story-র পরীক্ষা:**

| অক্ষর | মানে | প্রশ্ন |
|-------|------|--------|
| I | Independent | এটি অন্য Story-র উপর নির্ভরশীল নয়? |
| N | Negotiable | এটি নিয়ে আলোচনা করা যাবে? |
| V | Valuable | এটি User-এর জন্য মূল্যবান? |
| E | Estimable | এটি Estimate করা যায়? |
| S | Small | এটি একটি Sprint-এ শেষ করা যায়? |
| T | Testable | এটি Test করা যায়? |

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৩.২ Acceptance Criteria

**Acceptance Criteria** হলো প্রতিটি User Story-তে লেখা শর্ত — "কখন বলা যাবে এই কাজ সম্পন্ন হয়েছে?"

**কেন দরকার:**
- Developer জানে কী বানাতে হবে
- QA জানে কী Test করতে হবে
- PO জানে কখন Accept করবেন

*QuickMart উদাহরণ — Registration Story-র Acceptance Criteria:*

```
Story: User registration করতে পারবে

Acceptance Criteria:
✅ Name, Email, Password দিয়ে register করা যাবে
✅ Duplicate email দিলে "Email already exists" error দেখাবে
✅ Password minimum ৮ character হতে হবে
✅ Password-এ কমপক্ষে একটি number থাকতে হবে
✅ Successful registration-এ Welcome email যাবে
✅ Successful registration-এর পর Dashboard-এ redirect হবে
```

**Acceptance Criteria লেখার নিয়ম:**
- Given / When / Then format ব্যবহার করা যায়
- প্রতিটি Criteria স্বাধীনভাবে Test করা যাবে
- Negative case-ও লিখতে হবে (ভুল input দিলে কী হবে)

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৩.৩ Story Points এবং Estimation

**Story Points** হলো কাজের জটিলতা মাপার একক। এটি সময় নয় — এটি complexity, uncertainty, এবং effort-এর সমন্বয়।

**কেন সময়ের বদলে Story Point:**
- সময় ব্যক্তিভেদে আলাদা — একই কাজ Senior-এর ১ ঘণ্টা, Junior-এর ৩ ঘণ্টা
- Story Point relative — "এটি ওটার চেয়ে দ্বিগুণ জটিল"
- Team-এর গড় Performance measure করা যায়

**Fibonacci Sequence ব্যবহার:**
```
1, 2, 3, 5, 8, 13, 21...
```

কেন Fibonacci: বড় কাজে uncertainty বেশি, তাই বড় কাজের মধ্যে বড় gap রাখা হয়।

*QuickMart-এ Story Point উদাহরণ:*

```
1 Point: Login button-এর color পরিবর্তন
2 Point: Password reset email পাঠানো
3 Point: User registration
5 Point: Product Add with photos
8 Point: Product Search with filters
13 Point: bKash Payment Integration
21 Point: (এটি অনেক বড়, ভাগ করতে হবে)
```

**গুরুত্বপূর্ণ নিয়ম:** ১৩ Point-এর বেশি Story সাধারণত ভাগ করা উচিত। বড় Story = বেশি Risk।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৩.৪ Planning Poker

**Planning Poker** হলো Team মিলে Story Point Estimate করার একটি পদ্ধতি।

**কীভাবে হয়:**
১. PO একটি Story পড়ে শোনান
২. Team প্রশ্ন করে Story বোঝে
৩. সবাই একসাথে নিজের Estimate দেখায়
৪. যদি সবার Estimate একই হয় — সেটাই Final
৫. আলাদা হলে — সর্বোচ্চ এবং সর্বনিম্ন কারণ বলেন
৬. আবার Estimate করা হয়

**কেন একসাথে দেখানো হয়:**
যদি ক্রমানুসারে দেখানো হয় তাহলে প্রথমজনের Estimate পরবর্তীজনকে Influence করে। একসাথে দেখালে এই Bias কমে।

*QuickMart উদাহরণ — Cart Feature Estimation:*

```
Story: Cart-এ Product Add করা

সবাই একসাথে দেখালো:
রাফি: 3
মিম: 5
তানভীর: 3
নীলা: 8  ← আলাদা!
Tech Lead: 5

নীলাকে জিজ্ঞেস করা হলো:
নীলা: "Guest user-এর জন্যও Cart কাজ করবে?
        Stock check করতে হবে না?"

PO বললেন: "Guest cart এই Sprint-এ নয়।"
Stock check আলাদা Story হলো।

Final Estimate: 5 Points
```

**Planning Poker-এর আসল মূল্য:** বিভিন্ন Estimate বের হলে অজানা তথ্য বা risk সামনে আসে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৩.৫ Velocity

**Velocity** হলো একটি Team প্রতি Sprint-এ গড়ে কত Story Point শেষ করে।

**কীভাবে হিসাব করবেন:**

```
Sprint 1: 28 Points শেষ হয়েছে
Sprint 2: 32 Points শেষ হয়েছে
Sprint 3: 30 Points শেষ হয়েছে
──────────────────────────────
Average Velocity: (28+32+30) ÷ 3 = 30 Points/Sprint
```

**Velocity দিয়ে কী বোঝা যায়:**

যদি মোট Product Backlog-এ ৩০০ Points থাকে এবং Velocity ৩০ হয়, তাহলে মোট ১০ Sprint বা ২০ সপ্তাহ (২ সপ্তাহের Sprint হলে) লাগবে।

**Velocity-র সঠিক ব্যবহার:**

```
✅ সঠিক:
→ Future sprint estimate করতে ব্যবহার করুন
→ Capacity পরিকল্পনা করতে ব্যবহার করুন
→ Project completion date estimate করতে ব্যবহার করুন

❌ ভুল:
→ Team-এর Performance measure করতে ব্যবহার করবেন না
→ "Velocity বাড়াও" বলবেন না — এতে quality কমে
→ Team তুলনা করতে ব্যবহার করবেন না
```

Velocity হলো Team-এর Thermometer, Performance Score নয়।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৩.৬ Spike Story

**Spike Story** হলো Research বা Experiment করার জন্য একটি বিশেষ ধরনের Story।

**কখন দরকার:**
- নতুন Technology বা API সম্পর্কে জানা দরকার
- কোনো কাজ কতটুকু জটিল সেটা Estimate করা যাচ্ছে না
- একটি সমস্যার সমাধান খুঁজতে হবে

**Spike-এর বৈশিষ্ট্য:**
- নির্দিষ্ট সময় বরাদ্দ থাকে (Time-boxed)
- Output হলো Knowledge, Code নয়
- Sprint-এ নিয়মিত Story-র পাশে রাখা যায়

*QuickMart উদাহরণ:*

```
Spike Story: QM-SPIKE-01
──────────────────────────────────
Title: bKash Payment Integration Research

Time-box: ২ দিন (এর বেশি নয়)

Goal:
bKash Sandbox API ব্যবহার করে payment
করা কতটুকু জটিল সেটা বোঝা এবং
integration-এর জন্য Estimate দেওয়া।

Output:
- Integration-এর সম্ভাব্য approach
- Story Point Estimate
- যে Risks আছে সেগুলো
```

**গুরুত্বপূর্ণ:** Spike-এর সময় শেষ হলে কাজ বন্ধ করতে হবে। যা শিখেছেন তাই দিয়ে সিদ্ধান্ত নিতে হবে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৩.৭ Non-Functional Requirements (NFR)

**Non-Functional Requirements** হলো product কীভাবে কাজ করবে — কতটা দ্রুত, কতটা নিরাপদ, কতটা নির্ভরযোগ্য।

**Functional vs Non-Functional:**

```
Functional (কী করবে):
"User login করতে পারবে"

Non-Functional (কেমন করবে):
"Login ২ সেকেন্ডের মধ্যে হবে"
```

**NFR-এর ধরন:**

| ধরন | উদাহরণ |
|-----|--------|
| Performance | Product search ৫০০ms-এর মধ্যে হবে |
| Security | Password bcrypt দিয়ে hash হবে |
| Scalability | ১ লাখ concurrent user নিতে পারবে |
| Reliability | ৯৯.৯% uptime থাকবে |
| Availability | ২৪/৭ কাজ করবে |
| Accessibility | Screen reader support থাকবে |

**কেন NFR গুরুত্বপূর্ণ:**
অনেক Developer শুধু Functional Requirement নিয়ে কাজ করেন। কিন্তু একটি Feature কাজ করলেই হয় না — সেটা দ্রুত, নিরাপদ এবং নির্ভরযোগ্য হতে হবে।

*QuickMart-এর NFR উদাহরণ:*

```
Performance NFR:
- Product list page ২ সেকেন্ডের মধ্যে load হবে
- Search result ৫০০ms-এর মধ্যে আসবে
- Image upload maximum ১০MB পর্যন্ত হবে

Security NFR:
- সব password bcrypt দিয়ে hash হবে
- JWT token ২৪ ঘণ্টায় expire হবে
- HTTPS বাধ্যতামূলক

Scalability NFR:
- একসাথে ৫০,০০০ active user সামলাতে পারবে
```

**NFR-কে Backlog-এ রাখুন এবং Sprint-এ Include করুন।**

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ৪ — Jira দিয়ে Scrum Manage করা

## ৪.১ Jira-র Issue Hierarchy

Jira-তে কাজ সংগঠিত করতে চারটি স্তর আছে:

```
🏔️  EPIC        → বড় Feature গ্রুপ
  📖  STORY       → User-এর একটি কাজ
    ✅  SUB-TASK   → Story-র ছোট ছোট অংশ
  🐛  BUG         → যে সমস্যা খুঁজে পাওয়া গেছে
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.২ Epic তৈরি করা

Epic হলো একটি বড় Feature যা সাধারণত একটি Sprint-এ শেষ হয় না।

**Epic তৈরির নিয়ম:**
- Epic-এর নাম সংক্ষিপ্ত ও স্পষ্ট রাখুন
- Start এবং End Date দিন
- একটি Color দিন — বড় Backlog-এ বুঝতে সহজ হয়

*QuickMart-এর Epics:*

```
🔵 Epic 1: User Management
   (Registration, Login, Profile, Password Reset)
   Start: Jan 1 | End: Jan 31

🟢 Epic 2: Product Management
   (Add, Edit, Delete, Photos, Categories)
   Start: Jan 15 | End: Feb 28

🟡 Epic 3: Cart & Checkout
   (Cart, Order, Payment, Tracking)
   Start: Feb 1 | End: Mar 31

🔴 Epic 4: Seller Dashboard
   (Analytics, Orders, Revenue)
   Start: Mar 1 | End: Apr 30
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.৩ User Story তৈরি করা

Jira-তে Story তৈরি করার সময় নিচের সব field পূরণ করতে হবে:

```
Ticket: QM-01
════════════════════════════════════════
Title   : User registration করতে পারবে
Type    : Story
Priority: High
Points  : 3
Sprint  : Sprint 1
Epic    : User Management
Assignee: রাফি
════════════════════════════════════════
Description:
As a new user,
I want to register with email and password,
So that I can access QuickMart.
════════════════════════════════════════
Acceptance Criteria:
✅ Name, Email, Password দিয়ে register হবে
✅ Duplicate email-এ "Email already exists" error
✅ Password minimum ৮ character, ১টি number
✅ Registration-এ Welcome email যাবে
✅ Successful registration-এ Dashboard-এ redirect
════════════════════════════════════════
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.৪ Sub-task তৈরি করা

প্রতিটি Story-কে ছোট কাজে ভাগ করতে Sub-task ব্যবহার করুন।

**কেন Sub-task:**
- Daily Standup-এ precise progress বলা যায়
- কে কোথায় আটকে আছে বোঝা যায়
- Parallel কাজ হতে পারে

*QuickMart উদাহরণ — QM-01 (Registration)-এর Sub-tasks:*

```
📖 Story: QM-01 — User Registration [3 pts]
│
├── ✅ QM-01-A: Database schema তৈরি করা
│     Assignee: Tech Lead | সময়: ১ ঘণ্টা
│
├── ✅ QM-01-B: Registration API endpoint
│     Assignee: রাফি | সময়: ৩ ঘণ্টা
│
├── ✅ QM-01-C: Email validation logic
│     Assignee: মিম | সময়: ১ ঘণ্টা
│
├── ✅ QM-01-D: Frontend registration form
│     Assignee: নীলা | সময়: ২ ঘণ্টা
│
├── ✅ QM-01-E: Welcome email integration
│     Assignee: মিম | সময়: ২ ঘণ্টা
│
└── ✅ QM-01-F: Unit test লেখা
      Assignee: রাফি | সময়: ১ ঘণ্টা
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.৫ Bug Ticket তৈরি করা

Bug Ticket-এ নির্দিষ্ট তথ্য থাকা দরকার যেন Developer দ্রুত সমস্যা খুঁজে পায়।

*QuickMart Bug Ticket উদাহরণ:*

```
Ticket: QM-BUG-01
════════════════════════════════════════
Title   : Login-এর পর username দেখাচ্ছে না
Type    : Bug
Priority: High
Reporter: QA রিয়া
Assignee: রাফি
════════════════════════════════════════
Steps to Reproduce:
১. Valid email ও password দিয়ে login করুন
২. Dashboard-এ যান
৩. Header-এ "Hello, undefined!" দেখাচ্ছে

Expected Result:
"Hello, রাফিক!" দেখাবে

Actual Result:
"Hello, undefined!" দেখাচ্ছে

Environment: Chrome 120, Production
════════════════════════════════════════
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.৬ Sprint Setup করা

**Sprint তৈরির আগে — Backlog Ready করুন:**

Product Backlog Priority অনুযায়ী সাজান। সবচেয়ে গুরুত্বপূর্ণ এবং DoR মানদণ্ড পূরণ করা Story-গুলো উপরে থাকবে।

**Team-এর Capacity হিসাব:**

```
Sprint 1 Capacity হিসাব (২ সপ্তাহ):
──────────────────────────────────
রাফি    : ১০ দিন × ৬ ঘণ্টা = ৬০ ঘণ্টা
মিম     : ৮ দিন (২ দিন leave) = ৪৮ ঘণ্টা
তানভীর  : ১০ দিন = ৬০ ঘণ্টা
নীলা    : ১০ দিন = ৬০ ঘণ্টা
──────────────────────────────────
মোট: ২২৮ ঘণ্টা

গত Sprint Velocity: ৩০ Points
এই Sprint-এ নেবো: ২৮-৩০ Points (মিম-এর leave বাদ দিয়ে)
```

**Sprint তৈরি করুন:**

```
Sprint Name : QuickMart Sprint 1
Start Date  : Jan 6, 2025 (Monday)
End Date    : Jan 17, 2025 (Friday)
Sprint Goal : "User register থেকে product
               add পর্যন্ত কাজ করবে"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.৭ Jira Board পরিচালনা করা

Jira Board-এ চারটি Column থাকে:

```
┌──────────┬─────────────┬───────────┬──────────┐
│  TO DO   │ IN PROGRESS │  REVIEW   │   DONE   │
├──────────┼─────────────┼───────────┼──────────┤
│ QM-12    │ QM-10       │ QM-02     │ QM-01 ✅ │
│ Search   │ Product Add │ Login     │ Register │
│ [8 pts]  │ [5 pts]     │ [2 pts]   │ [3 pts]  │
└──────────┴─────────────┴───────────┴──────────┘
```

**Column-এর অর্থ:**
- **TO DO:** কাজ এখনো শুরু হয়নি
- **IN PROGRESS:** কাজ চলছে
- **REVIEW:** Code Review বা QA Test চলছে
- **DONE:** DoD অনুযায়ী সম্পন্ন

**প্রতিদিনের Routine:**

```
সকালে:
→ Board দেখুন — কে কোথায় আছে
→ Burndown দেখুন — পিছিয়ে আছেন?
→ নিজের Ticket IN PROGRESS করুন

সন্ধ্যায়:
→ কাজ শেষ হলে REVIEW-তে সরান
→ Comment লিখুন কী করেছেন
→ কাল কী করবেন Note করুন
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.৮ Burndown এবং Burnup Chart

### Burndown Chart

Burndown Chart দেখায় Sprint-এ কত কাজ বাকি আছে — এটি সময়ের সাথে কমতে থাকে।

```
Remaining
Story Pts
35 |●─────────────────── ← Ideal Line
   |  ●
   |    ●
20 |      ●             ← Actual Line
   |          ●
   |            ●
 0 +──────────────────→
   D1  D3  D5  D7  D10
```

**Burndown Chart পড়ার নিয়ম:**
- Actual Line, Ideal Line-এর উপরে → পিছিয়ে আছেন
- Actual Line, Ideal Line-এর নিচে → এগিয়ে আছেন
- হঠাৎ Actual Line বাড়লে → নতুন কাজ যোগ হয়েছে

### Burnup Chart

Burnup Chart দেখায় Sprint-এ কত কাজ হয়েছে — এটি সময়ের সাথে বাড়তে থাকে।

```
Story Pts
40 |              ╱──── ← Scope Line (মোট কাজ)
   |         ╱───
   |    ╱────
   |   ╱  ← Done Line (কত হয়েছে)
   |  ╱
 0 +──────────────────→
   D1  D3  D5  D7  D10
```

**Burnup Chart-এর সুবিধা:** Scope পরিবর্তন হলে সহজে বোঝা যায়। Done Line এবং Scope Line-এর দূরত্বই বাকি কাজ।

**কোনটি ব্যবহার করবেন:** Tech Lead হিসেবে Burnup Chart বেশি useful কারণ Scope Change দৃশ্যমান থাকে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.৯ Backlog Refinement

**Backlog Refinement** (বা Backlog Grooming) হলো আগামী Sprint-এর জন্য Story-গুলো Ready করার Process।

**কখন হয়:**
Sprint-এর মাঝামাঝি সময়ে। Sprint 2 চলছে — Sprint 3-এর Stories Ready করা হচ্ছে।

**কতক্ষণ:**
Sprint duration-এর ১০% সময়। ২ সপ্তাহের Sprint-এ সপ্তাহে ২ ঘণ্টার বেশি নয়।

**Refinement-এ কী হয়:**

```
১. বড় Story ভাগ করা
   "bKash Payment [13 pts]" →
   - bKash Setup [3 pts]
   - Payment API [5 pts]
   - Callback Handle [3 pts]
   - Payment UI [2 pts]

২. Acceptance Criteria লেখা বা পরিষ্কার করা

৩. Story Point Estimate করা

৪. Dependency চিহ্নিত করা

৫. Design/Mockup attach করা (UI Story হলে)

৬. প্রশ্ন করা এবং উত্তর নেওয়া
```

**Tech Lead-এর Role:**
- Technical complexity বলুন
- Unclear Story-তে প্রশ্ন করুন
- "এটা Ready নয়" বলার সাহস রাখুন
- Story ভাগ করার পরামর্শ দিন

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৪.১০ WIP Limit

**WIP (Work In Progress) Limit** হলো একসাথে কতটি কাজ IN PROGRESS অবস্থায় থাকতে পারবে তার সীমা।

**কেন WIP Limit দরকার:**

Multitasking productivity কমায়। একজন Developer যদি একসাথে ৫টি কাজ করেন, তাহলে কোনোটাই দ্রুত শেষ হয় না। WIP Limit নিশ্চিত করে একটি শেষ হলে পরেরটি শুরু হবে।

*QuickMart Board WIP Limit সহ:*

```
┌──────────┬────────────────┬──────────┐
│  TO DO   │  IN PROGRESS   │   DONE   │
│          │   (Max: 3)     │          │
├──────────┼────────────────┼──────────┤
│ QM-12    │ QM-10 ✓       │ QM-01 ✅ │
│ QM-20    │ QM-03 ✓       │ QM-02 ✅ │
│ QM-21    │ QM-05 ✓       │          │
│          │ ← Full! 🚫    │          │
│          │ নতুন নেওয়া যাবে না │    │
└──────────┴────────────────┴──────────┘
```

**WIP Limit-এর সুবিধা:**
- Focus বাড়ে
- কাজ দ্রুত শেষ হয়
- Bottleneck সহজে চোখে পড়ে

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ৫ — Bug Triage এবং Release Management

## ৫.১ Bug Priority নির্ধারণ

Bug পেলে আতঙ্কিত না হয়ে Priority নির্ধারণ করুন। সব Bug একই গুরুত্বের নয়।

```
P1 — Critical (এখনই Fix করতে হবে):
  → App crash হচ্ছে
  → Payment কাজ করছে না
  → User data নষ্ট হচ্ছে
  → Security breach হচ্ছে
  Action: Sprint ছেড়ে এখনই করুন

P2 — High (এই Sprint-এ):
  → Major feature কাজ করছে না
  → User অনেক Error দেখছে
  Action: Current Sprint-এ নিন

P3 — Medium (পরের Sprint-এ):
  → Minor feature-এর সমস্যা
  → UI-তে ছোট গড়মিল
  Action: Backlog-এ রাখুন

P4 — Low (সময় হলে):
  → Cosmetic সমস্যা
  → Typo বা পরামর্শ
  Action: Could Have List-এ রাখুন
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৫.২ Bug Triage Process

Bug Triage হলো Bug পেলে কী করবেন তার Process।

**Step 1: Bug Verify করুন**
QA-র বলা Bug নিজে একবার দেখুন। কখনো কখনো Environment-এর সমস্যা থাকে।

**Step 2: Priority নির্ধারণ করুন**
P1 থেকে P4 — কোন Category-তে পড়ে?

**Step 3: Root Cause বোঝার চেষ্টা করুন**
কোথায় সমস্যা? কত সময় লাগবে?

**Step 4: সিদ্ধান্ত নিন**
- P1: Sprint Stop করুন, এখনই Fix করুন
- P2: Sprint-এ নিন বা একটি Story বদলান
- P3/P4: Backlog-এ যোগ করুন

**Step 5: PO-কে জানান**
বড় Bug হলে PO-কে জানান — বিশেষত P1/P2।

*QuickMart উদাহরণ:*

```
রাত ১১টায় Alert এলো:
"Payment fail rate ৩০%!"

তুমি:
1. Production Log দেখলে → bKash API timeout হচ্ছে
2. Priority: P1
3. PO-কে জানালে
4. সাথে সাথে Rollback দিলে
5. সকালে Root cause fix করলে
6. আবার Deploy করলে
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৫.৩ Release Planning

**Release Planning** হলো কখন এবং কীভাবে User-এর কাছে Product পৌঁছাবে তার পরিকল্পনা।

**Sprint vs Release পার্থক্য:**

```
Sprint:
"এই ২ সপ্তাহে আমরা কী করবো"
→ Internal planning

Release:
"কখন User-এর হাতে দেবো"
→ External delivery
```

**Release Planning-এর উপাদান:**

```
Release 1.0 (March 31):
─────────────────────────────
Features:
  → User Registration/Login
  → Product Add/List
  → Cart & Order
  → bKash Payment

Quality Gates:
  → All P1 Bugs fixed
  → Performance NFR met
  → Security Audit passed

Testing:
  → 100 Beta Users-এর কাছে দেওয়া

Release 1.1 (April 30):
─────────────────────────────
Features:
  → Seller Dashboard
  → Product Search
  → Bug fixes from 1.0
```

**Semantic Versioning বোঝা:**
```
Version 1.2.3
        | | └── Patch: Bug fix
        | └──── Minor: নতুন Feature (backward compatible)
        └────── Major: বড় পরিবর্তন
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ৬ — Tech Lead হিসেবে Sprint Planning

## ৬.১ Tech Lead কে?

Tech Lead হলেন এমন একজন যিনি Code-ও বোঝেন এবং Team-কেও Guide করেন।

```
Tech Lead মানে নয়:
❌ শুধু Senior Developer
❌ Team Manager
❌ সব সিদ্ধান্ত একা নেওয়া

Tech Lead মানে হলো:
✅ Technical Direction দেওয়া
✅ Team-কে Best Practices শেখানো
✅ Architecture সিদ্ধান্ত নেওয়া
✅ PO-র সাথে Technical Reality নিয়ে কথা বলা
✅ Junior-দের Mentor করা
✅ Blocker সরানো
```

**Sprint Planning-এ Tech Lead তিনটি ভূমিকায় কাজ করেন:**

```
🎩 Developer Hat  → Technical কী Possible?
🎩 Planner Hat   → কে কী করবে?
🎩 Communicator  → PO-কে সত্যি বলা
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৬.২ Sprint Planning-এর আগের প্রস্তুতি

Sprint Planning Meeting-এর আগের রাতে Tech Lead যা করবেন:

**১. গত Sprint-এর Velocity দেখুন:**
```
গত Sprint: ৩২ Points হয়েছে
এই Sprint-এ নেবো: ৩০-৩৪ Points
```

**২. Team-এর Capacity হিসাব করুন:**
```
রাফি  : ১০ দিন (full)
মিম   : ৮ দিন (২ দিন leave)
তানভীর: ১০ দিন (full)
নীলা  : ১০ দিন (full)
রিয়া : ১০ দিন (full)
──────────────────
Capacity adjustment: ১ জনের ২ দিন কম
→ নিরাপদভাবে ২৮-৩০ Points নেবো
```

**৩. Backlog দেখুন — কোন Stories Ready:**
DoR চেক করুন। Ready নয় এমন Story Sprint-এ নেবেন না।

**৪. Technical Dependency Map মাথায় রাখুন:**
কোন Story শেষ না হলে কোনটা শুরু করা যাবে না — এটা আগে থেকে জানুন।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৬.৩ Sprint Goal নির্ধারণ

Sprint Goal হলো Sprint-এর একটি সংক্ষিপ্ত উদ্দেশ্য যা Team-কে Focus রাখে।

**ভালো Sprint Goal-এর বৈশিষ্ট্য:**
- একটি বাক্যে বলা যায়
- Business Value স্পষ্ট
- Measurable — শেষে বোঝা যাবে হয়েছে কিনা

*QuickMart-এ Sprint Goal নির্ধারণ:*

```
PO সাদিয়া বললেন:
"Payment, Search, আর Seller Dashboard চাই।"

Tech Lead বললেন:
"তিনটি একসাথে একটি Sprint-এ সম্ভব নয়।
 Payment ছাড়া Order complete নয়।
 আমার Suggestion:

 Sprint 2 Goal: Cart + Order + bKash Payment
 'User cart-এ product রেখে bKash-এ payment দিতে পারবে'

 Search Sprint 3-এ নিই।
 কারণ Payment আগে না হলে User কোনো value পাবেন না।"

সাদিয়া রাজি হলেন।
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৬.৪ Story Breakdown করা

যেকোনো Story ৮ Points-এর বেশি হলে ভাগ করুন।

*QuickMart উদাহরণ — bKash Payment [13 pts] ভাগ করা:*

```
আগে:
QM-30: bKash Payment Integration [13 pts]

ভাগ করার পর:
QM-30A: bKash Sandbox Setup         [3 pts]
QM-30B: Payment Initiate API        [5 pts]
QM-30C: Payment Callback Handle     [3 pts]
QM-30D: Payment Success/Failure UI  [2 pts]
──────────────────────────────────────────
মোট: ১৩ pts → ৪টি ছোট কাজ
```

**কেন ভাগ করবেন:**
- ছোট কাজ estimate করা সহজ
- Risk কম — একটি আটকালে বাকিগুলো চলে
- Progress দৃশ্যমান হয়

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৬.৫ Task Assignment

**Assignment-এর সময় শুধু "কে পারবে" ভাববেন না — "কে শিখবে" সেটাও ভাবুন।**

*QuickMart Sprint 2 Assignment:*

```
Story              Points  Assignee   কারণ
──────────────────────────────────────────────────
Cart Add/Remove    5       রাফি       Sprint 1-এ
                                      Order কাজ করেছে,
                                      Context আছে

bKash Setup        3       Tech Lead  Complex কাজ,
                                      Senior দেখুক

bKash API          5       Tech Lead  Pair করবে মিম-এর সাথে
                  +মিম                মিম শিখবেও

Payment Callback   3       মিম        একা করতে পারবে,
                                      Growth সুযোগ

Payment UI         2       নীলা       Frontend-এ শক্তিশালী

Order Place        5       তানভীর     Backend শক্তিশালী

QA Testing         —       রিয়া      সব Story-তে
──────────────────────────────────────────────────
মোট: ২৩ Points
```

**Assignment-এর নিয়ম:**
- Bottleneck তৈরি করবেন না — সব কাজ একজনকে দেবেন না
- Junior-কে Stretch করুন কিন্তু Support দিন
- Context আছে এমন মানুষকে দিন

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৬.৬ Dependency Map

Sprint Planning-এ Dependency Map তৈরি করুন — কোন কাজ কোনটির পর হবে।

*QuickMart Sprint 2 Dependency Map:*

```
bKash Setup (QM-30A)
      ↓ এটি শেষ না হলে পরেরটি শুরু করা যাবে না
bKash API (QM-30B)
      ↓
Payment Callback (QM-30C)
      ↓
Payment UI (QM-30D)

Cart (QM-20)
      ↓
Order Place (QM-21)
      ↓
Order History (QM-22)
```

**Meeting-এ বলুন:**

```
"bKash Setup না হলে bKash API শুরু করা যাবে না।
 তাই আমি প্রথম ৩ দিন Setup করবো।
 মিম এই সময়ে Cart API-তে সাহায্য করবে।
 ৪র্থ দিন থেকে আমরা দুজন bKash API করবো।"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৬.৭ Sprint চলাকালীন কাজ

```
Day 1-2:
  → সবাই ঠিকমতো শুরু করেছে?
  → Confusion আছে? এখনই সরান।
  → নিজের কাজও শুরু করুন।

Day 3-5 (Sprint মাঝে):
  → Burndown দেখুন — পিছিয়ে?
  → কেউ Blocked হলে সরান।
  → Code Review করুন প্রতিদিন।

Day 7-8 (Sprint শেষের দিকে):
  → কোন Story Risk-এ আছে?
  → PO-কে আগেই জানান।
  → QA-কে Ready থাকতে বলুন।

Last Day:
  → Demo Ready আছে?
  → সব Ticket Done?
  → Retrospective-এর জন্য Notes নিন।
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৬.৮ Tech Lead-এর Golden Rules

**Rule ১: "না" বলবেন না — Alternative দিন**

```
❌ "এটা এই Sprint-এ হবে না।"
✅ "এটা Sprint 3-এ করলে ভালো হবে, কারণ
    Payment আগে না হলে User কোনো value পাবেন না।"
```

**Rule ২: Burndown প্রতিদিন দেখুন**
সমস্যা দেরিতে দেখলে দেরিতে Fix হবে।

**Rule ৩: PO-কে সত্যি বলুন, আগেভাগে বলুন**
Sprint শেষে "হয়নি" বলা সবচেয়ে খারাপ। Risk দেখলে সাথে সাথে জানান।

**Rule ৪: Meeting-এ সবার Voice শুনুন**
সবচেয়ে Junior-ও ভালো Idea দিতে পারেন।

**Rule ৫: Junior-কে সব কাজ দেবেন না**
আপনার কাজ Code করা এবং শেখানো — দুটোই।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ৭ — Architecture Decision

## ৭.১ Architecture Decision কী?

**Architecture Decision** হলো Software কীভাবে বানাবেন — এই বড় সিদ্ধান্তগুলো।

```
উদাহরণ:
"Database কোনটা নেবো? MySQL নাকি MongoDB?"
"File কোথায় Store করবো? Server নাকি Cloud?"
"Monolith রাখবো নাকি Microservice করবো?"
"API কোন Technology-তে বানাবো?"
```

**কে নেন:**
```
Junior Dev    → নিজের Feature-এর ছোট সিদ্ধান্ত
Senior Dev    → নিজের Component-এর সিদ্ধান্ত
Tech Lead     → পুরো System-এর সিদ্ধান্ত ✅
Architect     → Multiple System-এর সিদ্ধান্ত
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৭.২ Decision নেওয়ার Framework

যেকোনো বড় Architecture Decision-এ এই ৫টি প্রশ্ন করুন:

```
১. এখন কী দরকার?
   আজকের সমস্যা Solve করুন।
   ৫ বছর পরের জন্য এখন Build করবেন না।

২. ভবিষ্যতে কী হতে পারে?
   Flexibility রাখুন — কিন্তু Over-engineer করবেন না।

৩. Team কি Handle করতে পারবে?
   সেরা Technology নয়, Team যা পারে সেটা নিন।

৪. Cost কত?
   Time + Money + Complexity — তিনটিই।

৫. Reverse করা যাবে?
   ভুল হলে ফিরে আসা কতটা কঠিন?
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৭.৩ Image Storage Decision — উদাহরণ

*QuickMart-এ Image Storage নিয়ে সিদ্ধান্ত নেওয়ার প্রক্রিয়া:*

**সমস্যা:** Seller product image upload করবে। প্রতিদিন হাজার হাজার image আসবে।

**তিনটি Option বিশ্লেষণ:**

| বিষয় | Local Server | AWS S3 | Cloudinary |
|-------|-------------|--------|------------|
| সহজ Setup | ✅ সহজ | ❌ জটিল | ✅ সহজ |
| Cost | ✅ কম | ⚠️ মাঝারি | ✅ Free tier |
| Scale | ❌ সীমিত | ✅ Unlimited | ✅ ভালো |
| CDN | ❌ নেই | ✅ আছে | ✅ আছে |
| Server crash হলে | ❌ সব হারাবে | ✅ নিরাপদ | ✅ নিরাপদ |

**Decision:**
```
Cloudinary দিয়ে শুরু করবো।
কারণ:
- Free tier-এ শুরু হবে — cost নেই
- CDN built-in — fast load
- Image optimization automatic
- Interface এমনভাবে বানাবো যেন পরে
  S3-এ Switch করতে ১ দিনও না লাগে।
```

**Team-কে বোঝানো:**

```
"১ লাখ Product × ৩টি Image × ২MB = ৬০০GB Storage।
 আমাদের Server এটা নেবে না।
 Cloudinary Free-তে শুরু হবে।
 বড় হলে S3-এ যাবো।"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৭.৪ Performance Problem সমাধান

*QuickMart-এ Product Search ৮ সেকেন্ড লাগছিল:*

**Step 1: আগে Diagnose করুন — Assume করবেন না**

```
API Response Time দেখলে:
GET /api/search → 7800ms

Database Query দেখলে:
SELECT * FROM products WHERE name LIKE '%phone%'
→ Full Table Scan! ১ লাখ Row Check করছে!
→ Index নেই!
```

**Step 2: Solution Options:**

```
Option A: Database Index (১ ঘণ্টার কাজ)
  ✅ দ্রুত Fix
  ✅ ৮ সেকেন্ড → ০.৫ সেকেন্ড হবে
  ❌ LIKE Search-এ সীমিত

Option B: Elasticsearch (১-২ সপ্তাহ)
  ✅ Super Fast
  ✅ Typo Handle করে
  ❌ নতুন System Setup করতে হবে

Option C: Redis Cache (৩-৪ দিন)
  ✅ Popular Search Instantly
  ❌ Fresh Data নাও দিতে পারে
```

**Decision:**
```
Plan:
১. এখনই: Database Index → দ্রুত Fix
২. Sprint 4-এ: Redis Cache → Performance বাড়বে
৩. Sprint 6-এ: Elasticsearch → Long-term Solution
```

**নিয়ম:** Perfect Solution পরে আসতে পারে। কিন্তু Working Solution এখন দরকার।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৭.৫ Monolith vs Microservice

**Monolith:** একটিই বড় Application যেখানে সব Feature একসাথে।

```
[QuickMart App]
├── User Module
├── Product Module
├── Order Module
├── Payment Module
└── Notification Module
→ সব একসাথে Deploy হয়
```

**Microservice:** আলাদা আলাদা ছোট Service।

```
[User Service]       → আলাদা Server
[Product Service]    → আলাদা Server
[Order Service]      → আলাদা Server
[Payment Service]    → আলাদা Server
```

**তুলনা:**

| বিষয় | Monolith | Microservice |
|-------|---------|--------------|
| শুরু করা | সহজ ✅ | জটিল ❌ |
| Team Size | ছোট Team-এ ভালো ✅ | বড় Team লাগে |
| Deploy | একবারে সব | আলাদা আলাদা |
| Debugging | সহজ ✅ | কঠিন ❌ |
| Cost | কম ✅ | বেশি ❌ |
| Scale | পুরোটা বাড়াতে হয় | শুধু দরকারিটা |

**QuickMart-এর জন্য সিদ্ধান্ত: Modular Monolith**

```
[QuickMart — একটিই App]
│
├── 📦 /users        → User সব কিছু এখানে
│    ├── routes/
│    ├── services/
│    └── models/
│
├── 📦 /products
├── 📦 /orders
└── 📦 /payments

সুবিধা:
→ এখন: একটি App, সহজ Manage
→ পরে: Payment Module বের করে
         আলাদা Service করা সহজ
```

**গুরুত্বপূর্ণ:** Amazon শুরু করেছিল Monolith দিয়ে। ১০ বছর পরে Microservice-এ গেছে। আপনার Team ৫ জন হলে Microservice করবেন না।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৭.৬ Architecture Decision Record (ADR)

**ADR** হলো একটি Document যেখানে Architecture Decision কেন নেওয়া হয়েছে সেটা লেখা থাকে।

**কেন লিখবেন:**
৬ মাস পরে নতুন Developer জিজ্ঞেস করবেন "S3 কেন করলেন না?" ADR দেখিয়ে দিন — আলোচনা শেষ।

*QuickMart ADR Template:*

```
ADR-001: Image Storage — Cloudinary
════════════════════════════════════════
Date   : January 15, 2025
Author : Tech Lead
Status : Accepted (Accepted/Deprecated/Superseded)
════════════════════════════════════════
Context:
Product image store করার জায়গা দরকার।
প্রতিদিন হাজার হাজার image আসবে।
বর্তমানে Team ৫ জন, Budget সীমিত।
════════════════════════════════════════
Decision:
Cloudinary ব্যবহার করবো।
Interface Abstract রাখবো যেন পরে S3-এ যাওয়া যায়।
════════════════════════════════════════
Consequences:
✅ Free-তে শুরু হবে
✅ CDN এবং Image Optimization পাবো
⚠️ Vendor Dependency থাকবে
⚠️ Scale-এ Cost বাড়বে
════════════════════════════════════════
Review Trigger:
১ লাখ Product-এ পৌঁছালে Review করবো।
════════════════════════════════════════
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৭.৭ Team-কে Decision বোঝানো

বিভিন্ন মানুষকে বিভিন্নভাবে বোঝান:

**Developer Team-কে:**
- Technical Diagram দিন
- Trade-off বলুন
- তাদের Opinion নিন

**PO-কে:**
- Business Impact বলুন
- Technical Detail কম
- "এটা করলে User এই সুবিধা পাবেন"

**Management-কে:**
- Risk বলুন
- Cost বলুন
- Timeline বলুন

**Number দিয়ে বোঝান:**

```
❌ "অনেক image হবে, Server নেবে না।"
✅ "১ লাখ Product × ৩টি Image × ২MB = ৬০০GB।
    আমাদের Server-এ এখন ২০০GB আছে।"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ৮ — Code Review

## ৮.১ Code Review কেন দরকার?

Code Review হলো একজনের লেখা Code অন্যজন দেখার Process।

**সুবিধা:**
- Bug দ্রুত ধরা পড়ে
- Better Solution বের হয়
- Knowledge Share হয়
- Junior শেখে
- Code Consistency থাকে

**তথ্য:** Microsoft-এর Research অনুযায়ী, Code Review ছাড়া Production-এ Bug ৬০-৯০% বেশি থাকে।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৮.২ ভালো Pull Request কেমন হয়?

Developer Code Review-এর জন্য Pull Request (PR) দেওয়ার আগে নিজে যা করবেন:

```
PR Title: QM-20: Cart-এ Product Add করার Feature

Description:
────────────────────────────────────────
🎯 কী করেছি:
  - Cart-এ product add করা যাবে
  - Quantity update করা যাবে
  - Cart থেকে Remove করা যাবে

🔗 Jira Ticket: QM-20

✅ Self-checklist:
  - [x] Unit test লিখেছি
  - [x] Local-এ test করেছি
  - [x] Console.log সরিয়েছি
  - [x] নিজে একবার পুরো diff পড়েছি

📸 Screenshot: [cart-ui.png]
────────────────────────────────────────
```

**PR-এর আকার:** বড় PR ভালো Review হয় না। একটি PR-এ ৩০০-৪০০ Lines-এর বেশি না রাখার চেষ্টা করুন।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৮.৩ Code Review Checklist

Tech Lead হিসেবে Code Review করার সময় এই বিষয়গুলো দেখুন:

```
🔴 Critical (অবশ্যই Fix করতে হবে):
  □ Security Vulnerability আছে?
    (SQL Injection, XSS, CSRF)
  □ Data Loss হতে পারে?
  □ Authentication/Authorization সঠিক?
  □ Sensitive Data (password, key) expose হচ্ছে?

🟡 Major (Fix করা উচিত):
  □ Error Handling আছে?
  □ Input Validation আছে?
  □ Unit Test আছে?
  □ Performance Issue আছে?
  □ Hard-coded Value আছে?

🟢 Minor (Suggestion):
  □ Code Readable?
  □ DRY Principle মানা হয়েছে?
  □ Naming Convention ঠিক?
  □ Comment দরকার এমন জায়গায় আছে?
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৮.৪ Critical Issues — কী দেখবেন

### SQL Injection

```javascript
// ❌ Dangerous — রাফির Code
const product = await db.query(
  'SELECT * FROM products WHERE id = ' + productId
);
// কেউ productId = "1; DROP TABLE products" দিলে?

// ✅ সঠিক — Parameterized Query
const product = await db.query(
  'SELECT * FROM products WHERE id = ?',
  [productId]
);
```

### Stock Check না থাকা

```javascript
// ❌ Stock check নেই
await db.query('INSERT INTO cart_items...');

// ✅ Stock check সহ
if (product.stock < qty) {
  return res.status(400).json({
    error: 'পর্যাপ্ত Stock নেই'
  });
}
```

### Input Validation না থাকা

```javascript
// ❌ Validation নেই
const { userId, productId, qty } = req.body;
// qty = -5 বা qty = 99999 দিলে কী হবে?

// ✅ Validation সহ
if (!productId || !userId || !qty) {
  return res.status(400).json({
    error: 'Required fields missing'
  });
}
if (qty <= 0 || qty > 100) {
  return res.status(400).json({
    error: 'Invalid quantity (1-100)'
  });
}
```

### Error Handling না থাকা

```javascript
// ❌ Error Handling নেই
const product = await db.query(...);
// Database fail হলে App crash করবে!

// ✅ Try-Catch সহ
try {
  const product = await db.query(...);
} catch (error) {
  console.error('Product fetch failed:', error);
  res.status(500).json({ error: 'Something went wrong' });
}
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৮.৫ Comment কীভাবে লিখবেন

Code Review Comment লেখার সময় Code-এর সমালোচনা করুন, মানুষের নয়।

**খারাপ Comment:**
```
❌ "এটা ভুল।"
❌ "Junior mistake।"
❌ "এভাবে করলে হবে না।"
```

**ভালো Comment:**
```
✅ 🔴 [Critical] SQL Injection risk আছে।

এখানে productId সরাসরি Query-তে বসানো হয়েছে।
এটি SQL Injection-এর সুযোগ তৈরি করে।

Parameterized Query ব্যবহার করুন:
db.query('SELECT * FROM products WHERE id = ?', [productId])

OWASP Top 10-এ এটি সবচেয়ে সাধারণ Vulnerability।
```

**Comment-এর ধরন চিহ্নিত করুন:**
- 🔴 Critical: Merge Block করুন
- 🟡 Major: পরিবর্তন Request করুন
- 🟢 Nit/Minor: Optional, Developer সিদ্ধান্ত নিতে পারেন

**ভালো কাজেরও প্রশংসা করুন:**
```
✅ "এই Error Handling টা খুব সুন্দর হয়েছে!"
✅ "এই Approach-টা আমি আগে ভাবিনি। ভালো!"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৮.৬ Code Review-এর ৩ স্তর

```
স্তর ১ — Automated (Tool করুক):
  → ESLint: Code Style
  → Prettier: Formatting
  → SonarQube: Code Quality Score
  PR Merge-এর আগে Auto-check হবে।

স্তর ২ — Peer Review (Junior ↔ Junior):
  → Basic Logic Check
  → Test আছে কিনা
  → Readability

স্তর ৩ — Tech Lead Review (আপনি):
  → Architecture সঠিক?
  → Security Issue আছে?
  → Performance ঠিক?
  → System-এর বাকি অংশের সাথে মিলছে?
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৮.৭ Code Review Culture তৈরি করা

```
নিয়ম ১: ২৪ ঘণ্টায় Review দিন
  PR দেওয়ার ২৪ ঘণ্টার মধ্যে Review করুন।
  নইলে Developer Block হয়ে থাকে।

নিয়ম ২: ছোট PR Encourage করুন
  বড় PR Review হয় না ভালো।
  ৩০০-৪০০ Lines-এর মধ্যে রাখুন।

নিয়ম ৩: Auto Tool দিয়ে ছোট কাজ করান
  Formatting, Spacing — ESLint করুক।
  আপনি Logic এবং Security দেখুন।

নিয়ম ৪: Review = শেখার সুযোগ
  Junior-এর ভুলে শুধু "ভুল" বলবেন না।
  কেন ভুল এবং সঠিক উপায় কী — দেখান।
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ৯ — Technical Debt

## ৯.১ Technical Debt কী?

**Technical Debt** হলো দ্রুত করার জন্য নেওয়া Shortcut — যা পরে বেশি সময় এবং কষ্ট দেয়।

**Real Life Analogy:**
Credit Card-এ কিনলে এখন জিনিস পাওয়া যায়, কিন্তু পরে সুদসহ দিতে হয়। Technical Debt একই — এখন দ্রুত করলাম, পরে ঠিক করতে বেশি সময় লাগবে।

**Technical Debt-এর ফলাফল:**

```
Short-term: ✅ দ্রুত Deliver হয়
Long-term:
  ❌ নতুন Feature যোগ করা কঠিন হয়
  ❌ Bug বাড়তে থাকে
  ❌ Developer Frustrate হন
  ❌ Codebase বুঝতে কঠিন হয়
  ❌ Onboarding নতুন Developer-এর সময় বাড়ে
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৯.২ Debt-এর ৩ ধরন

**ধরন ১: Intentional Debt (জেনেশুনে নেওয়া)**

```
"Deadline আছে, এখন Simple করি, পরে ঠিক করবো।"
→ এটি কখনো কখনো ঠিক আছে।
→ কিন্তু Track করতে হবে।
→ Jira-তে Tech Debt Ticket তৈরি করুন।
```

**ধরন ২: Unintentional Debt (না জেনে নেওয়া)**

```
"রাফি জানতোই না যে SQL Injection হতে পারে।"
→ Code Review দিয়ে ধরুন।
→ Team Training দিয়ে কমান।
```

**ধরন ৩: Bit Rot (সময়ের সাথে পুরনো হওয়া)**

```
"৩ বছর আগে যে Library নিয়েছিলাম
 এখন সেটা Outdated, Security Patch নেই।"
→ Regular Dependency Update করুন।
→ Dependabot বা Similar Tool ব্যবহার করুন।
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৯.৩ Debt Audit করা

প্রতি Quarter-এ একবার Codebase Audit করুন।

*QuickMart Debt Audit উদাহরণ:*

```
🔴 CRITICAL DEBT (এখনই Fix করুন):
────────────────────────────────────────
১. Password plain text Store হচ্ছে
   Risk: Security Breach
   Fix: bcrypt Hashing → ৪ ঘণ্টা

২. API-তে Authentication নেই
   Risk: যেকেউ যেকোনো API Call করতে পারে
   Fix: JWT Middleware → ৬ ঘণ্টা

৩. Payment Log নেই
   Risk: Dispute হলে Prove করা যাবে না
   Fix: Audit Log → ৮ ঘণ্টা

🟡 MAJOR DEBT (Sprint-এ নিন):
────────────────────────────────────────
৪. Duplicate Code ১২ জায়গায়
   Risk: Bug Fix করলে ১২ জায়গায় করতে হয়
   Fix: Shared Utility → ১ দিন

৫. Unit Test নেই
   Risk: Refactor করতে ভয়
   Fix: Critical Path Cover → ৩ দিন

৬. Hard-coded Config
   Risk: Production Deploy-এ ভুল হবে
   Fix: .env File → ৪ ঘণ্টা
────────────────────────────────────────
মোট Fix সময়: ~৬ দিন
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৯.৪ Debt Backlog তৈরি করা

Jira-তে আলাদা "tech-debt" Label দিয়ে Ticket তৈরি করুন।

```
Ticket: TD-01
════════════════════════════════════════
Title   : Password Hashing implement করা
Type    : Tech Debt
Priority: Critical 🔴
Label   : tech-debt, security
Points  : 3
════════════════════════════════════════
Problem:
User password plain text-এ Database-এ
Save হচ্ছে। Breach হলে সব User-এর
Password Exposed হবে।
════════════════════════════════════════
Solution:
bcrypt দিয়ে Hash করে Save করতে হবে।
Login-এ bcrypt.compare() ব্যবহার।
════════════════════════════════════════
Impact if not Fixed:
Security Audit fail করবে।
Investor আসবে না।
User Trust হারাবো।
════════════════════════════════════════
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৯.৫ PO-কে Convince করা

PO সাধারণত বলেন: "Debt Fix করে User কী পাবে?"

**এভাবে বোঝান:**

```
"সাদিয়া, আমাদের Codebase এখন পুরনো বাড়ির মতো।
 প্রতিটি নতুন Feature যোগ করা মানে নতুন তলা।
 কিন্তু Foundation-এ ফাটল আছে।

 এখন:
 → নতুন Feature বানাতে ২ সপ্তাহ লাগে।

 Debt Fix-এর পর:
 → একই Feature ১ সপ্তাহে হবে।

 মানে: এখন ৩ দিন দিলে
        পরের ৬ মাসে প্রতি Sprint-এ
        ৩-৪ দিন বাঁচবে।"
```

**Business Language-এ বলুন:**

```
❌ "Code Clean করতে হবে।"
✅ "এটা না করলে Feature Delivery
    ২ গুণ Slow হবে।"

❌ "Technical Debt আছে।"
✅ "Password Plain Text আছে।
    Hack হলে Company শেষ হতে পারে।"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৯.৬ ২০% Rule

প্রতি Sprint-এ ২০% সময় Technical Debt-এ দিন।

```
Sprint Capacity: ৩৫ Points হলে
─────────────────────────────────
Feature  : ২৮ Points (৮০%)
Tech Debt:  ৭ Points (২০%)
─────────────────────────────────
```

**Sprint 3-এ Debt Items:**

```
✅ TD-01: Password Hashing         [3 pts]
✅ TD-06: Hard-coded Config Remove  [2 pts]
✅ TD-04: Duplicate Code Refactor   [2 pts]
─────────────────────────────────
Total Debt: ৭ pts ✅
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ৯.৭ Debt Prevention

**Debt যেন না জমে তার জন্য:**

```
১. Code Review Strict করুন
   → Review ছাড়া Merge হবে না
   → Security Issue পেলে Block করুন

২. Definition of Done-এ রাখুন
   ✅ Unit Test লেখা হয়েছে
   ✅ Hard-coded Value নেই
   ✅ Error Handling আছে
   ✅ Code Review হয়েছে

৩. Automated Tool ব্যবহার করুন
   → SonarQube: Code Quality Score
   → ESLint: Bad Pattern ধরে
   → Dependabot: Outdated Library জানায়

৪. Boy Scout Rule Follow করুন:
   "যে জায়গায় কাজ করলেন,
    সেটা আগের চেয়ে একটু
    ভালো করে রেখে আসুন।"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ১০ — System Design Basics

## ১০.১ System Design কী?

**System Design** হলো Software কীভাবে তৈরি করবেন যাতে লক্ষ লক্ষ User ব্যবহার করতে পারেন।

**Junior vs Tech Lead-এর চিন্তা:**

```
Junior ভাবেন:
"এই Feature কীভাবে Code করবো?"

Tech Lead ভাবেন:
"১০ লাখ User একসাথে এলে
 System পড়ে যাবে না তো?"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১০.২ Basic Building Blocks

### Client
যে Request পাঠায়: Browser, Mobile App, অন্য Service।

### Server
যে Request Handle করে। Client Request নেয়, Database থেকে Data আনে, Response পাঠায়।

### Database

```
SQL (Relational) — MySQL, PostgreSQL:
→ Table-এ Data থাকে
→ Relation থাকে
→ Strong Consistency
→ QuickMart: User, Product, Order

NoSQL — MongoDB, Redis:
→ Document হিসেবে থাকে
→ Flexible Structure
→ Fast Read/Write
→ QuickMart: Sessions, Cache
```

### Load Balancer

```
সমস্যা: ১টি Server-এ ১০ লাখ Request আসলে Crash!

সমাধান:
[১০ লাখ Request]
       ↓
 [Load Balancer] ← Traffic ভাগ করে দেয়
  ↙    ↓    ↘
[S1] [S2] [S3] ← ৩টি Server
```

### Cache (Redis)

```
সমস্যা: একই Data বারবার Database থেকে আনা Slow।

সমাধান:
[Request]
    ↓
[Cache আছে?] → YES → সাথে সাথে দিন ⚡
    ↓ NO
[Database থেকে আনুন]
    ↓
[Cache-এ রাখুন]
    ↓
[Response দিন]
```

### CDN (Content Delivery Network)

```
সমস্যা: QuickMart-এর Server Dhaka-তে।
         Chittagong থেকে Image Load করলে Slow।

সমাধান: Image CDN-এ ছড়িয়ে রাখুন।
User Chittagong থেকে → কাছের Node থেকে পাবেন ⚡
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১০.৩ Key Concepts

### Scalability (বড় হওয়ার ক্ষমতা)

```
Vertical Scaling (Scale Up):
  ছোট Server → বড় Server
  ✅ সহজ
  ❌ Limit আছে, Expensive

Horizontal Scaling (Scale Out):
  ১টি Server → ১০টি Server
  ✅ Unlimited Scale
  ✅ একটি পড়লে বাকি চলে
  ❌ জটিল
```

### Availability (সবসময় চালু থাকা)

```
99%    = বছরে ৮৭ ঘণ্টা বন্ধ
99.9%  = বছরে ৮.৭ ঘণ্টা বন্ধ
99.99% = বছরে ৫২ মিনিট বন্ধ ✅
```

### Latency (কতটা দ্রুত)

```
ভালো: < ১০০ms
ঠিক আছে: ১০০-৫০০ms
খারাপ: > ১ সেকেন্ড (User চলে যাবেন)
```

### Consistency (Data সঠিক থাকা)

```
Strong Consistency:
  → একজন পাবেন, একজন পাবেন না (Stock শেষ হলে)
  → Slow কিন্তু সঠিক
  → QuickMart Payment-এ ব্যবহার করুন

Eventual Consistency:
  → Fast কিন্তু সাময়িক ভুল
  → QuickMart Product View-এ ব্যবহার করুন
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১০.৪ QuickMart-এর Full System Design

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
           QUICKMART SYSTEM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Browser/Mobile App]
       ↓
    [CDN] ← Images, Static Files
       ↓
[Load Balancer]
  ↙    ↓    ↘
[API] [API] [API] ← Node.js Servers
       ↓
[Redis Cache] ← Session, Hot Data
       ↓
 ┌─────┴──────┐
[MySQL]   [Elasticsearch]
Primary    Product Search
   ↓
[Read Replica]
Read-heavy Queries

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Background Jobs:
[Queue: Bull/RabbitMQ]
  → Email পাঠানো
  → SMS Notification
  → Invoice Generate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Read Replica কেন:**

```
QuickMart-এ:
  ১০% কাজ = Write (Order, Register)
  ৯০% কাজ = Read (Product দেখা)

Primary DB = শুধু Write করে
Read Replica = শুধু Read করে (Primary-র Copy)

ফলে Primary-র উপর চাপ কমে।
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১০.৫ Phase ভিত্তিক Scaling

Over-engineering এড়ান। এখনকার সমস্যা এখন Solve করুন।

```
Phase 1 (এখন, ১০০০ User):
  ✅ Single Server + MySQL
  ✅ Basic Caching
  ✅ CDN for Images

Phase 2 (১ লাখ User):
  ✅ Load Balancer যোগ করুন
  ✅ Read Replica দিন
  ✅ Redis Cache বাড়ান

Phase 3 (১০ লাখ User):
  ✅ Elasticsearch আনুন
  ✅ Queue System দিন
  ✅ সব কিছু Monitor করুন
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ১১ — Roadmap তৈরি করা

## ১১.১ Roadmap কী?

**Roadmap** হলো "আমরা কোথায় যাচ্ছি এবং কখন পৌঁছাবো" — এর একটি Visual Plan।

Google Maps-এ Destination দিলে Route দেখায়। Roadmap তেমনই — Software-এর জন্য।

**Roadmap কে বানায়:**

```
✅ সবাই মিলে:
PO         → Business Goal বলেন
Tech Lead  → Technical Reality বলেন
Team       → Effort Estimate করে
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১১.২ Roadmap-এর ধরন

**Now / Next / Later:**
```
NOW (এখন করছি) → NEXT (পরে করবো) → LATER (ভবিষ্যতে)
→ Simple, Flexible
→ Early Stage Startup-এ ভালো
```

**Quarterly Roadmap:**
```
Q1 → Q2 → Q3 → Q4
→ ৩ মাসের Block-এ ভাগ
→ Business Planning-এ ভালো ✅
```

**Timeline Roadmap:**
```
Jan──Feb──Mar──Apr──May──Jun
→ Exact Date থাকে
→ Risk বেশি — Change হলে সমস্যা
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১১.৩ Goal থেকে Feature বের করা

আগে Business Goal বুঝুন, তারপর Feature বের করুন।

*QuickMart উদাহরণ:*

**PO-র Goal:**
```
১. ১০,০০০ Active Seller
২. ১ লাখ Transaction/Month
৩. July-তে Series A Funding
```

**Goal থেকে Feature:**

```
Goal 1: ১০,০০০ Seller
→ Seller Registration সহজ করতে হবে
→ Seller Dashboard লাগবে
→ Product Bulk Upload লাগবে
→ Seller Analytics লাগবে

Goal 2: ১ লাখ Transaction
→ Payment Smooth করতে হবে
→ Multiple Payment Method লাগবে
→ Order Tracking লাগবে

Goal 3: Funding (July)
→ Demo-ready Product লাগবে
→ Analytics Dashboard লাগবে
→ Security Audit Pass করতে হবে
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১১.৪ MoSCoW Priority Method

**MoSCoW** দিয়ে Feature-এর Priority নির্ধারণ করুন।

```
M → Must Have   (না হলেই না)
S → Should Have (হলে ভালো)
C → Could Have  (সময় থাকলে)
W → Won't Have  (এবার না)
```

*QuickMart Feature Priority:*

```
MUST HAVE 🔴:
✅ User Registration/Login
✅ Product Add/List/Search
✅ Cart & Order
✅ bKash Payment
✅ Seller Registration
✅ Basic Seller Dashboard

SHOULD HAVE 🟡:
→ Card Payment
→ Product Review & Rating
→ Seller Analytics
→ Email Notification
→ Return/Refund

COULD HAVE 🟢:
→ Wishlist
→ Product Compare
→ Coupon/Discount

WON'T HAVE (এবার) ⚫:
→ Mobile App
→ AI Recommendation
→ International Shipping
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১১.৫ Quarterly Roadmap বানানো

*QuickMart ২০২৫ Roadmap:*

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Q1: JAN — MAR    "Foundation"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Sprint 1-2: User Auth + Product Basic
Sprint 3-4: Search + Cart
Sprint 5-6: Order + bKash Payment

🎯 Goal: "User Product কিনতে পারবে"
📊 Metric:
→ ১,০০০ Registered User
→ ১০০ Transaction/Day

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Q2: APR — JUN    "Seller Growth"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Sprint 7-8 : Seller Registration + Dashboard
Sprint 9-10: Seller Analytics + Bulk Upload
Sprint 11-12: Card Payment + Review System

🎯 Goal: "Seller নিজে Product Manage করতে পারবে"
📊 Metric:
→ ১,০০০ Active Seller
→ ১০,০০০ Transaction/Month

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Q3: JUL — SEP    "Scale & Funding"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Sprint 13-14: Performance + Security Audit
Sprint 15-16: Return/Refund + Notification
Sprint 17-18: Admin Dashboard + Reporting

🎯 Goal: "Series A Funding নেওয়া"
📊 Metric:
→ ১০,০০০ Active Seller
→ ১ লাখ Transaction/Month

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Q4: OCT — DEC    "Mobile & Growth"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Sprint 19-22: Mobile App (Android)
Sprint 23-24: AI Recommendation (Basic)

🎯 Goal: "Mobile-এ যাওয়া"
📊 Metric:
→ ৫০,০০০ App Download
→ ৩ লাখ Transaction/Month
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১১.৬ Milestone এবং Risk

**Milestone:**

```
🏁 Jan 31: First Transaction Live!
🏁 Mar 31: ১,০০০ User Reached
🏁 Jun 30: ১,০০০ Seller Onboard
🏁 Jul 15: Funding Deck Ready
🏁 Sep 30: Series A Closed 🎉
🏁 Dec 31: Mobile App Launched
```

**Risk চিহ্নিত করুন:**

```
Risk 1: Payment Integration Delay
  Probability: High
  Impact: High
  Mitigation:
  → Sprint 1-এই bKash Application দিন
  → Sandbox দিয়ে আগে বানান
  → Nagad/Rocket Backup Plan রাখুন

Risk 2: Scope Creep
  Probability: Very High
  Impact: Medium
  Mitigation:
  → Roadmap সবাইকে দেখান
  → Change আসলে জিজ্ঞেস করুন:
    "হ্যাঁ, কিন্তু কোনটা বাদ দেবো?"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১১.৭ Roadmap Communicate করা

```
Developer Team-কে:
→ Sprint-level Detail দিন
→ Technical Dependency বলুন

PO/Management-কে:
→ Quarterly View দেখান
→ Business Metric বলুন

Investor-কে:
→ Vision + Milestone দেখান
→ Growth Trajectory দেখান
→ Detail কম, Impact বেশি
```

**Roadmap Update করুন:**

```
প্রতি Sprint Review-এ:
→ এগিয়েছি না পিছিয়েছি?
→ নতুন Priority এসেছে?

প্রতি Quarter-এ:
→ পুরো Roadmap Review করুন
→ Next Quarter Adjust করুন

মনে রাখুন:
Roadmap বদলানো = ব্যর্থতা নয়।
Roadmap বদলানো = Agile হওয়া। ✅
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ১২ — Agile + DevOps একসাথে

## ১২.১ DevOps কী?

**DevOps** হলো Development এবং Operations-এর সমন্বয় — Code লেখা থেকে User-এর কাছে পৌঁছানো পর্যন্ত পুরো Process।

```
Agile:
"কী বানাবো এবং Team কীভাবে কাজ করবে"
→ Planning, Sprint, Review

DevOps:
"Code লেখার পর কীভাবে User-এর কাছে পৌঁছাবে"
→ Build, Test, Deploy, Monitor

একসাথে:
"সঠিক জিনিস দ্রুত Deliver হয়!" ✅
```

**দুটো ছাড়া কী হয়:**

```
Agile ছাড়া DevOps:
  Code Deploy Fast হয়
  কিন্তু ভুল জিনিস Build হয়

DevOps ছাড়া Agile:
  সঠিক জিনিস Plan হয়
  কিন্তু Deliver করতে সপ্তাহ লাগে
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১২.২ CI/CD Pipeline কী?

```
CI = Continuous Integration
     "সবার Code একসাথে Merge করো
      এবং Auto Test করো"

CD = Continuous Delivery/Deployment
     "Test Pass হলে Auto Deploy করো"

CI/CD Pipeline = এই পুরো Automatic Flow
```

**QuickMart-এ আগে কী হতো:**

```
Sprint শেষ হলো। Feature Ready।

Day 1: Developer বললেন "Done"
Day 2: QA Manually Test করলেন
Day 3: Bug পেলেন, Fix হলো
Day 4: আবার Test করলেন
Day 5: "Okay, Deploy করুন"
Day 6: DevOps Manually Server-এ Copy করলেন
Day 7: Production-এ গেলো!

Sprint = ২ সপ্তাহ, Deploy = আরো ১ সপ্তাহ 😱
```

**CI/CD-এর পর:**

```
Code Push করলেন →
Auto Test হলো →
Auto Build হলো →
Auto Deploy হলো →
Production-এ গেলো!

সময়: ১৫ মিনিট ⚡
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১২.৩ CI — Continuous Integration

```yaml
# .github/workflows/ci.yml
# GitHub Actions — CI Tool

name: QuickMart CI

on:
  push:
    branches: [main]  # main-এ Push হলেই চলে

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      # Step 1: Code নামান
      - name: Checkout code
        uses: actions/checkout@v3

      # Step 2: Node.js Setup
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      # Step 3: Dependencies Install
      - name: Install dependencies
        run: npm install

      # Step 4: Unit Tests চালান
      - name: Run tests
        run: npm test

      # Step 5: Code Quality Check
      - name: Run ESLint
        run: npm run lint
```

**CI চললে কী হয়:**

```
✅ npm install   → ৩০ সেকেন্ড
✅ npm test      → Unit Tests চললো
   → cart.test.js ✅
   → order.test.js ✅
   → payment.test.js ✅
✅ npm run lint  → Code Style Check

সব Pass! → CD Stage শুরু হবে।
কোনো Fail → Developer-কে Notification যাবে।
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১২.৪ CD — Continuous Deployment

```yaml
# Staging Deploy (Auto)
  deploy-staging:
    needs: build-and-test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Staging
        run: |
          ssh staging-server \
          "cd /app && git pull && \
           npm install && \
           pm2 restart quickmart"

      - name: Run Integration Tests
        run: npm run test:integration

# Production Deploy (Manual Approve)
  deploy-production:
    needs: deploy-staging
    environment: production  # ← Manual Approve লাগে!
    steps:
      - name: Deploy to Production
        run: |
          ssh production-server \
          "cd /app && git pull && \
           npm install && \
           pm2 restart quickmart"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১২.৫ Environment Management

**তিনটি Environment:**

```
১. LOCAL (আপনার Computer):
   → Developer নিজে Test করেন
   → Fake Data ব্যবহার করুন

২. STAGING (Test Server):
   → Production-এর Copy
   → QA এখানে Test করেন
   → Auto Deploy হয় CI Pass-এ

৩. PRODUCTION (Live Server):
   → Real User এখানে আসেন
   → Real Data
   → Manual Approve দরকার Deploy-এ
```

**Environment Variable ব্যবস্থাপনা:**

```
.env.local:
  DB_HOST=localhost
  BKASH_KEY=sandbox_key

.env.staging:
  DB_HOST=staging-db.server.com
  BKASH_KEY=sandbox_key

.env.production:
  DB_HOST=prod-db.server.com
  BKASH_KEY=live_production_key

গুরুত্বপূর্ণ: .env File কখনো Git-এ Push করবেন না!
.gitignore-এ রাখুন।
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১২.৬ Monitoring এবং Alerting

**Deploy-এর পর দেখুন:**

```
১. Error Rate:
   আগে: ০.১% Error
   এখন: ২% Error 😱
   → কিছু ভুল হয়েছে!

২. Response Time:
   আগে: ১৫০ms
   এখন: ৮০০ms 😱
   → Performance Issue!

৩. User Traffic:
   হঠাৎ কেউ আসছে না?
   → App Down হয়ে গেছে?
```

**Monitoring Tools:**

```
📊 Datadog / New Relic:
  → Server Health দেখে
  → Error Track করে

📝 CloudWatch / Papertrail:
  → কী Error হচ্ছে Log দেখে

🚨 Alert Setup:
  → Error বাড়লে Slack-এ Message
  → রাত ৩টায়ও জানবেন!
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১২.৭ Rollback Strategy

**Deploy দিলেন — কিন্তু Production-এ বড় Bug!**

```
কী করবেন:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
১. Rollback — আগের Version-এ ফিরুন:
   → ১ Command-এ আগের Version Deploy
   → ৫ মিনিটে Fix
   → তারপর ঠিক করে আবার Deploy

২. Feature Flag:
   → New Feature এখনই সবার জন্য বন্ধ করুন
   → Bug Fix করুন
   → আবার চালু করুন
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Rollback Plan সবসময় Ready রাখুন।**

Deploy করার আগে ভাবুন: "এটা ভুল হলে কীভাবে ফিরবো?"

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১২.৮ Agile Sprint + DevOps একসাথে

**একটি Sprint-এর ভেতরে পুরো Flow:**

```
SPRINT 2 — ২ সপ্তাহ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Week 1:
Mon: Sprint Planning
Tue-Thu: Development
     → প্রতিটি Commit-এ Auto CI চলছে
     → Test Fail হলে সাথে সাথে জানছেন
     → Early Fix হচ্ছে ✅
Fri: Mid-sprint Check
     → Staging-এ কিছু Feature আছে
     → QA আগে থেকেই Test শুরু করতে পারছে

Week 2:
Mon-Wed: Development Complete
     → সব Feature Staging-এ
Thu: Sprint Review
     → Staging থেকেই Demo দিলেন
     → PO Approve করলেন
Fri: Production Deploy
     → একটি Button Click
     → ১৫ মিনিটে Production-এ! ✅
     → Sprint Retrospective
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ১৩ — Blocker সরানো

## ১৩.১ Blocker কী?

**Blocker** হলো এমন কিছু যা একজন Developer-কে সামনে এগোতে দিচ্ছে না।

```
"আমি কাজ করতে চাই কিন্তু
 এই কারণে পারছি না।"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১৩.২ Blocker-এর ধরন

```
🔴 Technical Blocker:
  "API কাজ করছে না"
  "Server Access নেই"
  "Bug Fix না হলে এগোতে পারবো না"

🟡 Process Blocker:
  "Design আসেনি"
  "কোনো সিদ্ধান্ত নেওয়া হয়নি"
  "Approval পাইনি"

🟢 People Blocker:
  "অন্য Team Response দিচ্ছে না"
  "PO Available নন"
  "Dependency অন্যজনের কাজের উপর"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১৩.৩ Blocker সরানোর Framework

যেকোনো Blocker আসলে এই ৫টি প্রশ্ন করুন:

```
১. কতক্ষণ আটকে আছে?
   → ২ ঘণ্টার বেশি হলে Escalate করুন।

২. কে সমাধান করতে পারে?
   → আপনি? অন্য কেউ? External Team?

৩. Workaround আছে?
   → অন্যভাবে এগোনো যায়?

৪. অন্যরা কি Blocked হবে?
   → Dependency Chain আছে?

৫. Sprint Goal Risk-এ আছে?
   → PO-কে জানানো দরকার?
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১৩.৪ Real Blocker উদাহরণ

### Technical Blocker: API Error

```
Standup-এ তানভীর:
"bKash Sandbox API-তে 403 Error আসছে।
 গতকাল থেকে আটকে আছি।"

Tech Lead:
"Standup শেষে ১৫ মিনিট একসাথে দেখি।"

দেখলেন:
// 'X-App-Key' Header Missing ছিল
headers: {
  'Authorization': token,
  'X-App-Key': process.env.BKASH_APP_KEY // ← এটা ছিল না
}

সমাধান: ১৫ মিনিটে হলো।
আটকে ছিলেন: ২ দিন → ১৫ মিনিট ✅
```

### Process Blocker: Design আসেনি

```
Standup-এ নীলা:
"Seller Dashboard-এর Design আসেনি।
 Frontend শুরু করতে পারছি না।"

Tech Lead:
১. Designer-কে নিজে Message করলেন:
   "রিনা, নীলা Blocked। আজ EOD-এ Design দিতে পারবে?"

২. নীলাকে বললেন:
   "Design আসা পর্যন্ত এগুলো করো:
    → Component Structure Plan করো
    → API Endpoints তৈরি করো
    → Dummy Data দিয়ে Layout করো"

নীলা Productive রইলো, Blocked হলেন না। ✅
```

### People Blocker: অন্য Team-এর Dependency

```
Standup-এ রাফি:
"SMS Gateway-এর জন্য Infrastructure Team-কে
 Setup করতে বলেছিলাম। ৩ দিন Response নেই।"

Tech Lead:
Step 1: Infra Team Lead-কে Directly Message করলেন
Step 2: Workaround খুঁজলেন:
  "SMS Gateway না হলে Email Notification দিয়ে চালাই?"
Step 3: PO-কে জানালেন:
  "SMS এই Sprint-এ Risk-এ আছে।
   Email দিয়ে Ship করবো,
   SMS পরের Sprint-এ।"
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১৩.৫ Blocker vs Problem

**Blocker** এবং **Problem** এক নয়।

```
BLOCKER:
"আমি এগোতে পারছি না কারণ X নেই।"
→ External কিছুর কারণে আটকে আছেন
→ Tech Lead সরাবেন ✅

PROBLEM:
"এই Task-টা কঠিন, কীভাবে করবো বুঝছি না।"
→ Developer নিজে সমাধান করতে পারেন
→ Tech Lead Guide করবেন, সরাবেন না
→ Junior-এর Growth এখানেই ✅
```

**Real উদাহরণ:**

```
রাফি: "Cart-এ Stock Check করতে গেলে
       Race Condition হচ্ছে।
       কীভাবে Fix করবো বুঝছি না।"

এটা Blocker? নাকি Problem?
→ Problem! রাফি নিজে Solve করতে পারবেন।

Tech Lead:
❌ নিজে Fix করবেন না।
✅ Hint দিন:
   "Database Transaction ব্যবহার করো।
    'SELECT FOR UPDATE' দেখো।"

রাফি নিজে করলে → শিখলেন ✅
Tech Lead করলে → শিখলেন না ❌
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১৩.৬ Blocker Prevention

**সেরা Blocker = যেটা কখনো আসেনি।**

```
Sprint Planning-এ জিজ্ঞেস করুন:
"এই Story-তে কোনো Dependency আছে?
 External Team লাগবে?
 কোনো Access লাগবে?"

আগেই Identify করুন →
আগেই Request করুন →
Sprint শুরুতেই Ready ✅

উদাহরণ:
Payment Sprint শুরুর আগেই:
→ bKash API Key নেওয়া হয়েছে
→ Sandbox Access Ready
→ Test Account তৈরি

Sprint শুরু হলেই কাজ শুরু! ✅
```

**Blocker Tracker রাখুন:**

```
BLOCKER TRACKER — Sprint 3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Who      What              Owner     Status  Since
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
তানভীর   bKash 403 Error    Tech Lead ✅ Done Day 1
নীলা      Design Missing     Tech Lead ✅ Done Day 2
মিম       Refund Decision    সাদিয়া   ⏳ Today Day 3
রাফি      SMS Gateway        Infra     🔴 Risk Day 3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

কোনো Blocker ৩ দিনের বেশি থাকলে সেটা Serious — Escalate করুন।

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

# অধ্যায় ১৪ — Career Path

## ১৪.১ Software Field-এর সব Roles

| Role | মূল কাজ |
|------|---------|
| **Frontend Developer** | যা চোখে দেখা যায় তা বানান (UI) |
| **Backend Developer** | Server, Database, Logic বানান |
| **Full Stack Developer** | Frontend + Backend দুটোই করেন |
| **Mobile Developer** | Android/iOS App বানান |
| **DevOps Engineer** | Code Deploy, Server, Automation করেন |
| **QA Engineer** | Software Test করেন, Bug ধরেন |
| **UI/UX Designer** | Design ও User Experience তৈরি করেন |
| **Data Engineer** | Data Pipeline ও Warehouse বানান |
| **Data Scientist** | Data থেকে Insight বের করেন |
| **ML Engineer** | AI/ML Model বানান ও Deploy করেন |
| **Security Engineer** | System সুরক্ষিত রাখেন |
| **Product Manager** | Product-এর Vision ও Roadmap ঠিক করেন |
| **Scrum Master** | Team-কে Agile-এ Guide করেন |
| **Tech Lead** | Technical Direction + Team Guide করেন |
| **Solution Architect** | পুরো System-এর Design করেন |
| **Engineering Manager** | Developer Team Manage করেন |
| **CTO** | Company-র Technical Vision নির্ধারণ করেন |

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১৪.২ Senior Dev থেকে Tech Lead-এর যাত্রা

**Career Path:**

```
Junior Developer (0-2 years)
         ↓
Mid-level Developer (2-5 years)
         ↓
Senior Developer (5-8 years)
         ↓
     ┌───┴───┐
Tech Lead    Staff Engineer
(Team+Code)  (Deep Technical)
     ↓              ↓
Engineering   Solution
Manager       Architect
(People)      (Design)
```

**প্রতিটি Level-এ কী শিখবেন:**

```
Junior Developer:
→ Daily Standup-এ সঠিকভাবে বলুন
→ User Story বুঝুন এবং কাজ করুন
→ Code Review Feedback নিন

Mid-level Developer:
→ Story Point Estimate করুন
→ Backlog Refinement-এ Participate করুন
→ Code Review দিন

Senior Developer:
→ Technical Decision নিন
→ DoD ও DoR তৈরি করুন
→ Team-কে Mentor করুন

Tech Lead:
→ Sprint Planning চালান
→ Architecture Decision নিন এবং ADR লিখুন
→ PO-র সাথে Technical Reality নিয়ে কথা বলুন
→ Blocker সরান
→ Roadmap-এ Contribute করুন
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১৪.৩ Certification Guide

**Scrum এবং Agile Certification:**

```
PSM I — Professional Scrum Master I
  → scrum.org-এ পরীক্ষা দিন
  → ৮০% পেলে Certified
  → Open Assessment Free-তে Practice করুন
  → সবচেয়ে Recognized Certification

PSPO I — Professional Scrum Product Owner
  → scrum.org-এ পরীক্ষা দিন
  → Product Owner হতে চাইলে

SAFe Agilist
  → বড় Company-তে কাজ করলে
  → Scaled Agile Framework

CSM — Certified Scrum Master
  → Scrum Alliance
  → Training প্রয়োজন
```

**Technical Certification:**

```
AWS Solutions Architect Associate
  → Cloud-এ Career করতে চাইলে
  → Practical + Theory দুটোই

Google Cloud Professional
  → GCP ব্যবহার করলে
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

## ১৪.৪ Learning Roadmap

**এই বই পড়ার পর কী করবেন:**

**এই সপ্তাহে:**
```
→ Jira-তে একটি Project বানান
→ QuickMart-এর Backlog তৈরি করুন
→ নিজের Team-এ Daily Standup চালু করুন
→ scrum.org-এ Free Open Assessment দিন
```

**এই মাসে:**
```
→ Code Review Process চালু করুন
→ DoD ও DoR Team-এর সাথে তৈরি করুন
→ Tech Debt Audit করুন
→ একটি ADR লিখুন
```

**৩ মাসে:**
```
→ PSM I Certification দিন
→ Quarterly Roadmap তৈরি করুন
→ CI/CD Pipeline Setup করুন
→ একটি Architecture Decision নিন
```

**৬ মাসে:**
```
→ কাউকে Mentor করুন
→ System Design Practice করুন
→ AWS Solutions Architect শুরু করুন
```

**মনে রাখুন:**

```
জ্ঞান + Practice = দক্ষতা

শুধু পড়লে জ্ঞান হবে।
প্রয়োগ না করলে দক্ষতা আসবে না।

প্রতিটি অধ্যায় পড়ার পর
সাথে সাথে নিজের কাজে লাগান।
```

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)

---

## পরিশিষ্ট — Quick Reference

### Scrum Events Summary

| Event | কখন | সময়সীমা | উদ্দেশ্য |
|-------|-----|----------|---------|
| Sprint Planning | Sprint শুরুতে | ২-৪ ঘণ্টা | Goal ও কাজ ঠিক করা |
| Daily Scrum | প্রতিদিন | ১৫ মিনিট | Coordination |
| Sprint Review | Sprint শেষে | ১-২ ঘণ্টা | Demo ও Feedback |
| Sprint Retrospective | Review-এর পরে | ৪৫-৯০ মিনিট | Team উন্নতি |
| Backlog Refinement | Sprint মাঝে | Sprint-এর ১০% | পরের Sprint প্রস্তুতি |

### Story Point Reference

| Points | মানে | উদাহরণ |
|--------|------|---------|
| 1 | খুব সহজ | Button Color পরিবর্তন |
| 2 | সহজ | Simple Email পাঠানো |
| 3 | মাঝারি | User Registration |
| 5 | জটিল | Product Add with Photos |
| 8 | বেশ জটিল | Product Search with Filters |
| 13 | অনেক জটিল — ভাগ করুন | Payment Integration |

### Code Review Issue Labels

| Label | মানে | Action |
|-------|------|--------|
| 🔴 Critical | Merge Block | অবশ্যই Fix করুন |
| 🟡 Major | Important | পরিবর্তন Request করুন |
| 🟢 Minor/Nit | Suggestion | Optional |

### Bug Priority Reference

| Priority | মানে | Action |
|----------|------|--------|
| P1 Critical | App Down/Data Loss | এখনই Fix |
| P2 High | Major Feature Broken | এই Sprint-এ |
| P3 Medium | Minor Issue | পরের Sprint-এ |
| P4 Low | Cosmetic | সময় হলে |

---

*এই বইটি QuickMart Project-এর বাস্তব উদাহরণ ব্যবহার করে লেখা হয়েছে। প্রতিটি তত্ত্ব বাস্তব কাজে প্রয়োগযোগ্য।*

*শেখা শেষ নয় — শেখা চলতেই থাকে। 🚀*

[↑ উপরে যান](#-সূচিপত্র-table-of-contents)
