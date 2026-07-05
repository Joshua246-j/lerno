> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Frontend Architecture

## 📱 UI Architecture

The frontend is designed to be highly responsive, declarative, and heavily animated to maintain the gamified experience. It separates pure UI components from business logic strictly via Riverpod.

## 🧱 Widgets & Components

- **Dumb Widgets**: Located in `core/widgets/` or a feature's `presentation/widgets/`. These are usually `StatelessWidget`s that accept data via parameters and return UI. They do not read from Riverpod directly.
- **Smart Widgets**: Usually complete screens (`presentation/screens/`). They inherit from `ConsumerWidget` or `ConsumerStatefulWidget` to actively listen to Riverpod states.

## 🎨 Themes & Styling

Styling is strictly centralized in `core/theme/`.
- Hardcoded colors or sizes inside Widgets are forbidden.
- The UI relies on `Theme.of(context)` and custom extensions (e.g., `AppColors`, `AppTypography`).
- Dark Mode and Light Mode are structurally supported using dynamic `ThemeData`.

## 🌀 Animations

To maintain the kid-friendly gamified feel, Lerno uses `flutter_animate`.
- **Micro-interactions**: Buttons scale down slightly on press.
- **Page Transitions**: Handled globally by `GoRouter` using custom `FadeTransition` or `SlideTransition`.
- **State Changes**: When earning XP or coins, numbers use counting animations, and badges use bounce effects.

## 📱 Responsive Layout

The app is built primarily for mobile (Portrait mode) but uses safe area insets and relative sizing (e.g., `MediaQuery` or `LayoutBuilder` for dynamic grids) to ensure tablet compatibility. The games (Flame) natively scale their canvas to the device aspect ratio.

## 🔄 State Flow in UI

1. **Initial Load**: A `ConsumerWidget` calls `ref.watch(myControllerProvider)`. 
2. **Async Handling**: The UI leverages Riverpod's `.when()` method to cleanly render `data`, `loading`, and `error` states without nested if-else statements.
3. **Mutations**: The UI calls methods directly on the notifier: `ref.read(myControllerProvider.notifier).submitForm()`.
