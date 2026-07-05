# Backup & Release Strategy

## Backup Milestones
To prevent catastrophic loss of progress, explicit backup commits or tags MUST be created before executing any of the following high-risk operations:

- Major architectural refactoring.
- Dependency upgrades (e.g., upgrading Flutter SDK, FastAPI, or SQLAlchemy).
- Backend database migrations (Alembic upgrades/downgrades).
- Stripping out MockRepositories to replace them with ApiRepositories.

> [!CAUTION]
> **Never perform risky work without a recovery point.** Ensure your branch is pushed to origin before executing destructive commands.

## Release Tagging Strategy

We utilize Semantic Versioning via Git Tags.

### Prototype Phase (Current)
Releases are marked `v0.x.x` to denote the application is running in Mock mode.
- `v0.1.0`: Initial UI scaffold.
- `v0.2.0`: Feature complete (Mock Repositories).
- `v0.3.0`: UI/UX Polish complete.

### Production Phase (Future)
Releases jump to `v1.x.x` once the FastAPI backend is integrated and deployed.
- `v1.0.0`: First stable commercial release.
- `v1.1.0`: Minor feature additions.
- `v1.1.1`: Patch bugfix.

To tag a release:
```bash
git tag v0.2.0
git push origin v0.2.0
```
