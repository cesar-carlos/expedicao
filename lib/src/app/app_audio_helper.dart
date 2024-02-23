// ignore: unused_import
import 'dart:ffi';

import 'package:media_kit/media_kit.dart';

class AppAudioHelper {
  static final AppAudioHelper _instance = AppAudioHelper._internal();
  factory AppAudioHelper() {
    return _instance;
  }
  AppAudioHelper._internal();

  bool initializeded = false;
  bool isPlaying = false;
  bool isPaused = false;
  String currentFile = '';

  late Player audioPlayer;
  Future<AppAudioHelper> _initialize() async {
    if (!initializeded) {
      initializeded = true;
      audioPlayer = Player();
    }
    return this;
  }

  // static Future<String> pathAssets() async {
  //   String audioPath = 'assets/sounds';
  //   String audioUrl = (await rootBundle.load(audioPath)).toString();
  //   return audioUrl;
  // }

  playPause(String path, {bool stopAll = true, double volume = 1}) {
    if (isPlaying && path == currentFile) return pause();
    return play(path, volume: volume, stopAll: stopAll);
  }

  play(String path, {bool stopAll = true, double volume = 1}) async {
    await _initialize();
    if (stopAll && isPlaying) await audioPlayer.stop();

    // String audioPath = 'assets/sounds' + path;
    // String audioUrl = (await rootBundle.load(audioPath)).toString();
    // print(audioUrl);
    // path = audioUrl;
    // currentFile = Media('asset:///assets/videos/sample.mp4');

    await audioPlayer.open(Media('asset:///assets/sounds' + path));
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
