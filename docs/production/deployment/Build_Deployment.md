> [!IMPORTANT]
> **PRODUCTION BLUEPRINT**: This document describes the final target architecture and APIs. It does not reflect the current mock-data prototype.

# Build & Deployment

## 🧹 Cleaning the Environment

If you experience weird caching issues or dependency mismatches, always start fresh:
```bash
flutter clean
flutter pub get
```

## 🔍 Code Quality Checks

Before generating a build, ensure the code passes static analysis:
```bash
flutter analyze
dart analyze
```

## 📱 Building for Android

### Debug Build

Generates a heavy APK suitable for local testing and debugging.
```bash
flutter build apk --debug
```
**Output Location**: `build/app/outputs/flutter-apk/app-debug.apk`

### Release Build

Generates an optimized, minified APK. Ensure you have the keystore configured in `android/key.properties` before running this.
```bash
flutter build apk --release
```
**Output Location**: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (Play Store)

To upload to the Google Play Store, generate an AAB:
```bash
flutter build appbundle --release
```
**Output Location**: `build/app/outputs/bundle/release/app-release.aab`

## 📲 Manual Installation

To install the generated APK directly onto a connected device or emulator:
```bash
adb devices                  # Ensure your device shows up
flutter install              # Installs the built APK automatically
# OR manually:

adb install build/app/outputs/flutter-apk/app-debug.apk
```

## ⚠️ Known Build Limitations

**Kotlin Incremental Cache Issue on Windows**:
If you are building on Windows and your Flutter Project is on a different drive (e.g., `D:\`) than your Pub Cache (e.g., `C:\`), the Gradle Kotlin compiler may crash with `Could not close incremental caches` due to a known `RelocatableFileToPathConverter` bug.
**Workaround**:
1. Run `cd android && .\gradlew --stop`
2. Manually delete the `build/` folder.
3. Re-run `flutter build apk`.
