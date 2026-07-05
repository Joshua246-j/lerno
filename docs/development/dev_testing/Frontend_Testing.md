> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Frontend Testing Strategy

## 🧪 Philosophy

While the backend focuses heavily on business logic and API contracts, the Flutter frontend testing strategy focuses on State Management stability and UI correctness. 

We do not aim for 100% test coverage (which is fragile for UIs), but we do mandate 100% coverage on core Riverpod providers and complex utilities.

## 🧰 Test Types

### 1. Unit Tests (Logic & State)

Unit tests ensure that our Riverpod Notifiers update state correctly in response to events.
- **Location**: `test/features/<feature>/<name>_test.dart`
- **Tooling**: `flutter test`, `riverpod_test`

**Example:**
We mock the `AuthRepository` and verify that when `login()` is called, the `AuthNotifier` transitions from `loading` to `authenticated`.

### 2. Widget Tests (Component UI)

Widget tests render a single widget in isolation without running the full app. They ensure the UI reacts properly to state changes.
- **Tooling**: `flutter_test`

**Example:**
Pumping the `CoinBalanceBadge` widget and verifying that it displays the integer passed to it, and that tapping it triggers the expected callback.

### 3. Integration Tests (End-to-End)

Integration tests run on a real device or emulator. They drive the application from launch to a specific goal, simulating real user taps.
- **Tooling**: `integration_test` package

**Example:**
1. Launch App.
2. Tap "Play Game".
3. Verify the Game Loading screen appears.
4. Verify the Game Engine canvas renders.

## 🚫 What We Don't Test

- **External Libraries**: We trust that `flame` and `firebase_core` work as advertised. We only test *our* implementation of them.
- **Pixel-Perfect Rendering**: We rely on manual QA for visual alignment, as Golden Tests can be highly brittle across different OS rendering engines.
