> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Docker Guide

## 🐳 Why Docker?

Docker ensures absolute consistency between the developer's laptop, the CI/CD pipeline, and the production server. It eliminates the "it works on my machine" problem.

## 📄 The Dockerfile

Our Dockerfile utilizes a multi-stage build process to keep the final image size incredibly small and secure. We use `uv` inside the container for lightning-fast dependency installation.

```dockerfile
# Stage 1: Build

FROM python:3.13-slim AS builder

# Install uv

RUN pip install uv

WORKDIR /app
COPY pyproject.toml .

# Install dependencies into a virtual environment

RUN uv venv /opt/venv
RUN uv pip install -r pyproject.toml

# Stage 2: Production

FROM python:3.13-slim

WORKDIR /app

# Copy the virtual environment from the builder

COPY --from=builder /opt/venv /opt/venv

# Ensure the virtual environment is used

ENV PATH="/opt/venv/bin:$PATH"

# Copy application code

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## 🏗 Docker Compose (Local Development)

The `docker-compose.yml` file orchestrates the entire backend infrastructure locally.

```yaml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql+asyncpg://user:password@db/lerno
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=lerno
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  celery_worker:
    build: .
    command: celery -A app.workers.worker worker --loglevel=info
    depends_on:
      - redis
      - db
```
