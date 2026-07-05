> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Backend Project Structure

## 📂 Directory Layout

The backend follows a domain-driven, feature-first structure. This mirrors the frontend's architecture, making full-stack development highly intuitive.

```text
backend/
├── app/
│   ├── api/                  # API Routers and versioning
│   │   └── v1/
│   │       ├── auth/
│   │       ├── users/
│   │       ├── courses/
│   │       ├── lessons/
│   │       ├── games/
│   │       ├── quiz/
│   │       ├── leaderboard/
│   │       ├── store/
│   │       ├── friends/
│   │       ├── chat/
│   │       ├── notifications/
│   │       └── progress/
│   ├── core/                 # App-wide settings and security
│   │   ├── config/
│   │   └── security/
│   ├── database/             # Database connection and session management
│   ├── models/               # SQLAlchemy ORM models
│   ├── schemas/              # Pydantic validation schemas (DTOs)
│   ├── repositories/         # Database access layer (CRUD)
│   ├── services/             # Business logic layer
│   ├── middleware/           # Request/Response interceptors
│   ├── utils/                # Helper functions
│   └── workers/              # Celery background tasks
├── tests/                    # Pytest test suites
├── migrations/               # Alembic database migrations
├── docs/                     # Additional backend-specific documentation
├── scripts/                  # Utility scripts (seeders, cleanup)
├── docker/                   # Dockerfiles and entrypoint scripts
├── .env.example              # Environment variables template
├── docker-compose.yml        # Multi-container orchestration
└── pyproject.toml            # Poetry/uv dependency configuration
```

## 🧩 Architectural Layers

1. **`api/` (Routers)**: Responsible strictly for receiving HTTP requests, validating input parameters via Pydantic, calling the appropriate Service, and returning an HTTP response.
2. **`services/` (Business Logic)**: The core of the application. Services execute rules (e.g., checking if a user has enough coins before a purchase) and orchestrate calls to one or more Repositories.
3. **`repositories/` (Data Access)**: The only layer allowed to communicate with SQLAlchemy and the database. It handles raw data fetching and manipulation.
4. **`models/` (Data Entities)**: SQLAlchemy representations of PostgreSQL tables.
5. **`schemas/` (Data Transfer Objects)**: Pydantic classes defining exactly what data enters the API (Requests) and leaves the API (Responses).
