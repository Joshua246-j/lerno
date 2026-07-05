import os
import urllib.request
import time

def download_file(url, output_path):
    print(f"Downloading {url} to {output_path}...")
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response, open(output_path, 'wb') as out_file:
            out_file.write(response.read())
    except Exception as e:
        print(f"Failed to download {url}: {e}")
    time.sleep(1) # Delay for rate limiting

def setup_assets():
    # 1. Download logical audio from reliable Google Actions library
    print("Downloading Audio...")
    os.makedirs('assets/audio/ui', exist_ok=True)
    os.makedirs('assets/audio/rewards', exist_ok=True)
    
    audios = {
        'assets/audio/ui/click.ogg': 'https://actions.google.com/sounds/v1/ui/button_click.ogg',
        'assets/audio/ui/success.ogg': 'https://actions.google.com/sounds/v1/ui/coins_drop.ogg',
        'assets/audio/ui/error.ogg': 'https://actions.google.com/sounds/v1/ui/error_beep.ogg',
        'assets/audio/ui/fail.ogg': 'https://actions.google.com/sounds/v1/ui/error_beep.ogg',
        'assets/audio/rewards/level_up.ogg': 'https://actions.google.com/sounds/v1/ui/chime.ogg',
    }
    
    for path, url in audios.items():
        download_file(url, path)

    # 2. Download proper human-like Avataaars from DiceBear
    print("Downloading Avatars...")
    os.makedirs('assets/svg/avatars', exist_ok=True)
    
    avatars = {
        'default_user': 'https://api.dicebear.com/9.x/avataaars/svg?seed=Felix&backgroundColor=b6e3f4',
        'octopus': 'https://api.dicebear.com/9.x/avataaars/svg?seed=Aneka&backgroundColor=ffdfbf',
        'alien': 'https://api.dicebear.com/9.x/avataaars/svg?seed=Brooklynn&backgroundColor=c0aede',
        'robot': 'https://api.dicebear.com/9.x/avataaars/svg?seed=Destiny&backgroundColor=d1d4f9',
    }
    
    for name, url in avatars.items():
        download_file(url, f"assets/svg/avatars/{name}.svg")

if __name__ == '__main__':
    setup_assets()
    print("Finished downloading logical audio and proper avatars!")
