> [!NOTE]
> **CURRENT PROTOTYPE**: This document describes the current active development state, utilizing mock data and local persistence.

# Lerno Asset Guidelines

## Organization

All assets in Lerno must be organized into strict directories to maintain sanity as the project scales:
- `assets/audio/`: Subdivided into `music/`, `ui/`, `games/`, etc.
- `assets/svg/`: All scalable vector graphics. Subdivided by domain (`avatars`, `badges`, `leagues`).
- `assets/images/`: Fallback for non-scalable graphics (e.g. backgrounds).
- `assets/animations/`: Contains Lottie (`lottie/`) and Rive (`rive/`) files.

## Centralized Repositories

Never hardcode asset paths like `assets/svg/avatars/robo.svg` into UI files.
Instead, use the `AppAssets` centralized utility class (`lib/core/theme/app_assets.dart`).
This utility stores semantic ID mappings and resolves paths dynamically (e.g. `AppAssets.getAvatarPath(avatarId)`).

## Sourcing

All placeholder and high-quality prototype assets are generated or fetched automatically via Python scripts in the root directory:
- **Avatars**: High-quality SVG cartoon avatars dynamically downloaded from the DiceBear API (`download_avatars.py`).
- **Icons**: Lucide Icons.
- **Audio & SFX**: Kenney Audio game SFX, downloaded automatically via python script.
- **Custom Voice**: Speech synthesized using `gTTS` and `pydub` (`synthesize_audio.py`).
