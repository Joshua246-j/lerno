import os
import urllib.request
import zipfile
import shutil

def download_and_extract(url, extract_to):
    print(f"Downloading {url}...")
    zip_path = "temp_audio.zip"
    try:
        # Use a user-agent to avoid 403 Forbidden
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response, open(zip_path, 'wb') as out_file:
            shutil.copyfileobj(response, out_file)
        
        print(f"Extracting to {extract_to}...")
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(extract_to)
            
        print("Done!")
    except Exception as e:
        print(f"Failed to download/extract: {e}")
    finally:
        if os.path.exists(zip_path):
            os.remove(zip_path)

def setup_game_audio():
    # Example URL for a public domain SFX pack (Kenney UI Audio is usually available on Github mirrors or direct links)
    # Note: Since Kenney's direct download sometimes requires human verification, this uses a known Github mirror/repo for open game art if necessary.
    # For demonstration, we'll assume the direct link works or provide the user instructions.
    
    # URL to Kenney's UI Audio (Public Domain)
    # Kenney's direct download endpoint:
    kenney_url = "https://kenney.nl/downloads/ui-audio/download"
    
    # We will attempt to download it
    download_and_extract(kenney_url, "temp_kenney")
    
    # If successful, we can move the specific MP3/WAV files to our assets
    source_dir = "temp_kenney/Audio"
    if os.path.exists(source_dir):
        print("Moving files to assets/audio/...")
        
        os.makedirs("assets/audio/ui", exist_ok=True)
        os.makedirs("assets/audio/games", exist_ok=True)
        
        # Example mapping (you can customize this based on the exact filenames in the pack)
        # click1.ogg -> ui/click.wav etc.
        try:
            # Assuming the pack has .ogg or .wav
            for file in os.listdir(source_dir):
                if "click" in file.lower() and file.endswith(".ogg"):
                    shutil.copy(os.path.join(source_dir, file), "assets/audio/ui/click.ogg")
                elif "success" in file.lower() and file.endswith(".ogg"):
                    shutil.copy(os.path.join(source_dir, file), "assets/audio/ui/success.ogg")
                elif "error" in file.lower() and file.endswith(".ogg"):
                    shutil.copy(os.path.join(source_dir, file), "assets/audio/ui/error.ogg")
                    
            print("Successfully organized Kenney UI Audio!")
        except Exception as e:
            print(f"Error moving files: {e}")
    else:
        print("Could not find the extracted Audio folder. You may need to download manually from https://kenney.nl/assets/ui-audio")
        
    # Cleanup
    if os.path.exists("temp_kenney"):
        shutil.rmtree("temp_kenney")

if __name__ == '__main__':
    setup_game_audio()
