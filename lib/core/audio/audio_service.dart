import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  // Pre-load sounds for instantaneous playback
  Future<void> init() async {
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
    // In a real app, you would preload asset paths here:
    // await _sfxPlayer.setSource(AssetSource('sounds/pop.mp3'));
  }

  Future<void> playButtonTap() async {
    // Play a satisfying, colorful 'pop' sound
    await _sfxPlayer.play(AssetSource('sounds/ui_tap.mp3'));
  }

  Future<void> playVictoryChime() async {
    // Play for 1v1 match win or level complete
    await _sfxPlayer.play(AssetSource('sounds/victory.mp3'));
  }

  Future<void> playErrorBuzzer() async {
    await _sfxPlayer.play(AssetSource('sounds/error.mp3'));
  }

  Future<void> startBackgroundMusic() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('sounds/bgm_happy.mp3'), volume: 0.3);
  }

  Future<void> stopBackgroundMusic() async {
    await _bgmPlayer.stop();
  }
}
