import os
import wave
import math
import struct

def ensure_dir(path):
    if not os.path.exists(path):
        os.makedirs(path)

def create_tone(filename, base_freq, duration_sec, wave_type='sine', sweep=0.0):
    sample_rate = 44100
    num_samples = int(sample_rate * duration_sec)
    
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        for i in range(num_samples):
            t = float(i) / sample_rate
            # Frequency sweep effect (e.g. for level up or error)
            current_freq = base_freq + (sweep * t * base_freq)
            
            if wave_type == 'sine':
                val = math.sin(2.0 * math.pi * current_freq * t)
            elif wave_type == 'square':
                val = 1.0 if math.sin(2.0 * math.pi * current_freq * t) > 0 else -1.0
            elif wave_type == 'triangle':
                val = 2.0 * abs(2.0 * (t * current_freq - math.floor(t * current_freq + 0.5))) - 1.0
                
            # Envelope (quick attack, fade out)
            envelope = max(0, 1.0 - (t / duration_sec))
            # If it's a click, very sharp envelope
            if duration_sec <= 0.1:
                envelope = math.exp(-t * 50)
                
            value = int(32767.0 * val * envelope * 0.5)
            data = struct.pack('<h', value)
            wav_file.writeframesraw(data)

def generate_logical_audio():
    print("Generating logical game audio...")
    ensure_dir('assets/audio/ui')
    ensure_dir('assets/audio/rewards')
    
    # Click: Short sharp triangle wave
    create_tone('assets/audio/ui/click.wav', 600, 0.05, 'triangle')
    
    # Success: Sine wave sweeping UP
    create_tone('assets/audio/ui/success.wav', 800, 0.3, 'sine', sweep=2.0)
    
    # Error/Fail: Square wave sweeping DOWN (low pitch)
    create_tone('assets/audio/ui/error.wav', 250, 0.4, 'square', sweep=-0.5)
    create_tone('assets/audio/ui/fail.wav', 250, 0.4, 'square', sweep=-0.5)
    
    # Victory/Level Up: High pitch sine wave sweeping UP
    create_tone('assets/audio/rewards/level_up.wav', 1000, 0.8, 'sine', sweep=1.5)

if __name__ == '__main__':
    generate_logical_audio()
    print("Done generating audio!")
