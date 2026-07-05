# Conventional Commit Standards

Lerno enforces the [Conventional Commits](https://www.conventionalcommits.org/) specification for all git commits. This creates a highly readable history and allows for automated changelog generation.

## Format
```
<type>(<scope>): <subject>

[optional body]
```

## Allowed Types

- **`feat:`** A new feature (e.g., `feat(profile): add avatar inventory`)
- **`fix:`** A bug fix (e.g., `fix(auth): resolve session persistence`)
- **`docs:`** Documentation only changes (e.g., `docs(backend): update API documentation`)
- **`style:`** Changes that do not affect the meaning of the code (white-space, formatting, etc)
- **`refactor:`** A code change that neither fixes a bug nor adds a feature
- **`perf:`** A code change that improves performance
- **`test:`** Adding missing tests or correcting existing tests
- **`chore:`** Changes to the build process or auxiliary tools and libraries (e.g., `chore: update dependencies`)

## Best Practices
- The `<subject>` must be written in the imperative mood ("change", not "changed" or "changes").
- Do not capitalize the first letter of the subject.
- Do not end the subject line with a period.
- Use the `<scope>` to define what part of the app is affected (e.g., `frontend`, `backend`, `auth`, `games`).
