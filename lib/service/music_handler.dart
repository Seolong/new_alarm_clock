import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

class MusicHandler {
  static final MusicHandler _instance = MusicHandler._internal();
  AudioPlayer currentPlayer = AudioPlayer();
  Map<String, String> defaultRingPath = {
    StringValue.beepBeep: 'assets/audio/alarm_clock.mp3',
    StringValue.ringRing: 'assets/audio/old_telephone.mp3'
  };
  late double _originalVolume;

  factory MusicHandler() {
    PerfectVolumeControl.hideUI = true;
    return _instance;
  }

  MusicHandler._internal();

  // changeVolume(double volume) async {
  //   _originalVolume = await PerfectVolumeControl.volume;
  //   print('current volume is $_originalVolume');
  //   PerfectVolumeControl.setVolume(volume);
  // }

  initOriginalVolume() async {
    _originalVolume = await PerfectVolumeControl.getVolume();
    print('current volume is $_originalVolume');
  }

  /// Play device default alarm tone
  Future<void> playDeviceDefaultTone(double volume) async {}

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
      await currentPlayer.setAsset('assets/audio/alarm_clock.mp3');
    } else if (absPath == StringValue.ringRing) {
      await currentPlayer.setAsset('assets/audio/old_telephone.mp3');
    } else {
      await currentPlayer.setFilePath(absPath);
    }
    await currentPlayer.play();

    return true;
  }

  /// This function stops the music player
  Future<void> stopMusic() async {
    // Notifies UI isolate that nothing is currently playing
    //playingSoundPath.value = "";
    // Pause the music instead of stopping... Well i dunno whats up but the
    // developer of the player recommends it.
    if (currentPlayer.playing) {
      await currentPlayer.stop();
      // Stop default ringtone player if active
      await FlutterRingtonePlayer.stop();

      await PerfectVolumeControl.setVolume(_originalVolume);
    }
  }
}
