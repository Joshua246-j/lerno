> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Gamification System

## Overview

Lerno utilizes extensive gamification strategies to drive retention. The system is located in `features/gamification/` and orchestrates all user rewards, leveling, and competitive mechanics.

## Core Mechanics

### 1. XP and Leveling

- Users earn XP points across all app activities (completing lessons, winning games).
- The `GamificationEngine` processes XP gains and triggers local animations and database syncs.

### 2. League System

- Located in `domain/models/league_system.dart` and `models/league_tier.dart`.
- Users are grouped into tiers (e.g., Bronze, Silver, Gold).
- Tier promotion/demotion occurs based on weekly leaderboard standings (`league_leaderboard_screen.dart`).

### 3. Streaks

- `streak_service.dart` tracks consecutive days the user has engaged with the app.
- Maintaining streaks applies multipliers to XP and Coin rewards.

### 4. Achievements and Badges

- Users unlock badges for significant milestones.
- Managed by `achievements_screen.dart` and displayed dynamically via `achievement_popup.dart`.

### 5. Daily Tasks

- Found in `features/rewards/` and `daily_tasks_screen.dart`.
- Rotates daily objectives (e.g., "Play 2 Math Games") for bonus payouts.
