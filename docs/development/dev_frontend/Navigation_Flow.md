> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Navigation Flow

The app uses `go_router` for a declarative, URL-based routing system. This allows deep linking and robust web support.

## 🗺 Route Hierarchy

```mermaid
graph TD
    Root[App Startup / Splash] --> AuthCheck{Is Authenticated?}
    
    AuthCheck -->|No| Login[Login Screen]
    AuthCheck -->|Yes| Main[Main Tab Navigation]
    
    Login --> Register[Registration Screen]
    Login --> ForgotPassword[Forgot Password]
    
    Main --> Home[Home Tab]
    Main --> Path[Learning Path Tab]
    Main --> Battle[Battle Hub Tab]
    Main --> Profile[Profile Tab]
    
    Path --> Lesson[Lesson Detail]
    Path --> Quiz[Interactive Quiz]
    
    Battle --> Matchmaking[Matchmaking Screen]
    Matchmaking --> ActiveBattle[Active 1v1 Battle]
    
    Home --> MiniGame[Flame Mini-Game Engine]
```

## 🛡 Protected Routes

Routing is heavily guarded via a `redirect` handler in the GoRouter configuration.
- The router listens to the `AuthNotifier`.
- If a user tries to access `/home` but the state is `Unauthenticated`, GoRouter instantly redirects them to `/login`.
- If a user is on `/login` and the state becomes `Authenticated`, they are redirected to `/home`.

## 📍 Bottom Navigation

The primary interface relies on a customized `ScaffoldWithNavBar` (or `StatefulShellRoute`).
This preserves the state of individual tabs. For example, scrolling down the Learning Path, switching to the Profile tab, and switching back will not reset the Learning Path's scroll position.
