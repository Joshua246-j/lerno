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
- **Backend Services**: Firebase (Auth, Firestore, Realtime Database)
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
3. Configure Firebase (Add `google-services.json` and `GoogleService-Info.plist`).

### Build Commands
- **Clean Build**: `flutter clean && flutter pub get`
- **Debug APK**: `flutter build apk --debug`
- **Release APK**: `flutter build apk --release`

### Run Commands
- **Run App**: `flutter run`

## 📖 Documentation Index
For detailed technical implementation and architecture guidelines, refer to the following documents:
- [01_Project_Overview](docs/01_Project_Overview.md)
- [02_Project_Architecture](docs/02_Project_Architecture.md)
- [03_Tech_Stack](docs/03_Tech_Stack.md)
- [04_Project_Structure](docs/04_Project_Structure.md)
- [05_Frontend_Architecture](docs/05_Frontend_Architecture.md)
- [06_Backend_Architecture](docs/06_Backend_Architecture.md)
- [07_Database_Design](docs/07_Database_Design.md)
- [08_API_Design](docs/08_API_Design.md)
- [09_Authentication_System](docs/09_Authentication_System.md)
- [10_Navigation_Flow](docs/10_Navigation_Flow.md)
- [11_UI_Design_System](docs/11_UI_Design_System.md)
- [12_Game_System](docs/12_Game_System.md)
- [13_Quiz_Battle_System](docs/13_Quiz_Battle_System.md)
- [14_Gamification_System](docs/14_Gamification_System.md)
- [15_Profile_System](docs/15_Profile_System.md)
- [16_Offline_Architecture](docs/16_Offline_Architecture.md)
- [17_Mock_Backend_System](docs/17_Mock_Backend_System.md)
- [18_Performance_Optimization](docs/18_Performance_Optimization.md)
- [19_Security](docs/19_Security.md)
- [20_Development_Guide](docs/20_Development_Guide.md)
- [21_Build_Deployment](docs/21_Build_Deployment.md)
- [22_Project_Status](docs/22_Project_Status.md)
- [CHANGELOG](CHANGELOG.md)
