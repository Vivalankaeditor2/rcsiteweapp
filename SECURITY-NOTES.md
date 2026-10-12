# SECURITY-NOTES.md

**Duty:** the legacy security audit - findings and their status.

Phase 0 security audit of the legacy `rcsiteweb` app. Read-only review; no legacy
code was changed (it stays as the behavioural reference).

> Values are never reproduced here. Where a literal exists it is shown as `***`.

## Findings

### S-1 â€” ðŸ”´ Passwords are stored in plaintext (critical)
`ROOT/user/login.jsp` builds its query as:

```java
"SELECT username, customer, pword, consultant FROM rc_customer WHERE username='" +
    MM_valUsername.replaceAll("'", " ") + "' AND pword='" + <submitted password> + "'"
```

The submitted password is compared **directly against the column** and
`rc_customer.pword` is `varchar(20)`. That only works if the stored value is the
**plaintext** password (no MD5/BCrypt anywhere in the auth path). `memberadd.jsp`
likewise writes `pword` straight from the form.

- Impact: any DB read (backup, log, the SQL-injection vector below) exposes every
  user's real password.
- CAPA: **NC-006** (escalated from "verify" to **confirmed**).
- For the new stack (D-022): cannot "port" this. Options â€” migrate to a proper
  hash on first login (needs a schema-compatible column), or add a new hash
  column; both need owner approval because the schema is frozen (D-004).

### S-2 â€” ðŸ”´ SQL injection in the auth path (high)
`login.jsp` concatenates the username into SQL and only mitigates by replacing
`'` with a space (`.replaceAll("'", " ")`) â€” not a real defence. `loginnew.jsp`
(`MM_dupKeySQL`) builds `SELECT username FROM rc_customer WHERE username='"+â€¦`
the same way, using `treatStringParam` (a simple sanitiser).

- CAPA: **NC-005** (confirmed with evidence).
- New stack: all queries parameterised (Phase 1 requirement).

### S-3 â€” Hardcoded JDBC URLs and credentials (high)
Real credential variables are committed in:
`ROOT/Connections/OfficeConnection.jsp`, `ROOT/Connections/TrainingConnection.jsp`
(two different databases) and `RevCrea.jsp`; `Connections/dbconnection.jsp` reads
the user/password from config but still hardcodes `jdbc:mysql://localhost/`.

- CAPA: **NC-001** â€” owner accepted the risk, no rotation (D-023). The new stack
  does not use these files.

### S-4 â€” End-of-life Java (high)
`rcsiteweb/pom.xml` compiles `source/target 1.8` (Java 8, long out of support).
The revamp targets **Java 17** (D-007).

### S-5 â€” `log4j` 1.x (high)
The legacy depends on `log4j` (v1, EOL, known CVEs) and points at a config file
that is not in the repo. CAPA **NC-002**; the new stack uses SLF4J + Logback
(D-006).

### S-6 â€” `ai-java-sdk` dependency (info)
The legacy pulls an `ai-java-sdk`. The revamp drops all AI (D-010), so it is not
carried over.

### S-7 â€” Pages without an explicit charset (medium)
Four pages call `setContentType("text/html")` with no `;charset=â€¦`. This matches
the mojibake seen live (`Shiranthi Rajapaksa?Ts`). The new stack must serve
`text/html; charset=UTF-8` and encode straight apostrophes correctly.

### S-8 â€” Redirect surface (info)
72 `sendRedirect` calls exist. They are the source of the redirect behaviour
frozen in the URL contract â€” see `URL-INVENTORY.md`.

## Legacy dependency inventory

From `rcsiteweb/pom.xml`: `javax.servlet-api`, `javaee-api`, `hibernate`,
`rome`, `json`, `solr-solrj`, `log4j`, `ai-java-sdk`, `rcsiteJPA` (private) â€”
Java 8. None is carried over as-is; the new stack uses Spring Boot 3 / Jakarta EE
10 equivalents (D-002, D-007), Spring Data JPA, and reuse Solr (D-011).

## Status

Reproduce-only audit. Corrective work happens in the new stack, except where the
owner explicitly declined (NC-001/D-023).
