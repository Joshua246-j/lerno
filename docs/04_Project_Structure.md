# 04 - Project Structure

The project utilizes a strict feature-first organization within the `lib/` directory.

## 📂 Complete Folder Tree

```text
lib/
├── core/                       # Foundation and global utilities
│   ├── audio/                  # Background music and SFX managers
│   ├── mock/                   # Mock data generators for offline dev
│   ├── network/                # Dio HTTP client, interceptors, error handling
│   ├── presentation/           # Base screens and common scaffold widgets
│   ├── providers/              # Global Riverpod providers (e.g., global logger)
│   ├── routing/                # GoRouter configuration and route definitions
│   ├── security/               # Secure storage, cryptography utils
│   ├── services/               # Shared background services
│   ├── theme/                  # Colors, typography, spacing, and ThemeData
│   └── widgets/                # Highly reusable global widgets (buttons, dialogs)
│
├── data/                       # Global Data Transfer Objects (DTOs) and models
│
├── features/                   # Feature-specific logic and UI
│   ├── auth/                   # Authentication (Login, Register, OTP)
│   ├── chat/                   # In-app messaging and friends list
│   ├── games/                  # Flame engine mini-games
│   ├── gamification/           # XP, Leveling, and Badge calculations
│   ├── home/                   # Main dashboard and navigation wrapper
│   ├── learning_path/          # Core educational content and subject trees
│   ├── profile/                # User profile, statistics, settings
│   ├── rewards/                # Daily missions and daily login rewards
│   ├── social/                 # Leaderboards and leagues
│   └── store/                  # Virtual economy and inventory
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
