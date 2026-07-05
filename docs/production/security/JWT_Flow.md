> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# JWT Authentication Flow

This sequence diagram illustrates the stateless JWT flow between the Flutter Client, the FastAPI Backend, and the PostgreSQL database.

```mermaid
sequenceDiagram
    participant Flutter as Flutter Client
    participant FastAPI as FastAPI Backend
    participant DB as PostgreSQL DB
    participant Redis as Redis Cache

    %% Login Flow
    Note over Flutter, DB: 1. Login Phase
    Flutter->>FastAPI: POST /auth/login (email, password)
    FastAPI->>DB: Fetch user & hashed password
    DB-->>FastAPI: User record
    FastAPI->>FastAPI: Verify bcrypt hash
    FastAPI->>FastAPI: Generate Access Token (15m)
    FastAPI->>FastAPI: Generate Refresh Token (7d)
    FastAPI-->>Flutter: Return 200 OK (Tokens)
    Flutter->>Flutter: Store securely (SecureStorage)

    %% Standard API Request
    Note over Flutter, DB: 2. Protected Request (Valid Token)
    Flutter->>FastAPI: GET /users/me (Header: Bearer AccessToken)
    FastAPI->>FastAPI: Validate JWT Signature & Expiry
    FastAPI->>DB: Fetch profile data
    DB-->>FastAPI: Profile record
    FastAPI-->>Flutter: Return 200 OK (Profile Data)

    %% Token Expiry & Refresh
    Note over Flutter, DB: 3. Token Expiry & Refresh
    Flutter->>FastAPI: GET /users/me (Header: Bearer ExpiredAccessToken)
    FastAPI->>FastAPI: Validate JWT (Fails - Expired)
    FastAPI-->>Flutter: Return 401 Unauthorized
    
    Flutter->>FastAPI: POST /auth/refresh (Body: RefreshToken)
    FastAPI->>Redis: Check if RefreshToken is blacklisted
    Redis-->>FastAPI: Not blacklisted
    FastAPI->>FastAPI: Validate Refresh Token Signature
    FastAPI->>FastAPI: Generate NEW Access Token
    FastAPI-->>Flutter: Return 200 OK (New AccessToken)
    
    Flutter->>Flutter: Update stored AccessToken
    Flutter->>FastAPI: GET /users/me (Header: Bearer NEW_AccessToken)
    FastAPI-->>Flutter: Return 200 OK (Profile Data)
```
