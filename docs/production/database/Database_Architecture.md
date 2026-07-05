> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Database Architecture

## 🗄 Core Strategy

The Lerno backend utilizes **PostgreSQL** as its primary relational database. This ensures strict data integrity, robust relational mapping for complex gamification systems, and high performance.

## 🔗 Object-Relational Mapping (ORM)

We use **SQLAlchemy 2.0** with asynchronous drivers (`asyncpg`). This allows our FastAPI application to handle thousands of concurrent queries without blocking the event loop.

## 🗃 Key Domains & Tables

### 1. User & Identity

- **users**: Core identity, credentials, roles, and status.
- **profiles**: Display names, bios, linked avatars, and cosmetic customizations.

### 2. Economy & Gamification

- **inventory**: Tracks items (stickers, avatars) owned by the user.
- **achievements**: Global list of unlockable achievements.
- **user_achievements**: Mapping of users to unlocked achievements with timestamps.
- **leaderboard**: Materialized views or optimized tables tracking user rankings by league and trophies.

### 3. Education & Content

- **courses**: High-level learning subjects (e.g., Math, Science).
- **topics**: Sub-categories within courses.
- **lessons**: Individual educational modules.
- **user_progress**: Tracks completion status, stars earned, and XP gained per lesson.

### 4. Quizzes & Battles

- **quizzes**: Collections of questions linked to a topic.
- **quiz_questions**: The actual questions, options, and correct answers.
- **battles**: Records of 1v1 multiplayer matches, including participants, timestamps, and outcomes.
- **battle_rounds**: Detailed logs of question answers during a battle for analytics and replay.

### 5. Social

- **friendships**: Bidirectional or unidirectional friend links between users.
- **messages**: Chat history (though hot data may be stored in Redis/Memory first).
- **notifications**: System and social alerts for users.

## 🔄 Migrations

Database schema changes are strictly managed by **Alembic**. Developers must never manually alter the database schema.
1. Modify the SQLAlchemy models in `app/models/`.
2. Generate a migration: `alembic revision --autogenerate -m "Added inventory table"`.
3. Apply the migration: `alembic upgrade head`.
