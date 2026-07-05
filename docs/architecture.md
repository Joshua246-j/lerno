# Lerno Architecture

Lerno follows a strictly **Feature-First Architecture** combined with **Riverpod** for robust state management.

## Directory Structure
- `lib/core/`: Contains cross-cutting concerns that span the entire application (e.g., `theme/`, `routing/`, `audio/`, `assets/`, `local_storage/`).
- `lib/features/`: Contains distinct domain areas of the app (e.g., `auth`, `home`, `games`, `store`, `gamification`).
- `lib/data/`: Contains mock backend definitions (`mock_data.dart`) simulating a remote database.

## Shared Game Framework
Mini-games in Lerno are designed to be plug-and-play.
Instead of rebuilding timers and reward systems for every new game, they all consume the shared framework located at:
`lib/features/games/common/`

- **GameSessionService**: Handles wrapping up a game, communicating with the `GamificationRepository`, and playing victory/defeat sounds via `AudioManager`.
- **GameManagerScreen**: A shared UI wrapper to bootstrap games with standard lifecycles.

## Performance
- Always use `const` widgets to prevent unnecessary rebuilds.
- Isolate state updates heavily using `.select()` in Riverpod.
- Route entirely through GoRouter to maintain native stack behavior and deep-linking readiness.
