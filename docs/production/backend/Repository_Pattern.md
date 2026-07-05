> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Repository Pattern

## 🗃 Purpose

The Repository Pattern abstracts database logic away from the core business logic (Services). This ensures that FastAPI routes and business rules do not contain raw SQL queries or SQLAlchemy ORM operations. It mimics the architecture used in the Flutter frontend, creating full-stack consistency.

## 🏗 Implementation

### 1. Base Repository

A generic base class provides standard CRUD operations for all entities, reducing boilerplate.

```python
from typing import TypeVar, Generic
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

ModelType = TypeVar("ModelType")

class BaseRepository(Generic[ModelType]):
    def __init__(self, model: type[ModelType]):
        self.model = model

    async def get_by_id(self, db: AsyncSession, id: UUID) -> ModelType | None:
        result = await db.execute(select(self.model).filter(self.model.id == id))
        return result.scalars().first()

    async def create(self, db: AsyncSession, obj_in: dict) -> ModelType:
        db_obj = self.model(**obj_in)
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj
```

### 2. Specific Repositories

Repositories for specific models extend the base class and add domain-specific queries.

```python
from app.models.user import User
from app.repositories.base import BaseRepository
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

class UserRepository(BaseRepository[User]):
    def __init__(self):
        super().__init__(User)

    async def get_by_email(self, db: AsyncSession, email: str) -> User | None:
        result = await db.execute(select(self.model).filter(self.model.email == email))
        return result.scalars().first()

user_repo = UserRepository()
```

## 💉 Dependency Injection

Repositories are usually instantiated as singletons or injected into Services via FastAPI's `Depends`. This makes testing Services incredibly easy, as the Repository can be mocked.
