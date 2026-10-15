import 'package:media_kit/media_kit.dart';

class AppAudioHelper {
  late Player audioPlayer;

  bool initializeded = false;
  bool isPlaying = false;
  bool isPaused = false;
  String currentFile = '';

  static final AppAudioHelper _instance = AppAudioHelper._internal();
  factory AppAudioHelper() {
    return _instance;
  }

  AppAudioHelper._internal();

  Future<AppAudioHelper> _initialize() async {
    if (!initializeded) {
      MediaKit.ensureInitialized();
      initializeded = true;
      audioPlayer = Player();
      audioPlayer.setVolume(250.0);
    }

    return this;
  }

  dynamic playPause(String path, {bool stopAll = true, double volume = 1}) {
    if (isPlaying && path == currentFile) return pause();
    return play(path, volume: volume, stopAll: stopAll);
  }

  Future<void> play(String path, {bool stopAll = true, double volume = 1}) async {
    await _initialize();
    if (stopAll && isPlaying) await audioPlayer.stop();

    await audioPlayer.open(Media('asset:///assets/sounds$path'));
    await audioPlayer.play();
    isPlaying = true;
    isPaused = false;
  }

  Future<void> resume() async {
    await _initialize();
    if (isPaused) await audioPlayer.play();
    isPlaying = true;
    isPaused = false;
  }

  Future<void> pause() async {
    await _initialize();
    await audioPlayer.pause();
    isPaused = true;
    isPlaying = false;
  }

  Future<void> stop() async {
    await _initialize();
    await audioPlayer.stop();
    isPlaying = false;
    isPaused = false;
  }
}
