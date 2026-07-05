> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# CI/CD & Deployment Pipeline

## 🔄 Continuous Integration (CI)

All code merged into the `main` branch must pass strict automated checks. We utilize **GitHub Actions** for our CI pipelines.

### Frontend Pipeline (Flutter)

Triggered on Push and Pull Request to `main`:
1. **Format Check**: `flutter format --set-exit-if-changed .`
2. **Linting**: `flutter analyze`
3. **Unit Tests**: `flutter test`
4. **Build Check**: Attempts to build a temporary APK to ensure compilation succeeds.

### Backend Pipeline (FastAPI)

Triggered on Push and Pull Request to `main` (if changes occur in the `backend/` directory):
1. **Lint & Format**: `ruff check .` and `ruff format .`
2. **Type Checking**: `mypy app/`
3. **Integration Tests**: Spins up a temporary PostgreSQL service via Docker, runs Alembic migrations, and executes `pytest`.

## 🚀 Continuous Deployment (CD)

### Backend Deployment

When a PR is merged to `main`, the `deploy-backend.yml` action triggers:
1. Builds a new Docker image containing the FastAPI app.
2. Pushes the image to GitHub Container Registry (GHCR).
3. Connects to the production VPS via SSH.
4. Pulls the new image, runs database migrations, and restarts the Docker Compose stack seamlessly.

### Frontend Deployment (Future)

When a release tag (e.g., `v1.2.0`) is created:
1. **Android**: Builds the App Bundle (`.aab`), signs it with the Keystore, and uploads it to the Google Play Console Internal Track via Fastlane.
2. **iOS**: Builds the IPA, signs it, and uploads it to TestFlight via Fastlane (Requires macOS GitHub Action runner).
