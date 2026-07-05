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
    os.makedirs('assets/svg/badges', exist_ok=True)
    os.makedirs('assets/svg/courses', exist_ok=True)
    os.makedirs('assets/svg/games', exist_ok=True)
    os.makedirs('assets/svg/banners', exist_ok=True)

    # 1. Download badges
    badges = {
        'word_warrior': 'https://api.dicebear.com/9.x/icons/svg?seed=WordWarrior&backgroundColor=ffdfbf',
        'math_master': 'https://api.dicebear.com/9.x/icons/svg?seed=MathMaster&backgroundColor=b6e3f4',
        'science_explorer': 'https://api.dicebear.com/9.x/icons/svg?seed=Science&backgroundColor=c0aede',
    }
    for name, url in badges.items():
        download_file(url, f"assets/svg/badges/{name}.svg")

    # 2. Download courses
    courses = {
        'maths': 'https://api.dicebear.com/9.x/icons/svg?seed=Math&backgroundColor=ffdfbf',
        'science': 'https://api.dicebear.com/9.x/icons/svg?seed=ScienceCourse&backgroundColor=d1d4f9',
        'english': 'https://api.dicebear.com/9.x/icons/svg?seed=English&backgroundColor=c0aede',
    }
    for name, url in courses.items():
        download_file(url, f"assets/svg/courses/{name}.svg")

    # 3. Download games
    games = {
        'word_puzzle': 'https://api.dicebear.com/9.x/icons/svg?seed=Puzzle&backgroundColor=b6e3f4',
        'math_game': 'https://api.dicebear.com/9.x/icons/svg?seed=Game&backgroundColor=ffdfbf',
        'shapes': 'https://api.dicebear.com/9.x/shapes/svg?seed=Shapes&backgroundColor=d1d4f9',
        'colouring': 'https://api.dicebear.com/9.x/icons/svg?seed=Color&backgroundColor=c0aede',
    }
    for name, url in games.items():
        download_file(url, f"assets/svg/games/{name}.svg")

    # 4. Download banners
    banners = {
        'banner1': 'https://api.dicebear.com/9.x/shapes/svg?seed=Banner1&backgroundColor=c0aede',
        'banner2': 'https://api.dicebear.com/9.x/shapes/svg?seed=Banner2&backgroundColor=ffdfbf',
    }
    for name, url in banners.items():
        download_file(url, f"assets/svg/banners/{name}.svg")

if __name__ == '__main__':
    setup_realistic_assets()
    print("Finished downloading realistic SVGs!")
