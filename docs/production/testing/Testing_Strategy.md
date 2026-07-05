> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Testing Strategy

## 🧪 Philosophy

Automated testing is critical for maintaining confidence in the backend codebase, especially given the dynamic nature of Python. We aim for high test coverage on core business logic (Services) and API contracts (Routers).

## 🧰 Tools

- **Pytest**: The core testing framework.
- **pytest-asyncio**: For testing asynchronous FastAPI and SQLAlchemy code.
- **httpx**: For simulating HTTP requests to the FastAPI `TestClient`.

## 🏗 Test Types

### 1. Unit Tests (Services)

Unit tests isolate the business logic by mocking the database repositories. They execute in milliseconds.

```python
import pytest
from app.services.store import StoreService
from fastapi import HTTPException

@pytest.mark.asyncio
async def test_purchase_item_insufficient_funds():
    # Setup mock user with 10 coins
    mock_user_repo = MockUserRepository(coins=10)
    
    # Attempt to buy item costing 50 coins
    with pytest.raises(HTTPException) as exc:
        await StoreService.purchase_item(mock_user_repo, user_id=1, item_id="expensive_item")
        
    assert exc.value.status_code == 400
```

### 2. Integration Tests (Routers & Repositories)

Integration tests ensure that the API routing, Pydantic validation, and SQLAlchemy queries all function correctly together. These tests require a live test database.

```python
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_get_user_profile(db_session):
    # Seed test database
    seed_test_user(db_session)
    
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/api/v1/users/1")
        
    assert response.status_code == 200
    assert response.json()["data"]["display_name"] == "TestUser"
```

## 🔄 CI Integration

As outlined in the Deployment Guide, `pytest` is run on every pull request. The CI pipeline spins up a temporary PostgreSQL Docker container specifically for the integration tests to run against.
