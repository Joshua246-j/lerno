# Backend Development Guide

This document outlines the API endpoints, database structure, and integration specifications required to replace the frontend mock layer with a production-ready backend. 

## 1. Authentication & Users
The frontend currently uses a mock `AuthProvider` and `UserProfileProvider`.

**API Endpoints:**
- `POST /api/auth/register`: Phone number / email registration.
- `POST /api/auth/login`: Login and JWT generation.
- `POST /api/auth/verify`: OTP verification.
- `GET /api/users/profile`: Fetch the current user profile (level, xp, coins, trophies, league, inventory).
- `PUT /api/users/profile`: Update display name, avatarId.

**Database Collection: `users`**
```json
{
  "id": "string (UUID)",
  "displayName": "string",
  "avatarId": "string",
  "age": "int",
  "inventory": ["string (avatar_ids)"],
  "stats": {
    "level": "int",
    "xp": "int",
    "coins": "int",
    "trophies": "int",
    "league": "string",
    "currentStreak": "int"
  }
}
```

## 2. Gamification & Leaderboards
The system uses Clash of Clans style dynamic Elo/Trophy calculations.

**API Endpoints:**
- `GET /api/leaderboard?league=Bronze`: Fetch top players in a specific league tier.
- `POST /api/gamification/resolve`: Submit battle results to calculate Elo/Trophy changes. Requires both players' IDs and scores.

**Database Collection: `leaderboards`**
- Should be indexed by `league` and sorted by `trophies` descending.

## 3. Social Hub (Inbox, Friends, Chat)
Currently powered by `friends_provider.dart`.

**API Endpoints:**
- `GET /api/friends`: List current friends.
- `GET /api/friends/requests`: List pending incoming/outgoing requests.
- `POST /api/friends/request`: Send a friend request to a `userId`.
- `POST /api/friends/request/{req_id}/accept`: Accept request.
- `POST /api/friends/request/{req_id}/decline`: Decline request.
- `GET /api/chat/{friend_id}`: Fetch chat history with a specific friend.
- `POST /api/chat/{friend_id}`: Send a message via WebSockets or REST.

**Database Collections:**
- `friend_requests`: Track pending requests.
- `friendships`: Track accepted relationships.
- `messages`: Store chat logs (`senderId`, `receiverId`, `text`, `timestamp`). WebSockets recommended for real-time delivery.

## 4. Store & Economy
Powered by `store_provider.dart`. Avatars cost coins.

**API Endpoints:**
- `GET /api/store/avatars`: Fetch available shop items and pricing.
- `POST /api/store/purchase`: Purchase an avatar by ID. Will decrement user coins and add item to inventory.

## 5. Technology Stack Recommendation
- **API Gateway**: Node.js (Express/NestJS) or Python (FastAPI).
- **Database**: PostgreSQL for structured relationships (friends, store) or Firebase Firestore for rapid real-time integration (chat, leaderboards).
- **Real-time**: WebSockets (Socket.io) or Firebase Realtime Database for the Chat system and 1v1 Arena matchmaking.
