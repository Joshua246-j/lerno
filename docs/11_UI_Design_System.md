# 11 - UI Design System

Lerno employs a highly custom, gamified design system to keep children engaged.

## 🎨 Colors
- **Primary**: Vibrant Purple / Deep Blue (Evokes curiosity and trust).
- **Secondary**: Bright Yellow / Orange (Used for coins, XP, and critical CTAs).
- **Accents**: Neon Green (Correct answers), Bright Red (Incorrect answers).
- **Backgrounds**: Soft creams and extremely dark blues (for dark mode).

## 🔤 Typography
- **Font Family**: Managed via `google_fonts`. Uses rounded, playful fonts like *Nunito* or *Baloo* for headings to appear friendly.
- **Hierarchy**:
  - `DisplayLarge`: Huge text for level-ups and game-over screens.
  - `TitleLarge`: Screen headers and dialog titles.
  - `BodyMedium`: Standard reading text.

## 🧱 Components
- **Cards**: All cards have significant border radius (`24px`), subtle drop shadows, and slight gradients.
- **Buttons**:
  - *Primary Button*: High elevation, thick bottom border simulating 3D depth. On press, the button physically translates down to simulate pushing.
- **Bottom Sheets**: Used extensively instead of full-screen pushes for quick actions (e.g., viewing a badge or selecting an item). They feature blurred backgrounds (Glassmorphism).

## 🎭 Animations
- **Micro-interactions**: Defined in a global `AnimationUtils` file. Buttons scale.
- **Progress Bars**: When XP is gained, progress bars do not jump; they animate smoothly over 1 second to their new percentage.
- **Lottie/Rive**: Planned integration for complex mascot animations on the home screen.

## 🖼 Icons & SVGs
To maintain visual fidelity across extreme resolutions (iPads vs small phones), raster images (`.png`) are avoided where possible in favor of scalable vector graphics parsed by `flutter_svg`.
