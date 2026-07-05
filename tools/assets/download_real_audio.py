import os
import urllib.request

def download_file(url, output_path):
    print(f"Downloading {url} to {output_path}...")
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response, open(output_path, 'wb') as out_file:
            out_file.write(response.read())
        print("Success")
    except Exception as e:
        print(f"Failed to download {url}: {e}")

def fix_audio():
    os.makedirs('assets/audio/ui', exist_ok=True)
    os.makedirs('assets/audio/rewards', exist_ok=True)
    os.makedirs('assets/audio/music', exist_ok=True)
    
    # Using reliable demo mp3s
    audio_files = {
        # Using some sample sound clips that are always online
        'assets/audio/ui/click.wav': 'https://freewavesamples.com/files/Ensoniq-ESQ-1-Snare.wav',
        'assets/audio/ui/success.wav': 'https://freewavesamples.com/files/Alesis-Sanctuary-QCard-Cymbal-Crash.wav',
        'assets/audio/ui/error.wav': 'https://freewavesamples.com/files/Korg-Triton-Slow-Crash-Cymbal.wav',
        'assets/audio/rewards/level_up.wav': 'https://freewavesamples.com/files/Casio-MT-45-Beguine.wav',
        'assets/audio/music/bgm_home.wav': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    }
    
    for path, url in audio_files.items():
        # Saving with the correct extension depending on source if needed, or just let flutter figure it out (it uses audioplayers)
        download_file(url, path.replace('.wav', '.mp3') if url.endswith('.mp3') else path)

if __name__ == '__main__':
    fix_audio()
