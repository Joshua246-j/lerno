> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Game System

## Overview

Lerno incorporates multiple mini-games alongside its core Quiz Battles to provide varied and engaging learning mechanisms. The `features/games/` module handles all standalone gaming experiences.

## Supported Mini-Games

1. **Math Arena** (`features/games/math_arena/`)
   - Fast-paced math problem solving under time constraints.
2. **Math Fun Drive** (`features/games/math_fun_drive/`)
   - Educational driving game where solving equations navigates obstacles.
3. **Memory Match** (`features/games/memory_match/`)
   - Classic card-flipping memory game testing visual recall.
4. **Pattern Match** (`features/games/pattern_match/`)
   - Sequence and logic puzzle game.
5. **Word Hunt** (`features/games/word_hunt/`)
   - Spelling and vocabulary building challenges.
6. **Chess Puzzles** (`features/games/chess/`)
   - Tactical chess scenarios for advanced problem solving.

## Shared Game Architecture

- `core/GameSessionService`
- `core/GameManagerScreen`

## ♟ Specialized Games (Chess)

In addition to the Flame engine, the prototype leverages `flutter_chess_board` and `chess` packages for high-logic, grid-based learning scenarios that don't require the full weight of a 2D physics engine.

- **Game Session Service**: Centralized service (`game_session_service.dart`) handles the initialization, pausing, and termination of any game type.
- **Providers**: Each game utilizes its own Riverpod provider (e.g., `math_arena_provider.dart`, `memory_match_provider.dart`) to manage internal state independently.
- **Common UI**: Standardized overlays for `countdown_timer`, `game_header`, and `game_result_overlay` ensure a consistent look and feel across all experiences.
