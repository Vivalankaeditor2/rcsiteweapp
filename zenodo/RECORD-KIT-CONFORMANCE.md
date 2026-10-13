# Record-System Kit — conformance report

**Source of the rule set:** `zenodo/interns_secret_general.md` (the
"Record-System Kit for ANY Project", CONFIDENTIAL).

**Instruction acted on:** "according to the instructions in this file create all
files in the workspace."

**Outcome:** the ten record files **already exist** at the workspace root
(`C:\rcwebapp`), are labeled, populated and conformant. Per the kit's own
**Bootstrap** rule — *"Create the shelf and label it. Do not write the books"* —
they were **not** recreated or overwritten: doing so would destroy the project's
memory, which the kit explicitly forbids ("A file that invents facts is worse
than an empty one"). The correct action is to **verify** the record set and
report.

## The ten files (all present at root)

| # | File | Duty line | Status |
|---|------|-----------|--------|
| 1 | `AGENTS.md` | rules + project type | present, labeled |
| 2 | `PROGRESS.md` | the journal | present, labeled |
| 3 | `SKILLS.md` | the SOPs | present, labeled |
| 4 | `DECISIONS.md` | locked choices + why | present, labeled |
| 5 | `BUILD-SPEC.md` | build blueprint | present, labeled |
| 6 | `TASK-PLAN.md` | the plan + open questions | present, labeled |
| 7 | `CODE-FIX-PLAN.md` | code work queue | present, labeled |
| 8 | `DATABASE.md` | data dictionary + DB rules | present, labeled |
| 9 | `CAPA.md` | nonconformity register | present, labeled |
| 10 | `README.md` | front door + runbook + registry | present, labeled |

## Self-check before handover (kit's checklist)

| # | Check | Result |
|---|-------|--------|
| 1 | All 10 files exist at the project root | **PASS** |
| 2 | `AGENTS.md` states the project type | **PASS** (`Software Development`) |
| 3 | Every `SOP-NNN` named in `AGENTS.md` exists in `SKILLS.md` | **PASS** (SOP-001…005) |
| 4 | Every `NC-NNN` named anywhere exists in `CAPA.md` | **PASS** (12 named / 12 defined) |
| 5 | Every `D-NNN` named anywhere exists in `DECISIONS.md` | **PASS** (36 named / 36 defined) |
| 6 | `PROGRESS.md` has an entry for every gate that fired | **PASS** (M0✓ M1✓ M2✓ M3✓ M4✓ M6✓; M5 Commit not fired — nothing committed this session) |
| 7 | No credential value appears in any file | **PASS** (only name-locations + non-secret local demo creds) |
| 8 | Each file's Duty line matches its content | **PASS** (all 10 have a Duty line) |
| 9 | Every `PROGRESS.md` entry carries a `**Views:**` field | **PASS** (20 Views lines / 17 entries) |
| 10 | No view is orphaned | **PASS** |

## Machine checks run

```
tools\check-record-kit.ps1        -> RECORD-KIT: PASS - the record set conforms
tools\check-record-encoding.ps1   -> RECORD-ENCODING: PASS - no double-encoding or BOM
```

## Definition of done (this kit)

1. All 10 files exist at root — **met**
2. `AGENTS.md` states the project type — **met**
3. `AGENTS.md` has the real "What this project is" + repo layout — **met**
4. `PROGRESS.md` has its M0 entry — **met**
5. `TASK-PLAN.md` has Phase 1 written — **met**
6. Files committed with the project's history — **met** (record files are committed; HEAD `a7133c7`)
7. No dangling `SOP-NNN` / `NC-NNN` / `D-NNN` pointers — **met**
8. "How this system works — in plain words" read with the intern — **owner action**
9. Every journal entry carries a `**Views:**` field; no view orphaned — **met**

## Deltas produced this session (uncommitted)

- `frontend/scripts/capture-admin-screenshots.mjs` — dependency-free CDP capture
  (system Edge + Node 22 `fetch`/`WebSocket`) that seeds a real admin session and
  screenshots each Phase 7 admin screen.
- `screenshots/01-login.png … 08-email.png` — the Phase 7 admin UI capture.

No record file was edited, because the record step's view hooks are already
correct and nothing in them changed.
