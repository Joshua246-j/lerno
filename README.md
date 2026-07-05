# Lerno - Kids Learning Application

## 📌 Project Overview
Lerno is a cross-platform children's learning application designed to make education engaging through gamification. It features interactive learning paths, 1v1 quiz battles, and Flame-engine powered mini-games.

## ✨ Features
- **Gamified Learning**: Earn XP, coins, and badges while completing lessons.
- **Quiz Battles**: 1v1 real-time or bot-based multiplayer quiz battles.
- **Mini-Games**: Built-in 2D games powered by the Flame engine to reinforce learning.
- **Interactive UI**: Kid-friendly, colorful, and heavily animated user interface.
- **Cross-Platform**: Built with Flutter for seamless iOS and Android support.

## 🛠 Technology Stack
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod (`flutter_riverpod`)
- **Routing**: GoRouter (`go_router`)
- **Game Engine**: Flame (`flame`)
- **Backend Services**: Python, FastAPI, PostgreSQL, Redis (Planned)
- **Local Storage**: Shared Preferences & Secure Storage

## 🏛 Architecture Summary
The project follows a **Feature-First Clean Architecture**, deeply integrated with **Riverpod** for state management. This ensures that every feature (e.g., `auth`, `games`, `profile`) is isolated, scalable, and highly maintainable. 

## 📂 Project Folder Structure
```text
lerno/
├── android/             # Android native code
├── ios/                 # iOS native code
├── assets/              # Images, sounds, and SVGs
├── docs/                # Comprehensive Project Documentation
└── lib/                 # Core Flutter source code
    ├── core/            # Global utilities, networking, and security
    ├── data/            # Data models and DTOs
    ├── features/        # Feature modules (auth, home, games, etc.)
    └── shared/          # Reusable widgets and theme configurations
```

## 🎮 Games & Battles
- **Learning Path**: Guided educational content.
- **Flame Mini-Games**: Interactive games to test knowledge dynamically.
- **1v1 Quiz Battles**: Competitive learning through ranked and casual quiz matchmaking.

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK (>= 3.2.0)
- Dart SDK
- Android Studio / Xcode

### Setup
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. The backend is completely decoupled. Refer to `docs/03_Backend/Environment_Setup.md` for backend setup instructions.

### Build Commands
- **Clean Build**: `flutter clean && flutter pub get`
- **Debug APK**: `flutter build apk --debug`
- **Release APK**: `flutter build apk --release`

### Run Commands
- **Run App**: `flutter run`

## 📖 Documentation Index
- [Documentation Index](docs/README.md)
- [CHANGELOG](CHANGELOG.md)
