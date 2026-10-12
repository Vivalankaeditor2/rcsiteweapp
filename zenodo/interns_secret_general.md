# interns_secret_general.md — Record-System Kit for ANY Project (CONFIDENTIAL)

**What this file is:** the complete, copy-ready content of the 10 files
that keep a project honest when AI agents or interns work on it. Drop these
files into the root of ANY project — web, mobile, backend — and the workspace
becomes self-describing: what was done, what is planned, what is locked, what
broke.

**Why it exists:** agents and interns lose context. These 10 files are the
context. An AI that reads them on session start knows the project in seconds.

---

## How this system works - in plain words

*(Read this aloud to a new intern on day one. It is the whole idea on one page.)*

**The problem.** People forget. An AI forgets everything between sessions. A
human forgets why a choice was made three weeks ago. When the one person who
remembers leaves, the project loses its memory.

**The fix.** Put the memory in the files, not in heads. These 10 files are read
at the start of every session, so the project "remembers" even when nobody does.

**The picture.** Think of a kitchen:

| In the system | In the kitchen |
|---|---|
| The owner | owns the kitchen |
| `AGENTS.md` | the house rules on the wall |
| the agent or intern | the cook |
| `SKILLS.md` | the recipe cards in the drawer |
| `PROGRESS.md` | the kitchen diary |

The owner never "operates" a recipe. The cook cooks; the recipe tells the cook
how.

**One file answers one question.** This is the key to the whole system:

| File | The question it answers | When you read it |
|---|---|---|
| `AGENTS.md` | How do I behave here? | every session, first |
| `PROGRESS.md` | What has happened so far? | every session |
| `TASK-PLAN.md` | What is the whole plan? | when you need the shape of the job |
| `CODE-FIX-PLAN.md` | What code do I do next? | before writing code |
| `BUILD-SPEC.md` | How do we build it? | before building |
| `DECISIONS.md` | What is already decided? | before reopening a question |
| `CAPA.md` | What broke, and how was it stopped? | when a defect appears |
| `SKILLS.md` | How do I do this repeated job? | when repeating a process |
| `DATABASE.md` | What does each table mean? | when touching the database |
| `README.md` | How do I run this thing? | when you need to start it |

**Two ways the owner guides the work:**

1. **In chat** - the day's job: "fix the login bug". Said once.
2. **In `AGENTS.md`** - the standing rules: "never commit unless asked". These
   apply every session, automatically, even when the owner says nothing.

**Two kinds of rule.** A rule in `AGENTS.md` is either:

- **complete in itself** - "use simple English". Just obey it. No other file
  needed.
- **a pointer** - "Full procedure: `SKILLS.md` SOP-006". Obey the rule, then
  read that SOP for the exact steps.

**Pointers must land.** If any file names a `SOP-NNN`, `NC-NNN` or `D-NNN`,
that entry must exist. A pointer to nothing is a defect - it sends the next
person to a blank page. The self-check near the end of this file looks for
exactly these.

---

## Figure - how the record files flow

*(One picture of the whole system. Read them from the top down.)*

```text
FIGURE 1 - How a change flows through the files
=================================================

 (1) THE OWNER writes the intent
      |
      +---> in chat .......... the day's job       (said once)
      |
      +---> AGENTS.md ........ the standing rules  (read every session)
                 |
                 |  points to the exact SOP when steps are needed
                 v
             SKILLS.md ...... the how-to steps

 (2) THE AGENT reads AGENTS.md, follows it, opens the named SOP, does the work
      |
      v
 (3) A GATE FIRES   (M0 session open ... M6 session close)
      |
      v
 (4) THE RECORD STEP runs
      |
      |   1. PROGRESS.md       ALWAYS  <- the journal
      |   2. TASK-PLAN.md      if the plan moved
      |   3. CODE-FIX-PLAN.md  if code is affected
      |   4. BUILD-SPEC.md     if built work moved
      |   5. CAPA.md           if M3 fired  (something broke)
      |   6. SKILLS.md         if M4 fired  (done twice)
      |   7. DECISIONS.md      if a choice was locked
      |   8. AGENTS.md         if a durable rule was learned
      |   9. DATABASE.md       if the schema changed
      |  10. README.md         if run steps changed
      |
      v
 (5) EVERY ENTRY CARRIES A POINTER
      |
      |   Views: TASK-PLAN.md, CAPA.md       (or: none)
      |
      v
 (6) NO VIEW IS ORPHANED - every record file is updated or ruled out
```

**How to read Figure 1.** The owner writes the rules **once** in `AGENTS.md`.
The agent reads them **every session**, opens the named SOP in `SKILLS.md`, and
does the work. When something finishes, a gate fires, and the record step writes
the journal and updates only the files that actually changed. Every entry
carries a `Views:` pointer, so **no record file is left orphaned**.

```text
FIGURE 2 - Which file wins
===========================

 AUTHORITY (high to low)          THE QUESTION IT ANSWERS
 -----------------------          -----------------------
 DECISIONS.md ..................  WHY we chose it
      |                           (locked; only the owner reopens it)
      v
 BUILD-SPEC.md .................  HOW we build it      [always created]
      |                           (a changed requirement lands here)
      v
 the code files ................  WHAT exists now

 - - - - - - - - - - - - - - - -  and for the record:
 PROGRESS.md ...................  what HAPPENED  ->  wins on history
 CODE-FIX-PLAN.md ..............  what is NEXT    ->  wins on next action
 CAPA.md .......................  what BROKE     ->  wins on the cause
```

**How to read Figure 2.** `DECISIONS.md` holds **why**. `BUILD-SPEC.md` holds
**why**. `BUILD-SPEC.md` holds **how** - and it is where a changed
requirement is written down. It is **created in every project**; only its
size changes. The code is **what exists now**. Each level must match the
level above it. Separately, the journal answers *what happened*, and the
fix plan answers *what is next*.
```text
FIGURE 3 - Information flow (activity diagram)
==============================================

  OWNER                     AGENT                                   RECORD FILES
  |                           |                                     |
 (*) start                    |                                     |
  |                           |                                     |
  |--------------------------->                                     |
                              |                                     |
                              |  read AGENTS.md (every session)     |
                              |-------------------------------------> AGENTS.md
                              <-------------------------------------|
                              |                                     |
                   < rule names an SOP? >                           |
                   |                    |                           |
                   yes                  no                          |
                   |                    |                           |
                   v                    |                           |
           [ read that SOP ]            |                           |
                   |                    |                           |
                   +----------+---------+                           |
                              |                                     |
                              v                                     |
                       [ DO THE WORK ]                              |
                              |                                     |
                              v                                     |
                   < gate fires? M0..M6 >                           |
                   |                    |                           |
                   no                   yes                         |
                   |                    |                           |
                   |                    v                           |
                   |           [ THE RECORD STEP ]                  |
                   |          PROGRESS.md   always                  |
                   |        other files   if touched                |
                   |          "Views:"      always                  |
                   |                    |                           |
                   |                    |---------------------------> records written
                   +----------+---------+                           |
                              |                                     |
                              v                                     |
                    [ COMMIT (M5 gate) ]                            |
                              |                                     |
                              v                                     |
            [ next session re-reads the records ]                   |
               [ the records ARE the memory ]                       |
                              |                                     |
                              v                                     |
                          (*)  end                                  |
```

**How to read Figure 3.** The same system as Figure 1, drawn as an activity
diagram: a start node `(*)`, action nodes `[ ... ]`, decision nodes
`< ... ? >`, and the work flowing down the middle lane. The right-hand lane
is where information leaves the work - only the journal, plus the views its
`Views:` line names. The bottom arrow is the point of the whole system: the
records written today are what the next session reads tomorrow. That loop
**is** the memory. Which record file is written at which gate: see "The
record step" above.

### Figure 3B - the rest of the architecture

```text
FIGURE 3B - The other seven views, and their duties
=====================================================

    THE RECORD STEP                     writes these seven as well - each for its own duty
    |
    |
    +---> DECISIONS.md                  locked choices: what was decided, when, why,
    |                                   and the condition that would reopen it
    +---> BUILD-SPEC.md                 the build blueprint: source of truth for every
    |                                   file to build, each with an acceptance test
    +---> TASK-PLAN.md                  the plan: phase -> task -> step, with status,
    |                                   plus the open-questions parking lot
    +---> CODE-FIX-PLAN.md              the code work queue: fixes and features in
    |                                   priority order - what code to do next
    +---> DATABASE.md                   the data dictionary: one entry per table -
    |                                   duty, keys, joins - plus the DB rules
    +---> CAPA.md                       the nonconformity register: what broke, root
    |                                   cause, corrective, preventive, verified
    +---> README.md                     the front door: what it is, how to run it, and
    |                                   the external-service registry (names only)
    |
    v                                   [ no view is orphaned ]
```

### The complete inventory, with duties

Figure 3 shows three of the ten files. Figure 3B adds the other seven. Here
is all ten in one place - **file - its duty - the question it answers.**

| # | File | Duty | The question it answers |
|---|------|------|-------------------------|
| 1 | `AGENTS.md` | the rules and the doorway | How do I behave here? |
| 2 | `PROGRESS.md` | the journal - written at every gate | What happened? |
| 3 | `SKILLS.md` | the SOPs - steps for repeated jobs | How do I do this job? |
| 4 | `DECISIONS.md` | locked choices + why + reopen condition | What is already settled? |
| 5 | `BUILD-SPEC.md` | the build blueprint - source of truth for built files | How do we build it? |
| 6 | `TASK-PLAN.md` | the plan (phase -> task -> step) + open questions | What is the whole job? |
| 7 | `CODE-FIX-PLAN.md` | the code work queue, in priority order | What code do I do next? |
| 8 | `DATABASE.md` | the data dictionary + DB rules | What does each table mean? |
| 9 | `CAPA.md` | the nonconformity register (root cause, not just fix) | What broke, and why? |
| 10 | `README.md` | the front door + runbook + dependency registry | How do I run this? |

**The count, stated once.** Ten files are the standard set, created in every
project whatever its type: the journal plus its nine views. Figure 3 shows the
heart of the loop, Figure 3B the remaining views and their duties, and Figure 4
the whole set with its hooks - so all ten are covered and nothing is left out.

---

```text
FIGURE 4 - Activity diagram: all ten record files, with hooks
================================================================

         AGENT  /  THE WORK                         THE TEN RECORD FILES
                  |                                           |
                 (*) session start                            |
                  |                                           |
                  v                                           |
      [ M0 : read the records ]                               |
                  |-------------------------------------------> AGENTS.md        rules - read first
                  |-------------------------------------------> PROGRESS.md      what happened
                  |-------------------------------------------> DECISIONS.md     locked choices + why
                  |-------------------------------------------> TASK-PLAN.md     the plan
                  |-------------------------------------------> CODE-FIX-PLAN.md next code work
                  |-------------------------------------------> BUILD-SPEC.md    build blueprint
                  |-------------------------------------------> DATABASE.md      the data dictionary
                  |-------------------------------------------> CAPA.md          what broke, and why
                  |-------------------------------------------> SKILLS.md        the SOPs
                  |-------------------------------------------> README.md        how to run it
                  <-------------------------------------------|
                  |                                           |
                  v                                           |
           [ DO THE WORK ]                                    |
                  |                                           |
                  v                                           |
       < gate fires? M0..M6 >                                 |
                  | no  ->  back to [ DO THE WORK ]           |
                  |  yes                                      |
                  v                                           |
         [ THE RECORD STEP ]                                  |
         1. PROGRESS.md  - ALWAYS                             |
         2. Views: hook  - names the files touched            |
                           (or the word: none)                |
                  |                                           |
                  |-------------------------------------------> PROGRESS.md       ALWAYS
                  |-------------------------------------------> TASK-PLAN.md      if the plan moved
                  |-------------------------------------------> CODE-FIX-PLAN.md  if code is affected
                  |-------------------------------------------> BUILD-SPEC.md    if built work moved
                  |-------------------------------------------> CAPA.md           if M3 fired
                  |-------------------------------------------> SKILLS.md         if M4 fired
                  |-------------------------------------------> DECISIONS.md      if a choice locked
                  |-------------------------------------------> AGENTS.md         if a new rule
                  |-------------------------------------------> DATABASE.md       if the schema changed
                  |-------------------------------------------> README.md         if run steps changed
                  <-------------------------------------------|
                  |                                           |
                  v                                           |
           [ M5 : commit ]                                    |
                  |                                           |
                  v                                           |
           (*) session end                                    |
                  |                                           |
                  +------------------------------> next session: back to M0
```

**How to read Figure 4.** Every one of the ten record files appears twice:
**read** at session open (M0), and **written** only if the gate touched it.
The `Views:` line is the **hook** - the pointer each journal entry carries
back to the other files, so none is orphaned. `PROGRESS.md` is the only file
written at every gate; the rest are conditional. The step that says which
condition fires when is "The record step" above.

---

## Handover conditions — read to the intern

1. Create all 10 files at the project root **on day one**, before any code.
2. Fill in only the parts marked `[FILL]` — the structure is fixed.
3. **PROGRESS.md is the journal.** It is written at every milestone gate —
   never skipped, never rewritten, only appended.
4. A milestone without a PROGRESS.md entry did not happen.
5. The other files update **only when their gate fires** — see the gate table
   in `AGENTS.md`. Do not batch-update them "to be safe".
6. Keep entries short. One line beats a paragraph. These files are read every
   session — noise is how they stop being read.
7. **Never put a credential in any of these files** — names and locations only,
   never values.
8. Commit the record files with the code. The journal lives in the same
   history as the work it describes.
9. Read the **"How this system works - in plain words"** section with the
   intern on day one, before they touch a file.
10. **No dangling pointers.** If any file names a `SOP-NNN`, `NC-NNN` or
    `D-NNN`, that entry must exist. Check before handover.
11. **No orphaned views.** Every journal entry says in `**Views:**` which record
    files it touched, or `none`. A record file that a gate should have updated,
    but did not, is orphaned - fix it before closing.

---

## The 10 files at a glance

```
AGENTS.md        rules + project type - read every session
BUILD-SPEC.md    build blueprint: what to build + acceptance tests
PROGRESS.md      journal - source of truth, written at every gate
DECISIONS.md     locked choices + why
TASK-PLAN.md     plan + open questions
CODE-FIX-PLAN.md code work queue (what to do next)
DATABASE.md      data dictionary (not applicable if there is no DB)
CAPA.md          when something breaks
SKILLS.md        repeatable processes
README.md        front door + runbook + dependency registry
```

**Read order each session:** `AGENTS.md` first - it is the doorway, and it says
what to read next -> `PROGRESS.md` (what has happened) -> `TASK-PLAN.md` (the
plan) -> `CODE-FIX-PLAN.md` if doing code -> `CAPA.md` if resuming a fix ->
`SKILLS.md` when repeating a process; `BUILD-SPEC.md` before building.

**Which file wins.** When two records disagree, each file is the authority on
its own subject:

| The question | The file that wins |
|---|---|
| What happened? | `PROGRESS.md` |
| What should happen next? | `CODE-FIX-PLAN.md` |
| What is already decided? | `DECISIONS.md` |
| What broke, and why? | `CAPA.md` |

Never "fix" a disagreement by editing history. Add a new entry that says what
changed.

---

## Bootstrap — what to do FIRST (before anything else)

*(This happens exactly once per project. "Bootstrap" means the small first step
that makes everything else possible - like switching a computer on before it can
run any program.)*

**Bootstrap = the short first conversation where the assistant reads this kit
and creates the 10 files inside the project folder.** After that single step the
folder "knows" how to work. Every session afterwards just reads those files.

### What the intern does

1. **Create the workspace** - one folder to hold every project file.
2. **Hand the kit to the assistant** - either **paste** the content of this kit
   into the chat, or **give the file path** to this kit.
3. That is all. The assistant does the rest.

### What the assistant does

| # | Step | Meaning |
|---|---|---|
| 1 | Confirm the workspace | one project folder; all 10 files go at its **root** |
| 2 | Read this kit | from the pasted text, or from the path given |
| 3 | Create the 10 files | empty of project detail; each keeps its `[FILL: ...]` markers |
| 4 | Fill what can be filled | **only** what the owner actually said - name, purpose, type |
| 5 | Report and stop | list the 10 files created, then wait for the owner |

### The rule the bootstrap must obey

> **Create the shelf and label it. Do not write the books.**

The bootstrap creates **structure**. It must **never invent** project content it
was never given. An empty `[FILL: ...]` is honest. A file that invents facts is
worse than an empty one, because the next session will believe it.

### Where it sits in the gates

**Bootstrap runs once, before M0.** It is what creates the files. M0 to M6 are
the repeating loop, every session after that.

---

## Project types — Software Development, and Other

Every project declares its type in `AGENTS.md`. One line. It tells the assistant
how to shape `BUILD-SPEC.md`. **Both types get all 10 files** - only the
*content* of the blueprint differs.

| | **1 - Software Development** | **2 - Other** (written work and other soft work) |
|---|---|---|
| Typical work | websites, apps, APIs, databases | research papers, articles, books, reports, white papers |
| Blueprint unit | a **file** to build | a **deliverable**: section, chapter |
| Duty | what the file does | what the deliverable must say or do |
| Acceptance test | it runs and returns the right data | it reads correctly and meets the brief |
| Done means | proven end-to-end | reviewed and approved |
| `DATABASE.md` | active | usually `not applicable` |

**The shape never changes:** deliverable -> duty -> acceptance test -> status.
Only the words change. So a white-collar project - a research paper, a book, an
article - uses exactly the same system as a website.

### The generic fallback (the provision for now)

Any type not listed yet uses the **generic** shape: Deliverable / Duty /
Acceptance / Status. So an unlisted kind of work - a course, a film script, an
event plan - still fits without changing this kit. **New types are added later,
from real use, never guessed in advance.**

### A file that does not apply

A record file that does not fit the project is **still created**, and its first
line says `not applicable`. It is never left blank and never omitted.

> A blank file rots. A file marked "not applicable" is a decision.

---

## Template improvement — the kit learns from its users

This kit is expected to get better over time. When an experienced user finds a
*general* improvement - a rule, a section, a check pattern - it can be offered
back so every future project benefits.

| # | Step | Rule |
|---|---|---|
| 1 | Spot a general improvement | it must be a **rule, section or check pattern** - not project detail |
| 2 | Strip the specifics | remove names, paths, credentials, business facts; keep the general shape |
| 3 | Propose, never auto-apply | the assistant **offers** the change; the kit owner accepts or rejects |
| 4 | Version the kit | an accepted change bumps the kit version, so older projects see what moved |

**Planned next step (not yet done):** once enough `BUILD-SPEC.md` files exist
from experienced developers, their common patterns are collected and folded into
the shared template as new type definitions.

> **Hard guardrail.** Only structure and general rules travel back. **Never**
> credentials, personal data, client names, or business content. A template
> improved by one project must not leak that project.

---


## File 1 — `AGENTS.md`

**Duty:** the rules file. What the project is, how work is done, the record
system, credential handling, working rules learned the hard way. Read first,
every session. Updated only when a durable new rule is learned.

```markdown
# AGENTS.md

Guidance for anyone — human or AI — working in this repo. Read this first,
every session.

## What this project is

[FILL: one paragraph — what it does, who it is for, the stack.]

## Project type

**Type:** [FILL: `Software Development` OR `Other`]

[FILL: one line. Software: what is being built. Other: what written work
is being produced - e.g. "a research paper on X", "a book on Y".]

## Working rules

- **Simple English.** Short sentences. Common words.
- **Explain before you change.** Say what will change and why.
- **Do not edit a file the owner is editing.** Ask first.
- **Never commit or push** unless asked.
- **No credentials in code or chat.** Names and locations only, never values.
- **State the rule, and name the SOP.** A rule that needs steps: give the short
  rule here, then point to the exact `SKILLS.md SOP-NNN`.
- **No dangling pointers.** Never name a `SOP-NNN`, `NC-NNN` or `D-NNN` that
  does not exist.

## The record system — one journal, many views

**PROGRESS.md is the single source of truth.** Everything else is a view of it.

### Milestone gates

| Gate | When it fires |
|---|---|
| **M0 — Session open** | Read PROGRESS.md, confirm state. |
| **M1 — Plan** | A phase or task is added or re-scoped. |
| **M2 — Deliverable** | A file or feature is finished and verified. |
| **M3 — Defect** | Something broke, or a record was wrong. |
| **M4 — Reusable process** | Done twice, or worth repeating reliably. |
| **M5 — Commit** | Anything is committed or handed over. |
| **M6 — Session close** | End of session. Always write the close entry. |

### The record step (at every gate)

1. **PROGRESS.md** — append a dated entry. Always.
2. **TASK-PLAN.md** — move status. Only if plan changed.
3. **CODE-FIX-PLAN.md** — open/close a code item. Only if code affected.
4. **BUILD-SPEC.md** — move a status marker. Only if built work moved.
5. **CAPA.md** — open/close a nonconformity. Only if M3 fired.
6. **SKILLS.md** — add/update an SOP. Only if M4 fired.
7. **DECISIONS.md** — lock a choice. Only when one is made.
8. **DATABASE.md** — update the dictionary. Only if the schema changed.
9. **README.md** — update run steps, layout or dependencies. Only if those changed.
10. **AGENTS.md** — add a rule. Only if a durable new rule was learned.

**The routing check.** Every PROGRESS.md entry carries a `**Views:**` field
naming the record files the gate touched — or `none`. No entry is complete
until every record file is either updated or explicitly ruled out. A stale view
is a defect, not a shortcut.

### Entry format

    ### [M2] YYYY-MM-DD — short title
    - **Gate:** M2 Deliverable
    - **Area:** frontend / db / api …
    - **Status:** done | in-progress | blocked
    - **Views:** TASK-PLAN.md, CODE-FIX-PLAN.md   (or: none)
    - **Detail:** what changed, where, how verified.

### If records disagree

Each file is the authority on its own subject:

| The question | The file that wins |
|---|---|
| What happened? | PROGRESS.md |
| What should happen next? | CODE-FIX-PLAN.md |
| What is already decided? | DECISIONS.md |
| What broke, and why? | CAPA.md |

Never edit history to settle a disagreement - add a new entry.

## Repo layout

[FILL: folder map - one line per folder. Include BUILD-SPEC.md
as the build blueprint.]
```

---

## File 2 — `PROGRESS.md`

**Duty:** the journal. Append-only, newest at the bottom. The only file written
at every gate. Anyone can reconstruct the project history from this alone.

```markdown
# PROGRESS.md

**The journal. The single source of truth for what was done.**

- Append-only. Newest entries go at the **bottom**.
- Every entry: gate · area · status · detail.
- Never edit old entries — corrections are new entries.

---

### [M0] YYYY-MM-DD — Session open

- **Gate:** M0 Session open
- **Area:** —
- **Status:** done
- **Views:** none
- **Detail:** Records initialised. [FILL: what exists, what is next.]
```

---

## File 3 — `DECISIONS.md`

**Duty:** locked choices — what was decided, when, why, and what would reopen
it. Stops a settled question being silently re-decided by a later session.

```markdown
# DECISIONS.md

Locked choices — what was decided, when, and why.

**Rule:** never edit or delete an entry. A reversal is a new entry that
references the old one ("supersedes D-003").

**Format:**

## D-NNN — short title
- **Decided:** YYYY-MM-DD
- **Decision:** what was chosen
- **Options considered:** what else was on the table
- **Why:** the reason
- **Revisit if:** the condition that would reopen it

## Decisions

## D-001 — [FILL: first locked choice]
- **Decided:** YYYY-MM-DD
- **Decision:** [FILL]
- **Options considered:** [FILL]
- **Why:** [FILL]
- **Revisit if:** [FILL]
```

---

## File 4 — `TASK-PLAN.md`

**Duty:** the plan of record - phases -> tasks -> steps, with status. Plus the
**Open Questions** parking lot so nothing waiting on an answer gets lost.

**Not the same as `CODE-FIX-PLAN.md`.** `TASK-PLAN.md` is the **map**: the whole
job in build order (you cannot roof before the walls). `CODE-FIX-PLAN.md` is the
**queue**: the code items in the order they should be done *next*. One is
organised by dependency, the other by urgency. Both are needed; neither replaces
the other.

```markdown
# TASK-PLAN.md

Phase → Task → Step. The plan of record.

**Status key:** `[ ]` todo · `[~]` in progress · `[x]` done · `[!]` blocked

## Phase 1 — [FILL: name]

- [ ] [FILL: task]
- [ ] [FILL: task]

## Phase 2 — [FILL: name]

- [ ] [FILL: task]

## Open questions (waiting on owner)

- [ ] [FILL: question that blocks a decision]
```

---

## File 5 — `CODE-FIX-PLAN.md`

**Duty:** the code work list - fixes and features in **priority order**. It
answers one question: *what code do I do next?* Read before writing code.

**Not the same as `TASK-PLAN.md`.** `TASK-PLAN.md` is the map (the whole job in
build order); this file is the queue (the code work, most urgent first).

**Locked decisions do not live here.** They live in `DECISIONS.md`. If a locked
decision shapes the code, note it in the item's Notes column and point at the
`D-NNN` - do not copy the decision into this file, or the two will drift apart.

```markdown
# CODE-FIX-PLAN.md

The code work queue - priority order. Locked decisions live in
DECISIONS.md.

**Read before writing code.** If it and AGENTS.md disagree on what should
happen next, this file wins.

## Priority order

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | [FILL] | open | |

## Locked technical decisions

*(These live in `DECISIONS.md`. Listed here only as a short reminder, with the
`D-NNN` for each - never a second copy.)*

- [FILL: e.g. "PDO only, no ORM - D-003"]
```

---

## File 6 — `DATABASE.md`

**Duty:** the data dictionary — one entry per table: duty, keys, joins. Plus
the DB rules (engine, migration tool, naming). Skip this file only if the
project truly has no database.

```markdown
# DATABASE.md

Data dictionary — one entry per table. Update in the same step as the
migration that changes it — dictionary and schema must never drift.

## Rules

- **Engine:** [FILL: MariaDB / MySQL / Postgres …]
- **Migrations:** [FILL: Flyway / other] — versioned files only; never edit an
  applied migration.
- **Naming:** snake_case; `_id` FK suffix; `fk_<table>_<target>` constraints;
  repeating values live in lookup tables.
- **Normal form:** BCNF — non-key columns depend on the key only.

## Table dictionary

### [FILL: table_name]
- **Duty:** one sentence — what one row represents.
- **Key:** PK; unique keys.
- **Joins:** FK targets.
- **Since:** [migration/file that introduced it]
```

---

## File 7 — `CAPA.md`

**Duty:** the nonconformity register — written only when something breaks or a
record was wrong. Root cause, not just the fix. This is how the same bug never
happens twice.

```markdown
# CAPA.md

Corrective and Preventive Action register.

**One entry per nonconformity.** Nonconformity → root cause → corrective →
preventive → verification.

**Format:**

## NC-NNN — short title
- **Status:** open | closed
- **Found:** YYYY-MM-DD
- **What went wrong:** the symptom observed
- **Root cause:** why it actually happened — not the surface error
- **Corrective action:** the fix applied
- **Preventive action:** the rule/check that stops recurrence
- **Verified:** how it was proven fixed, and when

## Register

*(empty until first nonconformity)*
```

---

## File 8 — `SKILLS.md`

**Duty:** SOPs - "how we do a thing, every time". Written when a process is
done twice or important enough to repeat reliably. Each SOP is numbered and
referenced from CAPA entries when a fix produces a reusable procedure.

**Rules for SOPs:**

- **One SOP per process.**
- **Every SOP named in `AGENTS.md` must exist here.** If `AGENTS.md` says "see
  SOP-006", there must be a SOP-006. A pointer to nothing is a defect.
- `AGENTS.md` holds the **short rule** and points to the SOP; the SOP holds the
  **exact steps**. Keep it that way - do not move the steps into `AGENTS.md`.
- Write the SOP the moment gate **M4** fires - a process done twice, or one
  worth repeating reliably.

```markdown
# SKILLS.md

SOPs for processes we repeat. **One SOP per process.**

**Format:**

## SOP-NNN — short name
- **When to use:** the trigger
- **Steps:** numbered, exact commands/paths
- **Verify:** how you know it worked
- **Failure mode:** the common way it goes wrong

## SOPs

*(empty until the first repeatable process is learned)*
```

---

## File 9 — `README.md`

**Duty:** the front door — what the project is, how to run it, where things
live, and the dependency registry (external services by NAME, never values).

```markdown
# [FILL: Project name]

[FILL: one paragraph — what it is and who it is for.]

## Run it

[FILL: exact commands — e.g. `docker compose up -d`, dev server command,
test command.]

## Layout

[FILL: folder map — one line per folder.]

## Dependencies & external services

| Name | What for | Where configured | Owner |
|------|----------|------------------|-------|
| [FILL: e.g. "MariaDB local"] | app database | `.env` (not committed) | [FILL] |
| [FILL: e.g. "wa.me link"] | applicant WhatsApp | `lib/form.php` contact map | — |

**Rule: this table holds names and locations — never secrets or passwords.**
```

---

## File 10 — `BUILD-SPEC.md`

**Duty:** the build blueprint. The exact content of everything to be built, each
with its duty and its acceptance test. Answers, "how do we build it?"
**Created in every project**, whatever the type - the blueprint's size follows
the project, not its kind.

**Authority position.** `DECISIONS.md` says **why**. This file says **how**. The
code says **what exists now**. Each level must match the level above it.

**Build rules.**

1. Build **exactly as written** - paths, names, structure.
2. Do **not** change the schema. A schema change is a new migration, and only
   after owner approval.
3. **No credentials in code or documents.** Names and locations only.
4. Use the **existing theme or house style**. No new frameworks.
5. **Proof, not promises.** After building, prove it end-to-end and report the
   evidence - never just "done".

**The drift rule.** This spec is the source of truth. When built work must
deviate from it, **update the spec in the same step** - never let the two
disagree. A spec that no longer matches the work is worse than no spec.

**Status markers.** Every deliverable carries one, and it moves **in the same
step as the work**:

| Marker | Claims | Must be true |
|---|---|---|
| `specified` | a plan only | written down; nothing built |
| `built` | it exists | written to disk - **not proven to work** |
| `as-built-verified` | exists and works | evidence exists: a test passed, a page opened, a row written |

> `built` does **not** mean working. Only `as-built-verified` claims that, and it
> cannot be claimed without evidence. Moving a marker to `as-built-verified` is
> itself an **M2 deliverable gate**.

The shape is always **deliverable -> duty -> acceptance test -> status**. Only
the words change with the project type.

```markdown
# BUILD-SPEC.md

**Type:** [FILL: Software Development OR Other]
**Version:** [FILL: e.g. v1.0.0]

## Deliverables

| # | Deliverable | Duty | Acceptance test | Status |
|---|---|---|---|---|
| 1 | [FILL] | [FILL] | [FILL] | specified |
| 2 | [FILL] | [FILL] | [FILL] | specified |

<!-- Software example:  api/signup.php | accept the form, write the row |
     submit -> one row in the table | specified
     Other example:     Abstract | state the claim in 200 words |
     reads standalone, no jargon | specified -->

## Build rules

[FILL: the rules for this project - copied or adapted from above.]

## Definition of done

[FILL: the end-to-end proof that closes this project.]
```

**Done when:** every deliverable has a duty, an acceptance test and a status
marker - and no marker reads `as-built-verified` without evidence behind it.

---


## Glossary of system terms

The system uses its own short words. They are defined here so an intern never
has to guess.

| Term | Meaning |
|---|---|
| **Gate** | One of seven fixed moments (M0-M6) at which a record must be written. |
| **M0-M6** | Session open, Plan, Deliverable, Defect, Reusable process, Commit, Session close. |
| **Journal** | `PROGRESS.md` - the append-only log of what happened. |
| **Source of truth** | The one file that is authoritative on a question (see "Which file wins"). |
| **SOP** | Standard Operating Procedure - the exact steps for one repeated process (`SKILLS.md`). |
| **NC-NNN** | A nonconformity entry in `CAPA.md` - something that went wrong, with its root cause. |
| **D-NNN** | A locked decision in `DECISIONS.md`. |
| **Gate fires** | The moment that requires a record to be written. |
| **Owner-gated** | The change needs the owner's approval before anyone builds it. |
| **Append-only** | Add new entries; never edit or delete old ones. |
| **Views** | The `**Views:**` field in a journal entry - which record files the gate touched, or `none`. |
| **Orphaned view** | A record file a gate should have updated but did not. A defect. |
| **Status marker** | `specified` -> `built` -> `as-built-verified`. `built` does **not** mean working; only `as-built-verified` claims that, and only with evidence. |

---

## Self-check before handover

Run this on the whole record set. Every line is pass or fail.

- [ ] All 10 files exist at the project root.
- [ ] `AGENTS.md` states the project type (`Software Development` or `Other`).
- [ ] Every `SOP-NNN` named in `AGENTS.md` exists in `SKILLS.md`.
- [ ] Every `NC-NNN` named anywhere exists in `CAPA.md`.
- [ ] Every `D-NNN` named anywhere exists in `DECISIONS.md`.
- [ ] `PROGRESS.md` has an entry for every gate that fired.
- [ ] No credential value appears in any file - names and locations only.
- [ ] Each file's own "Duty" line matches what the file actually contains.
- [ ] Every PROGRESS.md entry has a `**Views:**` field (a file name or `none`).
- [ ] No view is orphaned: every touched record file was actually updated.

A failed line is a defect. Open a `CAPA.md` entry and fix it.

## Definition of done (this kit)

1. All 10 files exist at the project root.
2. AGENTS.md states the project type (Software Development or Other).
3. AGENTS.md has the real "What this project is" and repo layout filled in.
4. PROGRESS.md has its M0 entry.
5. TASK-PLAN.md has at least Phase 1 written.
6. The files are committed with the project's first commit.
7. No dangling pointers: every `SOP-NNN`, `NC-NNN` and `D-NNN` named anywhere
   resolves to a real entry.
8. The "How this system works - in plain words" section has been read with the
   intern.
9. Every journal entry carries a `**Views:**` field, and no view is orphaned.

---

**© 2026 Ishantha Siribaddana. All rights reserved.**

CONFIDENTIAL — for use by the internship team only. Not for external
distribution without written permission.
