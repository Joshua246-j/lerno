# 17 - Mock Backend System

## 🎭 Purpose
The Mock Backend allows UI, UX, and state management development to proceed unhindered while the production APIs and Firebase schemas are still being finalized.

## 🏗 Implementation
All repositories are defined by abstract interfaces in the `domain/repositories/` folder.
The mock implementations live in `core/mock/` or `data/repositories/mock_*.dart`.

### Example
```dart
abstract class AuthRepository {
  Future<User> login(String email, String password);
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network latency
    return User(id: '123', username: 'TestUser');
  }
}
```

## 💉 Dependency Injection
Riverpod handles the injection.
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // To switch to production, simply change this one line to:
  // return FirebaseAuthRepository();
  return MockAuthRepository();
});
```

## 🔄 Persistence Simulation
To make testing realistic, some Mock Repositories use singletons or `SharedPreferences` to maintain state across screen navigations, ensuring that when you "buy" an item in the mock store, your mock coin balance actually decreases for that session.
