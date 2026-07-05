> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Development Guide

## ⚙️ Setup & Installation

1. Ensure Flutter `>=3.2.0` is installed.
2. Clone the repository.
3. Run `flutter pub get`.
4. Ensure an emulator is running or a device is connected.
5. Run `flutter run`.

## 📁 Folder Conventions

Always adhere to the **Feature-First Architecture** (see `04_Project_Structure.md`).
- **NEVER** put feature-specific widgets in `lib/core/widgets/`.
- If a widget is used by exactly one feature, it belongs in that feature's `presentation/widgets/` folder.
- If a widget is used by two or more features, it should be moved to `lib/shared/` or `lib/core/widgets/`.

## 📝 Coding Standards

- **Strong Typing**: Always declare explicit return types for functions.
- **Null Safety**: Avoid using the `!` bang operator. Handle nulls gracefully using `??` or explicit `if (val == null)` checks.
- **Riverpod**: 
  - Use `ConsumerWidget` instead of `StatefulWidget` where possible.
  - Never mutate state directly outside of a Notifier.
- **Linting**: Run `flutter analyze` before committing. The project uses `flutter_lints` with strict rules.

## 🏷 Naming Conventions

- **Files/Folders**: `snake_case` (e.g., `auth_controller.dart`).
- **Classes/Enums**: `PascalCase` (e.g., `AuthController`).
- **Variables/Methods**: `camelCase` (e.g., `submitLogin()`).
- **Constants**: `SCREAMING_SNAKE_CASE` or `camelCase` prefixed with `k` (e.g., `kDefaultPadding`).

## 🔄 Git Workflow

1. Create a feature branch from `main`: `git checkout -b feature/login-screen`.
2. Commit small, logical chunks: `git commit -m "feat: add login UI"`.
3. Push and open a Pull Request against `main`.
4. PRs must pass `flutter analyze` and `flutter test` before merging.
