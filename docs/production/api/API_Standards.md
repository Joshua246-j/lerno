> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# API Standards

## 📐 General Principles

All endpoints exposed by the Lerno FastAPI backend must adhere to strict RESTful standards to ensure predictability and ease of integration with the Flutter client.

## 🔗 Endpoint Structure

Endpoints should be noun-based, pluralized, and strictly versioned.
- **GET** `/api/v1/users` - Retrieve a list of users.
- **GET** `/api/v1/users/{id}` - Retrieve a specific user.
- **POST** `/api/v1/users` - Create a new user.
- **PATCH** `/api/v1/users/{id}` - Update a user's profile.
- **DELETE** `/api/v1/users/{id}` - Deactivate a user.

## 📦 Request & Response Payloads

All payloads must be validated using **Pydantic** schemas. 

### Standard Success Response

```json
{
  "status": "success",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "display_name": "HeroKid99",
    "coins": 450
  }
}
```

### Standard Error Response

Errors must provide actionable information for the Flutter client.
```json
{
  "status": "error",
  "error": {
    "code": "INSUFFICIENT_FUNDS",
    "message": "You do not have enough coins to purchase this avatar.",
    "details": null
  }
}
```

## 📄 Pagination

Endpoints returning lists (e.g., leaderboards, friends, messages) must support cursor-based or offset-based pagination.
- Query Params: `?limit=20&offset=0`

```json
{
  "status": "success",
  "data": [ ... ],
  "meta": {
    "total": 150,
    "limit": 20,
    "offset": 0,
    "has_next": true
  }
}
```

## 🛡 Rate Limiting

To prevent abuse (especially on public endpoints like `/login` or `/register`), Redis-backed rate limiting must be applied via FastAPI middleware.
- Example: 5 requests per minute for login attempts.

## 📚 Documentation

FastAPI automatically generates OpenAPI documentation. Developers must ensure that all route decorators include clear summaries, descriptions, and explicit Pydantic response models.
```python
@router.get(
    "/{user_id}",
    response_model=SuccessResponse[UserProfileResponse],
    summary="Get User Profile",
    description="Retrieves public profile information for a specific user."
)
async def get_user_profile(user_id: UUID):
    ...
```
