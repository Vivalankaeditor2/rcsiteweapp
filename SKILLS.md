# SKILLS.md

**Duty:** the SOPs - steps for repeated jobs.

SOPs for processes we repeat. **One SOP per process.**

**Format:**

## SOP-NNN — short name
- **When to use:** the trigger
- **Steps:** numbered, exact commands/paths
- **Verify:** how you know it worked
- **Failure mode:** the common way it goes wrong

## SOPs

## SOP-001 — Run the URL-contract regression check
- **When to use:** before and after any change that can affect a public URL
  (routing, redirects, sitemaps, the web server). Also a pre-cutover gate.
- **Steps:**
  1. Open a shell at the repo root (`C:\rcwebapp`).
  2. Run: `powershell -ExecutionPolicy Bypass -File tools\url-contract.ps1`
  3. To check a local/other host instead: add `-BaseUrl http://localhost:3000`.
  4. To check only the must-not-break URLs: add `-OnlyCritical`.
  5. Read the table. Every line must read `PASS`.
- **Verify:** the final line reads `PASS - all N URL(s) match the contract`
  and the exit code is `0`.
- **Failure mode:** the live site rate-limits a fast burst and returns `429`
  (seen in Phase 0). The harness already throttles and retries; if a `429` still
  appears, wait a minute and re-run. A genuine break shows as `404`/`301` on a
  URL that should be `200`.

## SOP-002 — Run the forbidden-table guard
- **When to use:** before committing anything under `backend/src/main`,
  `frontend`, `rcsiteweb/src` or `rcsiteweb/ROOT` (D-019).
- **Steps:**
  1. From the repo root, run:
     `powershell -ExecutionPolicy Bypass -File tools\check-forbidden-tables.ps1`
  2. In the backend build, the same rule runs as
     `backend/src/test/java/.../architecture/ForbiddenTableUsageTest.java`
     (`mvn test`).
- **Verify:** the script prints
  `PASS - no forbidden table reference found` and exits `0`.
- **Failure mode:** a name match on `article_category_has_articles` in a comment
  or a doc string. Remove the reference — the news app must never touch that
  table (D-019).

## SOP-003 — Load the frozen schema + seed into a local database
- **When to use:** bringing up a fresh local dev database for the backend.
- **Steps:**
  1. Start the local stack (Docker):
     `docker compose -f tools/local-stack/docker-compose.yml up -d mariadb`
     (set `MARIADB_ROOT_PASSWORD` and `MARIADB_PASSWORD` first - never commit
     them).
  2. If MariaDB is installed locally instead, run:
     `pwsh -File tools/db-load.ps1 -User root -Password '<local-only>'`
  3. Both paths load `rcsiteweb/db/dbschema.sql` (DDL, 31 tables) then the
     `rcsiteweb/db/001-016` seed files (`INSERT` only).
- **Verify:** `SHOW TABLES;` lists 31 tables and `SELECT COUNT(*) FROM
  article_category;` returns 113. The loader never writes to `dbschema.sql`
  (D-014).
- **Failure mode:** running the seed files before the DDL gives "table doesn't
  exist"; load `dbschema.sql` first (the loader already does this by name order).

## SOP-004 — Check the record set against the kit
- **When to use:** at handover, at M6 session close, and after any edit to a
  record file.
- **Steps:**
  1. From the repo root, run:
     `powershell -ExecutionPolicy Bypass -File tools\check-record-kit.ps1`
  2. It runs the kit's self-check: all ten files present, project type stated,
     every `SOP-NNN`/`NC-NNN`/`D-NNN` resolves, `M0` and `M6` entries exist,
     every journal entry has a `Views:` field, every file declares a `Duty`, and
     no credential value leaks into the tracked files.
- **Verify:** the final line reads `RECORD-KIT: PASS` and the exit code is `0`.
- **Failure mode:** a pointer to a `D-NNN`/`NC-NNN`/`SOP-NNN` that was never
  defined — add the entry, or fix the reference.
