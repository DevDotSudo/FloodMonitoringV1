import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playCriticaltSound() async {
    await _player.play(AssetSource('sounds/critical_sound.mp3'));
  }

  Future<void> playWarningSound() async {
    await _player.play(AssetSource('sounds/warning_sound.mp3'));
  }

  Future<void> stop() async {
    await _player.stop();
  }
}
