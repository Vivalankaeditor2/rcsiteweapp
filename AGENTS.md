# AGENTS.md

**Duty:** the rules and the doorway - how to behave here; read first, every session.

Guidance for anyone â€” human or AI â€” working in this repo. Read this first,
every session.

## What this project is

A revamp of the VivaLanka.com Sri Lankan community-news website ("Raveendra
Creations"). The legacy app (`rcsiteweb`) is a Java 1.8 Maven web application
(JSP + servlets, Hibernate/JPA, MySQL/MariaDB) with news, community, events,
charities and sports sections, an AI article generator, YouTube video feeds,
Solr search and SMTP mail. It is being replaced with a **Next.js (React)**
frontend and a **Spring Boot** backend, running against the **existing
database**, with every public URL preserved exactly (see D-003).

## Project type

**Type:** `Software Development`

Building: a Next.js + Spring Boot revamp of the VivaLanka community-news site
and its supporting database, content feeds and admin tools.

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

## Hard rules for this project

These are safety rails. Do not break them, even if asked to "just try".
See `DECISIONS.md` D-003 to D-014.

- **URL contract is frozen (D-003, D-013).** Never change an existing URI pattern,
  and never turn a 200 into a redirect. Google has indexed millions of pages. Every
  URL in the contract in `TASK-PLAN.md` must keep resolving at the same path. The
  sample is `/newspage/12272011ai-court-rejects-shiranthi-s-bail-application`.
  Full procedure: `SKILLS.md` SOP-001.
- **Schema is frozen (D-004, D-008).** Do not change the database. Do not convert
  MyISAMâ†’InnoDB, do not migrate charsets, do not add keys. A change is a new
  migration. There is no migration tool; `rcsiteweb/db/dbschema.sql` is the single
  DDL source, loaded as-is - do not write it (D-014).
  Full procedure: `SKILLS.md` SOP-003.
- **Secrets stay out of git (D-005).** Repo secrets live in `credentials/`
  (gitignored) or are injected as env vars. The owner's live credentials are at
  `C:\allcredentials\Credentials.md` â€” **outside** this repo; never copy values in.
- **Never reference `article_category_has_articles` (D-019).** The news app must not touch that table. Full procedure: `SKILLS.md` SOP-002.
- **No AI, no commerce (D-009, D-010).** Do not port `AIArticleGenerator` or the
  `rccommerce` storefront.
- **`.env` and credential files are load-only.** Never read *and print* a secret
  value; never modify `.env`/credential files' tracked templates without asking.
- **`rcsiteweb/` is read-only.** Treat the legacy app as the behavioural reference.
- **Backend shape is fixed (D-007):** Spring Boot 3 on **Java 17**, deployed to
  **WildFly 27**; frontend Next.js on **IIS**.

## The record system â€” one journal, many views

**PROGRESS.md is the single source of truth.** Everything else is a view of it.

### Milestone gates

| Gate | When it fires |
|---|---|
| **M0 â€” Session open** | Read PROGRESS.md, confirm state. |
| **M1 â€” Plan** | A phase or task is added or re-scoped. |
| **M2 â€” Deliverable** | A file or feature is finished and verified. |
| **M3 â€” Defect** | Something broke, or a record was wrong. |
| **M4 â€” Reusable process** | Done twice, or worth repeating reliably. |
| **M5 â€” Commit** | Anything is committed or handed over. |
| **M6 â€” Session close** | End of session. Always write the close entry. |

### The record step (at every gate)

1. **PROGRESS.md** â€” append a dated entry. Always.
2. **TASK-PLAN.md** â€” move status. Only if plan changed.
3. **CODE-FIX-PLAN.md** â€” open/close a code item. Only if code affected.
4. **BUILD-SPEC.md** â€” move a status marker. Only if built work moved.
5. **CAPA.md** â€” open/close a nonconformity. Only if M3 fired.
6. **SKILLS.md** â€” add/update an SOP. Only if M4 fired.
7. **DECISIONS.md** â€” lock a choice. Only when one is made.
8. **DATABASE.md** â€” update the dictionary. Only if the schema changed.
9. **README.md** â€” update run steps, layout or dependencies. Only if those changed.
10. **AGENTS.md** â€” add a rule. Only if a durable new rule was learned.

**The routing check.** Every PROGRESS.md entry carries a `**Views:**` field
naming the record files the gate touched â€” or `none`. No entry is complete
until every record file is either updated or explicitly ruled out. A stale view
is a defect, not a shortcut.

### Entry format

    ### [M2] YYYY-MM-DD â€” short title
    - **Gate:** M2 Deliverable
    - **Area:** frontend / db / api â€¦
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

- `AGENTS.md`, `PROGRESS.md`, `DECISIONS.md`, `TASK-PLAN.md`, `CODE-FIX-PLAN.md`,
  `DATABASE.md`, `CAPA.md`, `SKILLS.md`, `README.md`, `BUILD-SPEC.md` â€” the record
  system; `BUILD-SPEC.md` is the build blueprint.
- `ARTICLES-HANDLING.md` â€” MyISAM rules, URL rule options, SEO strategy.
- `URL-INVENTORY.md` â€” the live-captured URL contract and its findings (Phase 0).
- `SECURITY-NOTES.md` â€” the legacy security audit (Phase 0).
- `frontend/` â€” the Next.js (React) app.
  - `frontend/public/robots.txt` â€” production-faithful (D-020). Sitemaps are
    generated by the backend at `/sitemapindex.xml` â†’ `/sitemap_{n}.xml` (D-025),
    not static files.
- `backend/` â€” the Spring Boot WAR.
  - `backend/pom.xml` - WAR build: Spring Boot 3, Java 17, WildFly 27 (D-017).
  - `backend/src/main/java/com/rev_creations/rcsite/` - `entity/`, `repository/`,
    `dto/`, `mapper/`, `service/`, `web/`, `config/`, `exception/`.
  - `backend/src/main/resources/application.properties` + `application-wildfly.properties`.
  - `backend/src/test/java/.../architecture/ForbiddenTableUsageTest.java` â€”
    guard that the news app never references the forbidden table (D-019).
- `tools/check-forbidden-tables.ps1` â€” the same guard for CI/legacy trees.
- `tools/check-record-kit.ps1` - checks the record set against the kit (SOP-004).
- `tools/url-contract.ps1` + `tools/url-inventory/url-contract.json` â€” the frozen
  URL contract and its regression harness (see `URL-INVENTORY.md`).
- `tools/capture-sitemap.ps1`, `tools/local-stack/`, `tools/wildfly/`,
  `tools/db-load.ps1` â€” Phase 0 local-stack and capture tooling.
- `credentials/` â€” local secrets, **gitignored**; only `README.md`, `.gitignore`
  and `*.example` are tracked.
- `claude/` â€” project-level assistant rules. Note: `project-level-claude.md`
  describes an unrelated "ecommerce-api" and is **not authoritative** for this
  project; the API-design and testing rules may be adopted where they fit.
- `rcsiteweb/` â€” the legacy app, kept **read-only** as the behavioural reference.
  - `rcsiteweb/pom.xml` â€” Maven build file.
  - `rcsiteweb/src/` â€” Java sources (`com.rev_creations.*`, `com.maxmind.geoip`).
  - `rcsiteweb/ROOT/` â€” web root (JSP, CSS, fonts, `WEB-INF`).
  - `rcsiteweb/db/dbschema.sql` â€” the **full DDL** (31 tables), owner-provided and
    read-only (D-014). This is the schema source of truth.
  - `rcsiteweb/db/001â€“016_*.sql` â€” numbered **seed** files (`INSERT` only).
  - `rcsiteweb/bin/` â€” generated/working copy of selected web files.
- `zenodo/` â€” the record-system kit (`interns_secret_general.md`).
## Local dev environment (verified 2026-10-12)
- **JDK 17:** ``C:\Program Files\Java\jdk-17`` (17.0.12). **Maven:** ``C:\Program Files\Apache Software Foundation\apache-maven-3.9.9``. Both are on the machine PATH but **not** in a fresh shell - export ``JAVA_HOME``/prepend ``bin`` before building.
- **DB:** MariaDB 10.6.16 service on ``127.0.0.1:3306``; database ``vivalanka``. **Local credentials live in ``C:\allcredentials\Credentials.md``** (outside the repo) as ``user ΓÇª`` / ``password ΓÇª`` lines. Do not copy values into the repo (D-005).
- **Load the schema:** ``tools\db-load.ps1 -User <u> -Password <p> -MysqlExe 'C:\Program Files\MariaDB 10.6\bin\mysql.exe' -SchemaFile <repo>\rcsiteweb\db\dbschema.sql -SeedDir <repo>\rcsiteweb\db`` (the script's ``$PSScriptRoot`` default is empty when run via ``&``, so pass the paths).
- **Backend run (dev, embedded Tomcat):** ``DB_URL=jdbc:mariadb://localhost:3306/vivalanka DB_USER=root DB_PASSWORD=ΓÇª mvn spring-boot:run``.
- **Backend deploy (WildFly 27 at ``C:\rev-crea\wildfly-27.0.0.Final``):** start ``standalone.bat`` with ``SPRING_PROFILES_ACTIVE=wildfly``; copy ``backend\target\rcsite-backend.war`` into ``standalone\deployments\``. Context root is ``/`` (``jboss-web.xml``); datasource JNDI ``java:/jdbc/rcsite``.
- **Caveat:** the seeds (``rcsiteweb/db/001-016``) contain **config/feed rows only** - no ``articles`` and no categories, so list endpoints are empty until real data is loaded.
