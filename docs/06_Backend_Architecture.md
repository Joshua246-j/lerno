# 06 - Backend Architecture

> [!NOTE]
> **Current Implementation**: The application currently uses Mock Repositories (`lib/core/mock/`) for UI/UX testing and layout verification.
> **Future Production Architecture**: The planned production backend will be a hybrid of Firebase and a scalable REST API.

## ☁️ Future Production Backend Stack
- **Real-Time Data (Battles & Chat)**: Firebase Realtime Database / Firestore.
- **Auth & User Identity**: Firebase Authentication.
- **Core Business API**: Node.js / Go / Python (REST or GraphQL API).
- **Database**: PostgreSQL (for structured relational data) + Redis (for caching leaderboards).

## 🔐 Authentication
Firebase Auth will handle the heavy lifting (OAuth, Email/Password, OTP). 
The backend will verify the Firebase JWT token on every protected API request rather than maintaining custom session cookies.

## 🌐 Services & Repository Mapping
The application architecture is already prepared for this transition. Because the app uses the Repository Pattern, swapping from `MockAuthRepository` to `FirebaseAuthRepository` requires changing exactly one line in the Riverpod Dependency Injection file.

## ☁️ Cloud Architecture & Real-Time Flow
For the 1v1 Quiz Battles, low latency is critical:
1. User enters matchmaking queue (API call to backend).
2. Backend pairs users and creates a Firebase Realtime Database Room.
3. Both clients connect directly to the Firebase Room via WebSockets.
4. Game progresses in real-time.
5. Winner is finalized, clients send a signed payload to the Backend API to securely calculate XP and ELO updates.

## 🚀 Caching & Background Jobs
- **Caching**: Global leaderboards will be aggressively cached on the server using Redis and only flushed to PostgreSQL periodically.
- **Background Jobs**: Nightly cron jobs will compute Weekly League promotions and demotions.

## 🔔 Notifications
Firebase Cloud Messaging (FCM) will be integrated to handle:
- Matchmaking found alerts.
- Daily mission reminders.
- Friend requests.
