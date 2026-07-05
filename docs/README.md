# Lerno Documentation Suite

Welcome to the central documentation index for the Lerno project. 

To eliminate any ambiguity between the **current implementation** and the **long-term vision**, this repository is strictly divided into two completely isolated environments:

---

## 🏭 Production Documentation (The Final Vision)
These documents describe the final, commercial-ready architecture we are building toward (FastAPI, PostgreSQL, Native Deployments).

- **`frontend/`**: Reserved for final native UI integrations and release candidates.
- **`backend/`**: [Architecture](production/backend/Backend_Architecture.md), [Structure](production/backend/Project_Structure.md), [Setup](production/backend/Environment_Setup.md), [Auth](production/backend/Authentication_Architecture.md), [Services](production/backend/Backend_Services.md), [WebSockets](production/backend/WebSocket_Architecture.md), [Jobs](production/backend/Background_Jobs.md), [Roadmap](production/backend/Backend_Roadmap.md).
- **`database/`**: [Database Architecture](production/database/Database_Architecture.md), [ER Diagram](production/database/ER_Diagram.md).
- **`api/`**: [API Standards](production/api/API_Standards.md).
- **`architecture/`**: Reserved for final cloud data flows.
- **`ui_ux/`**: [UI Design System](production/ui_ux/UI_Design_System.md).
- **`game_design/`**: [Learning Philosophy](production/game_design/Learning_Philosophy.md).
- **`product/`**: **[Project Vision](production/product/Project_Vision.md)**, [User Personas](production/product/User_Personas.md), [Engagement Strategy](production/product/Engagement_Strategy.md).
- **`security/`**: [Security](production/security/Security.md), [JWT Flow](production/security/JWT_Flow.md).
- **`deployment/`**: [Deployment Guide](production/deployment/Deployment_Guide.md), [Docker Guide](production/deployment/Docker_Guide.md), [CI/CD](production/deployment/CI_CD_Pipeline.md), [Build & Deployment](production/deployment/Build_Deployment.md).
- **`testing/`**: [Testing Strategy](production/testing/Testing_Strategy.md).

---

## 🧪 Development Documentation (The Current Prototype)
These documents describe the *actual* code running in `lib/` and `pubspec.yaml` right now. This is a High-Fidelity Prototype running on Flutter and Riverpod using Mock Data and local `hive` persistence.

- **`dev_progress/`**: **[Current Progress](development/dev_progress/Current_Progress.md)**, [Dev Guide](development/dev_progress/Development_Guide.md).
- **`dev_frontend/`**: [Frontend Architecture](development/dev_frontend/Frontend_Architecture.md), [Navigation](development/dev_frontend/Navigation_Flow.md), [Profiles](development/dev_frontend/Profile_System.md), [Performance](development/dev_frontend/Performance_Optimization.md).
- **`dev_backend/`**: [Mock Backend System](development/dev_backend/Mock_Backend_System.md).
- **`dev_database/`**: [Offline Architecture](development/dev_database/Offline_Architecture.md).
- **`dev_api/`**: Currently empty (APIs are mocked).
- **`dev_architecture/`**: [Project Architecture](development/dev_architecture/Project_Architecture.md), [Project Structure](development/dev_architecture/Project_Structure.md), [Tech Stack](development/dev_architecture/Tech_Stack.md).
- **`dev_ui_ux/`**: Covered by production UI/UX documents.
- **`dev_game_design/`**: [Game System](development/dev_game_design/Game_System.md), [Quiz Battles](development/dev_game_design/Quiz_Battle_System.md), [Gamification](development/dev_game_design/Gamification_System.md), [Learning Paths](development/dev_game_design/Learning_Path_System.md), [Social Features](development/dev_game_design/Social_Features.md).
- **`dev_assets/`**: [Asset Guidelines](development/dev_assets/Asset_Guidelines.md).
- **`dev_testing/`**: [Frontend Testing](development/dev_testing/Frontend_Testing.md).
