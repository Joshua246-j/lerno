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
    time.sleep(1) # delay to avoid rate limiting

def setup_realistic_assets():
    os.makedirs('assets/svg/avatars/starter', exist_ok=True)
    os.makedirs('assets/svg/avatars/shop', exist_ok=True)
    os.makedirs('assets/audio/ui', exist_ok=True)
    os.makedirs('assets/audio/rewards', exist_ok=True)
    os.makedirs('assets/audio/music', exist_ok=True)

    # 1. Download realistic dummy SVGs from DiceBear API
    avatars = {
        'default_user': 'https://api.dicebear.com/9.x/avataaars/svg?seed=AstroKid&backgroundColor=c0aede',
        'starter/octopus': 'https://api.dicebear.com/9.x/avataaars/svg?seed=Octopus&backgroundColor=b6e3f4',
        'starter/astronaut': 'https://api.dicebear.com/9.x/avataaars/svg?seed=Astronaut&backgroundColor=c0aede',
        'starter/robot': 'https://api.dicebear.com/9.x/avataaars/svg?seed=Robot&backgroundColor=ffdfbf',
        'shop/alien': 'https://api.dicebear.com/9.x/avataaars/svg?seed=Alien&backgroundColor=d1d4f9',
    }
    for name, url in avatars.items():
        download_file(url, f"assets/svg/avatars/{name}.svg")

    # 2. Download proper UI Sounds and BGM
    audio_files = {
        'assets/audio/ui/click.wav': 'https://raw.githubusercontent.com/KenneyNL/Audio-UI/master/Audio/click1.ogg',
        'assets/audio/ui/success.wav': 'https://raw.githubusercontent.com/KenneyNL/Audio-UI/master/Audio/rollover2.ogg',
        'assets/audio/ui/error.wav': 'https://raw.githubusercontent.com/KenneyNL/Audio-UI/master/Audio/error1.ogg',
        'assets/audio/rewards/level_up.wav': 'https://raw.githubusercontent.com/KenneyNL/Audio-UI/master/Audio/confirmation1.ogg',
        # A simple piano tune from public domain for bgm
        'assets/audio/music/bgm_home.wav': 'https://actions.google.com/sounds/v1/water/rain_on_roof.ogg',
    }
    
    for path, url in audio_files.items():
        # Using .ogg instead since that's what we download, or just save it as wav because flutter audio player can play it.
        download_file(url, path.replace('.wav', '.ogg'))

if __name__ == '__main__':
    setup_realistic_assets()
    print("Finished downloading realistic assets!")
