# CHANGELOG

All notable changes to this project will be documented in this file.

## [Unreleased] - Late Alpha Milestone

### Added
- Comprehensive Markdown documentation in the `docs/` folder (24 files detailing architecture, API, DB, and UI).
- Implemented `flutter_riverpod` state management architecture.
- Implemented `go_router` for robust tab-based and nested navigation.
- Created Feature-First directory structure.
- Developed UI Design System using `google_fonts` and `flutter_animate`.
- Integrated `flame` game engine scaffolding for educational mini-games.
- Added 1v1 Quiz Battle UI layouts.
- Overhauled `GameManagerScreen` with `flutter_animate` for professional Game UI wrappers (intro, blurred pause menu, animated score/XP trackers).
- Overhauled `QuizBattleScreen` and `MathArenaScreen` with animations, glowing radar matchmaking, and particle effects.
- Added `ComingSoonScreen` fallback for unimplemented activities using `go_router` errorBuilder.
- Configured `/games` route and wired up Home Screen Hero Banners and Grid Activity links for a seamless, error-free navigation flow.

### Changed
- Fixed Kotlin and Java JVM target incompatibilities across third-party Android plugins by forcing `JavaVersion.VERSION_17` uniformly.
- Transitioned initial hardcoded data into a scalable Mock Repository pattern to prepare for Firebase integration.

### Fixed
- Addressed Android build compilation failures caused by older AGP plugins defaulting to Java 1.8 while the app targets Java 17.

### Security
- Scaffolded secure storage (`flutter_secure_storage`) for upcoming JWT token integration.
