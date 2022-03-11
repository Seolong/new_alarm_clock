import 'dart:async';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

class MusicHandler {
  static final MusicHandler _instance = MusicHandler._internal();
  AudioPlayer currentPlayer = AudioPlayer();
  late double _originalVolume;

  factory MusicHandler(){
    return _instance;
  }

  MusicHandler._internal();

  changeVolume(AlarmData alarm) async {
    _originalVolume = await PerfectVolumeControl.volume;
    PerfectVolumeControl.setVolume(alarm.musicVolume);
  }

  /// Play device default alarm tone
  Future<void> playDeviceDefaultTone(AlarmData alarm) async {
    await FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true,      // Android only - API >= 28
      volume: alarm.musicVolume,      // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );
  }

  /// This function initializes the music player with a sound path and
  /// starts playing based on the given alarm configuration.
  /// @param alarm - An ObservableAlarm object holding ringtone description
  /// @param path - File path of sound to be played. This can be a local path or remote url.
  Future<bool> playMusic(double volume, String absPath) async {
    // Prevent duplicate sounds
    if (currentPlayer.playing) await currentPlayer.stop();
    currentPlayer.setLoopMode(LoopMode.one);
    // Initialize audio source

    //playingSoundPath.value =
    //    path; // Notifies UI isolate path is ready to play
    await currentPlayer.setFilePath(absPath);
    PerfectVolumeControl.setVolume(volume);
    await currentPlayer.play();

    await currentPlayer.setVolume(volume);

    return true;
  }

  /// This function stops the music player
  Future<void> stopMusic() async {
    // Notifies UI isolate that nothing is currently playing
    //playingSoundPath.value = "";
    // Pause the music instead of stopping... Well i dunno whats up but the
    // developer of the player recommends it.
    if (currentPlayer.playing) await currentPlayer.pause();
    await currentPlayer.stop();
    // Stop default ringtone player if active
    await FlutterRingtonePlayer.stop();

    PerfectVolumeControl.setVolume(_originalVolume);
  }
}
