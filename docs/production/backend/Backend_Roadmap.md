> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Backend Roadmap

This roadmap outlines the systematic development of the Lerno backend, completely decoupled from the existing Flutter prototype.

## Phase 1: Environment & Foundation

- [ ] Initialize Python environment using `uv`.
- [ ] Install FastAPI, Uvicorn, SQLAlchemy, Alembic, Pydantic, asyncpg.
- [ ] Configure `docker-compose.yml` for local PostgreSQL and Redis.
- [ ] Implement global config (`config.py`) using Pydantic `BaseSettings`.
- [ ] Setup base Repository classes and custom Exception handlers.

## Phase 2: Database Design

- [ ] Create SQLAlchemy ORM models based on the ER Diagram (Users, Progress, Inventory, Courses, Quizzes, Battles).
- [ ] Generate initial Alembic migration scripts.
- [ ] Write a database seeder script to populate Mock Data (Courses, Lessons).

## Phase 3: Authentication & Identity

- [ ] Implement robust password hashing with `passlib`.
- [ ] Create JWT generation and validation logic (`security.py`).
- [ ] Build `/api/v1/auth/register` and `/api/v1/auth/login` endpoints.
- [ ] Implement Refresh Token flow and Redis blacklisting.

## Phase 4: Core Educational APIs

- [ ] Build `/api/v1/courses` endpoints.
- [ ] Build `/api/v1/lessons` endpoints.
- [ ] Implement progress tracking logic (awarding XP and coins securely).

## Phase 5: Economy & Gamification

- [ ] Build `/api/v1/store` endpoints for purchasing avatars and stickers.
- [ ] Implement Leaderboard calculation logic (potentially using Celery for weekly resets).

## Phase 6: Real-time Quiz Battles (Flagship Feature)

- [ ] Set up FastAPI WebSockets.
- [ ] Implement matchmaking queue using Redis.
- [ ] Build the real-time battle loop (broadcasting questions, scoring, timer synchronization).

## Phase 7: Social Features

- [ ] Build `/api/v1/friends` endpoints.
- [ ] Implement real-time WebSocket chat.

## Phase 8: Frontend Integration

- [ ] Generate client-side API models using Swagger/OpenAPI.
- [ ] Incrementally replace the `Mock*Repositories` in the Flutter client with `Api*Repositories` pointing to the new FastAPI backend.
