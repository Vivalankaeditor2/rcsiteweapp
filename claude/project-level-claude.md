# ecommerce-api

## Stack
- Java 17
- Spring Boot 3.3.4
- Maven
- Jakarta EE	10
- WildFly	27.0.0.Final
- Tomcat	10.1
- Hibernate ORM	6.4
- MariaDB	10.6.16
- DB Engine	MyISAM
- DB Engine	InnoDB
- CharSet	utf8mb4
- Collations	utf8mb4_unicode_ci
- MySQL Connector	9.0.0
- SLF4J	2.0.16
- NextJs
- React JS	18.3.1
- Axios	1.7.7
- Tailwind	3.4.14
	


## Package Structure
Base package: `com.rev_creations.rcsite`

Sub-packages:
- `controller`
- `service`
- `repository`
- `entity`
     - `converter`
     - `enum`
- `dto`
- `adapter`
- `config`
- `batch`
- `interfaces`
- `response`

## Architecture Rules
- Always use DTOs in controllers — never expose entities directly.
-All business logic must reside in the service layer — keep controllers thin.
-All REST endpoints must be prefixed with /api/v1/.
-Use repository classes only for database access — no business logic.
-no native queries inside repository unless it is required.
-Use adapter classes for external API or third-party integrations.
-Keep configuration-related code in the config package.
-Use converter classes under entity for entity-to-model/data conversion where required.
-Use enum under entity for entity-related enumerations.
-Use response classes for standardised API response structures.
-Use interfaces where abstraction is required, with implementations kept in the appropriate package.
-Use batch for scheduled or batch-processing functionality. 


## Commands
- Run: `./mvnw spring-boot:run`
- Test: `./mvnw test`
- Compile check: `./mvnw clean compile`
