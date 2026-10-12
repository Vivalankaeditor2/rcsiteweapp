# API Design Rules
- All endpoints: `/api/`.

## HTTP Methods & Status Codes
| Operation | Verb   | Success Response                  |
|-----------|--------|-----------------------------------|
| Create    | POST   | `201 Created` with body           |
| Retrieve  | GET    | `200 OK`                          |
| Update    | PUT    | `200 OK` with updated body        |
| Delete    | DELETE | `204 No Content`                  |



## URL Structure
- All API endpoints must start with `/api/`.
- Use plural nouns for resources, for example `/api/users` and `/api/content`.
- Use lowercase URLs.
- Use path variables for resource IDs, for example `/api/users/{id}`.
- Do not put business actions in URLs unless an action endpoint is required.
- Keep URL naming consistent across the application.

## Error Responses
- Validation errors → `400 Bad Request`, listing all field errors.
- Duplicate resource → `409 Conflict`.
- Resource not found → `404 Not Found`.
- Unauthorized request → `401 Unauthorized`.
- Forbidden request → `403 Forbidden`.
- Too many requests → `429 Too Many Requests`.
- Server errors → `500 Internal Server Error`.
- Temporary service unavailability → `503 Service Unavailable`.

## Request Validation
- Validate request bodies using Bean Validation annotations.
- Use `@Valid` for request body validation.
- Return all relevant validation errors in the response.


