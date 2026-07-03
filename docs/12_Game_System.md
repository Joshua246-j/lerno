# 12 - Game System

## 🎮 Purpose
The game system breaks the monotony of standard quizzes by wrapping educational content inside actual physics-based mini-games powered by the **Flame Engine**.

## 🛠 Architecture
- **Flame Component System**: Games are built extending `FlameGame`.
- **Flutter Integration**: The game is embedded inside standard Flutter UI using the `GameWidget`. Riverpod is used to pass state from Flutter (e.g., current player health) into the Flame engine.

## 🕹 Example Gameplay Loop (Word Catcher)
- **Objective**: Catch falling letters in the correct sequence to spell a word.
- **Mechanics**: The player drags a bucket left and right. Physics and collisions are handled by Flame.
- **Integration**: The words generated are pulled directly from the current active Lesson in the Learning Path.

## 🏆 Rewards
Upon completing a mini-game, a payload is sent to the backend to verify the score, which is then converted into:
- **XP (Experience Points)**
- **Coins (Virtual Currency)**

## 📈 Difficulty Progression
Games dynamically increase in speed and complexity based on the user's current ELO rank or player level.
- Level 1: Slow falling objects, 3-letter words.
- Level 10: Fast falling objects, decoy objects, 6-letter words.

## 🔮 Future Improvements
- Addition of specialized power-ups (e.g., "Slow Motion", "Magnet") purchasable from the store.
- High-score leaderboards specific to each mini-game.
