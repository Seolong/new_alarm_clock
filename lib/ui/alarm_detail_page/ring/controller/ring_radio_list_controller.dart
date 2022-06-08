import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/music_path_data.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class RingRadioListController extends GetxController {
  MusicHandler musicHandler = MusicHandler();
  AlarmProvider _alarmProvider = AlarmProvider();
  String _selectedMusicPath = StringValue.beepBeep; //절대경로
  bool _power = false; //DB에서 가져오기
  Map<String, Color> textColor = {
    'active': Colors.black,
    'inactive': Colors.grey
  };
  Map<String, Color> _listTextColor = {'text': Colors.black};
  Future<List<MusicPathData>>? pathFutureList = null;
  RxList<MusicPathData> pathList = RxList<MusicPathData>();
  double _volume = 0.7; //addalarmpage에서 edit이면 db에서 받아오기

  String get selectedMusicPath => _selectedMusicPath;

  set selectedMusicPath(String musicPath) {
    _selectedMusicPath = musicPath;
    musicHandler.playMusic(_volume, musicPath);

    update();
  }

  double get volume => _volume;

  set volume(double volume) {
    _volume = volume;
    update();
  }

  bool get power => _power;

  set power(bool value) {
    _power = value;
    if (_power == false) {
      musicHandler.stopMusic();
    }
    update();
  }

  Color get listTextColor => _listTextColor['text']!;

  set listTextColor(Color color) {
    _listTextColor['text'] = color;
    update();
  }

  void initSelectedMusicPathInEdit(String path) {
    _selectedMusicPath = path;
    update();
  }

  @override
  void onInit() async {
    pathFutureList = _alarmProvider.getAllMusicPath();
    List<MusicPathData> varPathList = await pathFutureList ?? [];
    pathList = varPathList.obs;

    super.onInit();
  }

  @override
  void onClose() {
    musicHandler.stopMusic();

    super.onClose();
  }

  void inputMusicPath(MusicPathData musicPathData) async {
    await _alarmProvider.insertMusicPath(musicPathData);
    //List에 없을 때만 List에 넣는다
    if (!pathList.any((e) => e.path == musicPathData.path)) {
      pathList.add(musicPathData);
    }
    pathFutureList = _alarmProvider.getAllMusicPath();
    update();
  }

  String getNameOfSong(String fullName) {
    if (fullName == StringValue.beepBeep || fullName == StringValue.ringRing) {
      return fullName;
    }
    var splitNameByDirectory = fullName.split('/');
    var name = splitNameByDirectory[splitNameByDirectory.length - 1];
    var splitFileName = name.split('.');
    var splitFileNameWithoutExtension =
        splitFileName.getRange(0, splitFileName.length - 1);
    return splitFileNameWithoutExtension.join('.');
  }
}
