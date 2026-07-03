import os
import wave
import math
import struct

def ensure_dir(path):
    if not os.path.exists(path):
        os.makedirs(path)

# 1. Create Audio Files
def create_tone(filename, freq, duration_sec, wave_type='sine'):
    sample_rate = 44100
    num_samples = int(sample_rate * duration_sec)
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        for i in range(num_samples):
            t = float(i) / sample_rate
            if wave_type == 'sine':
                val = math.sin(2.0 * math.pi * freq * t)
            elif wave_type == 'square':
                val = 1.0 if math.sin(2.0 * math.pi * freq * t) > 0 else -1.0
            
            # Envelope (fade out)
            envelope = max(0, 1.0 - (t / duration_sec))
            value = int(32767.0 * val * envelope * 0.5)
            data = struct.pack('<h', value)
            wav_file.writeframesraw(data)

def generate_audios():
    print("Generating audio files...")
    ensure_dir('assets/sounds')
    create_tone('assets/sounds/click.wav', 800, 0.1, 'square')
    create_tone('assets/sounds/success.wav', 1200, 0.4, 'sine')
    create_tone('assets/sounds/bgm.wav', 440, 2.0, 'sine') # Just a dummy bgm loop
    create_tone('assets/sounds/fail.wav', 200, 0.5, 'square')

# 2. Create SVGs
def create_svg(filename, content, width=100, height=100):
    svg_str = f'''<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">
    {content}
    </svg>'''
    with open(filename, 'w') as f:
        f.write(svg_str)

def generate_svgs():
    print("Generating SVG images...")
    
    # Avatars
    ensure_dir('assets/images/avatars')
    avatars = [
        ('octopus', '<circle cx="50" cy="50" r="40" fill="#FF9A9E" /><circle cx="35" cy="40" r="8" fill="white" /><circle cx="65" cy="40" r="8" fill="white" /><circle cx="35" cy="40" r="3" fill="black" /><circle cx="65" cy="40" r="3" fill="black" /><path d="M 35 65 Q 50 75 65 65" stroke="black" stroke-width="3" fill="none" />'),
        ('alien', '<circle cx="50" cy="50" r="40" fill="#A8E063" /><ellipse cx="35" cy="45" rx="10" ry="15" fill="black" /><ellipse cx="65" cy="45" rx="10" ry="15" fill="black" />'),
        ('robot', '<rect x="20" y="20" width="60" height="60" rx="10" fill="#A1C4FD" /><rect x="30" y="40" width="15" height="10" fill="white" /><rect x="55" y="40" width="15" height="10" fill="white" /><rect x="35" y="65" width="30" height="5" fill="#333" />'),
        ('astronaut', '<circle cx="50" cy="50" r="45" fill="#E2E2E2" /><circle cx="50" cy="45" r="30" fill="#333" /><path d="M 30 75 Q 50 85 70 75" stroke="#FFF" stroke-width="2" fill="none" />'),
    ]
    for name, content in avatars:
        create_svg(f'assets/images/avatars/{name}.svg', content)

    # Badges
    ensure_dir('assets/images/badges')
    badges = [
        ('word_warrior', '<polygon points="50,10 90,90 10,90" fill="#FFD700" /><text x="50" y="70" font-family="Arial" font-size="20" font-weight="bold" fill="white" text-anchor="middle">W</text>'),
        ('math_master', '<polygon points="50,10 90,90 10,90" fill="#00BFFF" /><text x="50" y="70" font-family="Arial" font-size="20" font-weight="bold" fill="white" text-anchor="middle">+</text>'),
        ('science_explorer', '<polygon points="50,10 90,90 10,90" fill="#32CD32" /><circle cx="50" cy="60" r="10" fill="white" />'),
    ]
    for name, content in badges:
        create_svg(f'assets/images/badges/{name}.svg', content)

    # Subjects
    ensure_dir('assets/images/subjects')
    subjects = [
        ('maths', '<rect x="10" y="10" width="80" height="80" rx="20" fill="#FFC371" /><text x="50" y="55" font-family="Arial" font-size="30" font-weight="bold" fill="white" text-anchor="middle">+-</text>'),
        ('science', '<rect x="10" y="10" width="80" height="80" rx="20" fill="#2AFADF" /><circle cx="50" cy="50" r="20" fill="white" opacity="0.8"/><circle cx="50" cy="50" r="10" fill="white" />'),
        ('english', '<rect x="10" y="10" width="80" height="80" rx="20" fill="#B224EF" /><text x="50" y="55" font-family="Arial" font-size="30" font-weight="bold" fill="white" text-anchor="middle">Abc</text>'),
    ]
    for name, content in subjects:
        create_svg(f'assets/images/subjects/{name}.svg', content)
        
    # Games/Paths
    ensure_dir('assets/images/games')
    games = [
        ('word_puzzle', '<rect width="100" height="100" rx="15" fill="#667EEA" /><text x="50" y="60" font-size="40" fill="white" text-anchor="middle">A</text>'),
        ('math_game', '<rect width="100" height="100" rx="15" fill="#00C6FF" /><text x="50" y="60" font-size="40" fill="white" text-anchor="middle">123</text>'),
        ('shapes', '<rect width="100" height="100" rx="15" fill="#F09819" /><polygon points="50,20 80,80 20,80" fill="white" />'),
        ('colouring', '<rect width="100" height="100" rx="15" fill="#EE0979" /><circle cx="50" cy="50" r="25" fill="white" />'),
    ]
    for name, content in games:
        create_svg(f'assets/images/games/{name}.svg', content)
    
    print("Done generating assets.")

if __name__ == '__main__':
    generate_audios()
    generate_svgs()
