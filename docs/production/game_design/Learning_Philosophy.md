> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Learning Philosophy

## 🧠 Core Methodology

Lerno operates on the principle of **Micro-Learning mixed with Active Recall**. 

Traditional educational apps present a wall of text followed by a quiz. Lerno avoids text walls entirely. Instead, concepts are introduced dynamically through interactive elements, immediately followed by active recall challenges.

## 🏗 Content Hierarchy

The educational syllabus is strictly structured as follows:

1. **Subject** (e.g., Mathematics, Science, Logic)
   - The highest level category.
2. **Course** (e.g., Fractions, Gravity)
   - A sequential path represented visually as a map.
3. **Topic** (e.g., Adding Fractions with like denominators)
   - A cluster of nodes on the map.
4. **Lesson** (e.g., Node 1)
   - A 2-3 minute interactive session.
5. **Activities / Mini-Games**
   - The actual drag-and-drop, matching, or Flame-engine games that make up the lesson.

## 🎮 The "No-Fail" Approach

During a solo lesson, a user cannot "fail". 
- If a child answers incorrectly in a Flame mini-game, they do not lose lives or get a Game Over screen.
- Instead, the game provides immediate, gentle visual feedback (e.g., the character shakes their head, and the correct option pulses).
- The child must select the correct answer to proceed.
- **Reward Diminishing**: While they cannot fail, their 3-Star rating at the end of the lesson (which dictates Coin rewards) decreases based on the number of incorrect attempts.

## ⚔️ The "Competitive" Approach

In 1v1 Quiz Battles, the stakes are real. 
- Fast, accurate active recall is rewarded.
- Incorrect answers yield 0 points.
- Time limits induce adrenaline.
- This creates an environment where a child *wants* to replay the solo "No-Fail" lessons to memorize the content so they can dominate the competitive battles.
