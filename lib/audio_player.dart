import 'package:just_audio/just_audio.dart';

class AudioPlayerManager {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudio(String selectedSongPath) async {
    await _audioPlayer.setUrl(selectedSongPath);
    await _audioPlayer.play();
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> resumeAudio() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.seek(_audioPlayer.position);
    } else {
      await _audioPlayer.play();
    }

  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
