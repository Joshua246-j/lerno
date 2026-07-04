# 03 - Technology Stack

## 🛠 Core Frameworks & Languages
| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | `>=3.2.0` | Cross-platform UI toolkit and framework. |
| **Dart** | `>=3.2.0` | Primary programming language. |
| **Java** | `17` | Required for Android build compatibility. |
| **Kotlin** | `17 (JVM)` | Required for Android build compatibility. |
| **Gradle** | `9.1.0` | Android build system. |
| **Android SDK** | `Min SDK 23 / Target SDK 34` | Android OS compatibility. |

## 🏗 State Management & Architecture
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | `^2.4.9` | Core state management. Handles reactivity, dependency injection, and async states. |
| `go_router` | `^12.1.1` | Declarative routing system. Handles deep linking, protected routes, and tab navigation. |

## 🎨 UI, Animation & Assets
| Package | Version | Purpose |
|---------|---------|---------|
| `google_fonts` | `^6.1.0` | Dynamic loading of custom fonts without bloating app size. |
| `flutter_svg` | `^2.3.0` | Renders scalable vector graphics for crisp, high-res icons and imagery. |
| `flutter_animate` | `^4.5.0` | Declarative, chained animations to make the UI engaging and gamified. |
| `cached_network_image` | `^3.3.0` | Caches network images heavily to improve performance and reduce bandwidth. |
| `shimmer` | `^3.0.0` | Provides skeleton loading screens during network requests. |

## 🎮 Game Engine & Multimedia
| Package | Version | Purpose |
|---------|---------|---------|
| `flame` | `^1.14.0` | Lightweight 2D game engine built on Flutter. Powers the interactive mini-games. |
| `audioplayers` | `^5.2.1` | Handles SFX and BGM for UI interactions and game logic. |

## ☁️ Backend & Services (Firebase)
| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | `^2.24.2` | Core initialization for Firebase services. |
| `firebase_auth` | `^4.15.3` | Handles user authentication (Email/Password, Social Login). |
| `cloud_firestore` | `^4.13.6` | NoSQL Database for long-term user data and leaderboards. |
| `firebase_Database` | `^10.4.0` | Real-time Database for 1v1 matchmaking and active quiz battles. |

## 🔐 Security & Networking
| Package | Version | Purpose |
|---------|---------|---------|
| `dio` | `^5.4.3` | Powerful HTTP client used for Mock Data Providers calls (planned for production backend). |
| `flutter_secure_storage`| `^9.0.0` | Encrypts and securely stores sensitive data (e.g., JWT tokens). |
| `shared_preferences` | `^2.2.2` | Stores non-sensitive, simple key-value pairs (e.g., user theme preference). |

## 🧑‍💻 Social Auth
| Package | Version | Purpose |
|---------|---------|---------|
| `google_sign_in` | `^6.2.1` | Google OAuth provider integration. |
| `flutter_facebook_auth` | `^6.0.3` | Facebook OAuth provider integration. |

## 🧪 Development Tools
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | `^3.0.1` | Enforces strict Dart coding standards and best practices. |
