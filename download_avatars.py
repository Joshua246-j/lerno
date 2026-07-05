import urllib.request
import os

starter_seeds = ['robot', 'dinosaur', 'panda', 'fox', 'astronaut', 'octopus', 'wizard', 'penguin', 'dragon']
shop_seeds = ['alien', 'ninja', 'princess', 'chef', 'comet', 'explorer', 'knight', 'lion', 'pirate', 'planet', 'scientist', 'spaceship', 'tiger', 'unicorn']

def download_avatars(seeds, folder):
    os.makedirs(folder, exist_ok=True)
    for seed in seeds:
        url = f"https://api.dicebear.com/7.x/avataaars/svg?seed={seed}&backgroundColor=c0aede,b6e3f4,ffdfbf"
        file_path = os.path.join(folder, f"{seed}.svg")
        try:
            print(f"Downloading {seed}...")
            urllib.request.urlretrieve(url, file_path)
            print(f"Saved {file_path}")
        except Exception as e:
            print(f"Failed to download {seed}: {e}")

download_avatars(starter_seeds, 'assets/svg/avatars/starter')
download_avatars(shop_seeds, 'assets/svg/avatars/shop')
print("Done!")
