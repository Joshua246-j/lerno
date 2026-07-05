> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Entity Relationship (ER) Diagram

This diagram maps the core relational architecture of the Lerno database.

```mermaid
erDiagram
    USERS ||--o{ PROFILES : "has 1"
    USERS ||--o{ USER_PROGRESS : tracks
    USERS ||--o{ INVENTORY : owns
    USERS ||--o{ USER_ACHIEVEMENTS : unlocks
    USERS ||--o{ FRIENDSHIPS : requests
    USERS ||--o{ FRIENDSHIPS : accepts
    USERS ||--o{ MESSAGES : sends
    USERS ||--o{ MESSAGES : receives
    USERS ||--o{ BATTLE_PARTICIPANTS : joins

    COURSES ||--o{ TOPICS : contains
    TOPICS ||--o{ LESSONS : contains
    TOPICS ||--o{ QUIZZES : has

    LESSONS ||--o{ USER_PROGRESS : "completed by"
    
    QUIZZES ||--o{ QUIZ_QUESTIONS : contains
    QUIZZES ||--o{ BATTLES : "used in"

    BATTLES ||--o{ BATTLE_PARTICIPANTS : involves
    BATTLES ||--o{ BATTLE_ROUNDS : records

    BATTLE_PARTICIPANTS ||--o{ BATTLE_ROUNDS : answers

    USERS {
        uuid id PK
        string email
        string hashed_password
        boolean is_active
        boolean is_verified
        datetime created_at
    }

    PROFILES {
        uuid user_id FK
        string display_name
        string bio
        string avatar_id
        int total_xp
        int coins
        int trophies
        string current_league
    }

    COURSES {
        uuid id PK
        string title
        string description
        string icon_url
    }

    LESSONS {
        uuid id PK
        uuid topic_id FK
        string title
        int xp_reward
        int coin_reward
    }

    QUIZ_QUESTIONS {
        uuid id PK
        uuid quiz_id FK
        string question_text
        jsonb options
        string correct_answer
    }

    BATTLES {
        uuid id PK
        uuid quiz_id FK
        datetime start_time
        datetime end_time
        string status
        uuid winner_id FK
    }
```
