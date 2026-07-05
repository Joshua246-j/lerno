# Lerno Production Backend

This is the fully isolated, production-grade backend for Lerno, built with FastAPI, PostgreSQL, and Redis.
It acts as the single source of truth for the future Flutter application APIs.

## 🛠 Prerequisites
- [uv](https://docs.astral.sh/uv/) (Python 3.13+)
- [Docker](https://docs.docker.com/get-docker/)

## 🚀 Environment Setup

### 1. Start Supporting Services
Start the PostgreSQL and Redis containers:
```bash
docker-compose up -d
```

### 2. Configure Environment Variables
Copy the example environment file:
```bash
cp .env.example .env
```
*(Update `.env` if your local postgres credentials differ from the defaults)*

### 3. Install Dependencies
Use `uv` to create the virtual environment and sync dependencies blazingly fast:
```bash
uv sync
```

### 4. Run Migrations
Initialize your database schema:
```bash
uv run alembic upgrade head
```

### 5. Start the Server
Start the development server with hot-reloading:
```bash
uv run uvicorn app.main:app --reload
```
The API documentation will be instantly available at: [http://localhost:8000/docs](http://localhost:8000/docs)
