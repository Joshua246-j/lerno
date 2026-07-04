import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioManagerProvider = Provider<AudioManager>((ref) {
  return AudioManager();
});

class AudioManager {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _notificationPlayer = AudioPlayer();

  bool _isMuted = false;
  double _masterVolume = 1.0;
  double _musicVolume = 0.5;
  double _effectsVolume = 1.0;

  bool get isMuted => _isMuted;

  Future<void> init() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void setMute(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      _bgmPlayer.pause();
    } else {
      _bgmPlayer.resume();
    }
  }

  void toggleMute() {
    setMute(!_isMuted);
  }

  void setMasterVolume(double volume) {
    _masterVolume = volume;
    _updateVolumes();
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume;
    _updateVolumes();
  }

  void setEffectsVolume(double volume) {
    _effectsVolume = volume;
    _updateVolumes();
  }

  void _updateVolumes() {
    if (!_isMuted) {
      _bgmPlayer.setVolume(_musicVolume * _masterVolume);
      _sfxPlayer.setVolume(_effectsVolume * _masterVolume);
      _notificationPlayer.setVolume(_effectsVolume * _masterVolume);
    }
  }

  // --- Background Music ---

  Future<void> playBgm({String track = 'bgm_main'}) async {
    if (_isMuted) return;
    try {
      await _bgmPlayer.play(AssetSource('audio/music/$track.mp3'), volume: _musicVolume * _masterVolume);
    } catch (e) {
      // Ignore missing mock file errors in prototype
    }
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  // --- UI Sound Effects ---

  Future<void> playClick() async {
    _playSfx('ui/click');
  }

  Future<void> playSuccess() async {
    _playSfx('ui/success');
  }

  Future<void> playFail() async {
    _playSfx('ui/error');
  }

  // --- Game Sound Effects ---

  Future<void> playCorrectAnswer() async {
    _playSfx('game/correct');
  }

  Future<void> playWrongAnswer() async {
    _playSfx('game/wrong');
  }

  Future<void> playVictory() async {
    _playSfx('game/victory');
  }

  Future<void> playDefeat() async {
    _playSfx('game/defeat');
  }

  Future<void> playTaskComplete() async {
    _playSfx('rewards/task_complete');
  }

  Future<void> playLevelUp() async {
    _playSfx('rewards/level_up');
  }

  Future<void> _playSfx(String path) async {
    if (_isMuted) return;
    try {
      // Create a transient player for overlapping sounds
      final player = AudioPlayer();
      player.onPlayerComplete.listen((_) => player.dispose());
      await player.play(AssetSource('audio/$path.mp3'), volume: _effectsVolume * _masterVolume, mode: PlayerMode.lowLatency);
    } catch (e) {
      // Ignore missing mock file errors
    }
  }

  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    _notificationPlayer.dispose();
  }
}
