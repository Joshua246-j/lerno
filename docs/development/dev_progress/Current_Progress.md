> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Current Project Progress

This document tracks the actual, real-time implementation status of the Lerno prototype. It serves as a reality check against the long-term production vision.

## 🏗 Current Phase: High-Fidelity Prototype

The project is currently a standalone Flutter application heavily reliant on mock data. It is not yet connected to a live database or remote API. The primary focus has been proving the UX, UI, and Riverpod architectural stability.

## 📊 Overall Completion: 45%

### Discipline Breakdown

- **UI/UX Progress: 90%** 
  - Design system, animations, responsive layouts, and theming are complete and highly polished.
- **Frontend Architecture: 85%** 
  - Riverpod injection, GoRouter, and Feature-First folder structures are firmly established.
- **Game Development: 65%** 
  - Flame engine wrappers are built. 1v1 Quiz UI is done. Core game loop logic needs finalizing.
- **Documentation: 100%** 
  - The project is fully documented, strictly separating prototype reality from production plans.
- **Testing Progress: 15%** 
  - Basic unit tests exist. Full widget and integration testing is pending.
- **Backend Progress: 10%** 
  - Architecture is fully designed. FastAPI boilerplate needs to be written. Mock backend currently handles all data requests.
- **Database Progress: 5%** 
  - ER Diagrams designed for future FastAPI implementation. 
  - **Local Persistence**: `hive` is installed in `pubspec.yaml` and is actively used to simulate persistence for Mock Repositories so the prototype does not lose state on restart.
  - **Legacy Dependencies**: Firebase packages (`cloud_firestore`, etc.) are still physically present in `pubspec.yaml` but are deprecated and slated for removal.
- **API Progress: 0%** 
  - Zero live endpoints exist.

## ⚠️ Known Limitations & Technical Debt

- **Legacy Package Bloat**: Firebase dependencies are still technically compiled into the app, increasing build size unnecessarily while we use Mock Repositories.
- **Fake Opponents**: The 1v1 Quiz Battles currently match you against a delayed bot. It does not use WebSockets.
- **Build Errors**: Windows developers may experience Kotlin incremental build caching bugs if the repository and the Flutter SDK are on different hard drives.

## 🎯 Next Milestones

1. **Stabilize Flame Engine**: Finalize the drag-and-drop game mechanics.
2. **Purge Firebase**: Completely remove Firebase dependencies from `pubspec.yaml` and initialization code to clean up the prototype.
3. **Initialize FastAPI**: Create the backend repository and build the base PostgreSQL schemas.
4. **Auth Swap**: Replace `MockAuthRepository` with the first live FastAPI endpoint (`/api/v1/auth/login`).
