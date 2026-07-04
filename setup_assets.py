import os
import urllib.request
import urllib.error

# Define directory structure
dirs = [
    "assets/svg/avatars",
    "assets/svg/league",
    "assets/svg/badges",
    "assets/svg/games",
    "assets/svg/courses",
    "assets/svg/icons",
    "assets/svg/illustrations",
    "assets/svg/empty_states",
    "assets/svg/rewards",
    "assets/audio/music",
    "assets/audio/ui",
    "assets/audio/game",
    "assets/audio/rewards",
    "assets/audio/notifications"
]

for d in dirs:
    os.makedirs(d, exist_ok=True)
    print(f"Created {d}")

# Download a few Lucide icons as placeholders for UI icons
# We will use lucide-static unpkg
LUCIDE_BASE_URL = "https://unpkg.com/lucide-static@latest/icons/"

icons_to_download = {
    "assets/svg/icons/home.svg": "home.svg",
    "assets/svg/icons/book.svg": "book-open.svg",
    "assets/svg/icons/store.svg": "shopping-cart.svg",
    "assets/svg/icons/user.svg": "user.svg",
    "assets/svg/icons/settings.svg": "settings.svg",
    "assets/svg/icons/star.svg": "star.svg",
    "assets/svg/icons/award.svg": "award.svg",
    "assets/svg/icons/check.svg": "check.svg",
    "assets/svg/icons/x.svg": "x.svg",
    "assets/svg/icons/chevron-right.svg": "chevron-right.svg",
    "assets/svg/icons/chevron-left.svg": "chevron-left.svg",
    "assets/svg/icons/play.svg": "play.svg",
    "assets/svg/icons/pause.svg": "pause.svg",
}

print("Downloading SVG icons...")
for target_path, icon_name in icons_to_download.items():
    url = LUCIDE_BASE_URL + icon_name
    try:
        urllib.request.urlretrieve(url, target_path)
        print(f"Downloaded {icon_name} to {target_path}")
    except urllib.error.URLError as e:
        print(f"Failed to download {icon_name}: {e}")

print("Done setting up assets structure.")
