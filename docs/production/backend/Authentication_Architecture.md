> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Authentication Architecture

## 🔐 Core Philosophy

Lerno utilizes stateless, JSON Web Token (JWT) based authentication. The FastAPI backend is entirely responsible for generating, signing, and validating these tokens. We do **not** use Firebase Auth.

## 🛡 Token Types

The system uses a dual-token architecture for enhanced security:
1. **Access Token (Short-Lived)**: Valid for 15-30 minutes. Used for authorizing API requests.
2. **Refresh Token (Long-Lived)**: Valid for 7-30 days. Used to obtain new Access Tokens without requiring the user to log in again. Stored securely (HTTP-only cookie or Flutter Secure Storage).

## 🚀 Authentication Flows

### 1. Registration

- User provides Email/Password (or Phone/OTP in the future).
- Backend hashes the password using `bcrypt` (via `passlib`).
- Backend creates the `users` and `profiles` records in PostgreSQL.
- Backend returns an Access Token and a Refresh Token.

### 2. Login

- User provides credentials.
- Backend verifies the password hash.
- Backend issues a fresh Access Token and Refresh Token.

### 3. API Authorization

- The Flutter client attaches the Access Token to the `Authorization: Bearer <token>` header of every protected request.
- A FastAPI dependency (`Depends(get_current_user)`) intercepts the request.
- The dependency decodes the JWT, verifies the signature using the server's secret key, and ensures it has not expired.
- If valid, the request proceeds. If invalid/expired, it throws an `HTTP 401 Unauthorized`.

### 4. Token Refresh

- When the Flutter client receives a `401 Unauthorized`, it transparently calls the `/api/v1/auth/refresh` endpoint using the stored Refresh Token.
- The backend verifies the Refresh Token, checks against a Redis blacklist (to ensure it hasn't been revoked), and issues a new Access Token.
- The client retries the original request.

## 🚫 Revocation & Logout

Because JWTs are stateless, they cannot easily be invalidated before expiration.
- **Logout**: The Flutter client deletes the tokens locally. The backend adds the Refresh Token to a Redis Blacklist.
- **Security Breaches**: Changing a password automatically revokes all active Refresh Tokens by updating a `token_version` integer on the user record in the database.
