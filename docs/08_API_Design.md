# 08 - API Design

## 🌐 Production REST API Overview
The planned production backend will expose a RESTful API over HTTPS. All endpoints (except public authentication routes) will require a valid JWT Bearer token supplied by Firebase Authentication.

## 🔐 Authentication Flow
1. Client requests Firebase SDK for Auth (Google/Email).
2. Client retrieves Firebase JWT ID Token.
3. Client sends `Authorization: Bearer <token>` to Lerno REST API.
4. Lerno API validates the token using Firebase Admin SDK.

## 🚦 Status Codes
- `200 OK`: Request succeeded.
- `201 Created`: Resource successfully created.
- `400 Bad Request`: Validation failure.
- `401 Unauthorized`: Missing or invalid JWT.
- `403 Forbidden`: User lacks permission.
- `404 Not Found`: Resource does not exist.
- `500 Server Error`: Backend crash.

## 📦 Core Endpoints

### 1. User & Profile
- `GET /api/v1/users/me` -> Retrieves current user profile, stats, and inventory.
- `PATCH /api/v1/users/me` -> Updates avatar, username, or settings.

### 2. Learning Path (Courses & Lessons)
- `GET /api/v1/courses` -> Lists available subjects/courses.
- `GET /api/v1/courses/{id}/lessons` -> Lists lessons inside a course.
- `POST /api/v1/lessons/{id}/complete` -> Submits a completed lesson payload, returns XP and coin rewards.

### 3. Quiz & Battle System
- `POST /api/v1/battles/queue` -> Enters the matchmaking queue.
- `DELETE /api/v1/battles/queue` -> Cancels matchmaking.
- `POST /api/v1/battles/{id}/submit-answer` -> Submits a question answer securely to the server during an active match.

### 4. Leaderboard & League
- `GET /api/v1/leaderboard/global` -> Top 100 players globally.
- `GET /api/v1/leaderboard/friends` -> Top players among friends.
- `GET /api/v1/league/current` -> Current league standing and time remaining until promotion/demotion.

## 📄 Example Request/Response
**Request:**
`POST /api/v1/lessons/uuid-123/complete`
```json
{
  "score": 95,
  "time_taken_seconds": 120
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "xp_gained": 50,
    "coins_gained": 10,
    "new_level": 5,
    "achievements_unlocked": ["speed_demon_bronze"]
  }
}
```
