> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Backend Services

## ⚙️ Purpose

The `services/` layer holds the core business logic of the Lerno backend. 

- **Routers** (in `api/`) should only handle HTTP validation and response formatting.
- **Repositories** (in `repositories/`) should only handle database queries.
- **Services** (in `services/`) orchestrate everything in between.

## 🏗 Responsibilities

A Service is responsible for:
1. Enforcing business rules (e.g., checking if a user has enough coins, verifying email uniqueness).
2. Coordinating multiple repositories (e.g., deducting coins via `UserRepository` and granting an item via `InventoryRepository`).
3. Calling external APIs (e.g., sending an email, verifying a captcha).
4. Enqueueing background jobs to Celery.

## 📦 Example: Purchase Service

```python
from app.repositories.user import user_repo
from app.repositories.inventory import inventory_repo
from app.schemas.store import PurchaseRequest
from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

class StoreService:
    @staticmethod
    async def purchase_item(db: AsyncSession, user_id: UUID, request: PurchaseRequest):
        # 1. Fetch User
        user = await user_repo.get_by_id(db, user_id)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        # 2. Enforce Business Rules
        item_cost = get_item_cost(request.item_id) # Stub
        if user.coins < item_cost:
            raise HTTPException(status_code=400, detail="Insufficient coins")

        # 3. Mutate Data via Repositories
        await user_repo.deduct_coins(db, user_id, item_cost)
        await inventory_repo.add_item(db, user_id, request.item_id)

        return {"message": "Purchase successful"}
```

## 🧪 Testing

Because the business logic is isolated in Services, you can write pure Pytest unit tests that pass in Mock Repositories, ensuring that business rules are strictly tested without requiring a live PostgreSQL database.
