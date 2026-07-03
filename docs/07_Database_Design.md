# 07 - Database Design

The following represents the production relational database design required to support the application.

## 📊 Complete ER Diagram

```mermaid
erDiagram
    USERS ||--o{ MATCH_HISTORY : plays
    USERS ||--o{ INVENTORY : owns
    USERS ||--o{ ACHIEVEMENTS : unlocks
    USERS ||--o{ TRANSACTIONS : creates
    COURSES ||--o{ LESSONS : contains
    LESSONS ||--o{ QUIZ_QUESTIONS : includes
    QUIZ_QUESTIONS ||--o{ QUIZ_ANSWERS : has
    MATCH_HISTORY }|--|| QUIZ_BATTLES : logs
    
    USERS {
        uuid id PK
        string username
        string email
        string avatar_url
        int level
        int total_xp
        int coins
        int rank_elo
        datetime created_at
    }

    COURSES {
        uuid id PK
        string title
        string subject
        int min_level_req
    }

    LESSONS {
        uuid id PK
        uuid course_id FK
        string title
        int xp_reward
        int coin_reward
    }

    QUIZ_QUESTIONS {
        uuid id PK
        uuid lesson_id FK
        string question_text
        int difficulty
    }

    QUIZ_ANSWERS {
        uuid id PK
        uuid question_id FK
        string answer_text
        boolean is_correct
    }

    QUIZ_BATTLES {
        uuid id PK
        uuid player1_id FK
        uuid player2_id FK
        uuid winner_id FK
        int wager
        datetime started_at
        datetime ended_at
    }
```

## 🗄 Core Tables

### Users Table
Core user identity and gamification state.
- **Indexes**: Indexed by `username` for search, and `total_xp` / `rank_elo` for fast leaderboard generation.

### Courses & Lessons Tables
Hierarchical structure for the Learning Path.
- normalized to allow dynamic addition of subjects without altering schema.

### Quiz Questions & Answers Tables
Bank of questions for both solo learning and multiplayer battles.
- `difficulty` determines how much XP/ELO a question is worth in ranked mode.

### Quiz Battles Table
Stores historical data of 1v1 interactions. Used for anti-cheat analysis and user statistics generation.

## 🗃 Normalization Strategy
The database is generally in 3NF. However, fields like `total_xp` and `coins` are heavily denormalized and stored directly on the `Users` table (rather than summing up all `Transactions`) because they are read on almost every API call and UI render. 
