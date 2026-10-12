# WildFly 27 setup for the backend (D-017)

The backend is a Spring Boot **WAR** deployed to WildFly 27.0.0.Final and takes
its database connection from a **WildFly-managed datasource via JNDI**. There is
no application-managed pool.

## 1. Install the MariaDB JDBC driver as a module

```powershell
$WF = 'C:\wildfly-27.0.0.Final'
$ver = '3.3.3'   # must match backend/pom.xml
$dest = "$WF\modules\org\mariadb\jdbc\main"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Invoke-WebRequest "https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/$ver/mariadb-java-client-$ver.jar" -OutFile "$dest\mariadb-java-client-$ver.jar"
Copy-Item tools\wildfly\modules\org\mariadb\jdbc\main\module.xml $dest\module.xml
```

## 2. Add the datasource (CLI)

```powershell
$WF = 'C:\wildfly-27.0.0.Final'
& "$WF\bin\jboss-cli.ps1" --file=tools/wildfly/standalone-datasource.cli
```

Credentials are passed as CLI variables — never committed (D-005). Set them in
the shell first, or edit a local copy of the `.cli` file that is **not** tracked.

## 3. Deploy

```powershell
Copy-Item backend\target\rcsite-backend.war "$WF\standalone\deployments\"
```

The WAR binds to JNDI `java:/jdbc/rcsite` (see `standalone-datasource.cli`) and is
published under the context root `/` (see `backend/src/main/webapp/WEB-INF/jboss-web.xml`),
because the legacy URLs live at the domain root (`/newspage/...`, D-016).

## Open items

- **JNDI name** — `java:/jdbc/rcsite` is the working default; confirm before
  deployment and keep it in sync with `backend/src/main/resources/application.properties`.
- **Solr** — the production collection name is still to be confirmed (D-011).
