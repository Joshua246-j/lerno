# 14 - Gamification System

## 🌟 Core Loop
The primary engagement mechanic is a continuous loop:
**Learn/Play -> Earn Rewards -> Upgrade/Showcase -> Learn/Play.**

## ✨ Currencies
- **XP (Experience Points)**: Unspendable. Used purely for leveling up and unlocking new paths.
- **Coins**: Spendable virtual currency. Earned via daily missions, battles, and level-ups. Used to buy avatars, profile borders, and game power-ups.

## 🏅 Badges & Achievements
Achievements are broken down into tiers (Bronze, Silver, Gold).
- *Example*: "Bookworm" (Complete 5, 20, 50 lessons).
- Badges are displayed publicly on the user's Profile for bragging rights.

## 📅 Daily & Weekly Engagement
- **Daily Login Bonus**: Escalating rewards for consecutive logins (Days 1-7), resetting after Day 7 or if a day is missed.
- **Daily Missions**: Three random tasks (e.g., "Win 2 battles", "Complete 1 Math lesson"). Completing all three unlocks a bonus chest.
- **Weekly Challenges**: Harder tasks requiring sustained effort over the week.

## 📈 Progress Calculation
XP curves are designed using a quadratic formula to make early levels extremely fast (instant gratification) while later levels require sustained dedication.
`Required XP for Next Level = (Level^2) * 50`
