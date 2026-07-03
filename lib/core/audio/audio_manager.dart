import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioManagerProvider = Provider<AudioManager>((ref) {
  return AudioManager();
});

class AudioManager {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMuted = false;

  bool get isMuted => _isMuted;

  Future<void> init() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playBgm() async {
    if (_isMuted) return;
    await _bgmPlayer.play(AssetSource('sounds/bgm.wav'), volume: 0.3);
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  Future<void> playClick() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('sounds/click.wav'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playSuccess() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('sounds/success.wav'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playFail() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('sounds/fail.wav'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playTaskComplete() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('sounds/task_complete.wav'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playLevelUp() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('sounds/level_up.wav'),
        mode: PlayerMode.lowLatency);
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _bgmPlayer.pause();
    } else {
      _bgmPlayer.resume();
    }
  }

  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
