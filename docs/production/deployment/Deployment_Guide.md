> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Deployment Guide

## ☁️ Target Environment

The production backend will be deployed to a modern cloud provider (e.g., DigitalOcean, AWS, or Google Cloud) using a managed Kubernetes cluster or a simpler PaaS like Render or Railway. 

For the purposes of this portfolio project, a Virtual Private Server (VPS) via DigitalOcean Droplet running Docker Compose is sufficient.

## 🚀 CI/CD Pipeline (GitHub Actions)

A robust CI/CD pipeline ensures code quality before merging and automates the deployment process.

### Workflow: `ci.yml` (On Pull Request)

1. **Linting**: Runs `ruff check` and `ruff format`.
2. **Type Checking**: Runs `mypy`.
3. **Unit Tests**: Spins up a temporary PostgreSQL service container and runs `pytest`.

### Workflow: `deploy.yml` (On Merge to `main`)

1. **Build Image**: Builds the Docker image for the FastAPI app.
2. **Push Image**: Pushes the image to a container registry (e.g., GitHub Container Registry, Docker Hub).
3. **Deploy**: SSH into the production server, pull the latest image, and restart the `docker-compose` stack.

## 🔒 Environment Variables

Production secrets must never be committed to the repository. They are stored in GitHub Secrets and injected into the `.env` file on the production server.

**Required Secrets:**
- `DATABASE_URL` (PostgreSQL connection string)
- `REDIS_URL`
- `JWT_SECRET_KEY`
- `JWT_REFRESH_SECRET_KEY`

## 🔄 Database Migrations

Migrations are applied automatically during deployment. In the `docker-compose.yml`, an `init-db` container runs `alembic upgrade head` before the FastAPI container is allowed to start.
