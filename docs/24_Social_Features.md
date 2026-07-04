# 24 - Social Features

## Overview
Lerno incorporates peer-to-peer social elements handled by the `features/social/` and `features/chat/` modules to encourage collaborative learning.

## Friends System
- **Friend Management**: Users can search, add, and manage friends via `friends_screen.dart` and `friends_provider.dart`.
- **Profiles**: View other users' public stats and avatars via `friend_profile_screen.dart`.

## Chat & Inbox
- **Direct Messaging**: `chat_screen.dart` provides 1v1 messaging using the `chat_repository.dart` to sync with Firebase Realtime Database.
- **Stickers Support**: Messages can include custom stickers purchased from the Store.
- **Inbox System**: System notifications, friend requests, and challenge invites are aggregated in `inbox_screen.dart`.
