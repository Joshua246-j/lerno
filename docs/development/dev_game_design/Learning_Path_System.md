> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Learning Path System

## Overview

The core educational content is driven by the `features/learning_path/` module, providing structured courses and interactive lessons.

## Data Structure

- **Courses**: High-level curriculums (e.g., "Grade 3 Math"). Configured in `core/mock/course_config.dart` or fetched via `course_repository.dart`.
- **Subjects/Chapters**: Groupings within a course (`subject_details_screen.dart`).
- **Lessons**: Individual educational modules (`lesson_screen.dart`).

## Topic Quizzes

- After completing lessons, users face topic quizzes (`topic_quiz_screen.dart`) to validate understanding before progressing.
- Progression is strictly tracked; users cannot access future lessons until prerequisite quizzes are passed.

## UI Elements

- **Winding Path Painter**: The map-like interface uses a custom `winding_path_painter.dart` in the `core/widgets/` to draw dynamic, game-like level progression roads.
