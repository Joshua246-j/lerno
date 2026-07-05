> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Backend Environment Setup

## 🛠 Prerequisites

Before developing the backend, ensure you have the following installed on your machine:
- **Python 3.13+**
- **Docker & Docker Compose** (for running PostgreSQL and Redis locally)
- **uv** (The extremely fast Python package installer and resolver)

### Installing `uv`

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
# Or on Windows (PowerShell):

# irm https://astral.sh/uv/install.ps1 | iex
```

## 🚀 Local Development Setup

1. **Navigate to the Backend Directory**
   ```bash
   cd backend
   ```

2. **Set up the Virtual Environment**
   Using `uv`, you can create a virtual environment and install dependencies instantly:
   ```bash
   uv venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   uv pip install -r pyproject.toml
   ```

3. **Configure Environment Variables**
   Copy the example environment file and fill in the necessary secrets (like JWT Secret Keys).
   ```bash
   cp .env.example .env
   ```

4. **Spin up Local Infrastructure**
   Use Docker Compose to start PostgreSQL and Redis without needing to install them on your host machine.
   ```bash
   docker-compose up -d db redis
   ```

5. **Run Database Migrations**
   Apply Alembic migrations to create the database schema.
   ```bash
   alembic upgrade head
   ```

6. **Start the FastAPI Development Server**
   ```bash
   fastapi dev app/main.py
   # Or using uvicorn directly:
   # uvicorn app.main:app --reload
   ```

7. **Access the API Documentation**
   Open your browser and navigate to:
   - **Swagger UI**: `http://localhost:8000/docs`
   - **ReDoc**: `http://localhost:8000/redoc`

## 🧹 Code Quality Tools

The backend utilizes strict linting and formatting tools.
- **Ruff**: Extremely fast Python linter and formatter.
- **MyPy**: Static type checker.

Run these before committing code:
```bash
ruff check .
ruff format .
mypy app/
```
