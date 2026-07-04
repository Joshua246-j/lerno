# 04 - Project Structure

The project utilizes a strict feature-first organization within the `lib/` directory.

## 📂 Complete Folder Tree

```text
lib/
├── core/                       # Foundation and global utilities
│   ├── audio/                  # Background music and SFX managers
│   ├── local_storage/          # Hive database setup
│   ├── mock/                   # Mock data generators for offline dev
│   ├── network/                # HTTP client, interceptors, error handling
│   ├── presentation/           # Base screens and common scaffold widgets
│   ├── providers/              # Global Riverpod providers
│   ├── routing/                # GoRouter configuration and route definitions
│   ├── security/               # Secure storage, cryptography utils
│   ├── services/               # Shared background services
│   ├── theme/                  # Colors, typography, spacing, and ThemeData
│   └── widgets/                # Highly reusable global widgets
│
├── data/                       # Global Data Transfer Objects (DTOs) and models
│
├── features/                   # Feature-specific logic and UI
│   ├── auth/                   # Authentication (Login, Register, OTP)
│   ├── chat/                   # In-app messaging and chat repo
│   ├── games/                  # Standalone and Flame mini-games
│   │   ├── chess/              # Chess Puzzles
│   │   ├── math_arena/         # Math Arena game
│   │   ├── math_fun_drive/     # Math Fun Drive game
│   │   ├── memory_match/       # Memory Match game
│   │   ├── pattern_match/      # Pattern Match game
│   │   ├── quiz_battle/        # 1v1 Quiz Battles
│   │   └── word_hunt/          # Word Hunt game
│   ├── gamification/           # XP, Leveling, Leagues, and Streaks
│   ├── home/                   # Main dashboard and navigation wrapper
│   ├── learning_path/          # Courses, subjects, lessons, and topic quizzes
│   ├── profile/                # User profile, statistics, settings
│   ├── rewards/                # Daily missions and daily login rewards
│   ├── social/                 # Friends list, inbox, and leaderboards
│   └── store/                  # Avatar shop, stickers, and inventory
│
└── shared/                     # Feature-agnostic shared helpers
```

## 🧩 Feature Anatomy
Each directory inside `lib/features/` generally adheres to the following internal structure:

```text
features/{feature_name}/
├── data/
│   ├── datasources/            # Remote API calls / Local DB queries
│   └── repositories/           # Repository implementations mapping to domain
├── domain/
│   ├── entities/               # Core business objects
│   └── repositories/           # Abstract repository interfaces
└── presentation/
    ├── controllers/            # Riverpod Notifiers bridging UI and Domain
    ├── screens/                # Full-page Flutter widgets
    └── widgets/                # UI components specific to this feature
```

## 📋 Responsibilities
- **`lib/core/`**: Should contain absolutely NO feature-specific code. If a widget or service is only used by the Auth feature, it belongs in `features/auth`, not `core`.
- **`lib/features/`**: Code here should be isolated. Features should ideally communicate with other features via abstract interfaces or global providers, avoiding direct tight-coupling.
