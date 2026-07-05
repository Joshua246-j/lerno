# Backend Implementation Plan

> [!IMPORTANT]
> The backend must be developed as a completely isolated production project. Do not touch the Flutter frontend during these phases.

## Phase 1: Environment Foundation (COMPLETED)
- Scaffolding the `backend/` folder hierarchy.
- Setting up `docker-compose.yml` (Postgres, Redis).
- Initializing `uv` and dependencies (FastAPI, SQLAlchemy, Alembic).
- Configuring the async engine and Alembic migrations.

## Phase 2: Database Modeling (UP NEXT)
- Design the core PostgreSQL ER diagram schemas.
- Implement SQLAlchemy models for:
  - `User` (Authentication, Role)
  - `Profile` (Avatar, Level, XP, Bio)
  - `Leaderboard` (League rankings)
- Generate and apply Alembic migrations.

## Phase 3: Core REST APIs
- Build the Authentication router (Register, Login, JWT refresh).
- Build the User Profile router (Fetch, Update).
- Implement Pytest unit testing for these core routes.

## Phase 4: WebSocket Services
- Scaffold the `websocket/` directory.
- Build the Realtime Matchmaking router.
- Build the 1v1 Quiz Battle realtime state manager (Redis Pub/Sub).

## Phase 5: Frontend Integration
- Only after Phase 4 is thoroughly tested will we return to the Flutter codebase.
- Implement `ApiAuthRepository` to replace `MockAuthRepository`.
