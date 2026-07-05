# Backend Development Checklist

Before any backend feature branch can be merged into `develop`, it must pass this strict checklist.

## Feature Checklist
- [ ] **Architecture Followed**: Is the code strictly separated into API -> Service -> Repository -> Database?
- [ ] **No Layer Bypassing**: Did you ensure that API routers contain ZERO database queries?
- [ ] **Pydantic Validation**: Are all request payloads and response models properly validated using Pydantic?
- [ ] **Migrations**: If you modified a SQLAlchemy model, did you run `alembic revision --autogenerate`?
- [ ] **Asynchronous**: Are all database queries using `await session.execute()`?
- [ ] **Tests Written**: Do you have Pytest coverage for the Service logic and the API endpoint?
- [ ] **Linting Passed**: Did `ruff check .` pass with zero errors?

## Dual Track Integrity
- [ ] **Frontend Untouched**: I have absolutely NOT modified any Dart files in the Flutter `lib/` directory during this backend feature development.
