# 01 - Project Overview

## 🌟 Project Vision
**Lerno** is envisioned to be a premier, highly engaging educational platform for children. The vision is to transform learning from a passive chore into an exciting, competitive, and highly rewarding experience. By blending structured educational paths with gamified mechanics, 1v1 battles, and immersive mini-games, Lerno aims to maximize knowledge retention and user engagement.

## 🎯 Goals
- **Engaging Education**: Deliver content through interactive and game-like experiences rather than traditional reading.
- **Healthy Competition**: Foster motivation through 1v1 quiz battles, leaderboards, and leagues.
- **Scalability**: Build a robust, scalable architecture using Flutter and Firebase capable of handling thousands of concurrent users.
- **Accessibility**: Provide a seamless cross-platform experience across Android, iOS, and Web.

## 🧑‍🤝‍🧑 Target Users
- **Primary Users**: Children (Ages 6-14) looking for a fun way to learn and test their knowledge.
- **Secondary Users**: Parents and educators monitoring progress, managing screen time, and reviewing learning metrics.

## 🚀 Current Development Stage
The project is currently in the **Late Alpha / Pre-Beta** stage. 
- Core architectural foundations are fully implemented (Feature-First Clean Architecture, Riverpod).
- UI/UX layout is highly polished with animations and thematic elements.
- Mock backend integration is active to facilitate offline UI testing and frontend validation.
- The 1v1 Battle system and Flame-based mini-games have foundational code structures in place.

## 🗺 Production Roadmap

### Phase 1: Foundation (Completed)
- [x] Project architecture setup (Riverpod, GoRouter).
- [x] Base UI/UX Design System integration.
- [x] Core mock data and models definition.

### Phase 2: Core Features Integration (In Progress)
- [ ] Transition from Mock Repositories to Production Firebase/Mock Data Providerss.
- [ ] Complete implementation of the 1v1 Quiz Battle matching logic.
- [ ] Finalize Flame Engine mini-game physics and interactions.

### Phase 3: Gamification & Social (Upcoming)
- [ ] Full League and Leaderboard synchronization.
- [ ] Push notifications and daily rewards processing.
- [ ] Friends system and social sharing.

### Phase 4: Production Polish
- [ ] Thorough unit, widget, and integration testing.
- [ ] Performance profiling and Riverpod caching optimizations.
- [ ] Beta release to Android Play Store and iOS App Store.

## 🧩 Application Modules
The application is logically divided into several core modules:
1. **Auth Module**: User onboarding, login, registration, and session management.
2. **Home Module**: Dashboard showcasing user progress, daily missions, and quick access to games.
3. **Learning Path Module**: Sequential educational content grouped by subjects.
4. **Gamification Module**: XP, Coins, Badges, and Leveling systems.
5. **Games & Battles Module**: Dedicated engines for 1v1 quiz battles and Flame engine mini-games.
6. **Profile & Social Module**: User statistics, match history, inventory, and friends list.
