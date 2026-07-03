# 18 - Performance Optimization

Smooth performance (60/120 FPS) is critical for a gamified application to prevent frustration.

## 🚀 Riverpod Optimization
- **`select` Filtering**: UI components use `ref.watch(provider.select((value) => value.specificField))` to prevent full widget rebuilds when unrelated state in the same model changes.
- **Provider Caching**: API responses are cached in memory. The `keepAlive` flag is selectively used so that closing a heavy screen and reopening it doesn't trigger unnecessary network calls unless stale.

## 🖼 Asset & Image Optimization
- **SVG over PNG**: All icons and simple illustrations are SVGs to save memory and scale infinitely.
- **CachedNetworkImage**: External images (avatars, banners) are fetched once and cached on the device's disk.

## 🧊 Lazy Loading & Pagination
- Leaderboards and long lists use `ListView.builder` for virtualized rendering.
- Infinite scrolling pagination is implemented in the Riverpod controllers to fetch data in chunks of 20, rather than loading thousands of rows into memory.

## 🎮 Flame Engine
The mini-games run outside the standard Flutter widget tree rendering pipeline. Flame uses a direct canvas approach.
- Sprites are batched.
- Physics calculations are optimized using spatial hashing to avoid O(n^2) collision checks.
- Unused assets are aggressively unloaded from the Flame cache upon game exit.
