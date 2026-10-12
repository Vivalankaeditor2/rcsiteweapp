# API Design Rules

## URL Conventions
- All endpoints: `/api/v1/{resource}`.
- Use plural nouns for resource names.
- Use lowercase kebab-case for multi-word resources (e.g. `/api/v1/user-profiles`).
- Do not use verbs in resource URLs.
- Path parameters identify a specific resource and use camelCase: `/api/v1/users/{userId}`.
- Query parameters are for filtering, sorting, searching, and pagination: `/api/v1/users?page=0&size=20&sort=createdAt,desc`.

## HTTP Methods & Success Responses
| Operation      | Verb   | Success Response                                      |
|----------------|--------|-------------------------------------------------------|
| Create         | POST   | `201 Created` with body and `Location` header         |
| Retrieve       | GET    | `200 OK`                                              |
| Full update    | PUT    | `200 OK` with updated body                            |
| Partial update | PATCH  | `200 OK` with updated body                            |
| Delete         | DELETE | `204 No Content`                                      |

- `PUT` replaces the complete resource; `PATCH` updates only the supplied fields.

## Error Responses
| Case                          | Status                     |
|-------------------------------|----------------------------|
| Validation errors             | `400 Bad Request` (list all field errors) |
| Authentication failure        | `401 Unauthorized`         |
| Authorization failure         | `403 Forbidden`            |
| Resource not found            | `404 Not Found`            |
| Duplicate resource            | `409 Conflict`             |
| Business rule violation       | `422 Unprocessable Entity` |
| Unexpected server error       | `500 Internal Server Error`|

- All errors use one consistent body structure, for example:
```json
  {
    "timestamp": "2026-01-01T10:00:00Z",
    "status": 400,
    "error": "Bad Request",
    "message": "Validation failed"
  }
```
- Never leak stack traces or internal details in error responses.

## Request & Response Rules
- Use request DTOs for incoming data and response DTOs for outgoing data. Never expose entities directly.
- Use `camelCase` for JSON properties.
- Use ISO 8601 for dates and timestamps.
- Never expose passwords, tokens, secrets, or sensitive internal data.
- Keep response structures consistent across endpoints.

## Pagination
- Collection endpoints must support pagination when results can be large.
- Use `page` (zero-based) and `size`, and define a maximum page size (e.g. 100).
- Paginated responses include content plus metadata (`page`, `size`).