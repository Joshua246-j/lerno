> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Offline Architecture

## 🔌 Current Implementation

Currently, the mock repositories inherently function "offline". State changes (like XP gains and purchases) are persisted locally using **Hive**, a lightweight NoSQL database already installed in the `pubspec.yaml`. This ensures the prototype retains data across app restarts.

## 💾 Future Production Offline Support

Lerno aims to support limited offline functionality for scenarios like car rides or flights.

### Offline Capabilities

- Users can play single-player mini-games.
- Users can review previously downloaded lessons.
- Users **cannot** participate in 1v1 Quiz Battles or access the Store.

### Caching Strategy

- **SQLite / Hive Offline Persistence**: When the backend is integrated, offline persistence will be handled by caching API responses locally using Hive or SQLite.
- **Write Queues**: If a user completes an offline lesson, the XP transaction is stored in a local mutation queue and automatically synchronized to the FastAPI backend when the device regains connectivity.

### Conflict Resolution

In the event of a conflict (e.g., user completes a lesson offline on a tablet, and also completes it on a phone), the PostgreSQL database's timestamp-based server-side resolution will take precedence. For complex economy transactions (Coins), the backend will validate the queued offline receipts to prevent spoofing or cheating.
