# Frontend: Current State & Dual Track Development

> [!NOTE]
> This document describes the **CURRENT** prototype implementation only. Do not mix this with production API documentation.

## The Dual Track Strategy
Lerno is currently employing a strict "Dual Track Development" strategy:
- **Track 1 (Frontend):** UI, Animations, and Game Loops are being perfected in isolation using Mock Repositories.
- **Track 2 (Backend):** The FastAPI server is being constructed in complete isolation in the `backend/` directory.

## Current Architecture
- **State Management:** Riverpod (`ConsumerWidget`, `ref.watch`).
- **Navigation:** GoRouter.
- **Data Layer:** Exclusively utilizing Mock Repositories (`MockAuthRepository`, `MockGamesRepository`).
- **Persistence:** Local Hive storage is used to prevent the prototype from losing state on restart.

## Known Limitations
- The application currently has ZERO live API connections.
- Multiplayer quiz battles are simulated against a local bot.
- All "network delays" are artificially created using `Future.delayed`.

> [!WARNING]
> **Safety Rule:** Never modify the frontend UI to accommodate backend development. The frontend must continue using Mock Repositories until the backend exposes production-ready APIs. Integration will happen strictly via the Repository layer by replacing `MockRepository` with `ApiRepository`.
