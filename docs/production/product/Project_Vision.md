> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Lerno Project Vision

This document outlines the final, production-ready vision for Lerno. It describes what the application will become once all mock systems are removed and the real backend is deployed.

## 🌟 The Vision

Lerno will revolutionize how children perceive education by seamlessly blending the addictive, high-engagement loops of modern mobile gaming with rigid, syllabus-based learning modules. The goal is to shift learning from a "chore" to an exciting, competitive, and rewarding daily habit.

## 🚀 Mission Statement

To provide free, high-quality, gamified education accessible to any child with a smartphone, empowering them to learn through play and healthy competition.

## 🎯 Product Goals

1. **Engagement Over Enforcement**: Create an environment where users *want* to return daily, driven by intrinsic game rewards rather than extrinsic parental pressure.
2. **Social Learning**: Leverage 1v1 Quiz Battles and leaderboards to instill healthy peer-to-peer competition.
3. **Cross-Platform Ubiquity**: Deliver a flawless, 60fps experience on iOS, Android, and the Web from a single Flutter codebase.

## 🧠 Learning Philosophy

Traditional educational apps present a wall of text followed by a quiz. Lerno avoids text walls entirely. Instead, concepts are introduced dynamically through interactive elements (Micro-Learning), immediately followed by active recall challenges.

During solo lessons, a child cannot "fail" or reach a Game Over screen. Instead, gentle visual feedback corrects them until they succeed, ensuring zero-punishment learning loops.

## 🎮 Gamification Philosophy

The educational loop is reinforced by a robust virtual economy:
1. **Learn**: Complete a 3-minute interactive lesson.
2. **Earn**: Receive XP (to progress on the Learning Map) and Coins (virtual currency).
3. **Spend**: Buy cosmetic Avatar upgrades, profile banners, and chat stickers in the Store.
4. **Compete**: Equip the new Avatar and join a real-time 1v1 Quiz Battle to earn League Trophies and climb the global Leaderboard.

## ⚙️ Technical Vision

The final production application will operate on a highly scalable, decoupled architecture:
- **Client**: Flutter (Riverpod, GoRouter, Flame Engine)
- **API Layer**: Python / FastAPI (High performance, async-first, auto-documented)
- **Database**: PostgreSQL (Strict relational integrity for economy and progress)
- **Real-Time**: Native FastAPI WebSockets backed by Redis Pub/Sub for 1v1 battles.
- **Background**: Celery workers for heavy analytics, email generation, and weekly League calculation.

## 🛣 Future Roadmap (Commercialization)

While currently an open-source portfolio project, the architecture supports future commercial scaling:
- **Freemium Tier**: Base lessons are free, while premium cosmetics are unlocked via a "Lerno+" subscription.
- **Parent/Teacher Dashboard**: A separate React or Vue web portal for guardians to track detailed analytics, identify weak subjects, and assign custom missions.
- **Global Tournaments**: Monthly e-sports style events where the top users in the Diamond League compete for real-world prizes or exclusive digital badges.
