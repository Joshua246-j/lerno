# Git Workflow & Branching Strategy

## Core Principles
Lerno utilizes a strict branching model to isolate the Flutter frontend prototype from the FastAPI production backend, ensuring maximum safety and rollback capabilities.

> [!IMPORTANT]
> **Never develop directly on `main`**. `main` is strictly reserved for stable production and prototype releases.

## Branch Hierarchy

1. **`main`**: The stable production/prototype branch. 
2. **`develop`**: The primary integration branch. All features merge here first.
3. **`frontend`**: Integration branch specifically for UI/MockRepository work.
4. **`backend`**: Integration branch specifically for FastAPI/Database work.

## Feature Branch Formatting

When creating a new branch to work on a feature, use the following prefixes:
- `feature/*`: New features (e.g., `feature/profile`, `feature/quiz-battle`)
- `bugfix/*`: Non-critical bug fixes (e.g., `bugfix/auth-token`)
- `hotfix/*`: Critical production fixes (e.g., `hotfix/database-crash`)
- `docs/*`: Documentation-only updates.
- `experiment/*`: Research and prototyping that may be discarded.

## The Development Flow

1. Create a branch from `develop`: `git checkout -b feature/awesome-feature`
2. Develop and test locally.
3. Push to origin: `git push origin feature/awesome-feature`
4. Open a Pull Request targeting `develop`.
5. CI/CD checks automatically run (Flutter Analyze, Pytest).
6. Merge into `develop`.
7. Once `develop` reaches a release milestone, it is merged into `main` and tagged.
