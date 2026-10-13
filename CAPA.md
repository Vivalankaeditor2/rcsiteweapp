# CAPA.md

**Duty:** the nonconformity register - what broke, root cause, corrective, preventive, verified.

Corrective and Preventive Action register.

**One entry per nonconformity.** Nonconformity â†’ root cause â†’ corrective â†’
preventive â†’ verification.

**Format:**

## NC-NNN â€” short title
- **Status:** open | closed
- **Found:** YYYY-MM-DD
- **What went wrong:** the symptom observed
- **Root cause:** why it actually happened â€” not the surface error
- **Corrective action:** the fix applied
- **Preventive action:** the rule/check that stops recurrence
- **Verified:** how it was proven fixed, and when

## Register

## NC-001 â€” Hardcoded credentials committed to source
- **Status:** closed (accepted risk)
- **Found:** 2026-10-10
- **What went wrong:** real credential values are committed in
  `rcsiteweb/ROOT/Connections/OfficeConnection.jsp` and
  `rcsiteweb/ROOT/Connections/TrainingConnection.jsp`. The main
  `Connections/dbconnection.jsp` reads the username/password from `Config`, so the
  codebase is inconsistent about where credentials come from. (Values are
  deliberately not reproduced here.)
- **Root cause:** no single credential standard; the two connection files predate
  the config-driven approach and were never migrated.
- **Corrective action:** none â€” the owner chose not to rotate or change them
  (D-023). The new stack does not use these files.
- **Preventive action:** D-005 â€” the **new** stack keeps secrets out of git.
- **Verified:** 2026-10-10 â€” closed by owner decision (D-023). Residual risk
  accepted: the values remain in git history.

## NC-002 â€” `log4jconfigfilepath` points at a file that is not in the repo
- **Status:** open
- **Found:** 2026-10-10
- **What went wrong:** `ConfigServlet` configures logging from
  `Config.getValue("log4jconfigfilepath")`, but no `log4j.xml`/`log4j.properties`
  exists in the repository.
- **Root cause:** the logging config was expected on the server and never stored
  with the code; logging setup was never reproducible from the repo.
- **Corrective action:** *(pending)* D-006 â€” the backend uses
  `logback-spring.xml` committed to the repo.
- **Preventive action:** logging configuration is version-controlled with the app.
- **Verified:** *(pending)* the app starts with logging configured from the
  committed file.

## NC-003 â€” Legacy production depends on a private artifact (`rcsiteJPA`)
- **Status:** open
- **Found:** 2026-10-10
- **What went wrong:** `rcsiteweb/pom.xml` depends on
  `rcsiteJPA:0.0.1-SNAPSHOT` from a private Azure DevOps feed and on
  `com.rev_creations.persistence.*` classes for its entities (`Articles`,
  `ArticleCategory`, `GeoLocation`, `LocationArticleCategory`, `RcsiteConfig`).
  Neither is in the repo, so it cannot build standalone.
- **Root cause:** the persistence layer was split into a private module with no
  public copy and no schema documentation.
- **Corrective action:** *(pending)* D-002 â€” rebuild entities in the backend from
  the live schema (`SHOW CREATE TABLE`).
- **Preventive action:** the schema becomes the documented source of truth
  (`DATABASE.md`), and the build must not depend on private artifacts.
- **Verified:** *(pending)* backend builds and reads a row from `articles`.

## NC-004 â€” No automated tests in the legacy repo
- **Status:** open
- **Found:** 2026-10-10
- **What went wrong:** there are zero test sources (`*Test.java`) and no test
  dependency; behaviour can only be checked by hand.
- **Root cause:** testing was never set up for the legacy app.
- **Corrective action:** *(pending)* the new stack gets unit + integration tests
  (backend) and Playwright/axe E2E (frontend), plus the URL-contract regression
  suite (the most important test of all).
- **Preventive action:** each task-plan phase ends with a smoke test; the
  URL-contract suite runs in CI.
- **Verified:** *(pending)* CI runs the suites green.

## NC-005 â€” SQL injection in the legacy JSPs (and credential in the repo)
- **Status:** open
- **Found:** 2026-10-10
- **What went wrong:** login and other paths build SQL by string concatenation,
  e.g. `ROOT/user/login.jsp`:
  `SELECT ... FROM rc_customer WHERE username='<input>' AND pword='<input>'`
      with only `'` stripped. `ROOT/user/loginnew.jsp` does the same
    (`SELECT username FROM rc_customer WHERE username='" + â€¦`). Similar patterns
    appear in many `administrator/*.jsp`. **Confirmed with evidence in Phase 0**
    (`SECURITY-NOTES.md` S-2).
- **Root cause:** scriptlet-era code with no parameterised queries.
- **Corrective action:** *(pending)* the new stack uses Spring Data JPA /
  parameterised queries and Bean Validation; never concatenate user input.
- **Preventive action:** a code rule + a review check; the API-design rules
  already forbid native/concatenated queries.
- **Verified:** *(pending)* all repository queries parameterised; a security
  review sign-off.

## NC-006 â€” Passwords stored in plaintext in a 20-char column
- **Status:** open (confirmed with evidence, Phase 0)
- **Found:** 2026-10-10
- **What went wrong:** `rc_customer.pword` is `varchar(20)`. A 20-char field
  cannot hold a modern password hash (bcrypt/argon2 are ~60+ chars), so passwords
  are almost certainly stored weakly (plaintext/hash-truncated). The login query
  compares `pword` directly. **Phase 0 confirmed plaintext**: `login.jsp` compares
  the submitted password straight against the column and `memberadd.jsp` writes it
  straight from the form (`SECURITY-NOTES.md` S-1).
- **Root cause:** legacy schema and login flow predate password-hashing standards.
- **Corrective action:** *(pending)* verify how existing passwords are stored
  **before** designing the new auth; if weak, plan a migration-day rehash (needs a
  schema change â‡’ owner approval, D-004).
- **Preventive action:** new auth stores bcrypt/argon2 hashes in an
  appropriately sized column (new column, owner-approved).
- **Verified:** *(pending)* a security review of the auth flow.

## NC-007 â€” Credentials file outside the repo is not a CI/CD source of truth
- **Status:** open (accepted)
- **Found:** 2026-10-10
- **What went wrong:** the owner's live credentials are in
  `C:\allcredentials\Credentials.md` (outside this repo). That works locally but
  is not a pipeline secret store, and files on disk are easy to leak.
- **Root cause:** no secret-management standard was in place.
- **Corrective action:** *(pending, low priority)* the new stack reads secrets
  from the **WildFly datasource (JNDI)** for the DB (D-017) and env vars for the
  rest (D-005); the file stays a local convenience only.
- **Preventive action:** no secret in any tracked file; `credentials/` gitignored.
- **Verified:** *(pending)* the app starts with no secret-bearing file in the repo.

## NC-008 â€” Schema is not reproducible from the repo alone (resolved)
- **Status:** closed
- **Found:** 2026-10-10
- **What went wrong:** the repo had seed `INSERT`s but no DDL, so the schema could
  not be rebuilt from source.
- **Root cause:** the DDL lived only in the database.
- **Corrective action:** the owner supplied `rcsiteweb/db/dbschema.sql` (the full
  DDL). `DATABASE.md` now documents all 31 tables.
- **Preventive action:** the schema stays documented in `DATABASE.md`; there is\n  no migration tool - `dbschema.sql` is the single DDL source, loaded as-is (D-004).
- **Verified:** 2026-10-10 â€” all 31 `CREATE TABLE` statements catalogued and
  cross-checked against `DATABASE.md`.

## NC-009 -- PowerShell in-place edits corrupted record-file encoding
- **Status:** closed
- **Found:** 2026-10-12
- **What went wrong:** editing `AGENTS.md` with PowerShell string cmdlets rewrote the file with the wrong codepage: every em-dash became mojibake and a UTF-8 BOM appeared (DECISIONS.md also gained a BOM). Then `git checkout -- AGENTS.md`, used to undo that, discarded a whole uncommitted section of AGENTS.md (the local-dev and frontend-verification blocks) because it had never been committed.
- **Root cause:** (1) round-tripping a non-UTF-8 file through PowerShell Out-File/Set-Content/Add-Content, which re-encode on write; (2) using git checkout to undo a local edit while uncommitted work existed that HEAD did not have.
- **Corrective action:** restored the deleted AGENTS.md sections from the pre-checkout read; re-applied edits with the str_replace file editor and with [System.IO.File] UTF-8 (no-BOM) byte-level writes; stripped the BOM from DECISIONS.md; removed the mojibake literal from this file; and corrected an overstated claim (page = 0 is valid; the guard is page >= 0 and size 1-100).
- **Preventive action:** for existing files prefer the str_replace file editor; if a scripted write is unavoidable read and write with an explicit UTF8Encoding($false) and never Out-File/Set-Content/Add-Content on a file that is not already UTF-8. Never git checkout/git restore to undo a local edit while uncommitted work exists - read it first or commit it first.
- **Verified:** 2026-10-12 -- BOM/mojibake scan of all touched record files is clean; AGENTS.md content restored; tools/check-record-kit.ps1 -> PASS.
