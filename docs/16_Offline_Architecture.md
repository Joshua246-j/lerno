# 16 - Offline Architecture

## 🔌 Current Implementation
Currently, the mock repositories inherently function "offline" since they return hardcoded Dart objects. However, state changes (like XP gains) are volatile and reset upon app restart unless explicitly saved to `SharedPreferences`.

## 💾 Future Production Offline Support
Lerno aims to support limited offline functionality for scenarios like car rides or flights.

### Offline Capabilities
- Users can play single-player mini-games.
- Users can review previously downloaded lessons.
- Users **cannot** participate in 1v1 Quiz Battles or access the Store.

### Caching Strategy
- **Firestore Offline Persistence**: When Firebase is integrated, offline persistence will be enabled by default. Firestore caches queried documents locally.
- **Write Queues**: If a user completes an offline lesson, the XP transaction is stored in Firestore's local mutation queue and automatically synchronized to the cloud when the device regains connectivity.

### Conflict Resolution
In the event of a conflict (e.g., user completes a lesson offline on a tablet, and also completes it on a phone), Firebase's timestamp-based server-side resolution will take precedence. For complex economy transactions (Coins), a Cloud Function will validate the queued offline receipts to prevent spoofing or cheating.
