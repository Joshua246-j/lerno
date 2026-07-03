# 09 - Authentication System

## 🧪 Current Mock Authentication
Currently, the application bypasses real authentication to allow rapid UI development.
- A `MockAuthRepository` automatically returns a mocked `User` entity when the login button is pressed.
- The Riverpod state transitions to `Authenticated`, bypassing actual network calls.

## 🔒 Future Production Authentication
The production application will rely exclusively on **Firebase Authentication**.

### Supported Providers
1. **Email/Password**: Standard registration for parents or older children.
2. **Google OAuth**: One-tap login via `google_sign_in`.
3. **Facebook OAuth**: Social login via `flutter_facebook_auth`.

### 🔄 Session Flow & JWT
1. Upon successful Firebase login, a JWT (`IdToken`) is generated.
2. The token is stored securely using `flutter_secure_storage`.
3. A Riverpod `DioInterceptor` is configured to automatically append this token to the `Authorization` header of every outbound API request.

### ⏳ Token Lifecycle & Refresh
- Firebase manages token expiration automatically.
- Before making an API request, the Dio interceptor will request a fresh token from the Firebase SDK. If the user session has been revoked remotely, Firebase will throw an exception.
- This exception is caught globally by the `AuthNotifier`, which immediately forces the user back to the Login Screen and clears local data.
