> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Security

## 🛡 Current Security

As the app is currently using a mock backend, data is stored locally in plaintext for debugging purposes. Security features are scaffolded but not enforced.

## 🔒 Future Production Security

### Authentication & Sessions

- **JWT Storage**: JWTs will never be stored in `SharedPreferences`. They will be encrypted and stored in the OS-level keystore using `flutter_secure_storage`.
- **Token Rotation**: Short-lived access tokens combined with secure refresh tokens to minimize risk if a token is intercepted.

### API Security

- **HTTPS/TLS**: All connections will be strictly forced over HTTPS. Cleartext traffic will be disabled in Android/iOS network configs.
- **Payload Validation**: All XP and Coin gains submitted by the client will be heavily validated by the backend. 
  - *Example*: If the client says "I completed a 2-minute quiz in 1 second and earned 1000 XP", the backend will reject it and flag the account for potential cheating.

### Data Privacy (COPPA Compliance)

Since the target demographic includes children, strict privacy measures will be implemented:
- No tracking of precise geolocation.
- No third-party ad networks that scrape user data.
- Chat systems will use automated profanity and PII (Personally Identifiable Information) filters.
- Parental gates for in-app purchases and account deletion.
