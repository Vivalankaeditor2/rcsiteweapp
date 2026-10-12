# local-stack

Reproducible **development** database + search for the revamp. Not for
production.

## What it starts

| Service | Image | Port | Purpose |
|---|---|---|---|
| `mariadb` | `mariadb:10.6` | 3306 | Matches the production MariaDB 10.6. Loads the frozen schema + seed config. |
| `solr` | `solr:9` | 8983 | Local Solr stand-in (production index is reused as-is, D-011). |

## Start

```powershell
# Secrets come from the environment, never from this file (D-005).
$env:MARIADB_ROOT_PASSWORD = '<local-only>'
$env:MARIADB_PASSWORD      = '<local-only>'
docker compose -f tools/local-stack/docker-compose.yml up -d
```

The `mariadb` service auto-loads `rcsiteweb/db/dbschema.sql` (31 tables) on first
boot. The seed files `db/001-016` (config INSERTs only, no personal data) are
mounted at `/seed` and can be applied with `tools/db-load.ps1`.

## Load schema + seed without Docker

If MariaDB is already installed locally:

```powershell
pwsh -File tools/db-load.ps1 -User root -Password '<local-only>'
```

## Notes

- `dbschema.sql` is **read-only** (D-014); both paths copy from it and never write.
- The schema is fixed: `ddl-auto=none`, no migrations, no engine/charset changes
  (D-004, D-008).
- The production Solr collection name is still to be confirmed; until then this
  core exists only so the backend can start locally.
