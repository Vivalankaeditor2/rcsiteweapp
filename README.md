# VivaLanka.com (rcsiteweb â†’ Next.js + Spring Boot revamp)

**Duty:** the front door - what this is, how to run it, and the external-service registry (names only).

A revamp of the VivaLanka.com Sri Lankan community-news website. The new stack is
a **Next.js (React, TypeScript)** frontend and a **Spring Boot 3 / Java 17**
backend, running against the **existing MariaDB 10.6 database** (`vivalanka`),
with every public URL preserved exactly so no search ranking is lost (D-003).

Deployment: **frontend on IIS**, **backend on WildFly 27.0.0.Final** (D-007).
Search stays on **Apache Solr** (D-011). Only `/slcommunity/` (the WordPress blog)
is out of scope (D-012). **No AI, no commerce** (D-009, D-010).

The legacy app lives in `rcsiteweb/` and is kept **read-only** as the behavioural
reference: a Java 1.8 Maven web app (JSP + servlets, Hibernate/JPA) covering
world news, community news, events, charities and sports. The full schema is in
`rcsiteweb/db/dbschema.sql`; the data dictionary is in `DATABASE.md`.

> Status: **Phase 1 (backend foundation) built** - not yet run here (no JVM).
> See `TASK-PLAN.md` phase plan and `BUILD-SPEC.md` deliverables.

## Run it

Exact commands per piece are added as each piece is built (see `TASK-PLAN.md`).

- Frontend (`frontend/`): `npm install && npm run dev` **[to be created]**
- Backend (`backend/`): `./mvnw spring-boot:run` **[to be created]**
- Local infra: `docker compose up` (DB + Solr) **[to be created]**
- Legacy (reference only, needs its private deps): build in `rcsiteweb/` with
  `mvn clean package` â€” not runnable standalone from this repo (CAPA NC-003).

## Layout

- `frontend/` â€” Next.js (React) app.
  - `frontend/public/robots.txt`, `sitemap.xml`, `sitemaps/*.xml` â€” SEO discovery.
- `backend/` â€” Spring Boot WAR (Java 17, WildFly 27).
  - `backend/pom.xml` - WAR build: Spring Boot 3, Java 17, WildFly 27 (D-017).
  - `backend/src/main/java/com/rev_creations/rcsite/` - entities, repositories,
    DTOs, MapStruct mappers, services, REST controllers (`/api/...`).
  - `backend/src/test/.../architecture/ForbiddenTableUsageTest.java` â€” forbidden-table guard.
- `tools/check-forbidden-tables.ps1` â€” same guard for CI.
- `tools/check-record-kit.ps1` - checks the record set against the kit (SOP-004).
- `credentials/` â€” local secrets, gitignored; only `*.example` templates tracked.
- `ARTICLES-HANDLING.md` â€” MyISAM rules, URL options, SEO strategy.
- `URL-INVENTORY.md` â€” the frozen, live-captured URL contract (Phase 0).
- `SECURITY-NOTES.md` â€” the legacy security audit (Phase 0).
- `tools/url-contract.ps1` â€” checks every frozen URL's status.
- `rcsiteweb/` â€” legacy app (read-only reference): `pom.xml`, `src/`, `ROOT/`,
  `db/dbschema.sql` (full DDL), `db/001â€“016` (seed), `bin/`.
- `claude/` â€” assistant rules (note: `project-level-claude.md` is an unrelated
  "ecommerce-api" and is not authoritative here).
- `zenodo/` â€” the record-system kit.
- Root `*.md` â€” the record system (see `AGENTS.md`).

## Dependencies & external services

| Name | What for | Where configured | Owner |
|------|----------|------------------|-------|
| MariaDB 10.6 database `vivalanka` | application data (schema frozen) | legacy JNDI `jdbc/rcsite`; new backend reads `DB_*` env vars | site owner |
| Apache Solr | site search `/rcsearch/*` | legacy `search.*` config; new backend `SEARCH_*` env vars | site owner |
| YouTube feeds (VivaLanka playlists) | video content | `feed_channel` rows in `rcsiteweb/db/014-016` | â€” |
| SMTP mail server | outbound email | legacy `emailhost`/`emailport`; new backend `SMTP_*` env vars | site owner |
| MaxMind GeoIP | visitor location lookup | `rcsiteweb/src/com/maxmind/geoip/`; `geo_*` tables | â€” |
| IIS + WildFly 27 host | app hosting | owner-managed (D-007) | site owner |
| Existing CI/CD pipeline | build & deploy + secret store | owner-managed (not in this repo) | site owner |

Dropped from the new stack: AI article generation (D-010) and the commerce
storefront (D-009).

**Rule: this table holds names and locations â€” never secrets or passwords.**
Real values live in `credentials/` (gitignored) or the owner's
`C:\allcredentials\Credentials.md` (outside the repo), and are injected as env
vars at run time.
