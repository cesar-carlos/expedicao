// ignore: unused_import
import 'dart:ffi';

import 'package:media_kit/media_kit.dart';

class AudioHelper {
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() {
    return _instance;
  }
  AudioHelper._internal();

  bool initializeded = false;
  bool isPlaying = false;
  bool isPaused = false;
  String currentFile = '';

  late Player audioPlayer;
  Future<AudioHelper> _initialize() async {
    if (!initializeded) {
      initializeded = true;
      audioPlayer = Player();
    }
    return this;
  }

  playPause(String path, {bool stopAll = true, double volume = 1}) {
    if (isPlaying && path == currentFile) return pause();
    return play(path, volume: volume, stopAll: stopAll);
  }

  play(String path, {bool stopAll = true, double volume = 1}) async {
    await _initialize();
    if (stopAll && isPlaying) await audioPlayer.stop();
    currentFile = path;
    await audioPlayer.open(Media(path));
    await audioPlayer.play();
    isPlaying = true;
    isPaused = false;
  }

  resume() async {
    await _initialize();
    if (isPaused) await audioPlayer.play();
    isPlaying = true;
    isPaused = false;
  }

  pause() async {
    await _initialize();
    await audioPlayer.pause();
    isPaused = true;
    isPlaying = false;
  }

  stop() async {
    await _initialize();
    await audioPlayer.stop();
    isPlaying = false;
    isPaused = false;
  }
}
