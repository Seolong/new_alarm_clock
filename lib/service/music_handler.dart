import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

class MusicHandler {
  static final MusicHandler _instance = MusicHandler._internal();
  AudioPlayer currentPlayer = AudioPlayer();
  final String beepBeepPath = 'assets/audio/alarm_clock.mp3';
  final String ringRingPath = 'assets/audio/old_telephone.mp3';
  Map<String, String> defaultRingPath = {};
  late double _originalVolume;

  factory MusicHandler() {
    PerfectVolumeControl.hideUI = true;
    return _instance;
  }

  MusicHandler._internal();

  initOriginalVolume() async {
    _originalVolume = await PerfectVolumeControl.getVolume();
    defaultRingPath = {
      StringValue.beepBeep: beepBeepPath,
      StringValue.ringRing: ringRingPath
    };
    print('current volume is $_originalVolume');
  }

  /// This function initializes the music player with a sound path and
  /// starts playing based on the given alarm configuration.
  /// @param alarm - An ObservableAlarm object holding ringtone description
  /// @param path - File path of sound to be played. This can be a local path or remote url.
  Future<bool> playMusic(double volume, String absPath) async {
    // Prevent duplicate sounds
    if (currentPlayer.playing) await currentPlayer.stop();
    currentPlayer.setLoopMode(LoopMode.one);

    PerfectVolumeControl.setVolume(volume);
    if (absPath == StringValue.beepBeep) {
      await currentPlayer.setAsset(beepBeepPath);
    } else if (absPath == StringValue.ringRing) {
      await currentPlayer.setAsset(ringRingPath);
    } else {
      await currentPlayer.setFilePath(absPath);
    }
    await currentPlayer.play();

    return true;
  }

  /// This function stops the music player
  Future<void> stopMusic() async {
    if (currentPlayer.playing) {
      await currentPlayer.stop();
      await PerfectVolumeControl.setVolume(_originalVolume);
    }
  }
}
